#!/bin/bash

show_help() {
	echo "usage: fix [-h] [-e] [-i] [--uninstall]"
	echo ""
	echo "Fix-cli - A command-line fixing tool powered by Gemini AI"
	echo ""
	echo "options:"
	echo "  -h, --help     show this help message and exit"
	echo "  --uninstall    uninstall fix-cli from your system"
	echo "  -e             explain the error and provide detailed solution"
	echo "  -i             interactive mode for custom prompt input"
}

ask_gemini() {
	local prompt="$1"
	local api_key="$GEMINI_API_KEY"

	local json_payload=$(jq -n --arg prompt "$prompt" '{
		contents: [{
			parts: [{
				text: $prompt
			}]
		}]
	}')

	curl -s \
		-H "Content-Type: application/json" \
		-X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$api_key" \
		-d "$json_payload" \
		| jq -r '.candidates[0].content.parts[0].text'
}

fix() {
	user_input_prompt=0
	need_explain=0
	# handle parameters
	case "$1" in
		"-h"|"--help")
			show_help
			return 0
			;;
		"--uninstall")
			echo -n "Are you sure you want to uninstall fix-cli? (y/n) "
			read confirm
			if [[ "$confirm" == "y" ]]; then
				case $(echo $SHELL) in
					*zsh)
						sed -i '' '/source.*fix-cli\.sh/d' $HOME/.zshrc
						;;
					*bash)
						sed -i '/source.*fix-cli\.sh/d' $HOME/.bashrc
						;;
					*)
						echo "Error: Unsupported shell. Please use bash or zsh."
						exit 1
						;;
				esac

				rm -f "$HOME/.fix-cli.sh"
				echo "✅ fix-cli has been uninstalled. Please restart your terminal."
				return 0
			else
				echo "Uninstall cancelled."
				return 1
			fi
			;;
		"-e")
			need_explain=1
			;;
		"-i")
			user_input_prompt=1
			need_explain=1
			;;
		"")
			;;
		*)
			echo "Error: Unknown parameter '$1'"
			show_help
			return 1
			;;
	esac

	local prev_command=$(fc -ln -1)
	prev_command=$(echo "$prev_command" | sed 's/^[[:space:]]*//')

	local tmpfile=$(mktemp)
	eval "$prev_command" 2>&1 | tee "$tmpfile" > /dev/null
	local full_output=$(<"$tmpfile")

	local prompt="I am using $OS. I executed this command: $prev_command. "

	if [[ $user_input_prompt == 1 ]]; then
		echo "Please enter prompt for Gemini (press Ctrl+D when done):"
		local tmp_prompt=$(mktemp)
		cat > "$tmp_prompt"
		user_prompt=$(<"$tmp_prompt")
		rm -f "$tmp_prompt"
		prompt+="User prompt: $user_prompt"
	else
		prompt+="And its output was: $full_output."
	fi

	if [[ $need_explain == 1 ]]; then
		prompt+=" Please explain what went wrong and provide a correct command to fix this problem. Include a brief explanation of the issue. At the end of your response, add a new line with just the command 'COMMAND:' followed by the correct one-line command to fix this problem. Don't use Markdown."
	else
		prompt+=" Please give me a correct one-line command to fix this problem. Only return the command, no explanation or additional words needed."
	fi

	echo $prompt

	echo -e "\033[0;34m[fix] Asking Gemini for a fix...\033[0m"
	local full_response=$(ask_gemini "$prompt")

	if [[ $full_response == 'null' ]]; then
		echo -e "\033[0;31m[fix] Error: API Key not valid.\033[0m"
		return 1
	fi

	if [[ $need_explain == 1 ]]; then
		explanation=$(echo "$full_response" | sed '$d')
		fixed_command=$(echo "$full_response" | tail -n1 | sed 's/^COMMAND://')
		echo -e "\033[0;32m[fix] Gemini's explanation: \033[0m"
		echo "$explanation"
	else
		fixed_command=$full_response
	fi

	echo -e "\033[0;32m[fix] Gemini suggests command: \033[0m$fixed_command"
	echo -n "Execute the command? (y or Enter/n) "
	read confirm
	if [[ "$confirm" == "y" || -z "$confirm" ]]; then
		echo -e "\033[0;36m[fix] Executing...\033[0m"
		eval "$fixed_command"
	else
		echo "Execution cancelled."
	fi

	echo -e "\033[0;32m[fix] Original command: \033[0m$prev_command"
	echo -n "Execute the command? (y or Enter/n) "
	read confirm
	if [[ "$confirm" == "y" || -z "$confirm" ]]; then
		echo -e "\033[0;36m[fix] Executing $prev_command ...\033[0m"
		eval "$prev_command"
	else
		echo "Execution cancelled."
	fi

	rm -f "$tmpfile"
}


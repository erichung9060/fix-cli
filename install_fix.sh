#!/bin/bash

CONFIG_FILE="$HOME/.fix_gemini_config"
SHELL_RC="$HOME/.zshrc"
FIX="$HOME/.fix.sh"

echo -n "🔑 請輸入你的 Gemini API Key："
read -r -s API_KEY
echo "export GEMINI_API_KEY=\"$API_KEY\"" > "$FIX"

cat << 'EOF' >> "$FIX"
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
	if [[ "$1" == "--uninstall" ]]; then
		echo -n "Are you sure you want to uninstall fix-cli? (y/n) "
		read confirm
		if [[ "$confirm" == "y" ]]; then
			# Remove source line from .zshrc
			sed -i '' '/source.*fix\.sh/d' "$HOME/.zshrc"
			# Remove fix.sh
			rm -f "$HOME/.fix.sh"
			echo "✅ fix-cli has been uninstalled. Please restart your terminal."
			return 0
		else
			echo "Uninstall cancelled."
			return 1
		fi
	elif [[ -n "$1" && "$1" != "-e" ]]; then
		echo "Error: Unknown parameter '$1'. Valid parameters are --uninstall and -e"
		return 1
	fi

	local prev_command=$(fc -ln -1)
	local tmpfile=$(mktemp)
	eval "$prev_command" 2>&1 | tee "$tmpfile" > /dev/null
	local full_output=$(<"$tmpfile")

	local prompt="I just executed this command: $prev_command
Its output was: $full_output\n
I am using macbook. "
	if [[ "$1" == "-e" ]]; then
		prompt+="Please explain what went wrong and provide a correct command to fix this problem. Include a brief explanation of the issue. At the end of your response, add a new line with just the command 'COMMAND:' followed by the correct one-line command to fix this problem. Don't use Markdown."
	else
		prompt+="Please give me a correct one-line command to fix this problem. Only return the command, no explanation or additional words needed."
	fi

	echo "\033[0;34m[fix] Asking Gemini for a fix...\033[0m"
	local full_response=$(ask_gemini "$prompt")

	if [[ "$1" == "-e" ]]; then
		explanation=$(echo "$full_response" | sed '$d')
		fixed_command=$(echo "$full_response" | tail -n1 | sed 's/^COMMAND://')
		echo "\033[0;32m[fix] Gemini's explanation: \033[0m"
		echo "$explanation"
	else
		fixed_command=$full_response
	fi
	echo "\033[0;32m[fix] Gemini suggests command: \033[0m$fixed_command"

	echo -n "Execute the command? (y/n) "
	read confirm
	if [[ "$confirm" == "y" || -z "$confirm" ]]; then
		echo -e "\033[0;36m[fix] Executing...\033[0m"
		eval "$fixed_command"
	else
		echo "Execution cancelled."
	fi

	echo -n "\033[0;32m[fix] Execute original command? (y/n) \033[0m"
	read confirm
	if [[ "$confirm" == "y" || -z "$confirm" ]]; then
		echo -e "\033[0;36m[fix] Executing...\033[0m"
		eval "$prev_command"
	else
		echo "Execution cancelled."
	fi

	rm -f "$tmpfile"
}
EOF

echo "source $FIX" >> "$SHELL_RC"
source "$SHELL_RC"

rm install_fix.sh

echo -e "\n✅ 安裝完成！請試著打個錯的指令然後輸入 \033[1;32mfix\033[0m 來自動修復！"
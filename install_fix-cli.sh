#!/bin/bash
FIX="$HOME/.fix-cli.sh"

echo "Downloading fix-cli..."
curl -s -o $FIX https://raw.githubusercontent.com/erichung9060/fix-cli/refs/heads/main/fix-cli.sh

echo -n "🔑 請輸入你的 Gemini API Key："
read -r -s API_KEY
echo "export GEMINI_API_KEY=\"$API_KEY\"" >> "$FIX"

uname_out="$(uname -s)"
case "${uname_out}" in
    Linux*)     os_type=Linux;;
    Darwin*)    os_type=macOS;;
    *)          os_type="UNKNOWN:${uname_out}"
esac
echo "export OS=\"$os_type\"" >> "$FIX"


case $(echo $SHELL) in
    *zsh)
        SHELL_RC="$HOME/.zshrc"
        ;;
    *bash)
        SHELL_RC="$HOME/.bashrc"
        ;;
    *)
        echo "Error: Unsupported shell. Please use bash or zsh."
        exit 1
        ;;
esac

if ! grep -q "source $FIX" "$SHELL_RC"; then
    echo "source $FIX" >> "$SHELL_RC"
fi

source "$SHELL_RC"

rm install_fix-cli.sh

echo -e "\n✅ 安裝完成！請試著打個錯的指令然後輸入 \033[1;32mfix\033[0m 來自動修復！"
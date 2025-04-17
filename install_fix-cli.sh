#!/bin/bash

SHELL_RC="$HOME/.zshrc"
FIX="$HOME/.fix-cli.sh"

curl -s -o $FIX https://raw.githubusercontent.com/erichung9060/fix-cli/refs/heads/main/fix-cli.sh

echo -n "🔑 請輸入你的 Gemini API Key："
read -r -s API_KEY
echo "export GEMINI_API_KEY=\"$API_KEY\"" > "$FIX"

echo "source $FIX" >> "$SHELL_RC"
source "$SHELL_RC"

rm install_fix-cli.sh

echo -e "\n✅ 安裝完成！請試著打個錯的指令然後輸入 \033[1;32mfix\033[0m 來自動修復！"
# fix

🛠️ 一個基於 Gemini AI 的命令列修復工具，當你打錯指令時，它會幫你找出正確的指令！

## 功能

- 🤖 使用 Gemini AI 來分析錯誤並提供修復建議
- 🔄 可以選擇是否執行修復的指令
- 📝 使用 `-e` 參數可以獲得詳細的錯誤解釋
- 🗑️ 使用 `--uninstall` 參數可以完整移除此工具

## 安裝

1. 首先，你需要一個 [Gemini API Key](https://makersuite.google.com/app/apikey)

2. 下載並執行安裝腳本：
```bash
curl -s -o install_fix.sh https://raw.githubusercontent.com/erichung9060/fix-cli/refs/heads/main/install_fix.sh && source install_fix.sh
```

## 使用方法

1. 當你打的指令出現錯誤時，直接輸入：
```bash
fix
```

2. 如果你想要得到詳細的錯誤解釋，使用：
```bash
fix -e
```

3. 如果你想要解除安裝，使用：
```bash
fix --uninstall
```

## 範例

```bash
$ ls /nonexistent
ls: /nonexistent: No such file or directory

$ fix
[fix] Asking Gemini for a fix...
[fix] Gemini suggests command: ls /
```

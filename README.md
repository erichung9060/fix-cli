# fix-cli

🛠️ A command-line fixing tool powered by Gemini AI 2.0 — whenever you run a broken command, it helps you figure out the correct one !

## Features

- 🤖 Uses Gemini 2.0 flash to analyze command errors and suggest fixes
- 🔄 Option to confirm before running the suggested fix
- 📝 Use the `-e` flag to get a detailed explanation of the issue
- 💬 Use the `-i` flag to input custom questions or error codes
- 🗑️ Use the `--uninstall` flag to completely remove the tool
- ✅ Supports Linux and macOS


## Installation

1. First, you need to get a [Gemini API Key](https://makersuite.google.com/app/apikey)

2. Run this command to download and install fix-cli tool:
```bash
source <(curl -fsSL https://raw.githubusercontent.com/erichung9060/fix-cli/refs/heads/main/install_fix-cli.sh)
```

## Usage

1. When a command fails, just run:
```bash
fix
```

2. If you want a detailed explanation of the error, run:
```bash
fix -e
```

3. To input custom questions or error codes, run:
```bash
fix -i
```

4. To uninstall the tool, run:
```bash
fix --uninstall
```

## Example

1. `fix`
<img width="716" alt="fix" src="https://github.com/user-attachments/assets/aad0059f-85e5-42ba-bfde-8e95fb8a6901" />

2. `fix -e`
<img width="716" alt="fix -e" src="https://github.com/user-attachments/assets/44eaff41-3322-4dc2-8716-f2bba4d9af6d" />

3. `fix -i`
<img width="716" alt="fix -i" src="https://github.com/user-attachments/assets/cbc664e8-71c0-4975-8b83-de93b6b0871b" />

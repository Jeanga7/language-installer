# 🌐 Language Installer Script

![ShellCheck Lint](https://github.com/jeanga7/language-installer/actions/workflows/shellcheck.yml/badge.svg)
![Version](https://img.shields.io/github/v/release/jeanga7/language-installer?style=flat-square)
[![ShellCheck](https://img.shields.io/badge/ShellCheck-passed-brightgreen?style=flat-square&logo=gnu-bash)](https://www.shellcheck.net/)

> A professional multi-language installer script for Linux environments.

A powerful and easy-to-use Bash script to install popular programming languages on Debian-based Linux systems.  
Designed for developers, students, and sysadmins who want a quick, interactive, and customizable setup.

---

## 🚀 Features

- ✅ Install 19+ popular programming languages
- 📦 Handles special installations (Node.js, Flutter, Dart, etc.)
- 📋 Interactive or CLI usage
- ⚙️ Dependency auto-setup
- 📄 Logging support
- 🛡️ Root-check with safe execution (`set -euo pipefail`)
- 🧠 Skips already installed languages

---

## 📦 Supported Languages

| ID  | Language  | Command/Package |
|-----|-----------|-----------------|
| 1   | Python    | `python3`       |
| 2   | Go        | `go`            |
| 3   | Rust      | `rustc`         |
| 4   | Java      | `java`          |
| 5   | Node.js   | `node`          |
| 6   | Deno      | `deno`          |
| 7   | Ruby      | `ruby`          |
| 8   | PHP       | `php`           |
| 9   | Perl      | `perl`          |
| 10  | Lua       | `lua5.4`        |
| 11  | C         | `gcc`           |
| 12  | C++       | `g++`           |
| 13  | C#        | `mono`          |
| 14  | Kotlin    | `kotlin`        |
| 15  | Haskell   | `ghc`           |
| 16  | Elixir    | `elixir`        |
| 17  | R         | `R`             |
| 18  | Dart      | `dart`          |
| 19  | Flutter   | `flutter`       |

---

## 🛠️ Requirements

- Linux (Debian/Ubuntu-based)
- `sudo` or root privileges
- `apt`, `curl`, `wget`, `gnupg`, `snap`

---

## 📥 Installation

Clone the repository and run the installer:

```bash
git clone https://github.com/Jeanga7/language-installer.git
cd language-installer
chmod +x install.sh
sudo ./install.sh --interactive
````

Or try it online:

[![Run on Replit](https://replit.com/badge/github/Jeanga7/language-installer)](https://replit.com/new/github/Jeanga7/language-installer)
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/Jeanga7/language-installer)

---

## ⚡️ One-Liner Install

Create a shortcut command:

```bash
alias install-langs="bash <(curl -sSL https://raw.githubusercontent.com/Jeanga7/language-installer/main/install.sh)"
```

Then simply run:

```bash
install-langs
```

---

## ⚙️ Usage

### 🎛 Interactive Mode

```bash
sudo ./install.sh --interactive
```

An interactive menu will guide you to select languages.

### 💻 CLI Mode

Install selected languages by ID:

```bash
sudo ./install.sh 1 3 5
```

*(Python, Rust, Node.js in this example)*

### 📦 Install All

```bash
sudo ./install.sh all
```

Installs **everything** in the list.

---

## 📄 Output Log

All installation steps and outputs are saved in a log file:

```bash
less install.log
```

---

## 🧪 Post-Installation Check

Uncomment the line at the end of `install.sh` to automatically verify installs:

```bash
# check_all_installed
```

---

## 🧰 Customization

You can modify or add new languages in the script:

```bash
declare -A LANGUAGES=(
  ["1"]="Python:python3"
  ...
  ["20"]="Zig:zig"
)
```

Each entry follows the format: `["ID"]="DisplayName:command_to_check"`

---

## 🛡️ Security

* Script must be run with `sudo` or root privileges
* Uses `set -euo pipefail` for safe execution
* Skips already installed languages

---

## 🤝 Contributing

Pull requests and suggestions are welcome!
Feel free to fork the repo, improve the code, or add more languages.

---

## 📜 License

MIT License. See [LICENSE](./LICENSE) for details.

---

## 👨‍💻 Author

**JeanGa7**
GitHub: [@jeanga7](https://github.com/jeanga7)

---

## ⭐️ Star if you like it!

If this script saved you time, give it a ⭐️ and share it with your fellow devs!

```
```

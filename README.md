# 🌐 Language Installer Script

![ShellCheck Lint](https://github.com/jeanga7/language-installer/actions/workflows/shellcheck.yml/badge.svg)
![Version](https://img.shields.io/github/v/release/jeanga7/language-installer?style=flat-square)
[![ShellCheck](https://img.shields.io/badge/ShellCheck-passed-brightgreen?style=flat-square\&logo=gnu-bash)](https://www.shellcheck.net/)

> A professional multi-language installer script for Linux environments.

A powerful and easy-to-use Bash script to install popular programming languages on Debian-based Linux systems.
Designed for developers, students, and sysadmins who want a quick, interactive, and customizable setup.

---

## 🚀 Features

* ✅ Install 19+ popular programming languages
* 📦 Handles special installations (Node.js, Flutter, Dart, etc.)
* 📋 Interactive or CLI usage
* ⚙️ Dependency auto-setup
* 📄 Logging support
* 🛡️ Root-check with safe execution (`set -euo pipefail`)
* 🧠 Skips already installed languages

---

## 📦 Supported Languages

| ID | Language | Command/Package |
| -- | -------- | --------------- |
| 1  | Python   | `python3`       |
| 2  | Go       | `go`            |
| 3  | Rust     | `rustc`         |
| 4  | Java     | `java`          |
| 5  | Node.js  | `node`          |
| 6  | Deno     | `deno`          |
| 7  | Ruby     | `ruby`          |
| 8  | PHP      | `php`           |
| 9  | Perl     | `perl`          |
| 10 | Lua      | `lua5.4`        |
| 11 | C        | `gcc`           |
| 12 | C++      | `g++`           |
| 13 | C#       | `mono`          |
| 14 | Kotlin   | `kotlin`        |
| 15 | Haskell  | `ghc`           |
| 16 | Elixir   | `elixir`        |
| 17 | R        | `R`             |
| 18 | Dart     | `dart`          |
| 19 | Flutter  | `flutter`       |

---

## 🛠️ Requirements

* Linux (Debian/Ubuntu-based)
* `sudo` or root privileges
* `apt`, `curl`, `wget`, `gnupg`, `snap`

---

## 📥 Installation

Clone the repository and run the installer:

```bash
git clone https://github.com/jeanga7/language-installer.git
cd language-installer
chmod +x install.sh
sudo ./install.sh --interactive
```

Or try it online:

[![Run on Replit](https://replit.com/badge/github/jeanga7/language-installer)](https://replit.com/new/github/jeanga7/language-installer)
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/jeanga7/language-installer)

---

## 📦 Releases

Download pre-packaged archives from the [Releases](https://github.com/jeanga7/language-installer/releases) page:

* **language-installer.tar.gz**
* **language-installer.zip**

Simply extract and run:

```bash
tar -xzf language-installer.tar.gz  # or unzip language-installer.zip
cd language-installer
sudo ./install.sh --interactive
```

---

## ⚡️ One-Liner Install

Create a shortcut command:

```bash
alias install-langs="bash <(curl -sSL https://raw.githubusercontent.com/jeanga7/language-installer/main/install.sh)"
```

Then simply run:

```bash
install-langs
```

---

## 🖥️ Desktop Launcher (One-Click)

Place the `install.desktop` file in your system applications folder for a GUI launcher:

```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=Language Installer
Comment=Install multiple programming languages with one click
Exec=gnome-terminal -- bash -c "cd ~/language-installer && sudo ./install.sh --interactive; exec bash"
Icon=utilities-terminal
Terminal=false
Categories=Development;
```

Install it with:

```bash
chmod +x install.desktop
cp install.desktop ~/.local/share/applications/
```

Then search for "Language Installer" in your application menu.

---

## ⚙️ Usage

### 🎛 Interactive Mode

```bash
sudo ./install.sh --interactive
```

### 💻 CLI Mode

```bash
sudo ./install.sh 1 3 5
```

*(Installs Python, Rust, Node.js in this example)*

### 📦 Install All

```bash
sudo ./install.sh all
```

Installs **everything** in the list.

---

## 📄 Output Log

All steps and outputs are saved in `install.log`:

```bash
less install.log
```

---

## 🧪 Post-Installation Check

Uncomment the following line at the end of `install.sh` to verify installs automatically:

```bash
# check_all_installed
```

---

## 📝 Changelog

See [CHANGELOG.md](./CHANGELOG.md) for details on each release.

---

## 🧰 Customization

Modify or add new languages in the script:

```bash
declare -A LANGUAGES=(
  ["1"]="Python:python3"
  ...
  ["20"]="Zig:zig"
)
```

---

## 🛡️ Security

* Must be run with `sudo` or root
* Uses `set -euo pipefail`
* Skips already installed languages

---

## 🤝 Contributing

Pull requests and suggestions are welcome!
Fork the repo and submit changes via PR.

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

---
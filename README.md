# 🌐 Language Installer Script

A powerful and easy-to-use Bash script to install popular programming languages on Debian-based Linux systems. Designed for developers, students, and sysadmins who want a quick, interactive, and customizable setup.

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

```bash
git clone https://github.com/Jeanga7/language-installer.git
cd language-installer
chmod +x install.sh
sudo ./install.sh --interactive
````

---

## ⚙️ Usage

### 🎛 Interactive Mode

```bash
sudo ./install.sh --interactive
```

You'll be presented with a menu to select one or more languages to install.

### 💻 CLI Mode

```bash
sudo ./install.sh 1 3 5
```

Installs selected languages by ID (Python, Rust, Node.js in this example).

### 📦 Install All

```bash
sudo ./install.sh all
```

Installs **everything** in the list.

---

## 📄 Output Log

All installation steps and messages are logged in `install.log`:

```bash
less install.log
```

---

## 🧪 Post-Installation Check

Uncomment the `check_all_installed` line at the end of the script to verify installation of all languages:

```bash
# check_all_installed
```

---

## 🧰 Customization

You can easily add new languages or modify existing ones:

```bash
declare -A LANGUAGES=(
  ["1"]="Python:python3"
  ...
  ["20"]="Zig:zig"
)
```

Each entry is in the format: `["ID"]="DisplayName:command_to_check"`

---

## 🛡️ Security

* The script must be run as root (`sudo`) to ensure successful installation.
* Uses `set -euo pipefail` to exit on any error.
* Skips already installed languages to avoid duplication or overwrite.

---

## 🤝 Contributing

Pull requests and suggestions are welcome! Feel free to fork the repo and make improvements.

---

## 📜 License

MIT License. See [LICENSE](./LICENSE) for details.

---

## 👨‍💻 Author

**JeanGa7**
GitHub: [@your-username](https://github.com/jeanga7)
---

## ⭐️ Star if you like it!

If this script saved you time, give it a ⭐️ and share with your fellow devs!

```


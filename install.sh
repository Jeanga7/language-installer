#!/bin/bash

set -euo pipefail

# ========== CONFIGURATION ==========
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
LOG_FILE="install.log"

declare -A LANGUAGES=(
  ["1"]="Python:python3"
  ["2"]="Go:go"
  ["3"]="Rust:rustc"
  ["4"]="Java:java"
  ["5"]="Node.js:node"
  ["6"]="Deno:deno"
  ["7"]="Ruby:ruby"
  ["8"]="PHP:php"
  ["9"]="Perl:perl"
  ["10"]="Lua:lua5.4"
  ["11"]="C:gcc"
  ["12"]="C++:g++"
  ["13"]="C#:mono"
  ["14"]="Kotlin:kotlin"
  ["15"]="Haskell:ghc"
  ["16"]="Elixir:elixir"
  ["17"]="R:R"
  ["18"]="Dart:dart"
  ["19"]="Flutter:flutter"
)

# ========== FUNCTIONS ==========

print_help() {
  echo -e "${GREEN}Usage:${NC} $0 [all | num1 num2 ... | --interactive]"
  echo -e "Examples: $0 1 3 5"
  echo -e "          $0 all"
  echo -e "          $0 --interactive"
}

print_menu() {
  echo -e "${GREEN}=== LANGUAGE INSTALLER ===${NC}"
  for key in $(printf "%s\n" "${!LANGUAGES[@]}" | sort -n); do
    IFS=":" read -r name _ <<< "${LANGUAGES[$key]}"
    echo "  [$key] $name"
  done
  echo -e "Type numbers separated by spaces or 'all' to install everything."
}

interactive_prompt() {
  print_menu
  read -rp "Your choice: " input
  if [[ "$input" == "all" ]]; then
    CHOIX=("${!LANGUAGES[@]}")
  else
    CHOIX=($input)
  fi
}

log() {
  echo -e "$1" | tee -a "$LOG_FILE"
}

require_root() {
  if [[ "$EUID" -ne 0 ]]; then
    echo -e "${RED}This script must be run as root. Use sudo.${NC}"
    exit 1
  fi
}

install_dependencies() {
  log "${GREEN}→ Updating repositories and installing base tools...${NC}"
  apt update -qq
  apt install -y curl wget gnupg lsb-release software-properties-common apt-transport-https
}

install_language() {
  local name=$1
  local package=$2

  log "${YELLOW}→ Installing $name...${NC}"

  case "$name" in
    "Node.js")
      curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
      apt install -y nodejs ;;
    "Deno")
      if command -v deno &>/dev/null; then
        log "${YELLOW}⏭ Deno is already installed. Skipped.${NC}"
      else
        snap install deno --classic
      fi
      ;;
    "Rust")
      if command -v rustc &>/dev/null && command -v cargo &>/dev/null; then
        log "${YELLOW}⏭ Rust is already installed. Skipped.${NC}"
      else
        apt install -y cargo
        log "${GREEN}✔ Rust (cargo + rustc) installed via apt.${NC}"
      fi
      ;;
    "Flutter")
      if ! command -v flutter &>/dev/null; then
        snap install flutter --classic
        log "${GREEN}✔ Flutter installed via snap.${NC}"
      else
        log "${YELLOW}⏭ Flutter is already installed. Skipped.${NC}"
      fi

      if command -v flutter &>/dev/null; then
        if flutter precache; then
          log "${GREEN}✔ Flutter precache done.${NC}"
        else
          log "${RED}⚠ Error during Flutter precache.${NC}"
        fi
      else
        log "${RED}⚠ Flutter is not in the PATH. Try opening a new terminal or run 'export PATH=\$PATH:/snap/bin'.${NC}"
      fi ;;
    "Dart")
      wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee /usr/share/keyrings/dart-archive-keyring.gpg >/dev/null
      echo "deb [signed-by=/usr/share/keyrings/dart-archive-keyring.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list
      apt update
      apt install -y dart ;;
    *)
      apt install -y "$package" ;;
  esac

  log "${GREEN}✔ $name successfully installed.${NC}"
}

# ========== MAIN SCRIPT ==========

require_root
echo "" > "$LOG_FILE"

CHOIX=()

if [[ $# -eq 0 || "$1" == "--interactive" ]]; then
  interactive_prompt
elif [[ "$1" == "all" ]]; then
  CHOIX=("${!LANGUAGES[@]}")
else
  CHOIX=("$@")
fi

install_dependencies

for key in "${CHOIX[@]}"; do
  if [[ -z "${LANGUAGES[$key]+x}" ]]; then
    log "${RED}❌ Invalid key: $key${NC}"
    continue
  fi

  IFS=":" read -r NAME PACKAGE <<< "${LANGUAGES[$key]}"

  if command -v "$PACKAGE" &>/dev/null; then
    log "${YELLOW}⏭ $NAME is already installed. Skipped.${NC}"
  else
    install_language "$NAME" "$PACKAGE"
  fi
done

check_all_installed() {
  local all_ok=true
  log "${GREEN}\n=== Checking installed languages ===${NC}"
  for key in $(printf "%s\n" "${!LANGUAGES[@]}" | sort -n); do
    IFS=":" read -r NAME PACKAGE <<< "${LANGUAGES[$key]}"
    if command -v "$PACKAGE" &>/dev/null; then
      log "${GREEN}✔ $NAME is installed.${NC}"
    else
      log "${RED}✗ $NAME is NOT installed.${NC}"
      all_ok=false
    fi
  done

  if $all_ok; then
    log "${GREEN}All languages are installed.${NC}"
  else
    log "${RED}Some languages are not installed.${NC}"
  fi
}

log "${GREEN}\n✔ Installation complete. Run: source ~/.bashrc${NC}"

# check_all_installed

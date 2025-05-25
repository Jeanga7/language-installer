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
  ["2"]="Go:golang"
  ["3"]="Rust:rustc"
  ["4"]="Java:default-jdk"
  ["5"]="Node.js:nodejs"
  ["6"]="Deno:deno"
  ["7"]="Ruby:ruby"
  ["8"]="PHP:php"
  ["9"]="Perl:perl"
  ["10"]="Lua:lua5.4"
  ["11"]="C:gcc"
  ["12"]="C++:g++"
  ["13"]="C#:mono-complete"
  ["14"]="Kotlin:default-jdk"
  ["15"]="Swift:swift"
  ["16"]="Haskell:ghc"
  ["17"]="Elixir:elixir"
  ["18"]="R:r-base"
  ["19"]="Dart:dart"
  ["20"]="Flutter:flutter"
)

# ========== FONCTIONS ==========

print_help() {
  echo -e "${GREEN}Usage:${NC} $0 [all | num1 num2 ... | --interactive]"
  echo -e "Exemples : $0 1 3 5"
  echo -e "           $0 all"
  echo -e "           $0 --interactive"
}

print_menu() {
  echo -e "${GREEN}=== INSTALLATEUR DE LANGAGES ===${NC}"
  for key in $(printf "%s\n" "${!LANGUAGES[@]}" | sort -n); do
    IFS=":" read -r name _ <<< "${LANGUAGES[$key]}"
    echo "  [$key] $name"
  done
  echo -e "Tapez les numéros séparés par des espaces ou 'all' pour tout installer."
}

interactive_prompt() {
  print_menu
  read -rp "Votre choix : " input
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
    echo -e "${RED}Ce script doit être exécuté en tant que root. Utilisez sudo.${NC}"
    exit 1
  fi
}

install_dependencies() {
  log "${GREEN}→ Mise à jour des dépôts et installation des outils de base...${NC}"
  apt update -qq
  apt install -y curl wget gnupg lsb-release software-properties-common apt-transport-https
}

install_language() {
  local name=$1
  local package=$2

  log "${YELLOW}→ Installation de $name...${NC}"

  case "$name" in
    "Node.js")
      curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
      apt install -y nodejs ;;
    "Deno")
      curl -fsSL https://deno.land/install.sh | sh
      echo 'export PATH="$HOME/.deno/bin:$PATH"' >> ~/.bashrc ;;
    "Rust")
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y ;;
    "Flutter")
      if ! command -v flutter &>/dev/null; then
        snap install flutter --classic
        log "${GREEN}✔ Flutter installé via snap.${NC}"
      else
        log "${YELLOW}⏭ Flutter est déjà installé. Ignoré.${NC}"
      fi

      # Vérifier si flutter est dans le PATH
      if command -v flutter &>/dev/null; then
        if flutter precache; then
          log "${GREEN}✔ Flutter précache effectué.${NC}"
        else
          log "${RED}⚠ Erreur lors du précache de Flutter.${NC}"
        fi
      else
        log "${RED}⚠ Flutter n'est pas dans le PATH. Essayez d'ouvrir un nouveau terminal ou exécutez 'export PATH=\$PATH:/snap/bin'.${NC}"
      fi ;;
    "Dart")
      wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee /usr/share/keyrings/dart-archive-keyring.gpg >/dev/null
      echo "deb [signed-by=/usr/share/keyrings/dart-archive-keyring.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list
      apt update
      apt install -y dart ;;
    "Swift")
      apt install -y clang libicu-dev libblocksruntime-dev libcurl4-openssl-dev \
        libssl-dev uuid-dev libbsd-dev libsqlite3-dev libxml2-dev ;;
    *)
      apt install -y "$package" ;;
  esac

  log "${GREEN}✔ $name installé avec succès.${NC}"
}

# ========== SCRIPT PRINCIPAL ==========

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
    log "${RED}❌ Clé invalide : $key${NC}"
    continue
  fi

  IFS=":" read -r NAME PACKAGE <<< "${LANGUAGES[$key]}"

  if command -v "$PACKAGE" &>/dev/null; then
    log "${YELLOW}⏭ $NAME est déjà installé. Ignoré.${NC}"
  else
    install_language "$NAME" "$PACKAGE"
  fi
done

log "${GREEN}\n✔ Installation terminée. Exécutez : source ~/.bashrc${NC}"

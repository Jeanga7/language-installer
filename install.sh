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
      if command -v deno &>/dev/null; then
        log "${YELLOW}⏭ Deno est déjà installé. Ignoré.${NC}"
      else
        snap install deno --classic
      fi
      ;;
    "Rust")
      if command -v rustc &>/dev/null && command -v cargo &>/dev/null; then
        log "${YELLOW}⏭ Rust est déjà installé. Ignoré.${NC}"
      else
        apt install -y cargo
        log "${GREEN}✔ Rust (cargo + rustc) installé via apt.${NC}"
      fi
      ;;
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

check_all_installed() {
  local all_ok=true
  log "${GREEN}\n=== Vérification des langages installés ===${NC}"
  for key in $(printf "%s\n" "${!LANGUAGES[@]}" | sort -n); do
    IFS=":" read -r NAME PACKAGE <<< "${LANGUAGES[$key]}"
    if command -v "$PACKAGE" &>/dev/null; then
      log "${GREEN}✔ $NAME est installé.${NC}"
    else
      log "${RED}✗ $NAME n'est PAS installé.${NC}"
      all_ok=false
    fi
  done

  if $all_ok; then
    log "${GREEN}Tous les langages sont installés.${NC}"
  else
    log "${RED}Certains langages ne sont pas installés.${NC}"
  fi
}


log "${GREEN}\n✔ Installation terminée. Exécutez : source ~/.bashrc${NC}"

# check_all_installed
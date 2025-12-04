#!/usr/bin/env bash

# ============================================
#  Snusbase CLI - Colored Version
# ============================================

# Warna
CYAN="\033[96m"
GREEN="\033[92m"
YELLOW="\033[93m"
RED="\033[91m"
MAGENTA="\033[95m"
BLUE="\033[94m"
BOLD="\033[1m"
RESET="\033[0m"

# Ambil API key dari ENV
API_KEY="${EXPORT_KEY_SNUSBASE}"

if [ -z "$API_KEY" ]; then
    echo -e "${RED}${BOLD}Error:${RESET} ENV EXPORT_KEY_SNUSBASE belum diset."
    echo -e "Set dulu dengan:"
    echo -e "  ${YELLOW}export EXPORT_KEY_SNUSBASE=\"API_KEY_KAMU\"${RESET}"
    exit 1
fi

# ============================================
# HELP / USAGE
# ============================================
usage() {
    echo -e "${BOLD}${CYAN}Usage:${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} -u|--username ${YELLOW}USERNAME${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} -e|--email ${YELLOW}EMAIL${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --lastip ${YELLOW}IP${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --password ${YELLOW}PASSWORD${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --hash ${YELLOW}HASH${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --name ${YELLOW}NAME${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --domain ${YELLOW}DOMAIN${RESET}"
    echo
    echo -e "${BOLD}${CYAN}Options:${RESET}"
    echo -e "  ${YELLOW}-u, --username${RESET}   Cari berdasarkan username"
    echo -e "  ${YELLOW}-e, --email${RESET}      Cari berdasarkan email"
    echo -e "  ${YELLOW}    --lastip${RESET}     Cari berdasarkan last IP"
    echo -e "  ${YELLOW}    --password${RESET}   Cari berdasarkan plain password"
    echo -e "  ${YELLOW}    --hash${RESET}       Cari berdasarkan hash"
    echo -e "  ${YELLOW}    --name${RESET}       Cari berdasarkan nama"
    echo -e "  ${YELLOW}    --domain${RESET}     Cari berdasarkan domain (misal: gmail.com)"
    echo -e "  ${YELLOW}-h, --help${RESET}       Tampilkan bantuan"
    echo
    echo -e "${BOLD}${CYAN}Contoh:${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} -u dika"
    echo -e "  ${GREEN}$(basename "$0")${RESET} -e example@gmail.com"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --domain gmail.com"
}

# Cek input minimal
if [ $# -lt 2 ]; then
    usage
    exit 1
fi

TYPE=""
TERM=""

# ============================================
# PARSE ARGUMENTS
# ============================================
while [[ $# -gt 0 ]]; do
    case "$1" in
        -u|--username)
            TYPE="username"
            TERM="$2"
            shift 2
            ;;
        -e|--email)
            TYPE="email"
            TERM="$2"
            shift 2
            ;;
        --lastip)
            TYPE="lastip"
            TERM="$2"
            shift 2
            ;;
        --password)
            TYPE="password"
            TERM="$2"
            shift 2
            ;;
        --hash)
            TYPE="hash"
            TERM="$2"
            shift 2
            ;;
        --name)
            TYPE="name"
            TERM="$2"
            shift 2
            ;;
        --domain)
            TYPE="_domain"
            TERM="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo -e "${RED}${BOLD}Option tidak dikenal:${RESET} $1"
            usage
            exit 1
            ;;
    esac
done

if [[ -z "$TYPE" || -z "$TERM" ]]; then
    echo -e "${RED}${BOLD}Error:${RESET} type atau term belum diisi."
    usage
    exit 1
fi

# ============================================
# JALANKAN PYTHON CLIENT
# ============================================
python "$(dirname "$0")/snusbase_client.py" \
    --api-key "$API_KEY" \
    --type "$TYPE" \
    --term "$TERM"

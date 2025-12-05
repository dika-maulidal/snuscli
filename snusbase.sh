#!/usr/bin/env bash

CYAN="\033[96m"
GREEN="\033[92m"
YELLOW="\033[93m"
RED="\033[91m"
MAGENTA="\033[95m"
BLUE="\033[94m"
BOLD="\033[1m"
RESET="\033[0m"

API_KEY="${EXPORT_KEY_SNUSBASE}"

if [ -z "$API_KEY" ]; then
    echo -e "${RED}${BOLD}Error:${RESET} ENV EXPORT_KEY_SNUSBASE belum diset."
    echo -e "Set dulu dengan:"
    echo -e "  ${YELLOW}export EXPORT_KEY_SNUSBASE=\"API_KEY_KAMU\"${RESET}"
    exit 1
fi

MODE="search"
TYPE=""
TERM=""
OUTPUT_FORMAT=""
WHOIS_IPS=""

usage() {
    echo -e "${BOLD}${CYAN}Usage (Search):${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} -u|--username ${YELLOW}USERNAME${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} -e|--email ${YELLOW}EMAIL${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --lastip ${YELLOW}IP${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --password ${YELLOW}PASSWORD${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --hash ${YELLOW}HASH${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --name ${YELLOW}NAME${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --domain ${YELLOW}DOMAIN${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} -o|--output ${YELLOW}txt|json${RESET}"
    echo
    echo -e "${BOLD}${CYAN}Usage (IP WHOIS):${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --ip-whois ${YELLOW}IP${RESET}"
    echo -e "  ${GREEN}$(basename "$0")${RESET} --ip-whois ${YELLOW}\"IP1,IP2,...\"${RESET}"
    echo
    echo -e "${BOLD}${CYAN}Options:${RESET}"
    echo -e "  ${YELLOW}-u, --username${RESET}      Cari berdasarkan username"
    echo -e "  ${YELLOW}-e, --email${RESET}         Cari berdasarkan email"
    echo -e "      ${YELLOW}--lastip${RESET}        Cari berdasarkan last IP"
    echo -e "      ${YELLOW}--password${RESET}      Cari berdasarkan plain password"
    echo -e "      ${YELLOW}--hash${RESET}          Cari berdasarkan hash"
    echo -e "      ${YELLOW}--name${RESET}          Cari berdasarkan nama"
    echo -e "      ${YELLOW}--domain${RESET}        Cari berdasarkan domain"
    echo -e "      ${YELLOW}--ip-whois${RESET}       Gunakan WHOIS IP lookup"
    echo -e "  ${YELLOW}-o, --output${RESET}        Simpan hasil ke file (txt/json)"
    echo -e "  ${YELLOW}-h, --help${RESET}          Tampilkan bantuan"
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        -u|--username) TYPE="username"; TERM="$2"; shift 2 ;;
        -e|--email) TYPE="email"; TERM="$2"; shift 2 ;;
        --lastip) TYPE="lastip"; TERM="$2"; shift 2 ;;
        --password) TYPE="password"; TERM="$2"; shift 2 ;;
        --hash) TYPE="hash"; TERM="$2"; shift 2 ;;
        --name) TYPE="name"; TERM="$2"; shift 2 ;;
        --domain) TYPE="_domain"; TERM="$2"; shift 2 ;;
        --ip-whois) MODE="whois"; WHOIS_IPS="$2"; shift 2 ;;
        -o|--output) OUTPUT_FORMAT="$2"; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) echo -e "${RED}Unknown option:$RESET $1"; usage; exit 1 ;;
    esac
done

if [[ "$MODE" == "whois" ]]; then
    if [[ -z "$WHOIS_IPS" ]]; then
        echo -e "${RED}Error:${RESET} IP belum diisi."
        exit 1
    fi

    python "$(dirname "$0")/snusbase_client.py" \
        --api-key "$API_KEY" \
        --whois \
        --ips "$WHOIS_IPS" \
        ${OUTPUT_FORMAT:+--output "$OUTPUT_FORMAT"}

    exit $?
fi

if [[ -z "$TYPE" || -z "$TERM" ]]; then
    echo -e "${RED}Error:${RESET} type atau term belum diisi."
    usage
    exit 1
fi

python "$(dirname "$0")/snusbase_client.py" \
    --api-key "$API_KEY" \
    --type "$TYPE" \
    --term "$TERM" \
    ${OUTPUT_FORMAT:+--output "$OUTPUT_FORMAT"}

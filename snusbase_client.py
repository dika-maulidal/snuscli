#!/usr/bin/env python3
import argparse
import json
import sys
import re

try:
    import requests
except ImportError:
    print("Error: install module 'requests' dengan:")
    print("  pip install requests")
    sys.exit(1)

API_URL_SEARCH = "https://api.snusbase.com/data/search"
API_URL_WHOIS = "https://api.snusbase.com/tools/ip-whois"

RESET = "\033[0m"
WHITE = "\033[97m"
CYAN = "\033[96m"
YELLOW = "\033[93m"
GREEN = "\033[92m"
MAGENTA = "\033[95m"
RED = "\033[91m"


def colorize_json(json_str: str) -> str:
    json_str = re.sub(r"([\{\}\[\]])", WHITE + r"\1" + RESET, json_str)
    json_str = re.sub(r'"([^"]+)"\s*:', CYAN + r'"\1"' + RESET + ":", json_str)
    json_str = re.sub(r':\s*"([^"]*)"', r': ' + GREEN + r'"\1"' + RESET, json_str)
    json_str = re.sub(r":\s*([-]?\d+\.?\d*)", r": " + MAGENTA + r"\1" + RESET, json_str)
    json_str = re.sub(r":\s*(true|false|null)", r": " + RED + r"\1" + RESET, json_str)
    return json_str


def sanitize_filename_part(text: str) -> str:
    return re.sub(r"[^A-Za-z0-9_.-]", "_", text)


def main():
    parser = argparse.ArgumentParser(description="Snusbase CLI")
    parser.add_argument("--api-key", required=True)

    parser.add_argument("--type", required=False)
    parser.add_argument("--term", required=False)

    parser.add_argument("--whois", action="store_true")
    parser.add_argument("--ips", required=False)

    parser.add_argument("--output", required=False)

    args = parser.parse_args()

    headers = {
        "Content-Type": "application/json",
        "Auth": args.api_key,
    }

    # WHOIS MODE
    if args.whois:
        if not args.ips:
            print(f"{RED}Error:{RESET} --ips wajib diisi.")
            sys.exit(1)

        terms = [ip.strip() for ip in args.ips.split(",") if ip.strip()]
        payload = {"terms": terms}
        url = API_URL_WHOIS
        mode_label = "whois"

    else:
        if not args.type or not args.term:
            print(f"{RED}Error:{RESET} --type dan --term wajib untuk search.")
            sys.exit(1)

        payload = {
            "terms": [args.term],
            "types": [args.type]
        }
        url = API_URL_SEARCH
        mode_label = args.type

    # HTTP request
    try:
        resp = requests.post(url, headers=headers, json=payload, timeout=30)
    except requests.RequestException as e:
        print(f"{RED}Request error:{RESET} {e}")
        sys.exit(1)

    if resp.status_code != 200:
        print(f"{RED}HTTP {resp.status_code}{RESET}")
        print(resp.text)
        sys.exit(1)

    data = resp.json()
    pretty_json = json.dumps(data, indent=2, ensure_ascii=False)

    print(colorize_json(pretty_json))

    # Output file
    if args.output:
        fmt = args.output.lower()
        safe = sanitize_filename_part(args.term if not args.whois else args.ips.split(",")[0])
        filename = f"snusbase_{mode_label}_{safe}.{fmt}"

        if fmt == "json":
            with open(filename, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)

        elif fmt == "txt":
            with open(filename, "w", encoding="utf-8") as f:
                f.write(pretty_json)

        else:
            print(f"{RED}Format tidak dikenal: gunakan txt/json{RESET}")

        print(f"{GREEN}[+] File disimpan: {YELLOW}{filename}{RESET}")


if __name__ == "__main__":
    main()

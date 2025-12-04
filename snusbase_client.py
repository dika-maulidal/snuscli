#!/usr/bin/env python3
import argparse
import json
import sys
import re

try:
    import requests
except ImportError:
    print("Error: modul 'requests' belum terinstall. Install dengan:")
    print("  pip install requests")
    sys.exit(1)


API_URL = "https://api.snusbase.com/data/search"

# ANSI COLORS
RESET = "\033[0m"
WHITE = "\033[97m"
CYAN = "\033[96m"
YELLOW = "\033[93m"
GREEN = "\033[92m"
MAGENTA = "\033[95m"
RED = "\033[91m"


def colorize_json(json_str):
    # Kurung kurawal dan bracket
    json_str = re.sub(r"([\{\}\[\]])", WHITE + r"\1" + RESET, json_str)

    # Key JSON: "key":
    json_str = re.sub(r'"([^"]+)"\s*:', CYAN + r'"\1"' + RESET + ":", json_str)

    # String value: "text"
    json_str = re.sub(r':\s*"([^"]*)"', r': ' + GREEN + r'"\1"' + RESET, json_str)

    # Number value: 123, 45.6
    json_str = re.sub(r":\s*([-]?\d+\.?\d*)", r": " + MAGENTA + r"\1" + RESET, json_str)

    # Boolean / null
    json_str = re.sub(r":\s*(true|false|null)", r": " + RED + r"\1" + RESET, json_str)

    return json_str


def main():
    parser = argparse.ArgumentParser(description="Snusbase CLI")
    parser.add_argument("--api-key", required=True)
    parser.add_argument("--type", required=True,
                        choices=["email", "username", "lastip", "password",
                                 "hash", "name", "_domain"])
    parser.add_argument("--term", required=True)

    args = parser.parse_args()

    headers = {
        "Content-Type": "application/json",
        "Auth": args.api_key
    }

    payload = {
        "terms": [args.term],
        "types": [args.type]
    }

    try:
        resp = requests.post(API_URL, headers=headers, json=payload, timeout=30)
    except requests.RequestException as e:
        print("Request error:", e)
        sys.exit(1)

    if resp.status_code != 200:
        print(f"Error HTTP {resp.status_code}")
        print(resp.text)
        sys.exit(1)

    try:
        data = resp.json()
    except ValueError:
        print("Response bukan JSON:")
        print(resp.text)
        sys.exit(1)

    # Pretty print JSON biasa
    pretty_json = json.dumps(data, indent=2, ensure_ascii=False)

    # Warna-warnai
    print(colorize_json(pretty_json))


if __name__ == "__main__":
    main()

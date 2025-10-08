#!/usr/bin/env python3
# Hidden_API_Discovery.py
# Usage examples:
#   python3 Hidden_API_Discovery.py shein.com
#   python3 Hidden_API_Discovery.py https://shein.com --wordlist endpoints.txt --output hits.txt --threads 20

import argparse
import concurrent.futures
import sys
import urllib.parse
from pathlib import Path

import requests

def normalize_base(url: str) -> str:
    if not url.startswith(("http://", "https://")):
        url = "https://" + url
    return url.rstrip("/") + "/"

def load_wordlist(path: Path):
    if not path.exists():
        raise FileNotFoundError(f"Wordlist not found: {path}")
    endpoints = []
    with path.open("r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            if line.startswith("#"):
                continue
            endpoints.append(line)
    return endpoints

def check_endpoint(session: requests.Session, base: str, ep: str, timeout: int):
    # join must handle leading/trailing slashes properly
    url = urllib.parse.urljoin(base, ep.lstrip("/"))
    try:
        r = session.get(url, timeout=timeout, allow_redirects=True)
        # treat these as interesting
        interesting = (200, 201, 202, 204, 301, 302, 401, 403)
        if r.status_code in interesting:
            return (url, r.status_code, True)
        else:
            return (url, r.status_code, False)
    except requests.RequestException as e:
        return (url, str(e), None)

def main():
    p = argparse.ArgumentParser(
        description="Simple Hidden API Discovery (wordlist-driven). Be ethical and authorized."
    )
    p.add_argument("target", help="Target base (e.g. shein.com or https://shein.com/)")
    p.add_argument("--wordlist", "-w", default="endpoints.txt",
                   help="Path to endpoints wordlist (one endpoint per line). Default: endpoints.txt")
    p.add_argument("--threads", "-t", type=int, default=10, help="Concurrent workers (default 10)")
    p.add_argument("--timeout", type=int, default=6, help="Request timeout in seconds (default 6)")
    p.add_argument("--output", "-o", help="Write positive hits to this file (optional)")
    p.add_argument("--verbose", "-v", action="store_true", help="Print non-positive responses as well")
    args = p.parse_args()

    try:
        base = normalize_base(args.target)
        wordlist_path = Path(args.wordlist)
        endpoints = load_wordlist(wordlist_path)
    except Exception as e:
        print(f"[!] Error: {e}", file=sys.stderr)
        sys.exit(2)

    if not endpoints:
        print("[!] Wordlist is empty after filtering comments/blank lines.", file=sys.stderr)
        sys.exit(2)

    session = requests.Session()
    session.headers.update({"User-Agent": "Mozilla/5.0 (compatible; HiddenAPI/1.0)"})

    positives = []
    total = len(endpoints)
    print(f"[i] Target: {base}  Endpoints to test: {total}  Workers: {args.threads}")

    with concurrent.futures.ThreadPoolExecutor(max_workers=args.threads) as ex:
        futures = []
        for ep in endpoints:
            futures.append(ex.submit(check_endpoint, session, base, ep, args.timeout))

        for fut in concurrent.futures.as_completed(futures):
            url, status_or_err, ok = fut.result()
            if ok is True:
                print(f"[+] Found endpoint: {url} ({status_or_err})")
                positives.append((url, status_or_err))
            elif ok is False:
                if args.verbose:
                    print(f"[-] {url} -> {status_or_err}")
            else:
                # network/exception case
                if args.verbose:
                    print(f"[!] {url} -> error: {status_or_err}")

    # Save if requested
    if args.output and positives:
        outp = Path(args.output)
        try:
            with outp.open("w", encoding="utf-8") as f:
                for u, s in positives:
                    f.write(f"{u} {s}\n")
            print(f"[i] Saved {len(positives)} hits to {outp}")
        except Exception as e:
            print(f"[!] Could not write output file: {e}", file=sys.stderr)

    print(f"[i] Done. Total tested: {total}. Positive hits: {len(positives)}")

if __name__ == "__main__":
    main()


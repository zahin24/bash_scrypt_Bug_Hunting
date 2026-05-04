#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1
OUTPUT_DIR="hunt_$DOMAIN"
mkdir -p "$OUTPUT_DIR"

SUBS_FILE="$OUTPUT_DIR/all_subdomains.txt"
RESOLVED_FILE="$OUTPUT_DIR/resolved.txt"
LIVE_FILE="$OUTPUT_DIR/live_hosts.txt"
ENDPOINTS_FILE="$OUTPUT_DIR/endpoints.txt"
NUCLEI_FILE="$OUTPUT_DIR/nuclei_findings.txt"

echo "[*] Starting Full ProjectDiscovery Hunting for → $DOMAIN"
echo "[*] Output Directory: $OUTPUT_DIR"

# 1. Passive Subdomain Enumeration (Subfinder)
echo "[*] Running Subfinder (Passive)..."
subfinder -d "$DOMAIN" -all -silent -o "$SUBS_FILE"

# 2. Active Subdomain Permutation with AlterX
echo "[*] Generating permutations with AlterX..."
cat "$SUBS_FILE" | alterx -silent | tee -a "$SUBS_FILE" >/dev/null

# 3. DNS Resolution + Wildcard Filtering with dnsx
echo "[*] Resolving subdomains with dnsx..."
cat "$SUBS_FILE" | dnsx -silent -a -aaaa -cname -resp -o "$RESOLVED_FILE"

# 4. Live Hosts Detection with httpx
echo "[*] Probing live hosts with httpx..."
cat "$RESOLVED_FILE" | httpx -silent \
    -threads 200 \
    -status-code \
    -title \
    -web-server \
    -tech-detect \
    -o "$LIVE_FILE"

echo "[+] Live hosts found: $(wc -l < "$LIVE_FILE")"

# 5. Crawling with Katana (JS + Deep Crawl)
echo "[*] Crawling live hosts with Katana..."
cat "$LIVE_FILE" | katana -silent \
    -jc \
    -d 3 \
    -c 150 \
    -fs rdn \
    -o "$ENDPOINTS_FILE"

echo "[+] Endpoints crawled: $(wc -l < "$ENDPOINTS_FILE")"

# 6. (Optional) Light Nuclei Scan for Critical Issues
echo "[*] Running Nuclei for critical vulnerabilities..."
cat "$LIVE_FILE" | nuclei -silent \
    -severity critical,high \
    -o "$NUCLEI_FILE"

echo "[+] Nuclei findings saved: $(wc -l < "$NUCLEI_FILE")"

# Final Summary
echo "=================================================="
echo "[+] Hunting Completed Successfully!"
echo "   All Subdomains     → $SUBS_FILE"
echo "   Resolved Domains   → $RESOLVED_FILE"
echo "   Live Hosts         → $LIVE_FILE"
echo "   Endpoints (Katana) → $ENDPOINTS_FILE"
echo "   Nuclei Findings    → $NUCLEI_FILE"
echo "=================================================="

echo "[*] Happy Hunting! 🔥"

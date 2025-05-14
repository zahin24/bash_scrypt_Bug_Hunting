
#!/bin/bash

# Check if a domain is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1
OUTPUT_DIR="recon_$DOMAIN"
SUBS_FILE="$OUTPUT_DIR/all_subdomains.txt"
LIVE_FILE="$OUTPUT_DIR/live_hosts.txt"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "[*] Running subfinder..."
subfinder -d "$DOMAIN" -silent >> "$SUBS_FILE"

echo "[*] Running assetfinder..."
assetfinder --subs-only "$DOMAIN" >> "$SUBS_FILE"

echo "[*] Running amass..."
amass enum -d "$DOMAIN" -silent >> "$SUBS_FILE"

# Remove duplicates
sort -u "$SUBS_FILE" -o "$SUBS_FILE"

echo "[*] Probing for live hosts with httprobe..."
cat "$SUBS_FILE" | httprobe > "$LIVE_FILE"

echo "[+] Enumeration complete."
echo "    Subdomains saved to: $SUBS_FILE"
echo "    Live hosts saved to: $LIVE_FILE"

```

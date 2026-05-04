#!/bin/bash

# Check input
if [ -z "$1" ]; then
  echo "Usage: $0 domain.com"
  exit 1
fi

domain=$1
output_dir="recon/$domain"
mkdir -p $output_dir

echo "[*] Enumerating subdomains for $domain"
cd $output_dir || exit

# Subfinder
echo "[*] Running subfinder..."
subfinder -d $domain -silent -o subfinder.txt

# Assetfinder
echo "[*] Running assetfinder..."
assetfinder --subs-only $domain | tee assetfinder.txt

# Amass (passive)
echo "[*] Running amass (passive)..."
amass enum -passive -d $domain -o amass.txt

# subfin3r
echo "[*] Running subfin3r..."
subfin3r -d $domain -o subfin3r.txt

# Merge and sort
echo "[*] Merging all results..."
cat subfinder.txt assetfinder.txt amass.txt subfin3r.txt | sort -u > all_subs.txt

# Probing live domains
echo "[*] Checking for live subdomains using httpx..."
httpx -l all_subs.txt -silent -status-code -title -o alive.txt

echo "[+] Done! Results saved in $output_dir"

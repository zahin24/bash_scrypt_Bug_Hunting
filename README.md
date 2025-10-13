# Bug Hunting Automation Scripts

This repository contains my automation scripts for bug hunting and recon.
The scripts are small utilities to speed up common tasks (subdomain enumeration, recon, etc.).
# Usage:
- Run the ``enum_sumbdomain.sh`` script like this:
``
./enum_subdomain.sh tergate.com
``
Replace target.com with the domain you want to test.
- Run ``Hidden_API_Discovery.py`` script like this:
```
python3 Hidden_API_Discovery.py https://tergate.com --wordlist /usr/share/seclists/Discovery/Web-Content/api --output hits.txt --threads 20
```

# Example output

When the ``enum_subdomain.sh`` script finishes it creates a directory for the target recon, for example:
```
Dir: Recon/your-target.com
- subdomains.txt
- alive.txt
- screenshots/
- notes.txt

```


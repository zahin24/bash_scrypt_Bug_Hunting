# Bash_scrypt_Bug_Hunting

This repository contains my automation scripts for bug hunting and recon.
The scripts are small utilities to speed up common tasks (subdomain enumeration, recon, etc.).
# Usage:
- Run the ``enum_sumbdomain.sh`` script like this:
``
./enum_subdomain.sh tergate.com
``
Replace target.com with the domain you want to test.

# Example output

When the ``enum_subdomain.sh`` script finishes it creates a directory for the target recon, for example:
```
Dir: Recon/your-target.com
- subdomains.txt
- alive.txt
- screenshots/
- notes.txt

```


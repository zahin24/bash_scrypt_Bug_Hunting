# 🔍 Bug Hunting Automation Scripts

My personal toolkit for speeding up bug hunting and recon. I built these scripts to automate the 'boring' parts of security research—like finding subdomains and probing live hosts—so I can focus on finding actual vulnerabilities.

---

## 📂 Scripts Included

### 1. 🟢 `subdomain_enum.sh`

Basic subdomain enumeration script.

**Features:**

* Subdomain discovery
* Live host detection
* Organized output directory

---

### 2. 🔥 `recon.sh` (Advanced)

Full automation script using ProjectDiscovery tools.

**Features:**

* Passive subdomain enumeration
* Subdomain permutation
* DNS resolution
* Live host probing
* Deep crawling (Katana)
* Vulnerability scanning (Nuclei)

---

## ⚙️ Requirements

Ensure you have Go installed, then run the following to install the necessary tools:

```
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/alterx/cmd/alterx@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/notify/cmd/notify@latest
```


## 🚀 Installation

```bash
git clone https://github.com/zahin24/BugHunting-Scripts.git
cd bugHunting-Scripts
chmod +x *.sh
```

---

## 🧪 Usage

### ▶️ Basic Script

```bash
./subdomain_enum.sh example.com
```

### ▶️ Advanced Script

```bash
./recon.sh example.com
```

---

## 📁 Example Output

```
hunt_example.com/
├── all_subdomains.txt
├── resolved.txt
├── live_hosts.txt
├── endpoints.txt
└── nuclei_findings.txt
```

OR (basic script):

```
Recon/example.com/
├── subdomains.txt
├── alive.txt
├── screenshots/
└── notes.txt
```

---

## ⚠️ Disclaimer

This project is intended for **educational purposes and authorized security testing only**.
Do not use these scripts on targets without proper permission.

---

## 👨‍💻 Author

Zahin Shahriar
Security Researcher


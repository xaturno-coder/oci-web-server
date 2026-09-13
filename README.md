# xaturno.mx Project

Decoupled static website repository hosted on Oracle Cloud Infrastructure (OCI) using Caddy Server, with local development managed in WSL and continuous deployment via GitHub Actions.

---

## 🏗️ Architecture & Overview

* **Source Directory (`./src`):** All site assets (HTML, CSS, JS, images) are edited exclusively in `./src`.
* **Production Web Root (`/var/www/oci_web_server`):** Live OCI directory served by Caddy on `https://xaturno.mx`.
* **Deployment:** Pushing to `main` triggers a GitHub Actions pipeline that syncs `./src` and `Caddyfile` to OCI over SSH and reloads Caddy.

---

## 📁 Repository Structure

```text
~/oci-web-server/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions deployment pipeline
├── src/                        # Primary web assets
│   ├── index.html
│   ├── css/
│   └── js/
├── Caddyfile                   # Production Caddy configuration (OCI)
├── Caddyfile.local             # Unprivileged local Caddy configuration (Desktop)
├── dev.sh                      # Local sync & Caddy execution script
├── .gitignore                  # Ignores local logs, Caddyfile.local, and cache
└── README.md
```

---

## 🚀 Local Development Setup

### 1. Prerequisites
Ensure `caddy` and `git` are installed in your local WSL/Linux environment:

```bash
sudo dnf install -y caddy git  # Oracle Linux / RHEL
# or: 
sudo apt install -y caddy git  # Ubuntu / Debian
```

### 2. Clone the Project
Import the remote repository into your local development environment:

```bash
git clone git@github.com:xaturno-coder/oci-web-server.git
```

### 3. Start the Web Server
Navigate to the server directory, grant execution permissions to the setup script, and start the development server:

```bash
cd oci_web_server/
chmod +x dev.sh
./dev.sh
```

View your local site in browser: **`http://localhost:8080`**

---

## 📜 Logging

### Local Environment (`Caddyfile.local`)

* **Log Path:** `access.log`

### Production Environment (`Caddyfile`)

* **Log Path:** `/var/log/caddy/access.log`


---

## 🚢 Deployment Pipeline

Deployment is fully automated through GitHub Actions on push to `main`:

1. Syncs `./src/` to `/var/www/oci_web_server/` on the OCI instance.
2. Transfers production `Caddyfile` to `/var/www/oci_web_server/Caddyfile`.
3. Triggers `sudo systemctl reload caddy` over SSH.

### Execute Deployment
```
git add .
git commit -m "Update site content and configuration"
git push origin main
```
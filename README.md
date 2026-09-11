# OCI Web Server (`xaturno.mx`)

Decoupled static website repository hosted on Oracle Cloud Infrastructure (OCI) using Caddy Server, with local development managed in WSL and continuous deployment via GitHub Actions.

---

## 🏗️ Architecture & Overview

* **Source Directory (`./src`):** All site assets (HTML, CSS, JS, images) are edited exclusively in `./src`.
* **Local Web Root (`/var/www/oci_web_server`):** Local target directory served by Caddy on `http://localhost:8080`.
* **Production Web Root (`/var/www/oci_web_server`):** Live OCI directory served by Caddy on `https://xaturno.mx`.
* **Deployment:** Pushing to `main` triggers a GitHub Actions pipeline that syncs `./src` and `Caddyfile` to OCI over SSH and reloads Caddy.

---

## 📁 Repository Structure

```text
~/oci_web_server/
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
Ensure `caddy` and `rsync` are installed in your local WSL environment:

```
sudo dnf install -y rsync caddy   # Oracle Linux / RHEL
# or: sudo apt install -y rsync caddy  # Ubuntu / Debian
```

### 2. Prepare Local Target Directory
Run once to create the target local directory and set ownership to your user (no `sudo` required afterwards):

```
sudo mkdir -p /var/www/oci_web_server
sudo chown -R $USER:$USER /var/www/oci_web_server
```

### 3. Local Commands & Workflow
To sync `./src/` to `/var/www/oci_web_server`, format `Caddyfile.local`, and start Caddy on port `8080`:

```
chmod +x dev.sh
./dev.sh
```

View your local site in browser: **`http://localhost:8080`**

#### Automatic File Watcher (Optional)
To automatically trigger `./dev.sh` every time a file inside `./src/` is saved:

```
find src | entr ./dev.sh
```

---

## 🌐 Production Configuration Files

### `Caddyfile.local` (Local Desktop)

http://localhost:8080 {
    root * /var/www/oci_web_server
    file_server

    log {
        output file ./access.log
    }
}

### `Caddyfile` (Production OCI)

xaturno.mx {
    root * /var/www/oci_web_server
    file_server
    encode zstd gzip

    log {
        output file /var/log/caddy/access.log
    }
}

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
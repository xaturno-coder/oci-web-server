#!/bin/bash
set -euo pipefail

echo "==> 1. Reloading Caddy..."
sudo systemctl reload caddy

echo "==> 2. Ensuring update-stats.sh is executable..."
chmod +x /var/www/oci_web_server/update-stats.sh

echo "==> 3. Configuring cron job for stats..."
CRON_JOB="* * * * * /var/www/oci_web_server/update-stats.sh > /dev/null 2>&1"
(crontab -l 2>/dev/null | grep -Fv "update-stats.sh" || true; echo "$CRON_JOB") | crontab -

echo "==> 4. Generating initial stats.json..."
/var/www/oci_web_server/update-stats.sh

echo "==> Deployment tasks finished successfully!"


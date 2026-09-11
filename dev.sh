#!/usr/bin/env bash
# dev.sh - Local synchronization and Caddy reload script

set -e

TARGET_DIR="/var/www/oci_web_server"

echo "🔄 Syncing ./src/ to $TARGET_DIR..."
mkdir -p "$TARGET_DIR"
rsync -avz --delete ./src/ "$TARGET_DIR/"

echo "🎨 Formatting local Caddyfile..."
caddy fmt --overwrite Caddyfile.local

echo "🚀 Starting / Reloading Caddy..."
caddy reload --config Caddyfile.local || caddy run --config Caddyfile.local

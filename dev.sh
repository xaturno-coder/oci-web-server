#!/bin/bash
set -e

CONFIG_PATH="Caddyfile.local"

# 1. Format & Validate
caddy fmt --overwrite "$CONFIG_PATH"
caddy validate --config "$CONFIG_PATH" --adapter caddyfile

# 3. Run Caddy in background with your local config
sudo -E caddy start --config "$CONFIG_PATH"

echo "----------------------------------------------------"
echo "  🚀 Local server running at http://localhost:8080  "                              "
echo "----------------------------------------------------"
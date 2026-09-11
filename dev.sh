#!/bin/bash
set -e

# Format configuration file
caddy fmt --overwrite Caddyfile.local

# Reload or start Caddy using local config
caddy reload --config Caddyfile.local 2>/dev/null || caddy start --config Caddyfile.local

echo "Local server running at http://localhost:8080"

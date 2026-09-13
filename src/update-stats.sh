#!/bin/bash

# Target location where stats.json should be saved (defaults to script directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="${OUTPUT_FILE:-$SCRIPT_DIR/stats.json}"

# Collect system metrics
CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
RAM_USED=$(free -m | awk '/Mem:/ {print $3}')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
UPTIME=$(uptime -p | sed 's/up //')

# Output JSON atomically to avoid serving half-written content
cat <<EOF > "${OUTPUT_FILE}.tmp"
{
  "cpu_usage": "$CPU",
  "ram_used_mb": "$RAM_USED",
  "ram_total_mb": "$RAM_TOTAL",
  "disk_free_gb": "$DISK_FREE",
  "uptime": "$UPTIME"
}
EOF

mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"
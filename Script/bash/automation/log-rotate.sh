#!/bin/bash
# ============================================================
# Linux Log Rotation Script
# Author: Taerence McNeal
# ============================================================

LOGFILE="../examples/log-rotate.log"
TARGET_LOG="/var/log/syslog"      # Change for CentOS: /var/log/messages
RETENTION_DAYS=7

echo "========================================"
echo "   LOG ROTATION SCRIPT"
echo "   Started: $(date)"
echo "========================================"

{
echo "========================================"
echo "LOG ROTATION RUN"
echo "Started: $(date)"
echo "========================================"

if [ ! -f "$TARGET_LOG" ]; then
    echo "Log file not found: $TARGET_LOG"
    exit 1
fi

# Rotate log
ROTATED="${TARGET_LOG}-$(date +%Y-%m-%d).gz"

echo "Rotating log: $TARGET_LOG"
sudo cp $TARGET_LOG $TARGET_LOG.bak
sudo truncate -s 0 $TARGET_LOG

echo "Compressing rotated log..."
sudo gzip -c $TARGET_LOG.bak > $ROTATED
sudo rm $TARGET_LOG.bak

echo "Log rotated and compressed: $ROTATED"

# Delete old logs
echo "Deleting logs older than $RETENTION_DAYS days..."
sudo find /var/log -name "*.gz" -mtime +$RETENTION_DAYS -exec rm {} \;

echo "Old logs deleted."

echo ""
echo "========================================"
echo "Log Rotation Completed: $(date)"
echo "========================================"

} | tee $LOGFILE

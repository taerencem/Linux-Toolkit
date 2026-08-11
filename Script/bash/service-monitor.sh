#!/bin/bash
# ============================================================
# Linux Service Monitor Script
# Author: Taerence McNeal
# ============================================================

SERVICE=$1
LOGFILE="../examples/service-monitor.log"

if [ -z "$SERVICE" ]; then
    echo "Usage: $0 <service-name>"
    exit 1
fi

echo "========================================"
echo "   SERVICE MONITOR"
echo "   Monitoring: $SERVICE"
echo "   Time: $(date)"
echo "========================================"

STATUS=$(systemctl is-active $SERVICE)

if [ "$STATUS" = "active" ]; then
    echo "$SERVICE is running."
    echo "$(date) - $SERVICE is running." >> $LOGFILE
else
    echo "$SERVICE is DOWN. Restarting..."
    echo "$(date) - $SERVICE was DOWN. Restarting..." >> $LOGFILE

    systemctl restart $SERVICE

    NEWSTATUS=$(systemctl is-active $SERVICE)

    if [ "$NEWSTATUS" = "active" ]; then
        echo "$SERVICE restarted successfully."
        echo "$(date) - $SERVICE restarted successfully." >> $LOGFILE
    else
        echo "FAILED to restart $SERVICE."
        echo "$(date) - FAILED to restart $SERVICE." >> $LOGFILE
    fi
fi

echo "========================================"
echo "Monitor Complete"
echo "========================================"

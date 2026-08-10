#!/bin/bash
# ============================================================
# Linux System Health Monitoring Script
# Author: Taerence McNeal
# ============================================================

LOGFILE="../examples/health-output.txt"

echo "========================================"
echo "   SYSTEM HEALTH REPORT"
echo "   Generated: $(date)"
echo "========================================"

{
echo "========================================"
echo "   SYSTEM HEALTH REPORT"
echo "   Generated: $(date)"
echo "========================================"

echo ""
echo "---- CPU LOAD ----"
uptime

echo ""
echo "---- MEMORY USAGE ----"
free -h

echo ""
echo "---- DISK USAGE ----"
df -h

echo ""
echo "---- TOP PROCESSES ----"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -10

echo ""
echo "---- SYSTEM UPTIME ----"
uptime -p

echo ""
echo "---- LOGGED-IN USERS ----"
who

echo ""
echo "---- NETWORK STATUS ----"
ip -br a

echo ""
echo "---- OPEN PORTS ----"
sudo ss -tulnp | head -20

echo ""
echo "========================================"
echo "Report Complete"
echo "========================================"

} | tee $LOGFILE

#!/bin/bash
# ============================================================
# Linux Security Audit Script
# Author: Taerence McNeal
# ============================================================

REPORT="../examples/security-audit.txt"

echo "========================================"
echo "   LINUX SECURITY AUDIT"
echo "   Started: $(date)"
echo "========================================"

{
echo "========================================"
echo "LINUX SECURITY AUDIT REPORT"
echo "Generated: $(date)"
echo "========================================"

echo ""
echo "---- USERS ----"
cut -d: -f1 /etc/passwd

echo ""
echo "---- GROUPS ----"
cut -d: -f1 /etc/group

echo ""
echo "---- SUDOERS ----"
grep -E 'sudo|wheel' /etc/group

echo ""
echo "---- SSH SECURITY ----"
grep -E 'PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|X11Forwarding' /etc/ssh/sshd_config

echo ""
echo "---- FIREWALL RULES ----"
if command -v ufw >/dev/null 2>&1; then
    ufw status verbose
elif command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --list-all
else
    echo "No firewall detected."
fi

echo ""
echo "---- OPEN PORTS ----"
sudo ss -tulnp

echo ""
echo "---- RUNNING SERVICES ----"
systemctl list-units --type=service --state=running

echo ""
echo "---- FAIL2BAN STATUS ----"
if systemctl is-active --quiet fail2ban; then
    sudo fail2ban-client status sshd
else
    echo "Fail2Ban not installed or not running."
fi

echo ""
echo "---- FILE PERMISSIONS (Critical Files) ----"
ls -l /etc/passwd
ls -l /etc/shadow
ls -l /etc/sudoers

echo ""
echo "---- SYSTEM UPDATES ----"
if [ -f /etc/debian_version ]; then
    apt list --upgradable 2>/dev/null
elif [ -f /etc/redhat-release ]; then
    yum check-update
else
    echo "Unknown OS."
fi

echo ""
echo "========================================"
echo "Security Audit Completed"
echo "========================================"

} | tee $REPORT

#!/bin/bash
# ============================================================
# Linux Patch & Update Automation Script
# Author: Taerence McNeal
# ============================================================

LOGFILE="../examples/patch-update.log"
EMAIL_ALERT="no"   # change to "yes" to enable email alerts
EMAIL_TO="admin@yourdomain.com"

echo "========================================"
echo "   LINUX PATCH & UPDATE AUTOMATION"
echo "   Started: $(date)"
echo "========================================"

{
echo "========================================"
echo "PATCH & UPDATE LOG"
echo "Started: $(date)"
echo "========================================"

# Detect OS
if [ -f /etc/debian_version ]; then
    OS="debian"
elif [ -f /etc/redhat-release ]; then
    OS="rhel"
else
    OS="unknown"
fi

echo "Detected OS: $OS"
echo ""

# --- Debian/Ubuntu ---
if [ "$OS" = "debian" ]; then
    echo "Updating package lists..."
    sudo apt update -y

    echo "Upgrading packages..."
    sudo apt upgrade -y

    echo "Performing full upgrade..."
    sudo apt full-upgrade -y

    echo "Removing unused packages..."
    sudo apt autoremove -y

    echo "Debian/Ubuntu patching complete."
fi

# --- RHEL/CentOS ---
if [ "$OS" = "rhel" ]; then
    echo "Checking for updates..."
    sudo yum check-update

    echo "Installing updates..."
    sudo yum update -y

    echo "Cleaning up..."
    sudo yum autoremove -y

    echo "RHEL/CentOS patching complete."
fi

# --- Unknown OS ---
if [ "$OS" = "unknown" ]; then
    echo "Unsupported OS. Exiting."
    exit 1
fi

echo ""
echo "========================================"
echo "Patch & Update Completed: $(date)"
echo "========================================"

} | tee $LOGFILE

# --- Optional Email Alert ---
if [ "$EMAIL_ALERT" = "yes" ]; then
    mail -s "Linux Patch Report - $(hostname)" $EMAIL_TO < $LOGFILE
fi

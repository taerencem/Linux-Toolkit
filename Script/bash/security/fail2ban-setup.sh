#!/bin/bash
# ============================================================
# Fail2Ban Setup Script
# Author: Taerence McNeal
# ============================================================

LOGFILE="../examples/fail2ban-setup.log"

echo "========================================"
echo "   FAIL2BAN SETUP SCRIPT"
echo "   Started: $(date)"
echo "========================================"

{
echo "========================================"
echo "FAIL2BAN INSTALLATION LOG"
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

# --- Install Fail2Ban ---
if [ "$OS" = "debian" ]; then
    echo "Installing Fail2Ban (Debian/Ubuntu)..."
    sudo apt update -y
    sudo apt install fail2ban -y
fi

if [ "$OS" = "rhel" ]; then
    echo "Installing Fail2Ban (RHEL/CentOS)..."
    sudo yum install epel-release -y
    sudo yum install fail2ban -y
fi

if [ "$OS" = "unknown" ]; then
    echo "Unsupported OS. Exiting."
    exit 1
fi

# --- Configure SSH Jail ---
echo "Configuring SSH protection..."

sudo bash -c 'cat > /etc/fail2ban/jail.local <<EOF
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600
EOF'

echo "SSH jail configured."

# --- Enable & Start Fail2Ban ---
echo "Enabling Fail2Ban..."
sudo systemctl enable fail2ban

echo "Starting Fail2Ban..."
sudo systemctl start fail2ban

echo "Fail2Ban status:"
sudo systemctl status fail2ban --no-pager

echo ""
echo "========================================"
echo "Fail2Ban Setup Completed: $(date)"
echo "========================================"

} | tee $LOGFILE

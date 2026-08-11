#!/bin/bash
# ============================================================
# SSH Hardening Script
# Author: Taerence McNeal
# ============================================================

LOGFILE="../examples/ssh-hardening.log"
SSHD_CONFIG="/etc/ssh/sshd_config"

echo "========================================"
echo "   SSH HARDENING SCRIPT"
echo "   Started: $(date)"
echo "========================================"

{
echo "========================================"
echo "SSH HARDENING LOG"
echo "Started: $(date)"
echo "========================================"

# Backup config
echo "Backing up SSH config..."
sudo cp $SSHD_CONFIG ${SSHD_CONFIG}.bak
echo "Backup created: ${SSHD_CONFIG}.bak"

# Disable root login
echo "Disabling root login..."
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' $SSHD_CONFIG

# Disable password authentication
echo "Disabling password authentication..."
sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' $SSHD_CONFIG

# Enforce key-based authentication
echo "Enforcing key-based authentication..."
sudo sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' $SSHD_CONFIG

# Optional: Change SSH port (uncomment to use)
# echo "Changing SSH port to 2222..."
# sudo sed -i 's/^#Port 22/Port 2222/' $SSHD_CONFIG

# Disable empty passwords
echo "Disabling empty passwords..."
sudo sed -i 's/^PermitEmptyPasswords.*/PermitEmptyPasswords no/' $SSHD_CONFIG

# Disable X11 forwarding
echo "Disabling X11 forwarding..."
sudo sed -i 's/^X11Forwarding.*/X11Forwarding no/' $SSHD_CONFIG

# Apply changes
echo "Restarting SSH service..."
sudo systemctl restart ssh || sudo systemctl restart sshd

echo "SSH hardening applied successfully."

echo ""
echo "========================================"
echo "SSH Hardening Completed: $(date)"
echo "========================================"

} | tee $LOGFILE

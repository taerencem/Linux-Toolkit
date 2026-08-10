#!/bin/bash
# ============================================================
# Linux Firewall Setup Script (UFW + firewalld)
# Author: Taerence McNeal
# ============================================================

PORTS=("22" "80" "443")   # Default allowed ports

echo "========================================"
echo "   FIREWALL SETUP SCRIPT"
echo "========================================"

# Detect OS
if command -v ufw >/dev/null 2>&1; then
    FIREWALL="ufw"
elif command -v firewall-cmd >/dev/null 2>&1; then
    FIREWALL="firewalld"
else
    echo "No supported firewall found (ufw or firewalld)."
    exit 1
fi

echo "Detected firewall: $FIREWALL"
echo ""

# --- UFW CONFIGURATION ---
if [ "$FIREWALL" = "ufw" ]; then
    echo "Configuring UFW..."

    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    for PORT in "${PORTS[@]}"; do
        echo "Allowing port $PORT..."
        sudo ufw allow $PORT
    done

    echo "Enabling UFW..."
    sudo ufw --force enable

    echo "UFW configuration complete."
fi

# --- FIREWALLD CONFIGURATION ---
if [ "$FIREWALL" = "firewalld" ]; then
    echo "Configuring firewalld..."

    sudo systemctl enable firewalld
    sudo systemctl start firewalld

    for PORT in "${PORTS[@]}"; do
        echo "Allowing port $PORT..."
        sudo firewall-cmd --permanent --add-port=${PORT}/tcp
    done

    echo "Reloading firewalld..."
    sudo firewall-cmd --reload

    echo "Firewalld configuration complete."
fi

echo ""
echo "========================================"
echo "Firewall Setup Complete"
echo "========================================"

#!/bin/bash
# ============================================================
# Linux User Management Script
# Author: Taerence McNeal
# ============================================================

ACTION=$1
USERNAME=$2
GROUP=$3

if [ -z "$ACTION" ] || [ -z "$USERNAME" ]; then
    echo "Usage: $0 <create|delete|lock|unlock|addgroup|expire> <username> [group]"
    exit 1
fi

case $ACTION in

    create)
        echo "Creating user: $USERNAME"
        sudo useradd -m -s /bin/bash $USERNAME
        sudo passwd $USERNAME
        echo "User created."
        ;;

    delete)
        echo "Deleting user: $USERNAME"
        sudo userdel -r $USERNAME
        echo "User deleted."
        ;;

    lock)
        echo "Locking user: $USERNAME"
        sudo passwd -l $USERNAME
        echo "User locked."
        ;;

    unlock)
        echo "Unlocking user: $USERNAME"
        sudo passwd -u $USERNAME
        echo "User unlocked."
        ;;

    addgroup)
        if [ -z "$GROUP" ]; then
            echo "Group name required."
            exit 1
        fi
        echo "Adding $USERNAME to group $GROUP"
        sudo usermod -aG $GROUP $USERNAME
        echo "User added to group."
        ;;

    expire)
        echo "Setting account expiration for $USERNAME"
        sudo chage -E 2026-12-31 $USERNAME
        echo "Account expiration set."
        ;;

    *)
        echo "Invalid action."
        exit 1
        ;;
esac

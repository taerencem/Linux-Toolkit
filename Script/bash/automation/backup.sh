#!/bin/bash
# ============================================================
# Linux Backup Script (tar + rsync)
# Author: Taerence McNeal
# ============================================================

SOURCE_DIR=$1
BACKUP_DIR="/var/backups"
REMOTE_TARGET="user@backupserver:/backups"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
LOGFILE="../examples/backup-log.txt"

if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 <source-directory>"
    exit 1
fi

echo "========================================"
echo "   BACKUP SCRIPT"
echo "   Started: $(date)"
echo "========================================"

{
echo "========================================"
echo "BACKUP RUN"
echo "Started: $(date)"
echo "========================================"

# Ensure backup directory exists
sudo mkdir -p $BACKUP_DIR

# Create archive
ARCHIVE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"

echo "Creating backup archive..."
sudo tar -czf $ARCHIVE $SOURCE_DIR

echo "Backup created: $ARCHIVE"

# Sync to remote server
echo "Syncing backup to remote server..."
rsync -avz $ARCHIVE $REMOTE_TARGET

echo "Backup synced to: $REMOTE_TARGET"

echo ""
echo "========================================"
echo "Backup Completed: $(date)"
echo "========================================"

} | tee -a $LOGFILE

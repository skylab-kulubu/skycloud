#!/bin/bash

# Define source and destination directories
SOURCE_DIR=$1
BACKUP_DIR=$2

# Create a timestamp for the backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create a tarball of the source directory
sudo tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" .

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup completed successfully: $BACKUP_DIR/$BACKUP_NAME"
else
  echo "Backup failed"
  exit 1
fi

# Delete the oldest backup if there are more than 3 backups
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR" | wc -l)
if [ "$BACKUP_COUNT" -gt 3 ]; then
  OLDEST_BACKUP=$(ls -1t "$BACKUP_DIR" | tail -n 1)
  rm -f "$BACKUP_DIR/$OLDEST_BACKUP"
  echo "Deleted oldest backup: $BACKUP_DIR/$OLDEST_BACKUP"
fi

# Example Crontab
# 0 3 * * * /path/to/backup.sh /path/to/source /path/to/target

#!/bin/bash

# Define variables
BACKUP_DIR="$HOME/kima_backups"
DATA_DIR="$HOME/.kima"
SERVICE_NAME="kimad"
SNAPSHOT_FILE="$BACKUP_DIR/kima_snapshot.tar.gz"

# Ensure the backup directory exists
mkdir -p $BACKUP_DIR

case $1 in
    create)
        # Stop the Kima node service
        sudo systemctl stop $SERVICE_NAME

        # Backup the data directory
        tar -czvf $SNAPSHOT_FILE -C $DATA_DIR .

        # # Restart the Kima node service
        # sudo systemctl start $SERVICE_NAME

        echo "Full Backup created at $SNAPSHOT_FILE"
        ;;
    sync)
        if [ -z "$2" ]; then
            echo "Please provide the URL to the backup file."
            exit 1
        fi

        SNAPSHOT_URL=$2

        # Stop the Kima node service
        sudo systemctl stop $SERVICE_NAME

        # Download the snapshot file
        wget -O $SNAPSHOT_FILE $SNAPSHOT_URL

        # Clear the existing data directory
        rm -rf $DATA_DIR/*

        # Extract the snapshot
        tar -xzvf $SNAPSHOT_FILE -C $DATA_DIR

        # Restart the Kima node service
        sudo systemctl start $SERVICE_NAME

        echo "Node synced from snapshot."
        ;;
    *)
        echo "Usage: $0 {create|sync <snapshot_url>}"
        exit 1
        ;;
esac

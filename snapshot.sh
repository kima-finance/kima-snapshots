#!/bin/bash

# Define variables
REPO_DIR="$(pwd)"
BACKUP_DIR="$REPO_DIR/snapshots"
DATA_DIR="$HOME/.kima"
SERVICE_NAME="kimad"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
SNAPSHOT_FILE="$BACKUP_DIR/kima_snapshot_$TIMESTAMP.tar.gz"

# Ensure the backup directory exists
mkdir -p $BACKUP_DIR

case $1 in
    create)
        # Stop the Kima node service
        sudo systemctl stop $SERVICE_NAME

        # Backup the data directory
        sudo tar -czvf $SNAPSHOT_FILE -C $DATA_DIR .

        # Restart the Kima node service
        sudo systemctl start $SERVICE_NAME

        echo "Snapshot created at $SNAPSHOT_FILE"

        # Push the snapshot to the repository
        cd $REPO_DIR
        git add $SNAPSHOT_FILE
        git commit -m "Add snapshot $TIMESTAMP"
        git push origin main

        echo "Snapshot pushed to repository."
        ;;
    sync)
        # Fetch the latest snapshot if no specific file is provided
        if [ -z "$2" ]; then
            echo "No snapshot file provided. Fetching the latest snapshot..."
            cd $BACKUP_DIR
            git pull origin main
            LATEST_SNAPSHOT=$(ls -t kima_snapshot_*.tar.gz | head -n 1)
            if [ -z "$LATEST_SNAPSHOT" ]; then
                echo "No snapshots found in the repository."
                exit 1
            fi
            SNAPSHOT_FILE="$BACKUP_DIR/$LATEST_SNAPSHOT"
        else
            SNAPSHOT_FILE="$BACKUP_DIR/$2"
            if [ ! -f "$SNAPSHOT_FILE" ]; then
                echo "Snapshot file $SNAPSHOT_FILE not found."
                exit 1
            fi
        fi

        # Stop the Kima node service
        sudo systemctl stop $SERVICE_NAME

        # Clear the existing data directory
        rm -rf $DATA_DIR/*

        # Extract the snapshot
        sudo tar -xzvf $SNAPSHOT_FILE -C $DATA_DIR

        # Restart the Kima node service
        sudo systemctl start $SERVICE_NAME

        echo "Node synced from snapshot $SNAPSHOT_FILE."
        ;;
    *)
        echo "Usage: $0 {create|sync <snapshot_file>}"
        exit 1
        ;;
esac

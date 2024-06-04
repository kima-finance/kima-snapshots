# Kima Node Backup full Instructions

This repository contains a script to create and sync a Kima node using snapshots. This can significantly speed up the process of syncing a node from the genesis block.

## Prerequisites

- A running Kima node
- `wget` installed on the system
- `tar` installed on the system
- Systemd service for the Kima node (`kimad.service`)

## Usage

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone <repository_url>
cd kima-snapshots
```

### 2. Make the Script Executable
Make the snapshot.sh script executable:

```bash
chmod +x backup-full-data.sh
```

### 3. Create a Snapshot
To create a snapshot of the running Kima node:

```bash
./backup-full-data.sh create
```

This will:

```
    Stop the Kima node service.
    Backup the data directory.
    Create a compressed archive of the data directory.
```
The snapshot will be saved as kima_snapshot.tar.gz in the backup directory.

-------------------------------------------------------------------------------------------------------------

### 4. Sync from a Snapshot
To sync another Kima node using a snapshot:

```bash
./backup-full-data.sh sync <snapshot_url>
```

Replace <snapshot_url> with the URL to the snapshot file. This will:

```
    Stop the Kima node service.
    Download the snapshot file.
    Extract the snapshot to the data directory.
    Restart the Kima node service.
```

### 5. Service Management
The script interacts with the kimad.service systemd service to stop and start the Kima node. Ensure the service is correctly configured and running:

To check the status:

```bash
sudo systemctl status kimad
```

To start the service:

```bash
sudo systemctl start kimad
```

To stop the service:

```bash
sudo systemctl stop kimad
```

To reload the systemd daemon (after modifying the service file):

```bash
sudo systemctl daemon-reload
```

### Notes
- Ensure you have sufficient disk space for the snapshot files.
- Regularly create snapshots to keep your backups up to date.

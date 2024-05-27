### Syncing Nodes with Snapshot in Testnet Environment

In a testnet environment with significant block data, syncing a new node bootstrap can be challenging. Although CometBFT provides a fast sync method, it may stop and revert to normal mode due to network latency and block issues, taking several days to complete synchronization.

To address this problem, it is preferable to use a snapshot setting. This document provides a step-by-step guide on configuring and using snapshots for faster node synchronization.

#### Prerequisites

- Ensure you have access to the configuration files: `$HOME/config/app.toml` and `$HOME/config/config.toml`.
- Familiarity with using a text editor (e.g., `vim`).

### Step 1: Enable Snapshot Creation

1. **Open the app.toml Configuration File**

   ```bash
   vim $HOME/config/app.toml
   ```

2. **Find and Update the [state-sync] Section**

   Locate the `[state-sync]` section and update the `snapshot-interval` value to `1000`:

   ```toml
   [state-sync]
   snapshot-interval = 1000
   ```

   **Note:** Using a smaller value can speed up the process but might impact other block treatment processes. A value of `1000` is recommended.

3. **Save the File**

   Snapshot files will be generated in `$HOME/data/snapshots`. You will see two snapshot files divided by block number.

### Step 2: Synchronize Using Snapshot

1. **Initialize the Node**

   After initializing the node with `moniker` and `chainId`, download the `genesis` file and replace the existing one if necessary.

2. **Open the config.toml Configuration File**

   ```bash
   vim $HOME/config/config.toml
   ```

3. **Enable State Sync and Provide RPC Endpoints**

   Locate the `[statesync]` section and update the following parameters:

   ```toml
   [statesync]
   enable = true
   rpc_servers = "4.246.163.128:26657,20.172.162.43:26657"
   trust_height = 210621
   trust_hash = "2F9CD60BE5F6658291F2214EE8A368D7F5B6F4D7BE1869F4EC26D7CC7040D200"
   ```

   **Note:** The `trust_height` and `trust_hash` values can be obtained using the `kimad status` command.

4. **Save the File**

### Step 3: Restart the Node

Restart the node to apply the changes and begin synchronization:

```bash
sudo systemctl restart kimad
```

The node will discover snapshots from the specified RPC nodes, verify headers, and start catching up. Within a few hours, the node should be fully synchronized with the genesis node.

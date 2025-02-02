#!/bin/bash

# Step 1: Get the current logged-in user
USER=$(whoami)

# Step 2: Ask for the path to the data folders
echo "Enter the path to the data folders (e.g., /data):"
read DATA_PATH

# Step 3: Create /data folder if it doesn't exist
echo "Creating /data folder..."
sudo mkdir -p $DATA_PATH

# Step 4: Ask for the number of nodes
echo "Enter the total number of nodes to create directories for:"
read NUM_NODES

# Step 5: Ask for the Node Operator details
echo "Enter your Node Operator Wallet address:"
read WALLET

echo "Enter your Node Operator Email address:"
read EMAIL

echo "Enter the Node address (e.g., CHANGEME:30000):"
read ADDRESS

echo "Enter the storage capacity (in TB) for each node:"
read STORAGE

# Step 6: Create directories for each node (disk1, disk2, ...)
echo "Creating directories for nodes..."

for i in $(seq 1 $NUM_NODES); do
  # Create the data and identity directories
  sudo mkdir -p $DATA_PATH/disk$i
  sudo mkdir -p "/home/$USER/disk$i/identity"  # Create identity directories for each node
  echo "Created $DATA_PATH/disk$i and /home/$USER/disk$i/identity"
done

# Step 7: Pull the latest Storj node Docker image
echo "Pulling the latest Storj node Docker image..."
sudo docker pull storjlabs/storagenode:latest

# Step 8: Run the Storj node in setup mode for each created node
echo "Running Storj nodes in setup mode..."

for i in $(seq 1 $NUM_NODES); do
  echo "Running setup for Storj node $i..."

  sudo docker run --rm -e SETUP="true" \
    --mount type=bind,source="/home/$USER/disk$i/identity",destination=/app/identity \
    --mount type=bind,source="$DATA_PATH/disk$i",destination=/app/config \
    --name storagenode$i storjlabs/storagenode:latest
done

# Step 9: Run the Storj node with the full configuration for each created node
echo "Running Storj nodes with full configuration..."

for i in $(seq 1 $NUM_NODES); do
  # Incremental port number, but start with 30000 for the first node
  PORT=$((30000 + (i - 1)))

  echo "Running Storj node $i on port $PORT..."

  sudo docker run -d --restart unless-stopped --stop-timeout 300 \
    -p $PORT:28967/tcp -p $PORT:28967/udp -p 127.0.0.1:14000:14002 \
    -e WALLET="$WALLET" \
    -e EMAIL="$EMAIL" \
    -e ADDRESS="$ADDRESS" \
    -e STORAGE="${STORAGE}TB" \
    --mount type=bind,source="/home/$USER/disk$i/identity",destination=/app/identity \
    --mount type=bind,source="$DATA_PATH/disk$i",destination=/app/config \
    --name storagenode$i storjlabs/storagenode:latest
done

echo "Disk setup, Docker image pull, and Storj node setup complete."

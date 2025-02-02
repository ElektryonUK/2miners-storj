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

# Step 5: Create directories for each node (disk1, disk2, ...)
echo "Creating directories for nodes..."

for i in $(seq 1 $NUM_NODES); do
  # Create the data and identity directories
  sudo mkdir -p $DATA_PATH/disk$i
  sudo mkdir -p "/home/$USER/disk$i/identity"  # Create identity directories for each node
  echo "Created $DATA_PATH/disk$i and /home/$USER/disk$i/identity"
done

# Step 6: Pull the latest Storj node Docker image
echo "Pulling the latest Storj node Docker image..."
sudo docker pull storjlabs/storagenode:latest

# Step 7: Run the Storj node for each created node
echo "Running Storj nodes..."

for i in $(seq 1 $NUM_NODES); do
  echo "Running Storj node $i..."
  sudo docker run --rm -e SETUP="true" \
    --mount type=bind,source="/home/$USER/disk$i/identity",destination=/app/identity \
    --mount type=bind,source="$DATA_PATH/disk$i",destination=/app/config \
    --name storagenode$i storjlabs/storagenode:latest
done

echo "Disk setup, Docker image pull, and Storj node setup complete."

#!/bin/bash

# Step 1: Create /data folder
echo "Creating /data folder..."
sudo mkdir -p /data

# Step 2: Ask for the number of nodes
echo "Enter the total number of nodes to create directories for:"
read NUM_NODES

# Step 3: Create directories for each node (disk1, disk2, ...)
echo "Creating directories for nodes..."

for i in $(seq 1 $NUM_NODES); do
  sudo mkdir -p /data/disk$i
  echo "Created /data/disk$i"
done

# Step 4: Pull the latest Storj node Docker image
echo "Pulling the latest Storj node Docker image..."
sudo docker pull storjlabs/storagenode:latest

echo "Disk setup and Docker image pull complete."

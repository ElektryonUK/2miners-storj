#!/bin/bash

# Step 1: Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Check if the update and upgrade were successful
if [ $? -eq 0 ]; then
  echo "System updated and upgraded successfully."
else
  echo "There was an issue updating/upgrading the system. Exiting..."
  exit 1
fi

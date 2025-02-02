# Storj Node Setup Script

This repository contains a Bash script (`setup.sh`) to automate the setup and configuration of multiple Storj nodes on a Linux system. The script installs necessary dependencies, configures Docker, and sets up Storj nodes with user-defined parameters.

## Table of Contents
I. [About](#about)  
II. [Features](#features)  
III. [Prerequisites](#prerequisites)  
IV. [Installation](#installation)  
V. [Usage](#usage)  
VI. [Configuration](#configuration)  
VII. [Contributing](#contributing)  
VIII. [License](#license)  

---

## About
The `setup.sh` script automates the process of setting up and running multiple Storj nodes. It performs the following tasks:
1. Updates and upgrades the system.
2. Installs Docker, Nginx, PHP-FPM, and Unzip.
3. Configures Docker's official repository and installs Docker.
4. Creates directories for storing node data and identity files.
5. Pulls the latest Storj node Docker image.
6. Runs Storj nodes in setup mode and full configuration mode.
7. Saves the configuration to an `autostorj.conf` file for future reference.

---

## Features
- Automates the installation of dependencies (Docker, Nginx, etc.).
- Supports setting up multiple Storj nodes with custom configurations.
- Generates a configuration file (`autostorj.conf`) for easy reference.
- Uses Docker to ensure consistent and isolated environments for each node.

---

## Prerequisites
- A Linux-based system (preferably Ubuntu).
- `sudo` privileges to install packages and configure the system.
- Basic knowledge of Docker and Storj nodes.

---

## Installation
I. Clone this repository:
   ```
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   ```

II. Make the script executable:
   ```
   chmod +x setup.sh
   ```

---

## Usage
Run the script with the following command:
```
./setup.sh
```

The script will prompt you for the following inputs:
- Path to the data folders (e.g., `/data`).
- Number of nodes to create.
- Node Operator Wallet address.
- Node Operator Email address.
- Node address (e.g., `NODEEXTERNALADDRESS:30000`).
- Storage capacity (in TB) for each node.

Once the script completes, it will:
- Create directories for each node.
- Run Storj nodes in setup mode.
- Start Storj nodes with the provided configuration.
- Save the configuration to `autostorj.conf`.

---

## Configuration
The script generates an `autostorj.conf` file with the following details:
- Number of nodes.
- Path to data folders.
- Wallet address, email, and node address.
- Storage capacity for each node.
- Port and dashboard port for each node.

Example `autostorj.conf`:
```
NUM_NODES=3
DATA_PATH=/data
WALLET=your_wallet_address
EMAIL=your_email@example.com
ADDRESS=NODEEXTERNALADDRESS:30000
STORAGE=2
USER=your_username
NODE1_PATH=/home/your_username/disk1/identity
NODE1_STORAGE=/data/disk1
NODE1_PORT=30000
NODE1_DASHBOARD_PORT=14000
...
```
---

## Contributing
Contributions are welcome! If you have suggestions or improvements, please open an issue or submit a pull request.

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

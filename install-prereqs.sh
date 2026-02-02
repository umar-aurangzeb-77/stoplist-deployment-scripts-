#!/bin/bash

# ======================================================================================
#   This script installs the prerequisites needed for the Stoplist deployment on a
#   fresh Debian-based Linux server (like Ubuntu).
#
#   It installs Docker Engine and the Docker Compose plugin.
#
#   Run this script with sudo privileges: `sudo sh ./install-prereqs.sh`
# ======================================================================================

echo "### Starting prerequisite installation for Stoplist Deployment ###"

# --- Step 1: Update package lists and install dependencies ---
echo "--> Updating package list and installing dependencies..."
apt-get update
apt-get install -y ca-certificates curl gnupg

# --- Step 2: Add Docker's official GPG key ---
echo "--> Adding Docker's official GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# --- Step 3: Set up the Docker repository ---
echo "--> Setting up Docker's APT repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# --- Step 4: Install Docker Engine and Docker Compose ---
echo "--> Installing Docker Engine and Docker Compose..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- Step 5: Verify installation and start Docker ---
echo "--> Verifying Docker installation..."
if command -v docker &> /dev/null; then
    systemctl start docker
    systemctl enable docker
    echo ""
    echo "#####################################################################"
    echo "### Docker and Docker Compose installed successfully. ###"
    echo "### You can now proceed with the deployment steps. ###"
    echo "#####################################################################"
    echo ""
    docker --version
    docker compose version
else
    echo "Error: Docker installation failed."
    exit 1
fi

exit 0

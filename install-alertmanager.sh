#!/bin/bash

# Script to install Alertmanager on Red Hat-based systems
# Usage: Run this script as root or with sudo privileges.

set -e  # Exit immediately if a command exits with a non-zero status

ALERTMANAGER_VERSION="0.25.0"  # Specify the Alertmanager version to install

echo "Starting Alertmanager installation on Red Hat-based system..."

# Download Alertmanager
echo "Downloading Alertmanager version ${ALERTMANAGER_VERSION}..."
wget https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz

# Extract the downloaded archive
echo "Extracting Alertmanager..."
tar -xvzf alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz

# Move binaries to /usr/local/bin
echo "Moving binaries to /usr/local/bin..."
sudo mv alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/alertmanager /usr/local/bin/
sudo mv alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/amtool /usr/local/bin/

# Create Alertmanager directories
echo "Creating directories for Alertmanager..."
sudo mkdir -p /etc/alertmanager /var/lib/alertmanager

# Move configuration file to /etc/alertmanager
echo "Setting up Alertmanager configuration..."
sudo tee /etc/alertmanager/alertmanager.yml > /dev/null <<EOF
global:
  resolve_timeout: 5m

route:
  receiver: default

receivers:
  - name: default

# Inhibit rules can be configured here.
EOF

# Create a systemd service file for Alertmanager
echo "Creating systemd service for Alertmanager..."
sudo tee /etc/systemd/system/alertmanager.service > /dev/null <<EOF
[Unit]
Description=Alertmanager Service
Wants=network-online.target
After=network-online.target

[Service]
User=nobody
Group=nobody
Type=simple
ExecStart=/usr/local/bin/alertmanager \
  --config.file=/etc/alertmanager/alertmanager.yml \
  --storage.path=/var/lib/alertmanager

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, start, and enable Alertmanager service
echo "Starting and enabling Alertmanager service..."
sudo systemctl daemon-reload
sudo systemctl start alertmanager
sudo systemctl enable alertmanager

# Cleanup temporary files
echo "Cleaning up temporary files..."
rm -rf alertmanager-${ALERTMANAGER_VERSION}.linux-amd64*
 
# Print success message and instructions
echo "Alertmanager installation completed successfully!"
echo "You can access Alertmanager by visiting: http://<your-server-ip>:9093"

exit 0

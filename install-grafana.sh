
#!/bin/bash

# Script to install Grafana on Red Hat-based systems
# Usage: Run this script as root or with sudo privileges.

set -e  # Exit immediately if a command exits with a non-zero status

echo "Starting Grafana installation on Red Hat-based system..."

# Add Grafana repository
echo "Adding Grafana YUM repository..."
cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=Grafana OSS
baseurl=https://rpm.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
EOF

# Install Grafana
echo "Installing Grafana..."
sudo dnf install -y grafana

# Start and enable Grafana service
echo "Starting and enabling Grafana service..."
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Print success message and instructions
echo "Grafana installation completed successfully!"
echo "You can access Grafana by visiting: http://<your-server-ip>:3000"
echo "Default login credentials are:"
echo "  Username: admin"
echo "  Password: admin"

exit 0

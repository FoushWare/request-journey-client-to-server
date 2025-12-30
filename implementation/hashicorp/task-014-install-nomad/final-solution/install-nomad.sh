#!/bin/bash
# Install Nomad

NOMAD_VERSION="1.6.0"

echo "Installing Nomad ${NOMAD_VERSION}..."

# Download Nomad
wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip

# Unzip
unzip nomad_${NOMAD_VERSION}_linux_amd64.zip

# Move to /usr/local/bin
sudo mv nomad /usr/local/bin/

# Create data directory
sudo mkdir -p /opt/nomad/data

# Copy config
sudo cp nomad-config.hcl /etc/nomad.d/nomad.hcl

# Create systemd service
sudo tee /etc/systemd/system/nomad.service > /dev/null <<EOF
[Unit]
Description=Nomad
Documentation=https://www.nomadproject.io/docs
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/nomad agent -config /etc/nomad.d/nomad.hcl
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Start Nomad
sudo systemctl daemon-reload
sudo systemctl enable nomad
sudo systemctl start nomad

# Verify
nomad version
nomad node status

echo "Nomad installed and running!"


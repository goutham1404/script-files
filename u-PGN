#!/bin/bash
# ===========================
# INSTALL PROMETHEUS
# ===========================

# Download Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-amd64.tar.gz

# Extract the tarball
tar -xf prometheus-2.43.0.linux-amd64.tar.gz

# Move Prometheus binaries to /usr/local/bin
sudo mv prometheus-2.43.0.linux-amd64/prometheus prometheus-2.43.0.linux-amd64/promtool /usr/local/bin

# Create directories for configs and data
sudo mkdir /etc/prometheus /var/lib/prometheus

# Move console libraries (needed by Prometheus UI)
sudo mv prometheus-2.43.0.linux-amd64/console_libraries prometheus-2.43.0.linux-amd64/consoles /etc/prometheus

# Cleanup tar files
sudo rm -rvf prometheus-2.43.0.linux-amd64*

# Create Prometheus config file
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<EOF
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'prometheus_metrics'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node_exporter_metrics'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100','worker-1:9100','worker-2:9100']
EOF

# Create prometheus user without login access
sudo useradd -rs /bin/false prometheus

# Set correct ownership
sudo chown -R prometheus: /etc/prometheus /var/lib/prometheus

# Create systemd service file for Prometheus
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file /etc/prometheus/prometheus.yml \
  --storage.tsdb.path /var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus --no-pager


# ===========================
# INSTALL GRAFANA (on Ubuntu/Debian)
# ===========================

# Install Grafana GPG key and repo
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Install Grafana
sudo apt update
sudo apt install -y grafana

# Enable & start Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server --no-pager


# ===========================
# INSTALL NODE EXPORTER
# ===========================

# Download Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz

# Extract
tar -xf node_exporter-1.5.0.linux-amd64.tar.gz

# Move binary to /usr/local/bin
sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin

# Cleanup
rm -rv node_exporter-1.5.0.linux-amd64*

# Create node_exporter user
sudo useradd -rs /bin/false node_exporter

# Create systemd service for Node Exporter
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Reload and start Node Exporter
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter.service
sudo systemctl status node_exporter.service --no-pager

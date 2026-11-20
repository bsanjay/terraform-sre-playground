#!/bin/bash

set -euxo pipefail

PROM_VERSION="3.16.0"

echo "Installing Prometheus ${PROM_VERSION}..."

# Create prometheus group and user
getent group prometheus >/dev/null || groupadd --system prometheus

id prometheus >/dev/null 2>&1 || useradd \
  --system \
  --no-create-home \
  --gid prometheus \
  --shell /sbin/nologin \
  prometheus

# Create required directories
mkdir -p /etc/prometheus
mkdir -p /var/lib/prometheus

# Download and extract
cd /tmp

rm -rf prometheus-${PROM_VERSION}.linux-amd64
rm -f prometheus-${PROM_VERSION}.linux-amd64.tar.gz

curl -LO https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz

tar -xzf prometheus-${PROM_VERSION}.linux-amd64.tar.gz

# Install binaries
install -m 755 prometheus-${PROM_VERSION}.linux-amd64/prometheus /usr/local/bin/prometheus
install -m 755 prometheus-${PROM_VERSION}.linux-amd64/promtool /usr/local/bin/promtool

# Validate binary
/usr/local/bin/prometheus --version

# Prometheus config
cat > /etc/prometheus/prometheus.yml <<'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus

    static_configs:
      - targets:
          - localhost:9090
EOF

# Permissions
chown -R prometheus:prometheus /etc/prometheus
chown -R prometheus:prometheus /var/lib/prometheus
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool

# Validate configuration
/usr/local/bin/promtool check config /etc/prometheus/prometheus.yml

# Create systemd service
cat > /etc/systemd/system/prometheus.service <<'EOF'
[Unit]
Description=Prometheus Monitoring
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus

ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.listen-address=0.0.0.0:9090

Restart=always
RestartSec=5

LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Reload and start
systemctl daemon-reload
systemctl enable prometheus
systemctl restart prometheus

# Wait for startup
sleep 5

echo "Checking service..."

systemctl --no-pager --full status prometheus

echo "Checking listening port..."

ss -tulpn | grep 9090

echo "Checking health endpoint..."

curl -s http://localhost:9090/-/healthy

echo ""
echo "========================================="
echo " Prometheus installation successful"
echo " URL: http://$(hostname -I | awk '{print $1}'):9090"
echo "========================================="

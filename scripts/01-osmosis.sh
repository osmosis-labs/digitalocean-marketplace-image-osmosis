#!/bin/sh

MONIKER=osmosis

MAINNET_VERSION="19.2.0"
MAINNET_BINARY_URL="https://github.com/osmosis-labs/osmosis/releases/download/v$MAINNET_VERSION/osmosisd-$MAINNET_VERSION-linux-amd64"
TESTNET_VERSION="19.0.0-rc0"
TESTNET_BINARY_URL="https://osmosis-snapshots-testnet.fra1.cdn.digitaloceanspaces.com/binaries/osmosisd-$TESTNET_VERSION-linux-amd64"

# Update /etc/security/limits.conf 
NR_OPEN=$(cat /proc/sys/fs/nr_open)
echo "* soft nofile $NR_OPEN" >> /etc/security/limits.conf
echo "* hard nofile $NR_OPEN" >> /etc/security/limits.conf

# Enable pam_limits in /etc/pam.d/common-session
echo "session required pam_limits.so" >> /etc/pam.d/common-session

# Enable ufw
echo "y" | ufw enable
ufw allow http
ufw allow https
ufw allow ssh
ufw allow 26656 # p2p
ufw allow 26657 # rpc
ufw allow 1317  # rest
ufw allow 9090  # grpc

# Enables colors
sed -i 's/xterm-color)/xterm-color|\*-256color)/g' /root/.bashrc

# Download mainnet osmosisd binary
wget -q $MAINNET_BINARY_URL -O /usr/local/bin/osmosisd-$MAINNET_VERSION
chmod +x /usr/local/bin/osmosisd-$MAINNET_VERSION

# Download testnet osmosisd binary
wget -q $TESTNET_BINARY_URL -O /usr/local/bin/osmosisd-$TESTNET_VERSION
chmod +x /usr/local/bin/osmosisd-$TESTNET_VERSION

# Set mainnet osmosisd as default binary
ln -s /usr/local/bin/osmosisd-$MAINNET_VERSION /usr/local/bin/osmosisd

# Set scripts as executable
chmod +x /root/join.sh

#!/bin/sh

MONIKER=osmosis
OSMOSIS_VERSION=v15.1,0

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

# Download osmosisd binary
wget -q https://github.com/osmosis-labs/osmosis/releases/download/v$OSMOSIS_VERSION/osmosisd-$OSMOSIS_VERSION-linux-amd64 -O /usr/local/bin/osmosisd
chmod +x /usr/local/bin/osmosisd

# Download mainnet genesis
wget https://github.com/osmosis-labs/osmosis/raw/main/networks/osmosis-1/genesis.json -O /etc/osmosis/genesis.json

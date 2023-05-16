#!/bin/bash
set -e

export GOPATH=/usr/local/go/bin
export PATH=$GOPATH:/usr/local/go/bin:$PATH

# bash /root/start_node.sh "15.1.0" "" "" "mainnet"

MONIKER=osmosis
OSMOSIS_HOME=/root/.osmosisd
OSMOSIS_VERSION="15.1.0"
SNAPSHOT_URL=$(curl -s https://snapshots.osmosis.zone/v15/latest.json)
ADDRBOOK_URL="https://snapshots.polkachu.com/addrbook/osmosis/addrbook.json"
GENESIS_URL=https://github.com/osmosis-labs/osmosis/raw/main/networks/osmosis-1/genesis.json

# Check if the binary already exists
if [ -x "$osmosis_binary" ]; then
    installed_version=$(osmosisd version 2>&1)
    required_version="15.1.0"

    if [[ "$installed_version" != $OSMOSIS_VERSION ]]; then
        echo "Error: The installed version ($installed_version) does not match the required version ($required_version)."
        exit 1
    fi
else
    # Download the binary
    sudo wget -q "https://github.com/osmosis-labs/osmosis/releases/download/v$OSMOSIS_VERSION/osmosisd-$OSMOSIS_VERSION-linux-amd64" -O "$osmosis_binary"
    sudo chmod +x "$osmosis_binary"
fi

# Clean osmosis home
if [ -d "$OSMOSIS_HOME" ]; then
    rm -rfy $OSMOSIS_HOME
fi

# Initialize osmosis home
osmosisd init $MONIKER

# Copy configs
cp /etc/osmosis/client.toml $OSMOSIS_HOME/client.toml
cp /etc/osmosis/config.toml $OSMOSIS_HOME/config.toml
cp /etc/osmosis/app.toml $OSMOSIS_HOME/app.toml

# Copy genesis
wget -q $GENESIS_URL -O $OSMOSIS_HOME/config/genesis.json

# Download addrbook
wget -q $ADDRBOOK_URL -O $OSMOSIS_HOME/config/addrbook.json

# Download latest mainnet snapshot
wget -q -O - $SNAPSHOT_URL | lz4 -d | tar -C $OSMOSIS_HOME/ -xvf -

nohup osmosisd start --home ${OSMOSIS_HOME} &

echo "Your Osmosis node has started and is running on the background."
echo "Run `osmosisd status` to check sync status!"

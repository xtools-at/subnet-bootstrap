# Subnet node bootstrap script
echo "Subnet node bootstrap starting...\n"

echo "Please enter static public IP of this node:"
read IP
echo "Enable RPC? (Y/N) - keep disabled for validators!"
read RPC_ON
echo "$IP, $RPC_ON"

if [ $IP -eq "" ]; then
    $IP="dynamic"
fi

if [ $RPC_ON -eq "Y" ]; then
    $RPC="any"
else
    $RPC="local"
fi

# install and run AvalancheGo installer
echo "Installing AvalancheGo:"
wget -nd -m https://raw.githubusercontent.com/ava-labs/avalanche-docs/master/scripts/avalanchego-installer.sh
chmod 755 avalanchego-installer.sh
./avalanchego-installer.sh --fuji --state-sync on --rpc $RPC --track-subnets 5NwYE9TC3FLB3q8QYFxV5foXp4hWX9avWXkzmjwoNv7DzRg2B --ip $IP

# install Avalanche-CLI
echo "Installing Avalanche-CLI:"
curl -sSfL https://raw.githubusercontent.com/ava-labs/avalanche-cli/main/scripts/install.sh | sh -s
export PATH=~/bin:$PATH

# copy config files
echo "Copying config files..."
sudo systemctl stop avalanchego.service
cp -r ./config/.avalanchego ~/.avalanchego
cp -r ./config/.avalanche-cli ~/.avalanche-cli
## TODO: bootstrap DB?

# Display NodeID
echo "Getting NodeID from logs...\n"
sed -n '/initializing node {/,/nodePOP/p' ~/.avalanchego/logs/main.log
echo ""

# Restart node to apply subnet config
sudo systemctl restart avalanchego.service

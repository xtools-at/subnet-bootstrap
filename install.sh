# Subnet node bootstrap script
SUBNET_ID=5NwYE9TC3FLB3q8QYFxV5foXp4hWX9avWXkzmjwoNv7DzRg2B

echo "Subnet node bootstrap starting..."

echo "Please enter static public IP of this node: (or use 'dynamic' or 'static' for auto detection)"
read IP
echo "Enable RPC? (y/n) - keep disabled for validators!"
read RPC_ON
echo "$IP, $RPC_ON"

if [ "$IP" = "" ]; then
    IP="dynamic"
fi

if [ "$RPC_ON" = "Y" ] || [ "$RPC_ON" = "y" ]; then
    RPC="any"
else
    RPC="local"
fi

# install and run AvalancheGo installer
echo "Installing AvalancheGo:"
wget -nd -m -P ~/ https://raw.githubusercontent.com/ava-labs/avalanche-docs/master/scripts/avalanchego-installer.sh
chmod 755 ~/avalanchego-installer.sh
~/avalanchego-installer.sh --fuji --state-sync on --rpc $RPC --ip $IP
echo -e "\n\n"

# install Avalanche-CLI
echo "Installing Avalanche-CLI:"
curl -sSfL https://raw.githubusercontent.com/ava-labs/avalanche-cli/main/scripts/install.sh | sh -s
export PATH=~/bin:$PATH
echo -e "\n\n"

# copy config
echo "Copying config files..."
sudo systemctl stop avalanchego.service
cp -r ./config/.avalanchego ~
cp -r ./config/.avalanche-cli ~
sed '$d' ~/.avalanchego/configs/node.json > ~/.avalanchego/configs/tmp.json
echo ", \"track-subnets\": \"$SUBNET_ID\"" >> ~/.avalanchego/configs/tmp.json
echo "}" >> ~/.avalanchego/configs/tmp.json
rm ~/.avalanchego/configs/node.json
mv ~/.avalanchego/configs/tmp.json ~/.avalanchego/configs/node.json
echo -e "\n\n"

# Restart node to apply subnet config
echo "Restarting node to apply config..."
sudo systemctl start avalanchego
echo "Waiting for node to start up..."
sleep 15
wait
echo -e "\n\n"

# Display NodeID
chmod 755 node_id.sh
./node_id.sh


echo "All done! Run 'export PATH=~/bin:\$PATH' to use Avalanche CLI directly."

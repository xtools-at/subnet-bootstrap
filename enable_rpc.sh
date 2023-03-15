echo "Enabling RPC settings in node config..."
sudo systemctl stop avalanchego.service

sed '$d' ~/.avalanchego/configs/node.json > ~/.avalanchego/configs/tmp.json
echo ", \"http-host\": \"\"}" >> ~/.avalanchego/configs/tmp.json
rm ~/.avalanchego/configs/node.json
mv ~/.avalanchego/configs/tmp.json ~/.avalanchego/configs/node.json

sudo systemctl start avalanchego.service

echo -e "\n\nRPC enabled"

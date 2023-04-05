# upgrade script for AvaLabs pre-release
# TODO: remove specific versions used in here

# prep
sudo adduser node sudo

# avalanchego
echo -e "\n\n- Starting avalanchego update \n\n"
su node -c "/home/node/avalanchego-installer.sh --version v1.10.0-fuji"
sudo systemctl stop avalanchego

# subnet-evm
echo -e "\n\n- Starting subnet-evm upgrade \n\n"
su node -c "/home/node/bin/avalanche subnet upgrade vm XP --fuji --version v0.5.0-fuji-1"

# cleanup
sudo systemctl start avalanchego
sudo deluser node sudo


echo "Avalanchego and Subnet-EVM upgraded successfully"

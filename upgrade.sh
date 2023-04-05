# upgrade script for AvaLabs pre-release
# TODO: remove specific versions used in here

# prep
sudo adduser node sudo
su -l node

# avalanchego
./avalanchego-installer.sh --version v1.10.0-fuji
sudo systemctl stop avalanchego

# subnet-evm
avalanche subnet upgrade vm XP

# cleanup
sudo systemctl start avalanchego
exit
sudo deluser node sudo


echo "Avalanchego and Subnet-EVM upgraded successfully"

# Subnet Node Bootstrap Script


## Bootstrap node
This downloads the AvalancheGo node client, Avalanche CLI, and adds all necessary config for our Dev Subnet for Ubuntu/Debian based VPS.

### Add new user
The client shouldn't run as a root user. Add a new user like this, and remove it from the sudo'ers list when you're finished:
```
sudo adduser node
sudo adduser node sudo
su -l node
```

### Run installer script
Have your VPS' static IP handy. If you're bootstrapping a validator, keep RPC disabled. Run without root privileges.
```
git clone https://github.com/xtools-at/subnet-bootstrap.git
cd subnet-bootstrap
chmod 755 install.sh
./install.sh
```

### Starting/Stopping the node
(run as `root`)
```
sudo systemctl start avalanchego
sudo systemctl stop avalanchego
sudo systemctl restart avalanchego
sudo systemctl status avalanchego
```


## Add node as subnet validator
### Prep
- Have [Avalanche-CLI](https://docs.avax.network/subnets/install-avalanche-cli) ready and installed on your local machine
- Wait for your node to be *fully* bootstrapped and in sync with the network
- Add the node as a **Avalanche** validator like described [here](https://docs.avax.network/nodes/validate/add-a-validator#add-a-validator-with-avalanche-wallet). You'll need to stake 1 AVAX on testnet, and supply your node's _NodeID_

### On your local machine
- Have the private key handy you've used to create your subnet with Avalanche CLI. You should **not** run this on the VPS:
```
# create new random key
avalanche key create myKeyName

# create new key from file
avalanche key create myKeyName --file /tmp/test.pk

# show private key
avalanche key export myKeyName
```
- Give the node permission to become validator on your subnet ("XP" in our example). You'll need your node's _NodeID_, which you can e.g. extract from `~/.avalanchego/logs/main.log` or copy from the setup output:
```
avalanche subnet addValidator XP
```

### On your node
- when your validator is all set on Avalanche network, run `avalanche subnet join XP` to add it to the subnet too


## Misc
- Don't forget to remove your user from the sudo'ers list when you're done: `sudo deluser node sudo`
- YOu can find all lod files here: `ls -la ~/.avalanchego/logs/`
- To back up your validator/nodeID, copy the contents of `~/.avalanchego/staking/`
- To update your node to the latest version, simply run `avalanchego-installer.sh` again

### Node IDs:
- validator1/rpc: NodeID-APhFyzYExri3n5GtDz7ytXCgbt8x5NAud
- validator2: NodeID-7NenT29nACMVLj8K685mBLodfp6GehVy7

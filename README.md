# Subnet Node Bootstrap Script


## Bootstrap
This downloads the AvalancheGo node client, Avalanche CLI, and adds all necessary config for our Dev Subnet for Ubuntu/Debian based VPS.

### Add new user
The client shouldn't run as a root user. Add a new user like this, and remove it from the sudo'ers list when you're finished:
```
sudo adduser node
sudo passwd node
sudo usermod -aG sudo node
su -l node
```

### Run installer script
Have your VPs' static IP handy. If you're bootstrapping a validator, keep RPC disabled.
```
chmod 755 install.sh
./install.sh
```

If you want to set a custom fee recipient for the validator, update `~/.avalanchego/configs/chains/[subnetChainId]/config.json` and restart the node.


## Starting/Stopping the node
(run as `root`)
```
sudo systemctl start avalanchego.service
sudo systemctl stop avalanchego.service
sudo systemctl restart avalanchego.service
```


## Add Node as validator
### On your local machine
- Have [Avalanche-CLI](https://docs.avax.network/subnets/install-avalanche-cli) ready and installed on your machine
- Have the private key handy you've used to create your subnet with Avalanche CLI. You should *not* run this on the VPS:
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
- Wait for your node to be *fully* bootstrapped and in sync with the network
- Add the node as a **Avalanche** validator like described [here](https://docs.avax.network/nodes/validate/add-a-validator#add-a-validator-with-avalanche-wallet). You'll need to stake 1 AVAX on testnet, and supply your node's _NodeID_
- when your validator is all set on Avalanche network, run `avalanche subnet join XP` to add it to the subnet too


## Cleanup, Backup
- Don't forget to remove your user from the sudo'ers list: `sudo deluser node sudo`
- To back up your validator/nodeID, copy the contents of `~/.avalanchego/staking/`

# Subnet Node Bootstrap Script

## Connection details
Connect to the subnet using Metamask:

```
Network name: Beam Devnet
RPC Url: http://157.230.66.23:9650/ext/bc/2NXVLcGbemMjwyexwigxCoqn7UJ6DdeJdWNPxcWX4Y2eDem1aW/rpc
ChainID: 133
Currency symbol: XP
```

## Quickstart: Bootstrap node with DO Snapshot
Syncing a node fully can take some time, so we can use a partly bootstrapped node
- Go to DigitalOcean -> Images -> Snapshot
- Click the three-dot-menu on the most recent `synced-node` snapshot
- Verify that the snapshot is available for the region you want to deploy your VPS to
- Select "Create droplet" and spin up a VPS using the snapshot
- Update the `public-ip` property in `/home/node/.avalanchego/configs/node.json`, or remove it to auto detect it (not advised)
- Restart node: `sudo systemctl restart avalanchego`

If this node is supposed to become a validator, proceed with the steps for _Add node as subnet validator_ below
- To "import" an existing validator (e.g. when moving instances), you'll have to copy over the contents in `~/.avalanchego/staking/*` and restart the the node:
```
sudo systemctl stop avalanchego
# this will delete the current node's existing "identity" - thread carefully!
rm /home/node/.avalanchego/staking/*
# this copies the files over from another node:
scp -r root@IP_OF_VPS_TO_COPY_FROM:/home/node/.avalanchego/staking/ /home/node/.avalanchego/
sudo systemctl start avalanchego
```

If you want it to be a RPC node instead, open `/home/node/.avalanchego/configs/node.json` and add `"http-host": ""` to the config file, _or_ run `./enable_rpc.sh` (not both!)

## Bootstrap node with script
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
sh install.sh
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
- Add the node as a **Avalanche** validator like described [here](https://docs.avax.network/nodes/validate/add-a-validator#add-a-validator-with-avalanche-wallet). You'll need to stake 1 AVAX on testnet, and supply your node's _NodeID_, which you can e.g. get running `./node_id.sh`, extract from `head -n 5 ~/.avalanchego/logs/main.log`, or copy from the setup output.
  - _This may take up to 30min to apply_, if the steps below fail you'll have to wait a bit longer.

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
- Give the node permission to become validator on your subnet ("XP" in our example). You'll need your node's _NodeID_:
```
avalanche subnet addValidator XP
```

### On your node
- when your validator is all set on Avalanche network, run `~/bin/avalanche subnet join XP` to add it to the subnet too (select "manual" when prompted, these steps have been done already)


## Misc
- Don't forget to remove your user from the sudo'ers list when you're done: `sudo deluser node sudo`
- You can find all log files here: `ls -la ~/.avalanchego/logs/`
- To back up your validator/nodeID, copy the contents of `~/.avalanchego/staking/`
- To update your node to the latest version, simply run `~/avalanchego-installer.sh` again

### VPS Node IDs:
- validator1: NodeID-Ffr1YgeWw3h2Ct9dY7V3u79ScrAbhSUUz (20)
- validator2: NodeID-7NenT29nACMVLj8K685mBLodfp6GehVy7 (20)
- validator3: NodeID-PA9LANCKQbk9Un8Wv4SbBXoDCW4bP9yLk (50)
- validator4: NodeID-PqZJgjNLDbeqmSg7hMWU8R1a5HCEjbBP9 (50)
- validator5: NodeID-APhFyzYExri3n5GtDz7ytXCgbt8x5NAud (100)
- rpc1: NodeID-F2M4P5DrPt8SA2WEV49zeH9PFTmLuqdnX

# Display NodeID
echo "Fetching NodeID..."
echo ""
sleep 15
wait
# head ~/.avalanchego/logs/main.log -n 1 | grep "\"nodeID\": \"NodeID-"
curl -X POST --data '{"jsonrpc":"2.0","id":1,"method":"info.getNodeID"}' -H 'content-type:application/json' 127.0.0.1:9650/ext/info | grep "NodeID-"
echo ""

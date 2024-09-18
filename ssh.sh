if [ $# -eq 1 ]; then
    IPADDRESS=$1
    ssh miner@$IPADDRESS
else
    echo "provide arguments: 
    ssh.sh <IP ADDRESS>
    (get this IP ADDRESS from ./nmap.sh YOUR_IP_ADDRESS then finding your target device on the list of network devices)"
fi

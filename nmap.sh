if [ $# -eq 1 ]; then
    IPADDRESS=$1
    nmap   -T 5 -R $IPADDRESS --system-dns
else
    echo "provide arguments: 
    nmap.sh <IP ADDRESS>
    (get your IP ADDRESS with 'ip addr' command, make sure it's of the same network as target device)"
fi

# look for your target device in the results, should look something like this:
#Nmap scan report for xxx.xxx.xx.xx <--- IP ADDRESS WILL BE HERE
#Host is up (0.0057s latency).
#Not shown: 999 closed ports
#PORT   STATE SERVICE
#22/tcp open  ssh
#MAC Address: xx:xx:xx:xx:xx:xx (Unknown)
#TODO make identifying easier via host name?

# get the IP_ADDRESS from the nmap scan

# run ./ssh.sh IP_ADDRESS (configured to target miner@IP_ADDRESS)

filename=$1
IPADDR=$2
scp "$filename" miner@"$IPADDR":/home/miner/"$filename"

newdns=$1
echo "setting DNS server to: " $newdns
sudo sed -i \
    "s/^nameserver [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/nameserver $newdns/"  \
    /etc/resolv.conf

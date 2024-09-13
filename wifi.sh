wifi_interface=$(ls /sys/class/net | grep -v -e '^lo$' -e '^enp9s0$' | head -n 1)

FILENAME="/etc/netplan/50-cloud-init.yaml"

sudo cp "$FILENAME" "$FILENAME.bak"

echo "enter wifi access point name"
read ACCESS_POINT

echo "enter wifi password":
read PASSWORD


#the in_wifis && /^{}$/ clause can probably be removed as it doesnt seem to work its functionality is replaced by the sed call after it
sudo awk '
BEGIN { in_wifis = 0 }
/^    wifis:/ {
    in_wifis = 1
    print
    next
}
in_wifis && /^{}$/ { 
  in_wifis = 0
  next
}
in_wifis {
  next
}
{
  print
}
END {
    if (in_wifis) {
    print "      '$wifi_interface':"
	print "        optional: true"
	print "        access-points:"
	print "          \"'$ACCESS_POINT'\":"
	print "            password: \"'$PASSWORD'\""
	print "        dhcp4: true"

    }
}

' $FILENAME > temp.yaml

sed -i '/^    wifis:/ s/{}//g' temp.yaml

sudo mv temp.yaml $FILENAME

sudo netplan --debug apply 

ip a

sudo ./disableCloudNetConfig.sh

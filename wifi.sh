wifi_interface=$(ls /sys/class/net | grep -v -e '^lo$' -e '^enp9s0$' | head -n 1) #gets the first interface that isnt a lan interface
                                                    # needs more validation accross systems, maybe more default interfaces

FILENAME="/etc/netplan/50-cloud-init.yaml" # u22.04 default netplan file

sudo cp "$FILENAME" "$FILENAME.bak" #backup the default netplan file

echo "enter wifi access point name" #collect access point name info
read ACCESS_POINT

echo "enter wifi password": # collect access point password info
read PASSWORD


#Use awk to modify the netplan file, insert a wifi_interface section given the interface we found, and the access point info collected

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

' $FILENAME > temp.yaml #saves it to a temp file

sed -i '/^    wifis:/ s/{}//g' temp.yaml 
    #use sed to remove the residual {} characters in the temp netplan file as awk method is failing to do it atm

sudo mv temp.yaml $FILENAME #move the temp file into the real file

sudo netplan --debug apply # apply the netplan with a debug flag to see any errors

ip a # display ip address information assuming a success case

# disable the cloud config as it will fail to find network on wifi every boot otherwise
# it will also restore the default netplan file, forcing you to need to call the `wifi` script again
sudo disableCloudNetConfig.sh # this needs to be called without ./ prefix 
# since both this and wifi.sh will be sent to /usr/bin during post install commands

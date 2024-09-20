#WARNING: This can cause a problem with the login screen
#If the login screen doesn't display after setting this
# sudo nano /etc/X11/xorg.conf and note out or delete all but the first device AKA GPU entrys
sudo nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration

sudo echo "\nallowed_users=anybody" >> /etc/X11/Xwrapper.config
sudo echo "\nneeds_root_rights=yes" >> /etc/X11/Xwrapper.config
sudo chmod 2644 /etc/X11/Xwrapper.config

sudo sed -i '/^EndSection/i\    Option "Coolbits" "28"' /usr/share/X11/xorg.conf.d/10-nvidia.conf

sudo sed -i '/^ExecStart=\/lib\/systemd\/systemd-networkd-wait-online/ s/$/ --timeout=5/' /etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service 

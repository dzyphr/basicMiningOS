wget -nc https://releases.ubuntu.com/noble/ubuntu-24.04.1-desktop-amd64.iso #get ubuntu iso

wget -nc https://github.com/balena-io/etcher/releases/download/v1.19.21/balena-etcher_1.19.21_amd64.deb #get balena etcher

sudo apt install ./balena-etcher_1.19.21_amd64.deb #install balena etcher

sudo usermod -aG sudo $USER #avoids issues where you cant write to the disk in balena

balena-etcher #startup balena, slect the iso downloaded to this directory, and the disk you want to overwrite (CAREFULLY ofcourse)


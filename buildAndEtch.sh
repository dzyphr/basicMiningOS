#/bin/bash

#####################################################################
# This script will locally build a custom ubuntu 22.04 ISO with the #
# necessary packages for basicminingOS automatic installation.      #
# Then it will download, install, and launch Balena Etcher.         #
# Balena Etcher is a tool for flashing drives with ISO files.       #
#####################################################################

sudo apt install p7zip #unzip stuff

sudo apt install wget #download stuff

sudo apt install xorriso #mod ISO files


ISONAME='basicminingOS-u22.04-ISO' #set ISO file 
ISODIRNAME=$ISONAME"_BUILDDIR"

mkdir "$ISODIRNAME"

cd $ISODIRNAME

mkdir "source-files" #make source files dir

wget -nc https://cdimage.ubuntu.com/ubuntu-server/jammy/daily-live/current/jammy-live-server-amd64.iso #get ubuntu 22.04 server

7z -y x jammy-live-server-amd64.iso -osource-files #extract to source-files dir

cd source-files #go to source-files dir

mkdir customOS_scripts

cp ../../*.sh customOS_scripts/
rm customOS_scripts/buildAndEtch.sh

mv  '[BOOT]' ../BOOT #move raw boot images out of the way
#(
#   reference: 
#
#   https://www.pugetsystems.com/labs/hpc/ubuntu-22-04-server-autoinstall-iso/#h-step-2-unpack-files-and-partition-images-from-the-ubuntu-22-04-live-server-iso
#)

# use `awk` to insert an 'Autoinstall Ubuntu Server' config stanza 
# into the grub.cfg file once above first existing occurence of menuentry 

awk -v block="$(<../../menuEntryStanza.cfg)" '
BEGIN { inserted = 0 }
{
    if (/menuentry/ && inserted == 0) {
        print block
        inserted = 1
    }
    print
}
' boot/grub/grub.cfg > tmpgrubcfg.cfg #using a temp file for now because it works

mv tmpgrubcfg.cfg boot/grub/grub.cfg #move the tempt file into the real grub.cfg file

new_md5=$(md5sum ./boot/grub/grub.cfg | awk '{ print $1 }') # calculates md5 of modified grub.cfg

sed -i "/\.\/boot\/grub\/grub.cfg/c\\$new_md5  ./boot/grub/grub.cfg" md5sum.txt # replaces grub.cfg md5 hash line for authentication

mkdir server #make a server directory

touch server/meta-data #make essential expected EMPTY meta-data file

cp ../../user-data-example server/user-data #copy in the user-data-example file into a file called user-data
#TODO: Make sure to edit user-data-example if you want to make a custom password or username before writing the ISO

# call the `xorriso` tool in order to build the customized ISO file
sudo xorriso -as mkisofs -r \
  -V 'Ubuntu 22.04 LTS AUTO (EFIBIOS)' \
  -o ../../$ISONAME.iso   \
  --grub2-mbr ../BOOT/1-Boot-NoEmul.img  \
  -partition_offset 16   \
  --mbr-force-bootable   \
  -append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b ../BOOT/2-Boot-NoEmul.img  \
  -appended_part_as_gpt  \
  -iso_mbr_part_type a2a0d0ebe5b9334487c068b6b72699c7  \
  -c '/boot.catalog'  \
  -b '/boot/grub/i386-pc/eltorito.img'   \
      -no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info   \
  -eltorito-alt-boot   -e '--interval:appended_partition_2:::'   \
  -no-emul-boot   .

cd ../../

wget -nc https://github.com/balena-io/etcher/releases/download/v1.19.21/balena-etcher_1.19.21_amd64.deb #get balena etcher

sudo apt install ./balena-etcher_1.19.21_amd64.deb #install balena etcher

sudo usermod -aG sudo $USER #avoids issues where you cant write to the disk in balena

balena-etcher #startup balena, slect the iso downloaded to this directory, and the disk you want to overwrite (CAREFULLY ofcourse)

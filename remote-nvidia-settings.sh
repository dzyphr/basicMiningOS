#!/bin/bash

# HUGE thank you to author of https://u2pia.medium.com/ubuntu-20-04-nvidia-gpu-control-through-ssh-terminal-bb136f447e11 ! 

if [ "$#" -lt 4 ]; then
        echo "
provide arguments:
        -f <speed> [set manual fan speed]
        -m <offset> [set memclock offset]
        -i <ID> [GPU ID]
"
fi

# Get the UID of the user 'gdm'
uid=$(id gdm | grep -oP 'uid=\K[0-9]+')

# Print the UID
#echo "$uid"
#sudo ls -AFlh /run/user/"$uid"/gdm/ #should print an Xauthority path if working properly

if [ $1 = "-f" ]; then
        speed=$2
        if [ $3 = "-i" ]; then
                gpu=$4
                sudo DISPLAY=:0 XAUTHORITY=/run/user/"$uid"/gdm/Xauthority nvidia-settings \
                        -a [gpu:"$gpu"]/GPUFanControlState=1 \
                        -a [fan:0]/GPUTargetFanSpeed="$speed"
        fi
fi # to set fan to auto, GPUFanControlState=0

if [ "$1" = "-m" ]; then
        offset="$2"
        if [ "$3" = "-i" ]; then
                gpu="$4"
                sudo DISPLAY=:0 XAUTHORITY=/run/user/"$uid"/gdm/Xauthority nvidia-settings \
                        -a [gpu:"$gpu"]/GPUMemoryTransferRateOffsetAllPerformanceLevels="$offset"
        fi
fi


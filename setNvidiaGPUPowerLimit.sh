if [ $# -eq 2 ]
	then
	sudo nvidia-smi -pl $1 -i $2
else
	echo "provide arguments: 
       	setNvidiaGPUPowerLimit <powerlimit> <GPU_ID>"
fi


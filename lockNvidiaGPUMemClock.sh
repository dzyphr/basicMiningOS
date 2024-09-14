if [ $# -eq 2 ]
        then
	sudo nvidia-smi --lock-memory-clocks=$1 -i $2
else
	echo "provide arguments: 
	lockNvidiaGPUMemClock.sh <memoryClock> <GPU_ID>"
fi

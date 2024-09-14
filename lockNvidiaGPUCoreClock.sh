if [ $# -eq 2 ]
        then
	sudo nvidia-smi --lock-gpu-clocks=$1 -i $2
else
	echo "provide arguments: 
	lockNvidiaGPUCoreClock.sh <coreClock> <GPU_ID>"
fi

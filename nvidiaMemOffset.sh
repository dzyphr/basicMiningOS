ACTUAL_MEMORY_OFFSET=$(( $1*2 ))
echo $ACTUAL_MEMORY_OFFSET
sudo /usr/bin/nvidia-settings -a [gpu:0]/GPUMemoryTransferRateOffsetAllPerformanceLevels=$ACTUAL_MEMORY_OFFSET

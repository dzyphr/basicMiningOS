sudo apt-get install gpustat
wget -nc https://github.com/develsoftware/GMinerRelease/releases/download/3.44/gminer_3_44_linux64.tar.xz
tar -xvf gminer_3_44_linux64.tar.xz #TODO modularize the miner choice obviously
echo "What coin do you want to mine?
options: [Ergo]"
read coinoption
if [ $coinoption == "Ergo" ]; then
    echo "Enter the mining pool address:"
    read miningpooladdr
    echo "Enter your ergo public key:"
    read ergopub
    cd gminer
    ./miner --algo autolykos2 --server $miningpooladdr --user $ergopub
else
    echo "Coin: $coinoption is currently unhandled! Needs configuring in this script"
fi


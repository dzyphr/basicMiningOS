#!/bin/sh
#TODO gather list of mining pool addrs and chain pubs in json then offer those options as saved results
sudo apt-get install gpustat
echo "What mining software do you want to use?
options: [gminer(memClockingIssues), trex]"
read -r mineroption
if [ "$mineroption" = "gminer" ]; then
    wget -nc https://github.com/develsoftware/GMinerRelease/releases/download/3.44/gminer_3_44_linux64.tar.xz
    mkdir -p "$mineroption"
    tar -xvf gminer_3_44_linux64.tar.xz -C gminer #TODO modularize miner choice further
elif [ "$mineroption" = "trex" ]; then
    wget -nc https://github.com/trexminer/T-Rex/releases/download/0.26.8/t-rex-0.26.8-linux.tar.gz
    mkdir -p "$mineroption"
    tar -xvzf t-rex-0.26.8-linux.tar.gz -C trex
else
    echo "Miner: $mineroption is currently unhandled! Needs configuration."
fi
echo "What coin do you want to mine?
options: [Ergo]"
read -r coinoption
if [ "$coinoption" = "Ergo" ]; then
    echo "Enter the mining pool address:"
    read -r miningpooladdr
    echo "Enter your ergo public key:"
    read -r ergopub
    cd "$mineroption" || return
    if [ "$mineroption" = "gminer" ]; then
        ./miner --algo autolykos2 --server "$miningpooladdr" --user "$ergopub"
    elif [ "$mineroption" = "trex" ]; then
        ./t-rex -a autolykos2 -o "$miningpooladdr" -u "$ergopub"
    fi
else
    echo "Coin: $coinoption is currently unhandled! Needs configuration."
fi


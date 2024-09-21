#!/bin/sh
#TODO run with flags option for non interactivity
sudo apt-get install jq fzf

editKeyValueJSON(){
    local key="$1"
    local value="$2"
    local jsonFileName="$3"
    local entrieslabel="$4"
    if [ ! -f "$jsonFileName" ]; then
        touch "$jsonFileName"
        echo \
        "{
        \"$entrieslabel\": [
            {
                \"$key\": \"$value\"
            }
         ]
}
        " > "$jsonFileName"
        echo "Created '$jsonFileName' with initial entry: $key = $value."
    else
        echo "'$jsonFileName' already exists."
        jq ".$entrieslabel[0] += {\"$key\": \"$value\"}" "$jsonFileName" > "$jsonFileName.tmp"
        cp "$jsonFileName.tmp" "$jsonFileName"
        rm "$jsonFileName.tmp" #move not working for whatever reason 
        # Add the new entry using jq
        echo "Added entry: $key = $value."
    fi
}

fzfFromJSONChoices(){
    local jsonFileName="$1"
    LABEL=$(jq -r 'keys[]' "$jsonFileName")
    OPTIONS=$(jq -r ".$LABEL[]" "$jsonFileName" | jq  'keys' | jq -r '.[]')
    CHOICE=$(printf "%s\n" $OPTIONS | fzf --prompt "Choose an option from $jsonFileName: ")
    case "$CHOICE" in
    *)
        if [ -n "$CHOICE" ]; then
            VALUE=$(jq -r ".\"$LABEL\"[0].\"$CHOICE\"" "$jsonFileName")
            echo "$VALUE"
        else
            echo "No option selected or cancelled."
        fi
        ;;
    esac
}


NvidiaMinerOptionsJSON="NvidiaMiners.json"

echo "What mining software do you want to use?"
mineroption=$(fzfFromJSONChoices "$NvidiaMinerOptionsJSON")
#read -r mineroption



if [ "$mineroption" = "gminer" ]; then
    wget -nc https://github.com/develsoftware/GMinerRelease/releases/download/3.44/gminer_3_44_linux64.tar.xz
    mkdir -p "$mineroption"
    tar -xvf gminer_3_44_linux64.tar.xz -C "$mineroption" #TODO modularize miner choice further
elif [ "$mineroption" = "trex" ]; then
    wget -nc https://github.com/trexminer/T-Rex/releases/download/0.26.8/t-rex-0.26.8-linux.tar.gz
    mkdir -p "$mineroption"
    tar -xvzf t-rex-0.26.8-linux.tar.gz -C "$mineroption"
elif [ "$mineroption" = "rigel" ]; then
    wget -nc https://github.com/rigelminer/rigel/releases/download/1.19.1/rigel-1.19.1-linux.tar.gz
    mkdir -p "$mineroption"
    tar -xvzf rigel-1.19.1-linux.tar.gz -C "$mineroption"
else
    echo "Miner: $mineroption is currently unhandled! Needs configuration."
fi

CoinOptionsJSON="CoinOptions.json"
echo "What coin do you want to mine?"
coinoption=$(fzfFromJSONChoices "$CoinOptionsJSON")
#read -r coinoption

ErgoMiningPoolsJSON="ErgoMiningPools.json"
ErgoMiningAddressesJSON="ErgoMiningAddresses.json"



if [ "$coinoption" = "Ergo" ]; then
    #TODO prompt for new or existing pool and or addr if json exists
    if [ -f "$ErgoMiningPoolsJSON" ]; then
        echo "New pool? (y/n)" 
        read -r newpool
        if [ "$newpool" = "y" ]; then
            echo "Enter the mining pool address:"
            read -r miningpooladdr
            echo "Enter a name for this mining pool:"
            read -r miningpoolname
            editKeyValueJSON "$miningpoolname" "$miningpooladdr" "$ErgoMiningPoolsJSON" "ergopools"
        elif [ "$newpool" = "n" ]; then
            miningpooladdr=$(fzfFromJSONChoices "$ErgoMiningPoolsJSON")
            echo "pool address chosen: $miningpooladdr"
        fi
    else
        echo "Enter the mining pool address:"
        read -r miningpooladdr
        echo "Enter a name for this mining pool:"
        read -r miningpoolname
        editKeyValueJSON "$miningpoolname" "$miningpooladdr" "$ErgoMiningPoolsJSON" "ergopools"
    fi
    if [ -f "$ErgoMiningAddressesJSON" ]; then
        echo "New Mining Address? (y/n)"
        read -r newaddr
        if [ "$newaddr" = "y" ]; then
            echo "Enter your ergo mining address:"
            read -r ergoaddr
            echo "Give this address a name:"
            read -r ergoaddrname
            editKeyValueJSON "$ergoaddrname" "$ergoaddr" "$ErgoMiningAddressesJSON" "ergoaddrs"
        elif [ "$newaddr" = "n" ]; then
            ergoaddr=$(fzfFromJSONChoices "$ErgoMiningAddressesJSON")
            echo "ergo address chosen: $ergoaddr"
        fi
    else
        echo "Enter your ergo mining address:"
        read -r ergoaddr
        echo "Give this address a name:"
        read -r ergoaddrname
        editKeyValueJSON "$ergoaddrname" "$ergoaddr" "$ErgoMiningAddressesJSON" "ergoaddrs"
    fi

    cd "$mineroption" || return
    if [ "$mineroption" = "gminer" ]; then
        sudo ./miner --algo autolykos2 --server "$miningpooladdr" --user "$ergoaddr"
    elif [ "$mineroption" = "trex" ]; then
        sudo ./t-rex -a autolykos2 -o "$miningpooladdr" -u "$ergoaddr"
    elif [ "$mineroption" = "rigel" ]; then
        cd "rigel-1.19.1-linux"
        sudo ./rigel -a autolykos2 -o stratum+tcp://"$miningpooladdr" -u "$ergoaddr"
    fi
else
    echo "Coin: $coinoption is currently unhandled! Needs configuration."
fi


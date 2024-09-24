import os, json_tools

def run(command):
    print(os.popen(command).read())

run('./nvidia-smi-persistence.sh')


if os.path.isfile('NvidiaGPUTweakConfig.json'):
    conf = json_tools.ojf('NvidiaGPUTweakConfig.json')
    for GPU in conf:
        CoreClockLock = conf[GPU]["CoreClockLock"]
        if CoreClockLock != "unset":
            run(f'./lockNvidiaGPUCoreClock.sh {CoreClockLock} {GPU}')
        MemClockOffset = conf[GPU]["MemClockOffset"]
        if CoreClockLock != "unset":
            run(f'./remote-nvidia-settings.sh -m {MemClockOffset} -i {GPU}')
        PowerLimit = conf[GPU]["PowerLimit"]
        if PowerLimit != "unset":
           run(f'./setGPUPowerLimit.sh {PowerLimit} {GPU}')
        FanSpeed = conf[GPU]["FanSpeed"]
        if FanSpeed != "unset":
            run(f'./remote-nvidia-settings.sh -f {FanSpeed} -i {GPU}')
        




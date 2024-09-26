import os, json_tools

def run(command):
    print(os.popen(command).read())

run('./nvidia-smi-persistence.sh')


if os.path.isfile('NvidiaGPUTweakConfig.json'):
    conf = json_tools.ojf('NvidiaGPUTweakConfig.json')
    for GPU in conf:
        GPUMap = json_tools.ojf('NvidiaGPUs.json')
        HWID = GPUMap[GPU]["HWID"]
        CoreClockLock = conf[GPU]["CoreClockLock"]
        UUID = GPUMap[GPU]["UUID"]
        if CoreClockLock != "unset":
            run(f'./lockNvidiaGPUCoreClock.sh {CoreClockLock} {HWID}')
        MemClockOffset = conf[GPU]["MemClockOffset"]
        if CoreClockLock != "unset":
            run(f'./remote-nvidia-settings.sh -m {MemClockOffset} -i {UUID}')
        PowerLimit = conf[GPU]["PowerLimit"]
        if PowerLimit != "unset":
           run(f'./setGPUPowerLimit.sh {PowerLimit} {HWID}')
        FanSpeed = conf[GPU]["FanSpeed"]
        if FanSpeed != "unset":
            run(f'./remote-nvidia-settings.sh -f {FanSpeed} -i {UUID}')
        




import os, file_tools, json_tools, json

if os.path.isfile('NvidiaGPUs.json'):
    GPUMap = json_tools.ojf('NvidiaGPUs.json')
    TweakJSON = {}
    for GPU in GPUMap:
        ID = GPU
        Name = GPUMap[ID]["Name"]
        HWID = GPUMap[ID]["HWID"]
        Subsystem = GPUMap[ID]["Subsystem"]
        TweakJSON[ID] = {
                "Card": Name,
                "Subsystem": Subsystem,
                "CoreClockLock": "unset",
                "MemClockOffset": "unset",
                "PowerLimit": "unset",
                "FanSpeed": "unset"
        }
    file_tools.clean_file_open("NvidiaGPUTweakConfig.json", "w", json.dumps(TweakJSON, indent=2))




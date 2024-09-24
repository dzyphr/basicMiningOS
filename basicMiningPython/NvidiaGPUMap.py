import json, subprocess, re, file_tools, os
from datetime import datetime

def nvidia_smi_output():
    return subprocess.run(['nvidia-smi'], stdout=subprocess.PIPE, text=True).stdout

def is_label_line(s):
    if s.startswith('| GPU  Name'):
        return True
    elif s.startswith('| Fan  Temp'):
        return True
    elif s.startswith('| Processes:'):
        return True
    elif s.startswith('|  GPU'):
        return True
    elif s.startswith('|        ID   ID'):
        return True
    elif s.endswith('MIG M. |'):
        return True
    elif s.endswith('Default |'):
        return True
    elif s.endswith('|                      |                  N/A |'):
        return True
    elif 'usr/lib/xorg/Xorg' in s:
        return True
    elif '/usr/bin/gnome-shell' in s:
        return True
    else:
        return False

def is_mute_line(s):
    return all(char in '+-|= ' for char in s)

def is_smi_version_line(s):
    return "NVIDIA-SMI" in s

def is_valid_timestamp(s):
    try:
        # Attempt to parse the string using the expected format
        datetime.strptime(s.strip(), '%a %b %d %H:%M:%S %Y')
        return True
    except ValueError:
        return False

def convert_uppercase_to_lowercase(input_string):
    result = ""
    for char in input_string:
        if char.isupper():
            result += char.lower()
        else:
            result += char
    return result


def remove_tabs_and_newlines(input_string):
    return input_string.replace('\t', '').replace('\n', '')

def getGPUSubsystem(GPU_HWID):
    GPU_HWID = convert_uppercase_to_lowercase(GPU_HWID.replace("00000000:", ""))
    out = remove_tabs_and_newlines(os.popen(f"lspci -vnn | grep {GPU_HWID} -A 12 | grep Subsystem").read())
    return out.replace("Subsystem: ", "")


def parse_nvidia_smi_output(output):
    gpus = {} 
    
    # Split the output into lines
    lines = output.splitlines()
    
    filteredString = ""
    # Process lines to find GPU information
    for line in lines:
        if is_mute_line(line) == False:
            if is_smi_version_line(line) == False:
                if is_valid_timestamp(line) == False:
                    if is_label_line(line) == False:
                        filteredString += f'{line}\n'.replace('|', '')
    for line in filteredString.splitlines():
        linearray = re.sub(r'\s\s+', '-', line).split('-')
        GPU_IDNO = linearray[1]
        print(f"GPU ID NUMBER: {GPU_IDNO}")
        GPU_NAME = linearray[2]
        print(f"GPU NAME: {GPU_NAME}")
        GPU_HWID = linearray[4].replace("Off", "").replace("On", "")
        print(f"GPU HARDWARE ID: {GPU_HWID}")
        GPU_Sub = getGPUSubsystem(GPU_HWID)
        gpus[GPU_IDNO] = {
                "Name": GPU_NAME,
                "HWID": GPU_HWID,
                "Subsystem": GPU_Sub
        }
    return json.dumps(gpus, indent=2)


    

file_tools.clean_file_open("NvidiaGPUs.json", "w", parse_nvidia_smi_output(nvidia_smi_output()))


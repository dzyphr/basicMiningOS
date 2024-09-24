import os, json
import file_tools
def keyVal_list_update(keyValList, jsonPath): #update a json file with a list of key value pairs
    if type(keyValList) is not list:
        print("must be a list of key value pairs. actual:", keyValList, "path: ", jsonPath)
        return False
    try:
        j = json.loads(str(file_tools.clean_file_open(jsonPath, "r")))
        for keyVal in keyValList:
            if keyVal not in json_to_keyValList(jsonPath): #overwrite protection
                j.update(keyVal)
        file_tools.clean_file_open(jsonPath, "w", str(json.dumps(j, indent=4)))
    except ValueError as e:
        print("Invalid Json")

def json_to_keyValList(jsonPath): #convert a json file to a python key value list: [{"key":"value"}, {"key", "value"}]
    keyValList = []
    try:
        j = json.loads(file_tools.clean_file_open(jsonPath, "r"))
        for key in j:
            keyValList.append({key:j[key]})
        return keyValList
    except ValueError as e:
        print("Invalid Json")

def ojf(filepath): #open json file
    while True:
        try:
            contents = json.loads(str(file_tools.clean_file_open(filepath, "r")))
            break
        except json.decoder.JSONDecodeError as e:
            print(e)
            continue
    return contents

def createOrUpdateIndexedJSONPath(path, value):
    if os.path.isfile(path):
        obj = ojf(path)
        index = len(obj)
        updatelist = [{index:value}]
        keyVal_list_update(updatelist, path)
    else:
        file_tools.clean_file_open(path, "w", "{}")
        updatelist = [{0:value}]
        keyVal_list_update(updatelist, path)
    return value

def is_json(myjson):
    try:
        json.loads(myjson)
    except ValueError as e:
        return False
    return True


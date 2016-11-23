import json
import sys
import subprocess

filename = sys.argv[1]

with open(filename) as data_file:
    data = json.load(data_file)

for item in data:
    #cmd = "brew install {} "
    for installed in item['installed']:
        print installed['used_options']

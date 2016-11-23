import json
import subprocess

leaves = subprocess.check_output('brew leaves', shell=True).splitlines()

json_info = json.loads(subprocess.check_output('brew info --json=v1 --installed', shell=True))

leaves_info = filter(lambda x: (x['full_name'] in leaves) or (len(x['installed'][0]['used_options']) > 0), json_info)

print json.dumps(leaves_info)

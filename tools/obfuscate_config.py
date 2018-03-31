import sys
import yaml

OSETTINGS = {
    'provider' : 'web3 path or socket, e.g. http://localhost:8545',
    'fields_json' : 'path to a file generated by worker',
    'rule_file' : 'worker template file',
    'pravo_api' : 'pravo_api backend listening socket',
    'upload_folder' : 'upload folder used by workers',
    'secret_key' : 'key used by pravo_api',
    'template_file' : 'path to a suit template file'
    }

inp = sys.stdin.read()
y = yaml.load(inp)

settings = y['settings']
for s in settings:
    if s in OSETTINGS:
        settings[s] = 'MODIFY: ' + OSETTINGS[s]


print(yaml.dump(y))

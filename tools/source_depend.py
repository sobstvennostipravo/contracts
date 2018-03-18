#!/usr/bin/python3
from optparse import OptionParser
import yaml
import time
from web3 import Web3
import os

stamp_to_compare = 0.

def traverse(el):
    if type(el) == type(list()):
        for list_el in el:
            traverse(list_el)
    elif type(el) == type(dict()):
        for key in el:
            if type(el[key]) == type(dict()) or type(el[key]) == type(list()):
                traverse(el[key])
            elif key == 'address':
                if "sources" in el:
                    if 'name' in el:
                        print(el["name"])
                    else:
                        print(el['address'])
                    for a_source in el["sources"]:
                        try:
                            mtime = os.path.getmtime(a_source)
                            if mtime > stamp_to_compare:
                                print(a_source," is new")
                                el["address"] = "UNDEFINED"
                        except:
                            pass

def main(yaml_fname, provider):
    with open(yaml_fname, 'r') as f:
        y = yaml.load(f)
    global stamp_to_compare
    stamp_to_compare = os.path.getmtime(yaml_fname)

    traverse(y)

    with open(yaml_fname, "w") as f:
        yaml.dump(y, f)

if __name__ == "__main__":
    usage = """
    %prog [options]
        Run debug_server
        example: $ ./debug_server.py --deploy=/path/to/deploy/yaml
    """

    parser = OptionParser(usage=usage)

    parser.add_option("--deploy", "--deploy-yaml", "--yaml", dest="yaml_fname", default="../contracts/deploy.yaml",
        help="path to deploy.yaml file")
    (options, args) = parser.parse_args()


    with open(options.yaml_fname, 'r') as f:
        y = yaml.load(f)


    main(options.yaml_fname, y['settings']['provider'])

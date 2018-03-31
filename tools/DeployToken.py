import yaml
import solcwrap
import pickle
import os

def main(yaml_fname):

    with open(yaml_fname, 'r') as f:
        y = yaml.load(f)

    if y["token"]["address"] == "UNDEFINED":

        cwd = os.getcwd()
        os.chdir('../token')
        (contract_address, abi) = solcwrap.tmpl('PRAVOToken', y['settings']['provider'], {})

        y["token"]["address"] = contract_address
        y["token"]["abi"] = pickle.dumps(abi)
        y["token"]["sources"] = ['PRAVOToken.sol.in']

        with open(yaml_fname, "w") as f:
            yaml.dump(y, f)
        os.chdir(cwd)

if __name__ == "__main__":
    main("deploy.yaml")

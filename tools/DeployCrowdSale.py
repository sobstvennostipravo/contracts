import yaml
import solcwrap
import pickle
import os

def main(yaml_fname):

    with open(yaml_fname, 'r') as f:
        y = yaml.load(f)

    if y["crowd_sale"]["address"] == "UNDEFINED":

        cwd = os.getcwd()
        os.chdir('../token')
        (contract_address, abi) = solcwrap.tmpl('PRAVOCrowdSale', y['settings']['provider'], {})

        y["crowd_sale"]["address"] = contract_address
        y["crowd_sale"]["abi"] = pickle.dumps(abi)
        y["crowd_sale"]["sources"] = ['PRAVOCrowdSale.sol.in']

        with open(yaml_fname, "w") as f:
            yaml.dump(y, f)
        os.chdir(cwd)

if __name__ == "__main__":
    main("../deploy.yaml")

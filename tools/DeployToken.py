import yaml
import solcwrap
import pickle

def main(yaml_fname, provider):

    with open(yaml_fname, 'r') as f:
        y = yaml.load(f)

    if y["token"]["address"] == "UNDEFINED":

        (contract_address, abi) = solcwrap.tmpl('PRAVOToken', provider, {})

        y["token"]["address"] = contract_address
        y["token"]["abi"] = pickle.dumps(abi)
        y["token"]["sources"] = ['PRAVOToken.sol.in']

        with open(yaml_fname, "w") as f:
            yaml.dump(y, f)

if __name__ == "__main__":
    main("deploy.yaml", 'http://localhost:8545')

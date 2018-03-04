import yaml
import solcwrap
import pickle

def main(yaml_fname, provider):

    with open(yaml_fname, 'r') as f:
        y = yaml.load(f)

    if y["root"]["address"] == "UNDEFINED":

        mapdict = {}
        factories = []
        for afactory in y['factories']:
            factories.append({"address": afactory['address'],
                              "name": afactory['name'],
                              "micro_ether_price": int(afactory['ether_price'] * 1000000),
                              "token_price": afactory['token_price'],
                              "timeout": afactory['timeout']})

        mapdict['factories'] = factories

        (contract_address, abi) = solcwrap.tmpl('Root', provider, mapdict)

        print(contract_address)

        y["root"]["address"] = contract_address
        y["root"]["abi"] = pickle.dumps(abi)
        y["root"]["sources"] = ["Root.sol.in"]

        with open(yaml_fname, "w") as f:
            yaml.dump(y, f)


if __name__ == "__main__":
    main("deploy.yaml", 'http://localhost:8545')   #'/home/ilejn/.ethereum_private/geth.ipc'

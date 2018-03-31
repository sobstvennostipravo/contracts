import yaml
import solcwrap
import pickle

def main(yaml_fname):
    with open(yaml_fname, 'r') as f:
        y = yaml.load(f)


    for afactory in y['factories']:

        if afactory["address"] == "UNDEFINED":

            mapdict = {}
            workers = []
            for aworker in afactory['workers']:
                workers.append({"address": aworker['address'],
                                "micro_ether_price": int(aworker['ether_price'] * 1000000),
                                "token_price": aworker['token_price']})

            mapdict['workers'] = workers

            (contract_address, abi) = solcwrap.tmpl('Factory', y['settings']['provider'], mapdict)

            print(contract_address)

            afactory["address"] = contract_address
            afactory["abi"] = pickle.dumps(abi)
            afactory["sources"] = ["Factory.sol.in"]


    with open(yaml_fname, "w") as f:
        yaml.dump(y, f)


    # my_contract = SIPContract(contract_address)

    # my_contract.call().jobStart(1000000)

if __name__ == "__main__":
    main("deploy.yaml")

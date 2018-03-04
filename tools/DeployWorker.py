import yaml
import solcwrap
import pickle

def main(yaml_fname, provider):

    with open(yaml_fname, 'r') as f:
        y = yaml.load(f)


    for afactory in y['factories']:
        for aworker in afactory['workers']:

            if aworker["address"] == "UNDEFINED":

                (contract_address, abi) = solcwrap.tmpl('Worker', provider, {})

                print(contract_address)

                aworker["address"] = contract_address
                aworker["abi"] = pickle.dumps(abi)
                aworker["sources"] = ["Worker.sol.in"]



    with open(yaml_fname, "w") as f:
        yaml.dump(y, f)


    # my_contract = SIPContract(contract_address)

    # my_contract.call().jobStart(1000000)

if __name__ == "__main__":
    main("deploy.yaml", "http://localhost:8545")

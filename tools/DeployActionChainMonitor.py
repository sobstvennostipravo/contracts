import yaml
import solcwrap
import pickle
import os

def main(yaml_fname):

    with open(yaml_fname, 'r') as f:
        y = yaml.load(f)

    if y["action_chain_monitor"]["address"] == "UNDEFINED":

        mapdict = {}
        workers = []
        for aworker in y['factories'][0]['workers']:   # a sort of hack, we handle first Factory only
            workers.append({"name": aworker['name']})

        mapdict['workers'] = workers

        (contract_address, abi) = solcwrap.tmpl('ActionChainMonitor', y['settings']['provider'], mapdict)

        y["action_chain_monitor"]["address"] = contract_address
        y["action_chain_monitor"]["abi"] = pickle.dumps(abi)
        y["action_chain_monitor"]["sources"] = ['ActionChainMonitor.sol.in']

        with open(yaml_fname, "w") as f:
            yaml.dump(y, f)

if __name__ == "__main__":
    main("deploy.yaml")

import yaml
import solcwrap
import pickle

def main(yaml_fname, provider):

    with open(yaml_fname, 'r') as f:
        y = yaml.load(f)

    (contract_address, abi) = solcwrap.tmpl('ActionChain', provider, {}, do_deploy=False)

    y["action_chain"]["abi"] = pickle.dumps(abi)
    y["action_chain"]["sources"] = ["ActionChain.sol.in"]

    with open(yaml_fname, "w") as f:
        yaml.dump(y, f)


if __name__ == "__main__":
    main("deploy.yaml", 'http://localhost:8545')   #'/home/ilejn/.ethereum_private/geth.ipc'

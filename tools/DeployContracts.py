#!/usr/bin/python3

import yaml
import os
import DeployRoot
import DeployFactory
import DeployWorker
import DeployToken
import CompileActionChain
import DeployActionChainMonitor
import DeployCrowdSale

yaml_fname = "../deploy.yaml"


# import run_backends
os.chdir('../src')

print(">token")
DeployToken.main(yaml_fname)

print(">worker")
DeployWorker.main(yaml_fname)

print(">action_chain")
CompileActionChain.main(yaml_fname)

print(">factory")
DeployFactory.main(yaml_fname)

print(">root")
DeployRoot.main(yaml_fname)

print(">action_chain_monitor")
DeployActionChainMonitor.main(yaml_fname)

print(">crowd_sale")
DeployCrowdSale.main(yaml_fname)

# run_backends.main(yaml_fname, provider, "SOBSTVENNOSTIPRAVO")

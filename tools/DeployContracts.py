#!/usr/bin/python3

import yaml
import os
import DeployRoot
import DeployFactory
import DeployWorker
import DeployToken
import CompileActionChain

yaml_fname = "../deploy.yaml"


with open(yaml_fname, 'r') as f:
     y = yaml.load(f)


provider = y['settings']['provider']


# import run_backends
os.chdir('../src')

print(">token")
DeployToken.main(yaml_fname, provider)

print(">worker")
DeployWorker.main(yaml_fname, provider)

print(">action_chain")
CompileActionChain.main(yaml_fname, provider)

print(">factory")
DeployFactory.main(yaml_fname, provider)

print(">root")
DeployRoot.main(yaml_fname, provider)


# run_backends.main(yaml_fname, provider, "SOBSTVENNOSTIPRAVO")

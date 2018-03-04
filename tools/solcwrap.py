import solc
import sys
import time
from mako.template import Template
from web3 import Web3

def deploy(compiled_contract, fname_contract, provider):
    web3 = Web3(Web3.HTTPProvider(provider) if provider.find("//") > 0 else Web3.IPCProvider(provider))
    Contract = web3.eth.contract(abi = compiled_contract[fname_contract]['abi'], bytecode = compiled_contract[fname_contract]['bin'], bytecode_runtime = compiled_contract[fname_contract]['bin-runtime'])
    trans_hash = Contract.deploy(transaction={'from':web3.eth.accounts[0]})
    print(trans_hash)


    while True:
        trans_receipt = None
        try:
            trans_receipt = web3.eth.getTransactionReceipt(trans_hash)
        except ValueError as err:
            # print("ValueError", err)
            pass

        if trans_receipt:
            print('')
            break
        time.sleep(1)
        sys.stdout.write(".")
        sys.stdout.flush()

    contract_address = trans_receipt['contractAddress']
    return contract_address

def tmpl(contract_name, provider, mapdict, do_deploy = True, debug=True):

    fname = contract_name + ".sol"
    fname_in = fname + ".in"
    fname_contract = fname + ':' + contract_name

    with open(fname_in, "r") as f:
        solidity_source = ""
        for a_line in f.readlines():
            if a_line.startswith("//TMPL"):
                a_line = a_line[6:]
            elif a_line.startswith("//DBG"):
                if debug:
                    a_line = a_line[5:]
                else:
                    a_line = ''
            solidity_source = "".join([solidity_source, a_line])

    instantiated = Template(solidity_source, strict_undefined=True).render(**mapdict)
    with open(fname, "w+") as f:
        f.write(instantiated)


    compiled_contract = solc.compile_files([fname], import_remappings=["common=/home/ilejn/contracts/common", "token=/home/ilejn/contracts/token"])
    abi = compiled_contract[fname_contract]['abi']
    print(abi)
    if do_deploy:
        contract_address = Web3.toChecksumAddress(deploy(compiled_contract, fname_contract, provider))
    else:
        contract_address = 0
    return (contract_address, abi)

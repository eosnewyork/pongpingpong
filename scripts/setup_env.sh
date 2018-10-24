#!/bin/sh

# send output to a log file and start a background process
nodeos -e -p eosio --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin &> /var/log/nodeos.log & 

# create wallet named "default"
cleos wallet create --file /tmp/default.w

# import the default private key
cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

# the wallet will lock occasionally so you would need to unlock it
cleos wallet unlock --password `cat /tmp/default.w`

# set the bios contract
cleos set contract eosio /opt/eosio/contracts/eosio.bios/ -p eosio@active

# create the account
cleos create account eosio ricksclaimer EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV 

# check the account
cleos get account ricksclaimer

# load up the wasm file
cleos set code ricksclaimer /data/build/ricksclaimer.wasm

# load the abi
cleos set abi ricksclaimer /data/build/ricksclaimer.abi

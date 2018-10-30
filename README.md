# pongpingpong
Tutorial on EOS Contracts and some Windows tooling

[EOS Account](https://bloks.io/account/pongpingpong)

## Introduction
Hello and welcome to a fun little tutorial around some great tooling created by us, EOS New York, that hopefully will make the life of the elusive *Windows EOS Developer* a bit easier.

So what is a **pongpingpong** you may be asking. **pongpingpong** is an EOS smart contract tutorial that revolves around [EOS Easy Contract](https://github.com/eosnewyork/EOSEasyContract), Windows Developers, and eventually some more advanced smart contract contracts. [Part I](#Part-I:-Create,-Compile,-and-Deploy-Your-Smart-Contract) will focus on getting everyone up to speed on creating, compiling, and deploying their smart contract. Follow up sections will revolve around more advanced smart contracts such as inline actions, multi-index databases, and "the Trust and Confirm model". At the end of this tutorial you should be able to setup a Windows environment for smart contract development.

**Prerequistes**
This project requires [Docker for Windows](https://www.docker.com/get-started) (of course) and my new favorite text editor, IDE, and all around good guy [VS Code](https://code.visualstudio.com/download). Both of these tools have great communites with tons of information available regarding setup and customization. The final requirement is the brainchild of our very own [Warrick](https://github.com/eosnewyork/EOSEasyContract/commits?author=warrick-eosny). He spent a rainy weekend holed up creating [EOS Easy Contract](https://github.com/eosnewyork/EOSEasyContract). We will be using this project to create, compile, and deploy a smart contract.

## Goals
Our goal here is to get any developers from the Windows world who may be unsure of how get into the EOS development game. There is a ton of tooling for Mac and Linux but no love for the Windows Dev. Hopefully this opens some doors for those characters.

## Environment setup
I am going to assume that you have installed Docker and VS Code using the links above.  Now it is time to get [EOS Easy Contract](https://github.com/eosnewyork/EOSEasyContract) heading to the [github](https://github.com/eosnewyork/EOSEasyContract) link and following the setup instructions there.

Now that you have completed the install of [EOS Easy Contract](https://github.com/eosnewyork/EOSEasyContract) it is now time to start building your first smart contract.

## Part I: Create, Compile, and Deploy Your Smart Contract

#### 1. First create the pongpingpong project
```
> EOSEasyContract.exe template new --path %USERPROFILE% --name pongpingpong
```
![Template output ](images/template_creation_output.png?raw=true)

#### 2. Open up the project in VS Code
```
code %USERPROFILE%\pongpingpong
```

#### 3. Compile the code
Hit ```Ctrl-Shift-B``` to build the sample contract
![Compile output](images/build_sample_contract_output.png?raw=true)

#### 4. Check out the built files
Now in the build directory you should be able to see the wasm and abi files

![build output](images/build_output.png?raw=true)

#### 5. Start the development docker image
##### a. First find the docker image name from the build output. 
In this case it is **EOSCDT-CB6FACF96E87DAA7FAB531911B0B8683**

![container output](images/container_output.png?raw=true)

###### b. Open the terminal
Hit ``` Ctrl-Shift-\` ``` to open a terminal

```
docker exec -it EOSCDT-CB6FACF96E87DAA7FAB531911B0B8683 /bin/bash
```
![start docker output](images/start_docker_output.png?raw=true)

#### 6. Start a single node testnet
The below steps are captured in [a script](scripts\setup_env.sh) that can be copied to the machine and run.

##### a. Start nodeos
```
# send output to a log file and start a background process
nodeos -e -p eosio --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin &> /var/log/nodeos.log & 
tail /var/log/nodeos.log
```
![nodeos output](images/nodeos_output.log.png?raw=true)

##### b. Create wallet and import key
```
# create wallet named "default"
cleos wallet create --file /tmp/default.w

# import the default private key
cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

# the wallet will lock occasionally so you would need to unlock it
cleos wallet unlock --password `cat /tmp/default.w`
```
![wallet output](images/wallet_output.png?raw=true)

##### c. Load up the bios contract
```
cleos set contract eosio /opt/eosio/contracts/eosio.bios/ -p eosio@active
```

![bios output](images/bios_output.png?raw=true)

##### d. Create an account
*For the sake of this tutorial we are using the default key. DO NOT USE THIS KEY FOR ANYTHING BUT DEVELOPMENT*
```
# create the account
cleos create account eosio pongpingpong EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV 

# check the account
cleos get account pongpingpong
```

![account output](images/account_output.png?raw=true)

##### e. Load up the contract
```
# load up the wasm file
cleos set code pongpingpong /data/build/pongpingpong.wasm

# load the abi
cleos set abi pongpingpong /data/build/pongpingpong.abi
```
![set code output](images/set_code_output.png?raw=true)

###### f. Push a test transaction
```
cleos push action pongpingpong hi '{"user" : "pongpingpong"}' -p pongpingpong
```

![action output](images/action_output.png?raw=true)

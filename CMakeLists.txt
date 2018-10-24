cmake_minimum_required(VERSION 3.5)
project(pongpingpong_example VERSION 1.0.0)

find_package(eosio.cdt)

### Only generate the wasm
#add_executable( pongpingpong.wasm pongpingpong.cpp )

### Generate the wasm and abi
add_contract( pongpingpong pongpingpong pongpingpong.cpp )

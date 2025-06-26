// deploy script is written in solidiyty but is not considered a contract. only for execuding a chain of commands

// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// we need to tell foundry that this is a script anf for that we import somehting from foundry

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script{

    function run() external returns(SimpleStorage) {

        // this vm will only work in foundry
        // it is a cheatcode
        // it says that everytihng after this line should be sent to rpc
        // when we are done broadcasting we can call vm.stopBroadcast()
        vm.startBroadcast();
        // everyhitn insdie this is what we want to send and deploy


        SimpleStorage simpleStorage = new SimpleStorage(); // new creates a new SimpleStorage contract and deploys it to the blockchain

        vm.stopBroadcast();

        return simpleStorage;

        
    }


}


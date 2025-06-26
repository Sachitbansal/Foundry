// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    // this is a script to deploy the FundMe contract
    // we can use this to deploy the contract to any network we want

    function run() external returns (FundMe) {
        // anything before startBroadcast will not be executed on the blockchain and will not be send as a real transaction
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        // this vm will make the funder as msg.sender
        vm.startBroadcast();
        // here we are deploying the FundMe contract
        // we will now make a mock on anvil chain using HelperConfig
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
        // now this fundMe will be used in testing script
    }
}

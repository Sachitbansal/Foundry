// we deploy mocks when we are on local anvil chain
// we keep track of contract address across different chains

// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // if we on local anvil chain then we will deploy mocks
    // if we on testnet then we will use the real contract address

    NetworkConfig public activeNetworkConfig;
    uint256 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8; // 2000 USD with 8 decimals

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            // every network has their own unique chain id
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory config = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return config;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // price feed address

        if (activeNetworkConfig.priceFeed != address(0)) {
            // if we already have a price feed address then we can return it and no need to start a new one
            return activeNetworkConfig;

        }
        // deploy the mocks and return the mock address

        vm.startBroadcast();

        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        // Contract takes demical and int256 as parameters
        // 8 becayse decimals of ETH USD is 8

        vm.startBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}

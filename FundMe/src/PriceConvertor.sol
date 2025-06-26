// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// remix knows that @chainlink is coming from github as it is an npn package
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// this will teach you to write a library in solidity

library PriceConvertor {
    // state is not being modified we are only calling and returning the valye so view and return needed
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // we need the address and the abi
        // Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // interface of a contract is just an empty skeleton of it where we get all funcitons and their types just enough to get the ABI of the real contract

        // Here we are setting up the contract with the address to start using functions
        // AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // here the latestRoundData returns allot of values so we did not assigned any variable names of unwanted returns and only put up for the one we want
        // this gives value with 8 decimal places but msg.value has 18 decimal places. so to match the 2 we would need to add the remaining 10
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // now int256 is price and msg.value is uint256, so we need to resolve this by type casting
        return uint256(price) * 1e10;
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        // here we devided by 1e18 because both multiplication will give us 1e36 and we only need 1e18
        uint256 eathAmountInUsd = (ethAmount * ethPrice) / 1e18;
        return eathAmountInUsd;
    }
}

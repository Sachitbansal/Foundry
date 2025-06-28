// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// another thing in Test.sol is console
import {Test, console} from "forge-std/Test.sol";
// basically we can do console.log() so can be used for debugging

import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test{

    address USER = makeAddr("user"); // this will create a new address for the user
    uint256 constant SEND_VALUE = 0.1 ether; // this will be the amount we will send to the fundMe contract
    uint256 constant STARTING_BALANCE = 10 ether; // this will be the starting balance of the user

    FundMe fundMe; // setting a storage/state variable to use throughout the contract


    // In all of our tests, the first thing that happens is this setUp function 

    function setUp() external {
        // This function is run before each test function
        // It can be used to set up state, deploy contracts, etc.
        // now in demo we can test this fundMe contract
        // fundMe = new FundMe(); // Deploying the FundMe contract
        // the most basic one will be to call a public varibale and see its value
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run(); // this will run the script and deploy the FundMe contract

        vm.deal(USER, STARTING_BALANCE); // this will give the USER address 10 ETH

    }

    // any other function works only after the setUp function

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.miniUSD(), 5e18 );
    }

    function testOwnerIsMsgSender() public {
        console.log("msg.sender: ", msg.sender);
        console.log("i_owner: ", fundMe.i_owner());
        // both will be different address becuse in herem FundMeTest is the owner since it deployed the FundMe contract
        // but here are the msg.sender since we sent the message. so we need fundMe to send the message and check
        // so we change msg.sender to address(this) to check if the address of the FundMeTest contract is the owner of the FundMe contract
        // we can use assertEq to check if the owner is set to the msg.sender
        assertEq(fundMe.i_owner(), msg.sender);
        // this msg.sender is coming from deployFundMe
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 verison = fundMe.getVersion();
        assertEq(verison, 4); // this is the version of the price feed we are using
    }

    // we are using foundry cheatcodes for writting this function
    function testFundFailsWithoutEnoughEth() public {

        vm.expectRevert(); // this will expect a revert
        // means the assertion will fail if the function does not revert
        // uint256 cat = 1; // this iwll not revert abd function will fail

        fundMe.fund(); // this will revert because we are sending 0 ETH
    }

    function testFundUpdatesDataStructure() public {

        vm.prank(USER); // this will make the next call to fundMe.fund() come from the USER address

        fundMe.fund{value: SEND_VALUE}(); // this will send 10 ETH to the fundMe contract
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE); // this will check if the amount funded is equal to the SEND_VALUE
    }
}
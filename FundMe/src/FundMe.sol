// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {PriceConvertor} from "./PriceConvertor.sol";
// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// we can create our own custom error
error NotOwner();
// now we can use it in our onlyOwner modifier and remove the require which stores and string and would cost more gass

contract FundMe {

    // using const and immutable varaible helps makinfg the code gass efficient

    using PriceConvertor for uint256;

    // Public variables are meant to be stored in the contract storage, and their values must be constant or default-initialized at the time of contract deployment
    uint256 public constant miniUSD = 5e18; // in terms of usd

    address[] public funders; // addresses of all who funded us
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    // it is the first function called when the contract is deployed
    address public immutable i_owner;
    constructor() {
        i_owner = msg.sender;
    }

    // we set the function as payable to accept currency
    function fund() public payable{
        // Allow users to send USD
        // Have a minimum USD Sent

        // getConversionRate taken in a uint256 and here we have taken it from library as a method on msg.value and it goes in there as its arguement
        // agar function 2 parameters leta to in that case 2nd wala would have gone in to the parenthesis of the method called here
        uint256 converted = msg.value.getConversionRate();
        // 
        // here we are seting a condition that input value should be greater than 10** 18 ETH or else it will revert with the following message
        require(converted > miniUSD, "did not send enough ETH"); // 1e18 = 1 ETH = 1 * 10 ** 18

        funders.push(msg.sender); // msg.sender is another global varibale which gives us address of who ever called the function
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;

        // revert will undo any actions that have been done and send the remaing gass back
        // so lets say you create an INT variable and ask it to incrrment in this fucntion, so if the function reverts, incrementation will also get undo
        // and also the gas will only be refunded for which the computation is perform after the require line.. the above computaiton gass will not be refunded

    }

    // we want only the owner of the contract to be able to call this function

    function withdraw() public onlyOwner {

        // setting amount funded to 0 for every address in the array
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // resetting the funders array
        // previously we used new keyword to deploy a new contract, now we use it to create a new array of addresses with an inital length of 0 and then we set it to funders variable
        funders = new address[](0);

        // sending funds from here
        // 3 ways to send blockchain currency
        // 3 ways are transfer, send and call

        // transfer is literally just to trasfer from sender to reciever

        // payable converts a normal address to payable address and then we transfer to this address 
       
        // payable(msg.sender).transfer(address(this).balance);
       
        // problem here is that if it fails, it throws error and reverts the transaction
        
        
        // but in send type, we get bool whether the transaction was success or not. to send will revert on adding requie statement
        
        // bool status = payable(msg.sender).send(address(this).balance);
        // require(status, "transfer failed");

        // call is powerfull where it is used to call anyb function in whole of solidity. but we can use it as send eth function
        // here the second thing returned is calldata of type bytes it is anything returned from the function called by the call keyword
        // we leave empty paranthesis to declare that we did not call any function and hence we do not need calldata.
        // value: address(this).balnce is just telling the call function the value we want to transfer...
        // also returns a bool

        // call is the recommended way...
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "transfer failed");
    }

    // there might be allot of admin only functions so we need to make something such that we do not need to write the require line again and again
    // this is where modifier comes into play, we can ceate a keyword and set it use in functions
    // we dont give it visibility like functions
    modifier onlyOwner() {
        // require(msg.sender == i_owner, "must be owner");
        // _;

        // role of underscore is that it acts as a place holder for the remaining funciotn
        // so like i caleld onlyowner so firstly the require line executes and then remaining contract is set into the underscore area 
        // where as if is move the underscore above the require line, then it first executues the function and then checks the require
    
        if (msg.sender != i_owner) {
            revert NotOwner();
            // now we do not need to store the string. 
            // custom error is new for solidity.
        }
        _;
    
    }   


    // what happens when someone sent ETH without calling fund function? setting recieve for it
    receive() external payable { 
        fund();
    }

    fallback() external payable { 
        fund();
    }


}
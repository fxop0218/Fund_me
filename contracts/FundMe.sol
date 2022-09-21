// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; // import a interface (similar to java) 

contract FundMe {

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    AggregatorV3Interface public priceFeed; 

    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed); 
        owner = msg.sender; 
    }

    function fund() public payable {
        //uint256 minimumUSD = 50 * 10 ** 18;
        //require(getConversionRate(msg.value) >= minimumUSD, "You need to spend 50$ in ETH");
        addressToAmountFunded[msg.sender] += msg.value; // Sum all the eth funded
        // What the ETH -> USD conversion rate
        funders.push(msg.sender);
    }

    function getVersion() public view returns(uint256) {
        return priceFeed.version();
    }

    // Do the dame as the laters, but oprimized
    function getPrice() public view returns (uint256) {
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10**18);
    }

    // Do the conversion
    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 price = getPrice();
        uint256 ethAmountInUsd = (price * ethAmount) / 10**18;
        return ethAmountInUsd; 
    }

    function getEntraceFee() public view returns(uint256){
        (, int price, , ,) = priceFeed.latestRoundData();
        uint256 adjustPrice = uint256(price) * 10 ** 10;
        // 50$/2.000$
        uint256 costToEnter = (50 * 10 ** 18) / adjustPrice;
        return costToEnter; 
    }

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    function withdraw() payable onlyOwner public { // Put heare modifer, and when any push the withdraw button do the modifier validation
        // Only want the contract admin/owner
        // require(msg.sender == owner); its not needed if you have a modifier onlyOwner (declared upper)
        payable(msg.sender).transfer(address(this).balance);

        for (uint256 i = 0; i < funders.length; i ++) { // Reset all the funder who have currently participated
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}
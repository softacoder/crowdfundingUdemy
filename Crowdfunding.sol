// "SPDX-License_Identifier: GPL-3.0" "SPDX-License-Identifier: UNLICENSED"

pragma solidity >=0.5.0 <0.9.0;

contract CrowdFunding{
    mapping(address => uint) public contributors;
    address public admin;
    uint public noOfContributors;
    uint public minimumContribution;
    uint public deadline;
    uint public goal;
    uint public raisedAmount;

    constructor(uint _goal, uint _deadline){
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        admin = msg.sender;
    }

    function contribute() public payable{
        require(block.timestamp < deadline, "Deadline has passed!");
        require(msg.value >= minimumContribution, "Minimum contribution met!");

        if(contributors[msg.sender] == 0){
            noOfContributors++;
        }

        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

        receive() payable external{
            contribute();
        }

        function getBalance() public view returns(uint){
            return address(this).balance;
        }

         function getBalance() public view returns(uint){
            return address(this).balance;
        }

        function getRefund() public{
            require(block.timestamp > deadline && raisedAmount < goal);
            require (contributors[msg.sender] > 0);

            address payable recipient = payable(msg.sender);
            uint value = contributors[msg.sender];
            recipient.transfer(value);

            // payable (msg.sender).transfer(contributors[msg.sender]);

            contributors[msg.sender] = 0;
        }
}
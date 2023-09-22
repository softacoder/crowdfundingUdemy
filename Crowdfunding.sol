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
}
    constructor(uint _goal, uint _deadline){
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        admin = msg.sender;
    }

    event ContributeEvent(address _sender, uint _value);
    event CreateRequestEvent(string _description, address recipient, unit value);
    event MakePaymentEvent(address _recipient, uint _value);

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

        function getRefund() public{
            require(block.timestamp > deadline && raisedAmount < goal);
            require (contributors[msg.sender] > 0);

            address payable recipient = payable(msg.sender);
            uint value = contributors[msg.sender];
            recipient.transfer(value);

            // payable (msg.sender).transfer(contributors[msg.sender]);

            contributors[msg.sender] = 0;
        }

            modifier onlyAdmin(){
                require(msg.sender == admin, "Only admin can call this function!");
                _;

                function createRequest(string memory _description, address payable _recipient, uint, value) public onlyAdmin{
                    Request storage newRequest = request[numRequests];
                    numRequests_;

                    newRequest.desription = _description;
                    newRequest.requests = _recipient;
                    newRequest.completed = false;
                    newRequest.noOfVoters = 0;

                    emit CreateRequestEvent(_description, _recipient, _value);
                }

            function voteRequest(uint _requestNo) public{
                require contributors[msg.sender] > 0, "You must be a contributor to vote!");
            Request storage thisRequest = requests[_requestNo];
            require(thisRequest.voters[msg.sender] == false, "You have already voted!");
            thisRequest.voters[msg.sender] = true;
            thisRequest.noOfVoters++;

            }

            function makePayment(uint _requestNo) public onlyAdmin{
                require(raisedAmount >= goal);
                Request storage thisRequest = requests[_requestNo];
                require(thisRequest.completed == false, "The request has been completed");
                require(thisRequest.noOfVoters > noOfContributors / 2);
            
            thisRequest.recipient.transfer(thisRequest.value);
            thisRequest.completed = true;

            emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
            }
}
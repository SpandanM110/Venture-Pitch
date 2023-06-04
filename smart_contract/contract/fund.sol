// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.14;

contract CrowdFunding{
    mapping(address => uint) public contributors;
    address public manager;
    uint public minimumContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;

    struct Request{
        string name;
        string description;
        string link;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }

    mapping (uint=>Request) public requests;
    uint public numRequests;

    constructor(uint _target, uint _deadline){
        target = _target;
        deadline = block.timestamp+_deadline;
        minimumContribution = 100 wei;
        manager = msg.sender;
    }

    function sendEth() public payable{
        require(block.timestamp < deadline,"Deadline has passed");
        require(msg.value >= minimumContribution,"Not Possible");
        if(contributors[msg.sender] == 0){
            noOfContributors++;
        }
        contributors[msg.sender]+=msg.value;
        raisedAmount+=msg.value;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    function refund() public {
        require(block.timestamp>deadline && raisedAmount<target,"You are not eligible");
        require(contributors[msg.sender]>0,"You are not contributor");
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0; 
    }

    modifier onlyManager(){
        require(msg.sender == manager,"You are not manager to request");
        _;
    }

    function createRequest(string memory _name, string memory _description, string memory _link, address payable _receipent,uint _value) public onlyManager{
        Request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.name = _name;
        newRequest.description = _description;
        newRequest.link = _link;
        newRequest.recipient = _receipent;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    } 

    function voteRequest(uint _requestNo) public{
        require(contributors[msg.sender]>0,"You must be a contributor");
        Request storage thisRequest=requests[_requestNo];
        require(thisRequest.voters[msg.sender]==false,"You have already voted");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyManager{
        require(raisedAmount>=target,"Target Not met");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false,"The request is fulfilled");
        require(thisRequest.noOfVoters>noOfContributors/2,"Half of the contributors have not voted for request");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
        thisRequest.value = 0;
    }
}
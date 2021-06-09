pragma solidity >=0.7.0 <0.9.0;

contract Escrow {

    // VARIABLES
    enum State { Not_Initiated, Awaiting_Payment, Awaiting_Delivery, Complete }

    State public currState;

    bool public isGrantreceived;
    bool public isGrantapproved;

    unit public price;

    address public grantr;
    address payable public grantee;


    // MODIFIERS

    modifier onlygrantr() {
        require(msg.sender == grantr, "only grantr can call this function");
        _;
    }

    modifier escrowNotStarted() {
        require(currState == state.Not_Initiated);
        _;
    }



    // FUNCTIONS

    constructor(address _grantr, address payable _grantee, uint _price){
        grantr = _grantr;
        grantee = _grantee;
        price = _price * (1 ether);
    }

    function initContract() escrowNotStarted public {
        if(msg.sender == grantr) {
            isGrantreceived = true;
        }

        if(msg.sender == grantee) {
            isGrantapproved = true;
        }

        if(isGrantreceived && isGrantapproved) {
            currState = state.Awaiting_Payment;
        }

    }

    function deposit() onlygrantr public payable {
        require(currState == state.Awaiting_Payment, "Already Paid");
        require(msg.value == price, "Wrong deposit amount");
        currState = state.Awaiting_Delivery;

    }

    function confirmDelivery() onlygrantr payable public {
        require(currState == state.Awaiting_Delivery, "Cannot Confirm Delivery");
        seller.transfer(price);
        currState = State.Complete;
    }

    function withdraw() onlygrantr payable public {
        require(currState == state.Awaiting_Delivery, "Cannot Withdraw at this Stage");
        payable(msg.sender).transfer(price);
        currState = State.Complete;
    }

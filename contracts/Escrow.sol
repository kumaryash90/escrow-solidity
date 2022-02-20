// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Escrow {
    struct Payment {
        uint amount;
        address arbiter;
        address depositor;
        address beneficiary;
	    bool isApproved;
        bool isUnlocked;
        bool isActive;
    }

    uint public id;
    mapping(uint=>Payment) public payments;

    event Created(uint);
	event Approved(uint);
    event Unlocked(uint);
    event Depositor_Withdraw(uint);
    event Beneficiary_Withdraw(uint);

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function createPayment(address _arbiter, address _beneficiary) external payable {
        require(msg.sender != _arbiter, "depositor same as arbiter");
        require(msg.sender != _beneficiary, "depositor same as beneficiary");
        require(_arbiter != _beneficiary, "arbiter same as beneficiary");
        require(msg.value >= 0.01 ether, "invalid amount");

        Payment memory payment = Payment({
            amount: msg.value,
            arbiter: _arbiter,
            depositor: msg.sender,
            beneficiary: _beneficiary,
            isApproved: false,
            isUnlocked: false,
            isActive: true
        });
        uint _id = id++;
        payments[_id] = payment;
        emit Created(_id);
    }

	function approvePayment(uint _id) external {
        Payment storage payment = payments[_id];
		require(msg.sender == payment.arbiter, "not arbiter");
        require(!payment.isApproved && !payment.isUnlocked, "either already approved or unlocked");
        payment.isApproved = true;
        emit Approved(_id);
	}

    function unlockPayment(uint _id) external {
        Payment storage payment = payments[_id];
		require(msg.sender == payment.arbiter, "not arbiter");
        require(payment.isActive == true, "payment not active");
        require(!payment.isApproved && !payment.isUnlocked, "either already approved or unlocked");
        payment.isUnlocked = true;
        emit Unlocked(_id);
	}

    function withdrawBeneficiary(uint _id) external {
        Payment storage payment = payments[_id];
        require(msg.sender == payment.beneficiary, "not beneficiary");
        require(payment.isActive == true, "payment not active");
        require(payment.isApproved == true, "payment not approved");
        uint _amount = payment.amount;
        payment.amount = 0;
        payment.isActive = false;
        emit Beneficiary_Withdraw(_id);
        payable(msg.sender).transfer(_amount);
    }

    function withdrawDepositor(uint _id) external {
        Payment storage payment = payments[_id];
        require(msg.sender == payment.depositor, "not depositor");
        require(payment.isActive == true, "payment not active");
        require(payment.isUnlocked == true, "payment not unlocked");
        uint _amount = payment.amount;
        payment.isActive = false;
        emit Depositor_Withdraw(_id);
        payable(msg.sender).transfer(_amount);
    }
}
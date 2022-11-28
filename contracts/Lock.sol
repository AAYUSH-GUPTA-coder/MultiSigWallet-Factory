// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract MultiSigWallet {
    // deposit/send the amount to the reciever
    event Deposit(address indexed sender, uint amount);
    // submit when one user submit a transcation and waiting for other stake holders to vote, yes or no
    event Submit(uint indexed txId);
    // Other owners when approve the transcation
    event Approve(address indexed owner, uint indexed txId);
    // once the transcation is approved, they can also revoke the transcation
    event Revoke(address indeved owner, uint indexed txId);
    // once the sufficient amount of approval, then the contract can be executed
    event Execute(uint indexed txId);

    struct Transcation {
        address to;
        uint value;
        bytes data;
        bool executed;
    }


    address[] public owners;
    mapping (address => bool) public isOwner;
    uint public required;

    Transcation[] public transcations;
    // mapping(txId => mapping(address_of_owner => yes/no)) public approve;
    mapping(uint => mapping(address => bool)) public approve

    constructor(address[] memory _owners, uint _required){
        rq
    }
}

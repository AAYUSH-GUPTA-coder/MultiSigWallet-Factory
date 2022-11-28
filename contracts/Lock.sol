// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract MultiSigWallet {
    // recive crypto in wallet
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

    // array of owner address (state variable)
    address[] public owners;
    // mapping to check is this address, a onwer in multiSig wallet
    mapping (address => bool) public isOwner;
    // number of votes required to transcation to pass
    uint public required;

    // array of transcation
    Transcation[] public transcations;
    // mapping(txId => mapping(address_of_owner => yes/no)) public approve;
    mapping(uint => mapping(address => bool)) public approve

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    /**
     * @dev contructor
     * @param array of owner addresses, no of votes required
     */
    constructor(address[] memory _owners, uint _required){
        require(_owners.length > 0, "onwers required");
        require(_required > 0 && _required <= _owners.length, "invalid required");

        for(uint i; i< _owners.length; i++){
            address owner = _owners[i];
            require(onwer != address(0), "invalid owner!");
            require(!isOwner[owner], "owner is not unique");

            isOwner[onwer] = true;
            owners.push(onwer);
        }

        required = _required;
    }

    /**
     * @dev submit the transcation
     * @param _to: address of reciver
     * _value: amount to send
     * _data: any data you want to send
     */
    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner{
        transcations.push(Transcation({
            to:_to,
            value:_value,
            data:_data
            executed:false
        }));
        emit Submit(transcation.length - 1);
    }

    function approve(uint _txId)

    receive() external payable {
        emit Deposit(msg.sender, msg.value)
    }


}

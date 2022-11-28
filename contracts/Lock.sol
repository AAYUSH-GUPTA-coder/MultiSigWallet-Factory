// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract MultiSigWallet {
    // recive crypto in wallet
    event Deposit(address indexed sender, uint amount);
    // submit when one user submit a transaction and waiting for other stake holders to vote, yes or no
    event Submit(uint indexed txId);
    // Other owners when approve the transaction
    event Approve(address indexed owner, uint indexed txId);
    // once the transaction is approved, they can also revoke the transaction
    event Revoke(address indexed owner, uint indexed txId);
    // once the sufficient amount of approval, then the contract can be executed
    event Execute(uint indexed txId);

    struct transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    // array of owner address (state variable)
    address[] public owners;
    // mapping to check is this address, a onwer in multiSig wallet
    mapping (address => bool) public isOwner;
    // number of votes required to transaction to pass
    uint public required;

    // array of transaction
    transaction[] public transactions;
    // mapping(txId => mapping(address_of_owner => yes/no)) public approve;
    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint _txId){
        require(_txId < transactions.length, "tx does not exist");
        _;
    }

    modifier notApproved(uint _txId){
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }

    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed, "tx already executed");
        _;
    }

    /**
     * @dev contructor
     * @param _owners: array of owner addresses,_required: no of votes required
     */
    constructor(address[] memory _owners, uint _required){
        require(_owners.length > 0, "onwers required");
        require(_required > 0 && _required <= _owners.length, "invalid required");

        for(uint i; i< _owners.length; i++){
            address owner = _owners[i];
            require(owner != address(0), "invalid owner!");
            require(!isOwner[owner], "owner is not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    /**
     * @dev submit the transaction
     * @param _to: address of reciver
     * _value: amount to send
     * _data: any data you want to send
     */
    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner{
        transactions.push(transaction({
            to:_to,
            value:_value,
            data:_data,
            executed:false
        }));
        emit Submit(transactions.length - 1);
    }

    /**
     * @dev function to allow onwers to approve transcation 
     */
    function approve(uint _txId) external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId){
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender , _txId);
    }

    /**
     * @dev function to get count how many voted for approval
     * @param _txId : transcation ID
     */

    function _getApprovalCount(uint _txId) private view returns(uint count){
        for(uint i; i< owners.length; i++){
            if(approved[_txId][owners[i]]){
                count += 1;
            }
        }
    }

    /**
     * @dev function to execute the transcation
     * @param _txId : transcation ID
     */
    function execute(uint _txId) external txExists(_txId) notExecuted(_txId) {
        require(_getApprovalCount(_txId) >= required, "not enough approvals");
        transaction storage transaction1 = transactions[_txId];
        transaction1.executed = true;
        (bool success, ) = transaction1.to.call{value: transaction1.value}(transaction1.data);
        require(success, "tx failed");
        emit Execute(_txId);
    }

    /**
     * @dev function to execute revoke. Allow user to revoke approval if she earlier approve the transaction
     * @param _txId : transcation ID
     */
    function revoke(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId){
        require(approved[_txId][msg.sender], "tx not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}

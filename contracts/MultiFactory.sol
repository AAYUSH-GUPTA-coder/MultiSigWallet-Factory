// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./MultiSigWallet.sol";

contract MultiFactory{
    // factory contract onwer
    address private immutable multiSigFactoryOwner;

    // struct to store all the data of MultiSigWallet and MultiFactory contract
    struct multiFactoryStruct {
        address[] onwers;
        uint required;
        address multiSigFactoryOwner;
    }

    // searching the struct data of MultiSigWallet and MultiSigWallet factory using owner address
    mapping(address => multiFactoryStruct) public allMultiSigWallet;

    // number of MultiSigWallet created
    uint256 public numOfMultiSigWallet;

    /**
     * @dev constructor to get the owner address of this contract factory
     */
    constructor(address _multiSigFactoryOwner) {
        multiSigFactoryOwner = _multiSigFactoryOwner;
    }

    /**
     * @dev function to create the contract MultiSigWallet
     */
    function createMultiSigWallet(address[] _onwers, uint _required) public {
        // Create a new Wallet contract
        MultiSigWallet multiSigWallet =  new MultiSigWallet(
            _onwers,
            _required
        );
        // Increment the number of MultiSigWallet
        numOfMultiSigWallet++;

        // Add the new trust contract to the mapping
        
    }


}
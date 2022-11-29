const { ethers } = require("hardhat");

async function main() {
  /*
  A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
  so multiFactoryContract here is a factory for instances of our TrustFactory contract.
  */
  const multiFactoryContract = await ethers.getContractFactory("MultiFactory");

  // here we deploy the contract
  const deployedMultiFactoryContract = await multiFactoryContract.deploy(
    "0x4E476F7FB84c785557cDECdbf8CADEbE8EA57C37"
  );

  // Wait for it to finish deploying
  await deployedMultiFactoryContract.deployed();

  // print the address of the deployed contract
  console.log(
    "TrustFactory Contract Address:",
    deployedMultiFactoryContract.address
  );
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

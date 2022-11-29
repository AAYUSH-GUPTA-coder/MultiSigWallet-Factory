require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();
const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const { task } = require("hardhat/config");

const { API_URL_GOERLI, API_URL_MUMBAI, API_URL_FEVM, PRIVATE_KEY } =
  process.env;

task(
  "account",
  "returns nonce and balance for specified address on multiple networks"
)
  .addParam("address")
  .setAction(async (address) => {
    const web3Goerli = createAlchemyWeb3(API_URL_GOERLI);
    const web3Mumbai = createAlchemyWeb3(API_URL_MUMBAI);
    const web3FEVM = createAlchemyWeb3(API_URL_FEVM);

    const networkIDArr = [
      "Ethereum Goerli:",
      "Polygon  Mumbai:",
      "FEVM Wallaby",
    ];
    const providerArr = [web3Goerli, web3Mumbai, web3FEVM];
    const resultArr = [];

    for (let i = 0; i < providerArr.length; i++) {
      const nonce = await providerArr[i].eth.getTransactionCount(
        address.address,
        "latest"
      );
      const balance = await providerArr[i].eth.getBalance(address.address);
      resultArr.push([
        networkIDArr[i],
        nonce,
        parseFloat(providerArr[i].utils.fromWei(balance, "ether")).toFixed(0.1) +
          "ETH",
      ]);
    }
    resultArr.unshift(["  |NETWORK|   |NONCE|   |BALANCE|  "]);
    console.log(resultArr);
  });

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    hardhat: {},
    goerli: {
      url: API_URL_GOERLI,
      accounts: [PRIVATE_KEY],
    },
    mumbai: {
      url: API_URL_MUMBAI,
      accounts: [PRIVATE_KEY],
    },
    wallaby: {
      url: "https://wallaby.node.glif.io/rpc/v0",
      accounts: [PRIVATE_KEY],
    },
  },
};

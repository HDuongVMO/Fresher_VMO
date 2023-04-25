require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();
/** @type import('hardhat/config').HardhatUserConfig */
const { API_URL, PRIV_KEY, API_KEY } = process.env;
module.exports = {
  solidity: "0.8.18",
  networks: {
    mumbai: {
      url: API_URL,
      accounts: [`0x${PRIV_KEY}`]
    }
  },
  etherscan: {
    apiKey: API_KEY
  }
};

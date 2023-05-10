import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config({path: __dirname + "/.env"})
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    mumbai: {
      url: `https://rpc-mumbai.maticvigil.com`,
      accounts: [`0x${process.env.PRIV_KEY}`]
    }
  },
  etherscan: {
    apiKey: process.env.API_KEY
  }
};

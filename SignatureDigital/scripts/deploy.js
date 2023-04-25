
const hre = require("hardhat");

async function main() {

  const VerifySignature = await hre.ethers.getContractFactory("VerifySignature");
  const verifySignature = await VerifySignature.deploy();

  await verifySignature.deployed();

  console.log(
    `Contract Address: ${verifySignature.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
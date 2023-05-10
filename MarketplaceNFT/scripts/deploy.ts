import { ethers, hardhatArguments } from 'hardhat';
import * as Config from './config';

async function main() {
  await Config.initConfig();
  const network = hardhatArguments.network ? hardhatArguments.network : 'dev';
  const [deployer] = await ethers.getSigners();
  console.log('deploy from address: ', deployer.address);
  await Config.updateConfig();

  const SCI = await ethers.getContractFactory("SCI");
  const sci = await SCI.deploy();
  console.log('SCI address: ', sci.address);
  Config.setConfig(network + '.SCI', sci.address);

  const Vault = await ethers.getContractFactory("Vault");
  const vault = await Vault.deploy();
  console.log('Vault address: ', vault.address);
  Config.setConfig(network + '.Vault', vault.address);

  const NFT = await ethers.getContractFactory("NFT");
  const nft = await NFT.deploy();
  console.log('NFT address: ', nft.address);
  Config.setConfig(network + '.NFT', nft.address);

  const Market = await ethers.getContractFactory("Market");
  const market = await Market.deploy();
  console.log('Market address: ', market.address);
  Config.setConfig(network + '.Market', market.address);

  const Auction = await ethers.getContractFactory("Auction");
  const auction = await Auction.deploy("0xdE601068440bBba2e9214561315926e6e5CD2634", "0x229ECD71307465208Dc97700cA238b249cEcd6E2");
  console.log('Auction address: ', auction.address);
  Config.setConfig(network + '.Auction', auction.address);

  await Config.updateConfig();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

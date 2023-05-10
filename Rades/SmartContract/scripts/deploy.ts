import { ethers, hardhatArguments } from 'hardhat';
import * as Config from './config';

async function main() {
    await Config.initConfig();
    const network = hardhatArguments.network ? hardhatArguments.network : 'dev';
    const [deployer] = await ethers.getSigners();
    console.log('deploy from address: ', deployer.address);

    // const RadesToken = await ethers.getContractFactory("RadesToken");
    // const radesToken = await RadesToken.deploy();
    // console.log('Rades address: ', radesToken.address);
    // Config.setConfig(network + '.RadesToken', radesToken.address);

    // const RadesNFT = await ethers.getContractFactory("RadesNFT");
    // const radesNFT = await RadesNFT.deploy();
    // console.log('Rades address: ', radesNFT.address);
    // Config.setConfig(network + '.RadesNFT', radesNFT.address);

    const RadesBid = await ethers.getContractFactory("RadesBid");
    const radesBid = await RadesBid.deploy();
    console.log('Rades address: ', radesBid.address);
    Config.setConfig(network + '.RadesBid', radesBid.address);

    await Config.updateConfig();
}

main().then(() => process.exit(0))
    .catch(err => {
        console.error(err);
        process.exit(1);
});
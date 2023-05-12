import { ethers, hardhatArguments } from 'hardhat';
import * as Config from './config';

async function main() {
    await Config.initConfig();
    const network = hardhatArguments.network ? hardhatArguments.network : 'dev';
    const [deployer] = await ethers.getSigners();
    console.log('deploy from address: ', deployer.address);

    const RadesToken = await ethers.getContractFactory("RadesToken");
    const radesToken = await RadesToken.deploy();
    console.log('RadesToken address: ', radesToken.address);
    Config.setConfig(network + '.RadesToken', radesToken.address);

    const RadesNFT = await ethers.getContractFactory("RadesNFT");
    const radesNFT = await RadesNFT.deploy();
    console.log('RadesNFT address: ', radesNFT.address);
    Config.setConfig(network + '.RadesNFT', radesNFT.address);

    const RadesBid = await ethers.getContractFactory("RadesBid");
    const radesBid = await RadesBid.deploy();
    console.log('RadesBid address: ', radesBid.address);
    Config.setConfig(network + '.RadesBid', radesBid.address);

    const RadesRare = await ethers.getContractFactory("RadesRare");
    const radesRare = await RadesRare.deploy();
    console.log('RadesRare address: ', radesRare.address);
    Config.setConfig(network + '.RadesRare', radesRare.address);

    const RadesMarketplace = await ethers.getContractFactory("RadesMarketplace");
    const radesMarketplace = await RadesMarketplace.deploy(radesToken.address
        ,radesBid.address,radesNFT.address,radesRare.address);
    console.log('RadesMarketplace address: ', radesMarketplace.address);
    Config.setConfig(network + '.RadesMarketplace', radesMarketplace.address);

    await Config.updateConfig();
}

main().then(() => process.exit(0))
    .catch(err => {
        console.error(err);
        process.exit(1);
});
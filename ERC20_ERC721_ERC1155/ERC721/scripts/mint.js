// scripts/mint.js
const { ethers } = require("hardhat");

async function main() {
    console.log('Getting the choco hero contract...\n');
    const contractAddress = '0xdb6F25294515a802eF14af6096c6e89717347350';
    const chocoHero = await ethers.getContractAt('ChocoHero', contractAddress);
    const signers = await ethers.getSigners();
    const contractOwner = signers[0].address;

    // Mint new NFTs from the collection using custom function mintCollectionNFT()
    console.log(`Minting initial NFT collection to ${contractOwner}...`)
    const initialMintCount = 10;
    for (let i = 1; i <= initialMintCount; i++) {
        let tx = await chocoHero.mintCollectionNFT(signers[0].address, i.toString());
        await tx.wait(); // wait for this tx to finish to avoid nonce issues
        console.log(`NFT ${i} minted to ${contractOwner}`);
    }

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });
const {ethers} = require('ethers');

require('dotenv').config();

const API_URL = process.env.API_URL;
const PRIV_KEY = process.env.PRIV_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;

const abi = [{"inputs":[{"internalType":"address","name":"_signer","type":"address"},{"internalType":"bytes32","name":"_ethSignedMessageHash","type":"bytes32"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"},{"internalType":"uint8","name":"v","type":"uint8"}],"name":"verify","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"pure","type":"function"}];

const provider = new ethers.providers.JsonRpcProvider(API_URL);

const signer = new ethers.Wallet(PRIV_KEY, provider);

const contractInstance = new ethers.Contract(CONTRACT_ADDRESS, abi, signer);

const Message = async() => {
    let message = await contractInstance.getMessage();
    console.log("Old message is: " + message);
    let msg = "Hello again";
    let tx = await contractInstance.update(msg);
    await tx.wait();
    let newmessage = await contractInstance.getMessage();
    console.log("New message is " + newmessage);
}

Message();
import * as bip39 from "bip39";
import * as ed25519 from "ed25519-hd-key";
import * as TaquitoUtils from "@taquito/utils";
import { InMemorySigner } from "@taquito/signer";
import { Keypair } from "@solana/web3.js";
import * as base58  from 'base58-js';
import { ethers } from "ethers";

const mnemonic = bip39.generateMnemonic(128);

const index = 0;

const ethereumGenKey = async (mnemonic, index) => {
  const derivePath = `m/44'/60'/0'/0/${index}`;
  const seed = await bip39.mnemonicToSeed(mnemonic);
  const hdWallet = ethers.utils.HDNode.fromSeed(seed);
  const wallet = hdWallet.derivePath(derivePath);
  const privateKey = wallet.privateKey;
  const publicKey = wallet.publicKey;
  const address = ethers.utils.computeAddress(publicKey);

  return {
    address,
    privateKey,
    publicKey,
  };
};


const solanaGenKey = async (mnemonic, index) => {
  const derivePath = `m/44'/501'/${index}'/0'`;
  const seed = await bip39.mnemonicToSeed(mnemonic);
  const derivedSeed = ed25519.derivePath(derivePath, seed.toString("hex")).key;
  const keypair = Keypair.fromSeed(derivedSeed);
  const publicKey = keypair.publicKey.toString();

  const address = publicKey;
  const privateKey = base58.binary_to_base58(keypair.secretKey);
  return {
    address,
    privateKey,
  };
};



const tezosGenKey = async (mnemonic, index) => {
  const TEZOS_BIP44_COINTYPE = 1729;
  const derivePath = `m/44'/${TEZOS_BIP44_COINTYPE}'/${index}'/0'`;
  const seed = bip39.mnemonicToSeedSync(mnemonic);
  const { key } = ed25519.derivePath(derivePath, seed.toString("hex"));
  const accPrivateKey = TaquitoUtils.b58cencode(
    key.slice(0, 32),
    TaquitoUtils.prefix.edsk2
  );

  const signer = await InMemorySigner.fromSecretKey(accPrivateKey);
  const [accPublicKey, accPublicKeyHash] = await Promise.all([
    signer.publicKey(),
    signer.publicKeyHash(),
  ]);
  return {
    privateKey: accPrivateKey,
    publicKey: accPublicKey,
    address: accPublicKeyHash,
  };
};


ethereumGenKey(mnemonic, index).then(console.log);

solanaGenKey(mnemonic, index).then(console.log);

tezosGenKey(mnemonic, index).then(console.log);



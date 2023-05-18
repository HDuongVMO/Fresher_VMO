export type AddressType  = {
    80001: string;
  }
  
  export enum CHAIN_ID {
    TESTNET = 80001,
  }
  
  export default function getChainIdFromEnv(): number {
    const env = process.env.NEXT_PUBLIC_CHAIN_ID;
    if (!env) { return 80001;}
    return parseInt(env);
  }
  
  
  export const getRPC = () => {
    return process.env.NEXT_PUBLIC_RPC_TESTNET;
  }

  export const SMART_ADDRESS = {
    RADES_ICO: {80001: '0x384f1b195C64eFDbc4CfeAd57c4aEfBc61b858A0'},
    USDT: {80001: '0xbdc740051c68E8720BF6D35B6Ef17e94c20C0E5E'},
    RADES_NFT: {80001: '0xc8f1FeA7B1d3EeCB8B3540e30B6Bce817169CF4a'},
    RADES_MARKETPLACE: {80001: '0x538D15Cd66a2364E754E84e45A569DDaF90E0789'} 
  }
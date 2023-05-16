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
    RADES_ICO: {80001: '0xd531Aa042f7a93be3e02f383DC9b9521147BE15b'},
    USDT: {80001: '0xbdc740051c68E8720BF6D35B6Ef17e94c20C0E5E'}  
  }
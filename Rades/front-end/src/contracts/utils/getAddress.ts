import getChainIdFromEnv, { AddressType, SMART_ADDRESS } from "./common";

const getAddress = (address: AddressType) => {
  const CHAIN_ID = getChainIdFromEnv() as keyof AddressType ;
  return address[CHAIN_ID]
};

export const getRadesICOAddress =()=> getAddress(SMART_ADDRESS.RADES_ICO);
export const getUsdtAddress =()=> getAddress(SMART_ADDRESS.USDT);
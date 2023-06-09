declare var window: any;
import { ethers } from "ethers";
import store from "../reduxs/store";
import { generateContract, setProvider } from "@/reduxs/accounts/account.reducers";

export const connectToMetamask = async () => {
  if (window.ethereum) {
    const provider = new ethers.providers.Web3Provider(window.ethereum, "any");
    await provider.send("eth_requestAccounts", []);
    store.dispatch(setProvider(provider));
    await store.dispatch(generateContract(provider));
  }
};
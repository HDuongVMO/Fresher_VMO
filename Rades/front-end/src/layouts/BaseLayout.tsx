import Sidebar from "@/view/Sidebar/Sidebar";
declare var window: any;
import { ConnectWallet, WalletInfo } from "@/components";
import {
  setWalletInfo,
  setWeb3Provider,
} from "@/reduxs/accounts/account.slices";
import { useAppDispatch, useAppSelector } from "@/reduxs/hooks";
import { Box, Flex, Heading, Spacer, Text } from "@chakra-ui/react";
import { ethers } from "ethers";
import Link from "next/link";
import { useRouter } from "next/router";
import React, { ReactNode } from "react";

interface IProps {
  children: ReactNode;
}

export default function BaseLayout({ children }: IProps) {
  const router = useRouter();
  console.log(router.pathname);

  const dispatch = useAppDispatch();
  const { wallet } = useAppSelector((state) => state.account);

  const onConnectMetamask = async () => {
    if (window.ethereum) {
      const provider = new ethers.providers.Web3Provider(
        window.ethereum,
        undefined
      );
      await provider.send("eth_requestAccounts", []);
      const signer = provider.getSigner();
      const address = await signer.getAddress();
      const bigBalance = await signer.getBalance();
      const maticBalance = Number.parseFloat(
        ethers.utils.formatEther(bigBalance)
      );
      dispatch(setWalletInfo({ address, matic: maticBalance }));
      dispatch(setWeb3Provider(provider));
    }
  };
  return (
    <Flex className="layout"
    >
      <Sidebar />
      {children}
      <Spacer />
      <Flex margin="20px">
        {!wallet && <ConnectWallet onClick={onConnectMetamask} />}
        {wallet && (
          <WalletInfo address={wallet?.address} amount={wallet?.matic || 0} />
        )}
      </Flex>
    </Flex>
  );
}

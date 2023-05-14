declare var window: any;
import React from "react";
import { Box, Button, Flex, Heading, SimpleGrid, Spacer } from "@chakra-ui/react";
import Sidebar from "@/view/Sidebar/Sidebar";
import { ConnectWallet, WalletInfo } from "@/components";
import { ethers } from "ethers";
import { IRate, IWalletInfo, TOKEN } from "@/_types_";
import { packages } from "@/constants";
import InvestCard from "./components/InvestCard";

function InvestView() {
  const [wallet, setWallet] = React.useState<IWalletInfo>();
  const [rate, setRate] = React.useState<IRate>({maticRate: 0, usdtRate: 0});
  const [isProcessing, setIsProcessing] = React.useState<boolean>(false);
  const [pak, setPak] = React.useState<IPackage>();

  const [web3Provider, setWeb3Provider] =
    React.useState<ethers.providers.Web3Provider>();

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
      setWallet({ address, matic: maticBalance });
      setWeb3Provider(provider);
    }
  };

  const handleBuyIco = async() => {}



  return (
    <Flex
      width="95%"
      height="95%"
      flexDirection="column"
      margin="20px 20px auto"
    >
      <Flex>
        <Spacer />
        {!wallet && <ConnectWallet onClick={onConnectMetamask} />}
        {wallet && (
          <WalletInfo address={wallet?.address} amount={wallet?.matic || 0} />
        )}
      </Flex>
      <SimpleGrid columns={{ base: 1, lg: 3 }} mt="50px" spacingY="20px">
        {packages.map((pk, index) => (
          <InvestCard
            pak={pk}
            key={String(index)}
            isBuying={isProcessing && pak?.key === pk.key}
            rate={pk.token === TOKEN.MATIC ? rate.maticRate : rate.usdtRate}
            walletInfo={wallet}
            onBuy={() => handleBuyIco(pk)}
          />
        ))}
      </SimpleGrid>
    </Flex>
  );
}

export default InvestView;

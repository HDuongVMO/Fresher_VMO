declare var window: any;
import React from "react";
import { Box, Button, Flex, Heading, SimpleGrid, Spacer, useDisclosure } from "@chakra-ui/react";
import Sidebar from "@/view/Sidebar/Sidebar";
import { ConnectWallet, WalletInfo, SuccessModal } from "@/components";
import { ethers } from "ethers";
import { IPackage, IRate, IWalletInfo, TOKEN } from "@/_types_";
import { packages } from "@/constants";
import InvestCard from "./components/InvestCard";
import RadesICOContract from "@/contracts/RadesICO";
import UsdtContract from "@/contracts/USDT";

function InvestView() {
  const [wallet, setWallet] = React.useState<IWalletInfo>();
  const [rate, setRate] = React.useState<IRate>({maticRate: 0, usdtRate: 0});
  const [isProcessing, setIsProcessing] = React.useState<boolean>(false);
  const [pak, setPak] = React.useState<IPackage>();
  const [txHash, setTxHash] = React.useState<string>();
  const {isOpen, onClose, onOpen} = useDisclosure();

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

  const getRate = React.useCallback(async() => {
    const ICOContract = new RadesICOContract();
    const maticRate =  await ICOContract.getMaticRate();
    const usdtRate = await ICOContract.getUsdtRate();  
    setRate({maticRate, usdtRate});

  }, []);

  React.useEffect(() => {
    getRate();
  }, [getRate]);

  const handleBuyIco = async(pk: IPackage) => {
    if (!web3Provider) return;
      setPak(pk);
      setIsProcessing(true);
      let hash ='';
      const ICOContract = new RadesICOContract(web3Provider);
      if (pk.token === TOKEN.USDT) {
        const usdtContract = new UsdtContract(web3Provider);
        await usdtContract.approve(ICOContract._contractAddress, pk.amount / rate.maticRate);
        hash = await ICOContract.buyTokenByUSDT(pk.amount);
      } else {
        hash = await ICOContract.buyTokenByMATIC(pk.amount);
      }
      setTxHash(hash);
      onOpen();
    try {

    } catch(er: any) {

    }
    setPak(undefined);
    setIsProcessing(false);
  }


  return (
    <Flex
      w="full"
      flexDirection="column"
      margin=" 20px 20px 23px 30px"
    >
      <SimpleGrid columns={{ base: 1, lg: 3 }} mt="40px" spacingY="20px" spacingX="50px">
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
      <SuccessModal
        isOpen={isOpen}
        onClose={onClose}
        hash={txHash}
        title="THANK YOU!!"
      />
    </Flex>
  );
}

export default InvestView;

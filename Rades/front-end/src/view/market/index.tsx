declare var window: any;
import { INftItem, IWalletInfo } from "@/_types_";
import RadesMarketplace from "@/contracts/RadesMarketplace";
import RadesNFT from "@/contracts/RadesNFT";
import { useAppSelector } from "@/reduxs/hooks";
import {
  Flex,
  SimpleGrid,
  Spacer,
  Tab,
  TabList,
  TabPanel,
  TabPanels,
  Tabs,
} from "@chakra-ui/react";
import React from "react";
import Nft from "./components/Nft";
import { ethers } from "ethers";
import { ConnectWallet, WalletInfo } from "@/components";

export default function MarketView() {
  const { web3Provider } = useAppSelector((state) => state.account);
  const [nfts, setNfts] = React.useState<INftItem[]>([]);
  const [nftsListed, setNftsListed] = React.useState<INftItem[]>([]);
  const [wallet, setWallet] = React.useState<IWalletInfo>();
  const [Web3Provider, setWeb3Provider] =
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

  const getListNft = React.useCallback(async () => {
    if (!web3Provider || !wallet) return;
    const radesNFT = new RadesNFT(web3Provider);
    const nfts = await radesNFT.getListNFT(wallet.address);
    setNfts(nfts.filter((p) => p.name));
    const radesMarketplace = new RadesMarketplace(web3Provider);
    const ids = await radesMarketplace.getNFTListedOnMarketplace();
    const listedNfts = await radesNFT.getNftInfo(ids);
    setNftsListed(listedNfts);
  }, [web3Provider, wallet]);
  React.useEffect(() => {
    getListNft();
  }, [getListNft]);
  return (
    <Flex w="full" margin="20px">
      <Tabs>
        <TabList borderBottomColor="#5A5A5A" borderBottomRadius={2} mx="15px">
          <Tab
            textTransform="uppercase"
            color="#5A5A5A"
            _selected={{ borderBottomColor: "white", color: "white" }}
          >
            ITEMS
          </Tab>
          <Tab
            textTransform="uppercase"
            color="#5A5A5A"
            _selected={{ borderBottomColor: "white", color: "white" }}
          >
            active listings
          </Tab>
        </TabList>
        <TabPanels>
          <TabPanel>
            <SimpleGrid w="full" columns={4} spacing={10}>
              {nfts.map((nft, index) => (
                <Nft
                  item={nft}
                  key={index}
                  index={index}
                  isAuction
                  isList
                  isTransfer
                  onAction={() => {}}
                />
              ))}
            </SimpleGrid>
          </TabPanel>

          <TabPanel>
            <SimpleGrid w="full" columns={4} spacing={10}>
              {nftsListed.map((nft, index) => (
                <Nft
                  item={nft}
                  key={index}
                  index={index}
                  isUnList
                  onAction={() => {}}
                />
              ))}
            </SimpleGrid>
          </TabPanel>
        </TabPanels>
      </Tabs>
      <Spacer />
      <Flex>
        {!wallet && <ConnectWallet onClick={onConnectMetamask} />}
        {wallet && (
          <WalletInfo address={wallet?.address} amount={wallet?.matic || 0} />
        )}
      </Flex>
    </Flex>
  );
}

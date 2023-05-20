import { ActionType, INftItem } from "@/_types_";
import RadesMarketplace from "@/contracts/RadesMarketplace";
import RadesNFT from "@/contracts/RadesNFT";
import { useAppSelector } from "@/reduxs/hooks";
import {
  Flex,
  SimpleGrid,
  Tab,
  TabList,
  TabPanel,
  TabPanels,
  Tabs,
  useBoolean,
  useDisclosure,
} from "@chakra-ui/react";
import React from "react";
import Nft from "./components/Nft";
import { ProcessingModal, SuccessModal } from "@/components";
import ListModal from "./components/ListModal";

export default function HomeView() {
  const { web3Provider, wallet } = useAppSelector((state) => state.account);
  const [nfts, setNfts] = React.useState<INftItem[]>([]);
  const [nftsListed, setNftsListed] = React.useState<INftItem[]>([]);

  const [nft, setNft] = React.useState<INftItem>();
  const [action, setAction] = React.useState<ActionType>();
  const [isProcessing, setIsProcessing] = useBoolean();
  const [isOpen, setIsOpen] = useBoolean();
  const [txHash, setTxHash] = React.useState<string>();
  const [isUnlist, setIsUnList] = useBoolean();

  const [modalType, setModalType] = React.useState<"LISTING" | "AUCTION">(
    "LISTING"
  );

  const {
    isOpen: isSuccess,
    onClose: onCloseSuccess,
    onOpen: onOpenSuccess,
  } = useDisclosure();

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

  const selectAction = async (ac: ActionType, item: INftItem) => {
    if (!web3Provider) return;
    setNft(item);
    setAction(ac);
    setIsProcessing.off();
    switch (ac) {
      case "LIST":
      case "AUCTION": {
        setModalType(ac === "AUCTION" ? "AUCTION" : "LISTING");
        setIsOpen.on();
        break;
      }
      case "UNLIST": {
        setIsUnList.on();
        const marketContract = new RadesMarketplace(web3Provider);
        const tx = await marketContract.unListNft(item.id);
        setTxHash(tx);
        setAction(undefined);
        setNft(undefined);
        setIsUnList.off();
        onOpenSuccess();
        await getListNft();
        break;
      }
      default:
        break;
    }
  };

  const handleListNft = async (price: number, expireDate?: Date | null) => {
    if (!price || !web3Provider || !wallet || !nft) return;
    setIsProcessing.on();
    try {
      const radesNFT = new RadesNFT(web3Provider);
      let tx = "";
      if (modalType === "LISTING") {
        const radesMarketplace = new RadesMarketplace(web3Provider);
        await radesNFT.approve(radesMarketplace._contractAddress, nft.id);
        tx = await radesMarketplace.listNft(nft.id, price);
      }
      // else {
      //   if (!expireDate) return;
      //   const radesAuction = new RadesAuction(web3Provider);
      //   await radesNFT.approve(radesAuction._contractAddress, nft.id);
      //   const startTime = Math.round((new Date().getTime() / 1000)  + 60);
      //   tx = await radesAuction.createAuction(
      //     nft.id,
      //     price,
      //     startTime,
      //     Math.round(expireDate.getTime() / 1000) 
      //   );
      // }
      setTxHash(tx);
      onOpenSuccess();
      setAction(undefined);
      setNft(undefined);
      setIsOpen.off();
      await getListNft();
    } catch (er: any) {
      console.log(er);
      setIsProcessing.off();
    }
  };

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
            ACTIVE LISTINGS
          </Tab>
        </TabList>
        <TabPanels>
          <TabPanel>
            <SimpleGrid w="130%" columns={4} spacing={10}>
              {nfts.map((nft, index) => (
                <Nft
                  item={nft}
                  key={index}
                  index={index}
                  isAuction
                  isList
                  onAction={(a) => selectAction(a, nft)}
                />
              ))}
            </SimpleGrid>
          </TabPanel>

          <TabPanel>
            <SimpleGrid w="130%" columns={4} spacing={10}>
              {nftsListed.map((nft, index) => (
                <Nft
                  item={nft}
                  key={index}
                  index={index}
                  isUnList
                  onAction={(a) => selectAction(a, nft)}
                />
              ))}
            </SimpleGrid>
          </TabPanel>
        </TabPanels>
      </Tabs>
      <ProcessingModal isOpen={isUnlist} onClose={() => {}} />
      <ListModal
        type={modalType}
        isOpen={isOpen}
        nft={nft}
        isListing={isProcessing}
        onClose={() => setIsOpen.off()}
        onList={(amount, expireDate) => handleListNft(amount, expireDate)}
      />
      <SuccessModal
        hash={txHash}
        title="SUCCESS"
        isOpen={isSuccess}
        onClose={onCloseSuccess}
      />
    </Flex>
  );
}

import { INftItem } from "@/_types_";
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

export default function MarketView() {
  const { web3Provider, wallet } = useAppSelector((state) => state.account);
  const [ranfts, setNfts] = React.useState<INftItem[]>([]);
  const [nftsListed, setNftsListed] = React.useState<INftItem[]>([]);

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
            ACTIVE LISTINGS
          </Tab>
        </TabList>
        <TabPanels>
          <TabPanel>
            <SimpleGrid w="130%" columns={5} spacing={10}>
              {ranfts.map((nft, index) => (
                <Nft
                  item={nft}
                  key={index}
                  index={index}
                  isAuction
                  isList
                  isTransfer
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
                  
                />
              ))}
            </SimpleGrid>
          </TabPanel>
        </TabPanels>
      </Tabs>
    </Flex>
  );
}

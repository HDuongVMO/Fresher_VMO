import { logger } from '@constants';
import { Market, Synchronize } from '@schemas';
import cron from 'node-cron';
import { marketContract, web3 } from '.';

const globalVariable: any = global;

globalVariable.isSyncingGetDataFromSmartContract = false;
const onJobGetDataFromSmartContract = async () => {
  try {
    logger.info(
      'onJobGetDataFromSmartContract:' + globalVariable.isSyncingGetDataFromSmartContract,
    );
    if (globalVariable.isSyncingGetDataFromSmartContract) return;
    globalVariable.isSyncingGetDataFromSmartContract = true;
    const lastSynchronize = await Synchronize.findOne().sort({ last_block_number: -1 }).limit(1);
    const last_block_number = (lastSynchronize?.last_block_number || 0) + 1;

    if (!lastSynchronize?.last_block_number) {
      await Synchronize.create({
        last_block_number: 35774940,
      });
      globalVariable.isSyncingGetDataFromSmartContract = false;
      return;
    }
    const listTxHash: string[] = [];
    const last_block_number_onchain = Math.min(
      await web3.eth.getBlockNumber(),
      last_block_number + 100000,
    );
    logger.info(`Synchronizing from ${last_block_number} to ${last_block_number_onchain}`);
    await synchronizeMarket(last_block_number, last_block_number_onchain, listTxHash);
    if (listTxHash.length > 0) {
      await Synchronize.create({
        last_block_number: last_block_number_onchain,
        transactions: listTxHash,
      });
      logger.info(`Synchronized ${listTxHash.length} transactions`);
    } else {
      if (last_block_number_onchain - last_block_number > 500) {
        await Synchronize.create({
          last_block_number: last_block_number_onchain,
          transactions: [],
        });
      }
    }
  } catch (error: any) {
    logger.error(`onJobGetDataFromSmartContract: ${error.message}`);
  }
  globalVariable.isSyncingGetDataFromSmartContract = false;
};

const synchronizeMarket = async (
  last_block_number_sync: number,
  last_block_number_onchain: number,
  listTxHash: string[],
) => {
  const getPastEventsConfig = {
    fromBlock: last_block_number_sync,
    toBlock: last_block_number_onchain,
  };



  const eventListNFT = await marketContract.getPastEvents('ListNFT', getPastEventsConfig);
  logger.info(`Synchronizing ${eventListNFT.length} list events`);

  const eventUnlistNFT = await marketContract.getPastEvents('UnlistNFT', getPastEventsConfig);
  logger.info(`Synchronizing ${eventUnlistNFT.length} unlist events`);

  const eventBuyNFT = await marketContract.getPastEvents('BuyNFT', getPastEventsConfig);
  logger.info(`Synchronizing ${eventBuyNFT.length} buy events`);

  const event = [
    ...eventListNFT,
    ...eventUnlistNFT,
    ...eventBuyNFT,
  ];

  listTxHash.push(...eventListNFT.map(e => e.transactionHash));
  listTxHash.push(...eventListNFT.map(e => e.transactionHash));
  listTxHash.push(...eventBuyNFT.map(e => e.transactionHash));


  for (const listUpdate of event) {
    if (listUpdate.event == 'UnlistNFT') {
      try {
        await Market.findOneAndUpdate(
          { token_id: listUpdate.returnValues.tokenId },
          {
            owner: listUpdate.returnValues[2],
            is_list: true,
            priceFix: listUpdate.returnValues.price,
            updated_at: new Date(),
          },
          { upsert: true },
        );
      } catch (error: any) {
        logger.error(`Can not update listNFT: ${listUpdate.returnValues.tokenId}, error: ${error.message}`);
      }
    }

    else if (listUpdate.event == 'UnlistNFT') {
      try {
        await Market.findOneAndUpdate(
          { token_id: listUpdate.returnValues.tokenId },
          {
            owner: listUpdate.returnValues.newOwner,
            is_list: false,
            priceFix: 0,
            updated_at: new Date(),
          },
          { upsert: true },
        );
      } catch (error: any) {
        logger.error(`Can not update UnlistNFT: ${listUpdate.returnValues.tokenId}, error: ${error.message}`);
      }
    }
    else if (listUpdate.event == 'BuyNFT') {
      try {
        await Market.findOneAndUpdate(
          { token_id: listUpdate.returnValues._tokenId },
          {
            owner: listUpdate.returnValues.buyer,
            is_list: false,
            priceFix: 0,
            updated_at: new Date(),
          },
          { upsert: true },
        );
      } catch (error: any) {
        logger.error(`Can not update BuyNFT: ${listUpdate.returnValues.tokenId}, error: ${error.message}`);
      }
    }
  }
};
const startSynchronizeDataFromSmartContract = () => {
  cron.schedule('*/6 * * * * *', onJobGetDataFromSmartContract);
};

export { startSynchronizeDataFromSmartContract };
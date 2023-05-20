export interface IWalletInfo {
  address: string;
  matic: number;
}

export interface IRate {
  usdtRate: number;
  maticRate: number;
}

export enum TOKEN {
  MATIC = 'MATIC',
  USDT = 'USDT'
}

export interface IPackage {
  key: string;
  amount: number;
  icon: string;
  bg: string;
  token: TOKEN;
}

export interface IAttribute {
  trait_type: string;
  value: string | number;
}

export interface INftItem {
  id: number;
  name?: string;
  description?: string;
  image: string;
  attributes?: IAttribute[];
  //Listing
  price?: number;
  author?: string;  
}

export type ActionType = "LIST" | "UNLIST" | "AUCTION";

export interface IAuctionInfo extends  INftItem {
  auctionId: number;
  auctioneer: string;
  tokenId: number;
  initialPrice: number;
  previousBidder: string;
  lastBid: number;
  lastBidder: string;
  startTime: number;
  endTime: number;
  completed: boolean;
  active: boolean;
}
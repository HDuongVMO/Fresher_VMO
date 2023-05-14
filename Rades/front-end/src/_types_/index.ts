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
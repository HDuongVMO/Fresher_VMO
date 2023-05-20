import Head from "next/head";
import Image from "next/image";
import { Inter } from "next/font/google";
import type { NextPage } from 'next';
import BaseLayout from "@/layouts/BaseLayout";
import MarketView from "@/view/market";

const inter = Inter({ subsets: ["latin"] });

const Home: NextPage = () => {
  return (
      <MarketView />
  );
};

export default Home;

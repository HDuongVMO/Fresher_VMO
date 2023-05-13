import Head from "next/head";
import Image from "next/image";
import { Inter } from "next/font/google";
import styles from "@/styles/Home.module.css";
import InvestView from "@/view/invests";
import Sidebar from "@/view/Sidebar/Sidebar";
import { NextPage } from "next";
import BaseLayout from "@/layouts/BaseLayout";

const inter = Inter({ subsets: ["latin"] });

const Home: NextPage = () => {
  return (
    <BaseLayout>
      <InvestView />
    </BaseLayout>
  );
};

export default Home;

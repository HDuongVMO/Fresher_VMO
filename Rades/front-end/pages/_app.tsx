import SidebarProvider from "@/view/Sidebar/SidebarContext";
import "../styles/globals.css";
import type { AppProps } from "next/app";
import { ChakraProvider } from "@chakra-ui/react";
import theme from "../src/themes";

function App({ Component, pageProps }: AppProps) {
  return (
    <ChakraProvider theme={theme}>
      <SidebarProvider>
      <Component {...pageProps} />
    </SidebarProvider>
    </ChakraProvider>
  );
}

export default App;

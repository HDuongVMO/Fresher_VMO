import SidebarProvider from "@/view/Sidebar/SidebarContext";
import "../styles/globals.css";
import type { AppProps } from "next/app";
import { ChakraProvider } from "@chakra-ui/react";
import theme from "../src/themes";
import { Provider } from "react-redux";
import store from "@/reduxs/store";
import BaseLayout from "@/layouts/BaseLayout";

function App({ Component, pageProps }: AppProps) {
  return (
    <Provider store={store}>
      <ChakraProvider theme={theme}>
        <SidebarProvider>
          <BaseLayout>
            <Component {...pageProps} />
          </BaseLayout>
        </SidebarProvider>
      </ChakraProvider>
    </Provider>
  );
}

export default App;

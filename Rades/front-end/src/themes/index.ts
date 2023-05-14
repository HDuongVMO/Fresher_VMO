import { ChakraProvider, ThemeConfig, extendTheme, ComponentStyleConfig } from '@chakra-ui/react'

const config: ThemeConfig = {
  initialColorMode: 'dark',
  useSystemColorMode: false,
}

const Button: ComponentStyleConfig = {
  variants: {
    'primary': {
      bg: '#55638d',
      borderRadius: "8px",
      color: "#eee",
      fontWeight: 'bold',      
      padding: "25px 30px",
      border: "1px solid #55638d",
      fontSize: "15px",
    },  
    'outline': {      
      borderRadius: "5px",
      color: "#55638d",
      fontWeight: 'bold',      
      padding: "12px 36px",
      border: "1px solid #55638d !important", 
    },   
  }
}


const components = {
  Button,
}

const theme = extendTheme({
  config,
  components
});

export default theme;
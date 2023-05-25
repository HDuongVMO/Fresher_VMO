import { Button, HStack, Image, Text } from '@chakra-ui/react';
import React from 'react'
import { numberFormat, showSortAddress } from '../utils';

interface IProps {
  address?: string;
  amount: number;
}

export default function WalletInfo({address, amount}: IProps) {
  return (
    <Button variant="outline" ml="10px">
      <HStack>
        <Text>{showSortAddress(address)}</Text>
        <Image src="https://assets.coingecko.com/coins/images/4713/large/matic-token-icon.png?1624446912" w="25px" alt="matic" ml="20px" />        
        <Text>{numberFormat(amount)}</Text>
      </HStack>
    </Button>
  )
}
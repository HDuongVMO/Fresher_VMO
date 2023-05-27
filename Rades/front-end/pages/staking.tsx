import BaseLayout from '@/layouts/BaseLayout'
import StakingView from '@/view/staking'
import { Divider, Flex, Heading } from '@chakra-ui/react'
import React from 'react'

export default function Auction() {
  return (
    <Flex w="full" direction="column" margin="15px">
      <Heading color="#55638d">Staking</Heading>
      <Divider my="10px" />
      <StakingView />
     </Flex>
  )
}

import Sidebar from '@/view/Sidebar/Sidebar';
import { Flex } from '@chakra-ui/react';
import React, { ReactNode } from 'react'

interface Props {
    children: ReactNode | ReactNode[];
}

export default function BaseLayout({children}: Props) {
  return (
    <Flex className='layout'>
        <Sidebar />
        {children}</Flex>
  )
}

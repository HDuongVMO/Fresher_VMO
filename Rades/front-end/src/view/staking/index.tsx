import { Flex, SimpleGrid, Tab, TabList, TabPanel, TabPanels, Tabs } from '@chakra-ui/react'
import React from 'react'

function StakingView() {
  return (
    <Flex w="full" margin="20px">
      <Tabs>
        <TabList borderBottomColor="5A5A5A" borderBottomRadius={2} mx="15px">
          <Tab color="#5A5A5A"
            _selected={{ borderBottomColor: "white", color: "white" }}>
            STAKING
          </Tab>
          <Tab
            color="#5A5A5A"
            _selected={{ borderBottomColor: "white", color: "white" }}
          >
            MY STAKING
          </Tab>
        </TabList>
        <TabPanels>
          <TabPanel>
            <SimpleGrid>
              1
            </SimpleGrid>
          </TabPanel>
          <TabPanel>
            <SimpleGrid>
              2
            </SimpleGrid>
          </TabPanel>
        </TabPanels>
      </Tabs>
    </Flex>
  )
}

export default StakingView
import Sidebar from '@/view/Sidebar/Sidebar';
import React, { ReactNode } from 'react'

interface Props {
    children: ReactNode | ReactNode[];
}

export default function BaseLayout({children}: Props) {
  return (
    <div className='layout'>
        <Sidebar />
        {children}</div>
  )
}

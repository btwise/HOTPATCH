// battery
DefinitionBlock ("", "SSDT", 2, "hack", "BATT", 0)
{
    External(_SB, DeviceObj)
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(_SB.PCI0.LPCB.EC.HIID, FieldUnitObj)
    External(_SB.BATM, MutexObj)
    External(_SB.WAEC, MethodObj)
    External(_SB.PCI0.LPCB.EC.XFUD, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.XBCM, FieldUnitObj)
    External(BFUD, MethodObj)
    External(_SB.BASC, IntObj)
    
    Method (B1B2, 2, NotSerialized)
    {
        ShiftLeft (Arg1, 8, Local0)
        Or (Arg0, Local0, Local0)
        Return (Local0)
    }

    Method (B1B4, 4, NotSerialized)
    {
        Store (Arg3, Local0)
        Or (Arg2, ShiftLeft (Local0, 0x08), Local0)
        Or (Arg1, ShiftLeft (Local0, 0x08), Local0)
        Or (Arg0, ShiftLeft (Local0, 0x08), Local0)
        Return (Local0)
    }
    Scope(\_SB.PCI0.LPCB.EC)
    {
        Method (RE1B, 1, NotSerialized)
        {
            OperationRegion(ERAM, EmbeddedControl, Arg0, 1)
            Field(ERAM, ByteAcc, NoLock, Preserve) { BYTE, 8 }
            Return(BYTE)
        }
        Method (RECB, 2, Serialized)
        {
            ShiftRight(Arg1, 3, Arg1)
            Name(TEMP, Buffer(Arg1) { })
            Add(Arg0, Arg1, Arg1)
            Store(0, Local0)
            While (LLess(Arg0, Arg1))
            {
                Store(RE1B(Arg0), Index(TEMP, Local0))
                Increment(Arg0)
                Increment(Local0)
            }
            Return(TEMP)
        }
        OperationRegion (XRAM, SystemMemory, 0xFE700100, 0x0100)
        Field (XRAM, ByteAcc, NoLock, Preserve)
        {
            Offset (0xE0), 
            CRC0,8,CRC1,8,// XCRC,   16, //wxw
            CAC0,8,CAC1,8,// XCAC,   16, //wxw
            CVO0,8,CVO1,8,// XCVO,   16. //wxw
        }
        //Field (XRAM, ByteAcc, NoLock, Preserve)
        //{
        //    Offset (0xA0), 
        //    XAIF,   128, //wxw
        //}
        //
        OperationRegion (BRAM, EmbeddedControl, 0x00, 0xFF)
        Field (BRAM, ByteAcc, NoLock, Preserve)
        {    
            Offset (0xA2), 
            BFC0,8,BFC1,8,//   XBFC,   16,//wxw
        }            
        Field (BRAM, ByteAcc, NoLock, Preserve)
        {     
            Offset (0xA4), 
            BCC0,8,BCC1,8,//   XBCC,   16//wxw
        }
        Field (BRAM, ByteAcc, NoLock, Preserve)
        {
            Offset (0xA0), 
            BDC0,8,BDC1,8,//   XBDC,   16, //wxw
            BDV0,8,BDV1,8,//   XBDV,   16, //wxw 
            Offset (0xAA), 
            BSN0,8,BSN1,8,//   XBSN,   16  //wxw  
        }
        Field (BRAM, ByteAcc, NoLock, Preserve)
        {
            Offset (0xA0), 
            BCH0,8,BCH1,8,BCH2,8,BCH3,8 //XBCH,   32
        }
        //Field (XECR, ByteAcc, NoLock, Preserve)
        //{
        //    Offset (0xA0), 
        //    XBMN,   128//wxw
        //}
        //Field (XECR, ByteAcc, NoLock, Preserve)
        //{
        //    Offset (0xA0), 
        //    XBDN,   128//wxw
        //}
    }
    
    Scope(\_SB)
    {
        Name (ZBCM, Buffer (One)//wxw SBCM
        {
            0x00                                           
        })
        Name (ZBFC, Buffer (0x02)//wxw SBFC
        {
            0x00, 0x00                                     
        }) 
        Name (ZBDC, Buffer (0x02)//wxw SBDC
        {
            0x00, 0x00                                     
        })
        Name (ZBDV, Buffer (0x02)//wxw SBDV
        {
            0x00, 0x00                                     
        })
        Name (ZBSN, Buffer (0x02)//wxw SBSN
        {
            0x00, 0x00                                     
        })
        Name (ZBDN, Buffer (0x10)//wxw SBDN
        {
            /* 0000 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
        })
        Name (ZBCH, Buffer (0x04)//wxw SBCH
        {
            0x00, 0x00, 0x00, 0x00                         
        })
        Name (ZBMN, Buffer (0x10)//wxw SBMN
        {
            /* 0000 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 
        })
        
        Method (GBIF, 3, NotSerialized)
        {
            If (Arg2)
            {
                If (LNotEqual (BASC, Zero))
                {
                    Acquire (BATM, 0xFFFF)
                    Or (Arg0, One, ^PCI0.LPCB.EC.HIID)
                    WAEC ()
                    Store (^PCI0.LPCB.EC.XBCM, Local7)                      
                    Store (^PCI0.LPCB.EC.XBCM, ZBCM)//wxw SBCM
                    XOr (Local7, One, Index (Arg1, Zero))
                    Store (Arg0, ^PCI0.LPCB.EC.HIID)
                    WAEC ()
                    If (Local7)
                    {
                        Multiply (B1B2(^PCI0.LPCB.EC.BFC0,^PCI0.LPCB.EC.BFC1), 0x0A, Index (Arg1, 0x02))
                    }
                    Else
                    {
                        Store (B1B2(^PCI0.LPCB.EC.BFC0,^PCI0.LPCB.EC.BFC1), Index (Arg1, 0x02))
                    }

                    Store (B1B2(^PCI0.LPCB.EC.BFC0,^PCI0.LPCB.EC.BFC1), ZBFC)//wxw
                    Or (Arg0, 0x02, ^PCI0.LPCB.EC.HIID)
                    WAEC ()
                    If (Local7)
                    {
                        Multiply (B1B2(^PCI0.LPCB.EC.BDC0,^PCI0.LPCB.EC.BDC1), 0x0A, Local0)
                    }
                    Else
                    {
                        Store (B1B2(^PCI0.LPCB.EC.BDC0,^PCI0.LPCB.EC.BDC1), Local0)
                    }

                    Store (B1B2(^PCI0.LPCB.EC.BDC0,^PCI0.LPCB.EC.BDC1), ZBDC)//wxw SBDC
                    Store (Local0, Index (Arg1, One))
                    Divide (Local0, 0x14, Local1, Index (Arg1, 0x05))
                    Divide (Local0, 0x64, Local1, Index (Arg1, 0x06))
                        
                    Store (B1B2(^PCI0.LPCB.EC.BDV0,^PCI0.LPCB.EC.BDV1), Index (Arg1, 0x04))
                    Store (B1B2(^PCI0.LPCB.EC.BDV0,^PCI0.LPCB.EC.BDV1), ZBDV)//wxw SBDV
                        
                    Store (B1B2(^PCI0.LPCB.EC.BSN0,^PCI0.LPCB.EC.BSN1), Local0)
                    Store (B1B2(^PCI0.LPCB.EC.BSN0,^PCI0.LPCB.EC.BSN1), ZBSN)//wxw SBSN
                    Name (SERN, Buffer (0x06)
                    {
                        "     "
                    })
                    Store (0x04, Local2)
                    While (Local0)
                    {
                        Divide (Local0, 0x0A, Local1, Local0)
                        Add (Local1, 0x30, Index (SERN, Local2))
                        Decrement (Local2)
                    }

                    Store (SERN, Index (Arg1, 0x0A))
                    Or (Arg0, 0x06, ^PCI0.LPCB.EC.HIID)
                    WAEC ()
                    Store (^PCI0.LPCB.EC.RECB(0xA0,128), Index (Arg1, 0x09))
                    Store (^PCI0.LPCB.EC.RECB(0xA0,128), ZBDN)//wxw SBDN
                    Or (Arg0, 0x04, ^PCI0.LPCB.EC.HIID)
                    WAEC ()
                    Name (BTYP, Buffer (0x05)
                    {
                        0x00, 0x00, 0x00, 0x00, 0x00                   
                    })
                    Store (B1B4 (^PCI0.LPCB.EC.BCH0, ^PCI0.LPCB.EC.BCH1, ^PCI0.LPCB.EC.BCH2, ^PCI0.LPCB.EC.BCH3), BTYP)
                    Store (B1B4 (^PCI0.LPCB.EC.BCH0, ^PCI0.LPCB.EC.BCH1, ^PCI0.LPCB.EC.BCH2, ^PCI0.LPCB.EC.BCH3), ZBCH)//wxw SBCH
                    Store (BTYP, Index (Arg1, 0x0B))
                    Or (Arg0, 0x05, ^PCI0.LPCB.EC.HIID)
                    WAEC ()
                    Store (^PCI0.LPCB.EC.RECB(0xA0,128), Index (Arg1, 0x0C))
                    Store (^PCI0.LPCB.EC.RECB(0xA0,128), ZBMN)//wxw SBMN
                    Store (Zero, BASC)
                    Release (BATM)
                }
                Else
                {
                    Store (ToInteger (ZBCM), Local7)//wxw SBCM
                    XOr (Local7, One, Index (Arg1, Zero))
                    If (Local7)
                    {
                        Multiply (ToInteger (ZBFC), 0x0A, Index (Arg1, 0x02))//wxw
                    }
                    Else
                    {
                        Store (ToInteger (ZBFC), Index (Arg1, 0x02))//wxw
                    }

                    If (Local7)
                    {
                        Multiply (ToInteger (ZBDC), 0x0A, Local0)//wxw SBDC
                    }
                    Else
                    {
                        Store (ToInteger (ZBDC), Local0)//wxw SBDC
                    }

                    Store (Local0, Index (Arg1, One))
                    Divide (Local0, 0x14, Local1, Index (Arg1, 0x05))
                    Divide (Local0, 0x64, Local1, Index (Arg1, 0x06))
                    Store (ToInteger (ZBDV), Index (Arg1, 0x04))//wxw SBDV
                    Store (ToInteger (ZBSN), Local0)//wxw SBSN
                    Name (SRNB, Buffer (0x06)
                    {
                        "     "
                    })
                    Store (0x04, Local2)
                    While (Local0)
                    {
                        Divide (Local0, 0x0A, Local1, Local0)
                        Add (Local1, 0x30, Index (SRNB, Local2))
                        Decrement (Local2)
                    }

                    Store (SRNB, Index (Arg1, 0x0A))
                    Store (ToString (ZBDN, Ones), Index (Arg1, 0x09))//wxw SBDN
                    Name (BTTP, Buffer (0x05)
                    {
                        0x00, 0x00, 0x00, 0x00, 0x00                   
                    })

                    Store (ToBuffer (ZBCH), BTTP)//wxw SBCH
                    Store (BTTP, Index (Arg1, 0x0B))
                    Store (ToString (ZBMN, Ones), Index (Arg1, 0x0C))//wxw SBMN
                }
            }
            Else
            {
                Store (0xFFFFFFFF, Index (Arg1, One))
                Store (Zero, Index (Arg1, 0x05))
                Store (Zero, Index (Arg1, 0x06))
                Store (0xFFFFFFFF, Index (Arg1, 0x02))
            }

            Return (Arg1)
        }
        
        Method (GBIX, 3, NotSerialized)
        {
            Acquire (BATM, 0xFFFF)
            If (Arg2)
            {
                If (LNotEqual (BASC, Zero))
                {
                    Or (Arg0, One, ^PCI0.LPCB.EC.HIID)
                    Store (B1B2(^PCI0.LPCB.EC.BCC0,^PCI0.LPCB.EC.BCC1), Local7)  
                    Store (Local7, Index (Arg1, 0x08))
                    WAEC ()
                    Store (^PCI0.LPCB.EC.XBCM, Local7)    
                    XOr (Local7, One, Index (Arg1, One))
                    Store (Arg0, ^PCI0.LPCB.EC.HIID)
                    WAEC ()
                    If (Local7)
                    {
                        Multiply (B1B2(^PCI0.LPCB.EC.BFC0,^PCI0.LPCB.EC.BFC1), 0x0A, Local1)
                    }
                    Else
                    {
                        Store (B1B2(^PCI0.LPCB.EC.BFC0,^PCI0.LPCB.EC.BFC1), Local1)
                    }
                    
                    Store (Local1, Index (Arg1, 0x03))
                    Or (Arg0, 0x02, ^PCI0.LPCB.EC.HIID)
                    WAEC ()
                    If (Local7)
                    {
                        Multiply (B1B2(^PCI0.LPCB.EC.BDC0,^PCI0.LPCB.EC.BDC1), 0x0A, Local0)
                    }
                    Else
                    {
                        Store (B1B2(^PCI0.LPCB.EC.BDC0,^PCI0.LPCB.EC.BDC1), Local0)
                    }

                    Store (Local0, Index (Arg1, 0x02))
                    Divide (Local1, 0x14, Local2, Index (Arg1, 0x06))
                    If (Local7)
                    {
                        Store (0xC8, Index (Arg1, 0x07))
                    }
                    ElseIf (B1B2(^PCI0.LPCB.EC.BDV0,^PCI0.LPCB.EC.BDV1))
                    {
                        Divide (0x00030D40, B1B2(^PCI0.LPCB.EC.BDV0,^PCI0.LPCB.EC.BDV1), Local2, Index (Arg1, 0x07))
                    }
                    Else
                    {
                        Store (Zero, Index (Arg1, 0x07))
                    }

                    Store (B1B2(^PCI0.LPCB.EC.BDV0,^PCI0.LPCB.EC.BDV1), Index (Arg1, 0x05))
                    Store (B1B2(^PCI0.LPCB.EC.BSN0,^PCI0.LPCB.EC.BSN1), Local0)
                    Name (SERN, Buffer (0x06)
                    {
                        "     "
                    })
                    Store (0x04, Local2)
                    While (Local0)
                    {
                        Divide (Local0, 0x0A, Local1, Local0)
                        Add (Local1, 0x30, Index (SERN, Local2))
                        Decrement (Local2)
                    }

                    Store (SERN, Index (Arg1, 0x11))
                    Or (Arg0, 0x06, ^PCI0.LPCB.EC.HIID)
                    WAEC ()
                    Store (^PCI0.LPCB.EC.RECB(0xA0,128), Index (Arg1, 0x10))
                        Or (Arg0, 0x04, ^PCI0.LPCB.EC.HIID)
                    WAEC ()
                    Name (BTYP, Buffer (0x05)
                    {
                        0x00, 0x00, 0x00, 0x00, 0x00                   
                    })
                    //Store (^PCI0.LPCB.EC.XBCH, BTYP)
                    Store (B1B4 (^PCI0.LPCB.EC.BCH0, ^PCI0.LPCB.EC.BCH1, ^PCI0.LPCB.EC.BCH2, ^PCI0.LPCB.EC.BCH3), BTYP)                       
                    Store (BTYP, Index (Arg1, 0x12))
                    Or (Arg0, 0x05, ^PCI0.LPCB.EC.HIID)
                    WAEC ()
                    Store (^PCI0.LPCB.EC.RECB(0xA0,128), Index (Arg1, 0x13))
                }
            }
            Else
            {
                Store (0xFFFFFFFF, Index (Arg1, 0x02))
                Store (Zero, Index (Arg1, 0x06))
                Store (Zero, Index (Arg1, 0x07))
                Store (0xFFFFFFFF, Index (Arg1, 0x03))
            }

            Store (Zero, BASC)
            Release (BATM)
            Return (Arg1)
        }
        
        Method (GBST, 4, NotSerialized)
        {
            If (^PCI0.LPCB.EC.XFUD)
            {
                BFUD ()
            }

            Acquire (BATM, 0xFFFF)
            If (And (Arg1, 0x20))
            {
                Store (0x02, Local0)
            }
            ElseIf (And (Arg1, 0x40))
            {
                Store (One, Local0)
            }
            Else
            {
                Store (Zero, Local0)
            }

            If (And (Arg1, 0x0F)){}
            Else
            {
                Or (Local0, 0x04, Local0)
            }

            If (LEqual (And (Arg1, 0x0F), 0x0F))
            {
                Store (0x04, Local0)
                Store (Zero, Local1)
                Store (Zero, Local2)
                Store (Zero, Local3)
            }
            Else
            {
                Store (B1B2(^PCI0.LPCB.EC.CVO0,^PCI0.LPCB.EC.CVO1), Local3)
                If (Arg2)
                {
                    Multiply (B1B2(^PCI0.LPCB.EC.CRC0,^PCI0.LPCB.EC.CRC1), 0x0A, Local2)
                }
                Else
                {
                    Store (B1B2(^PCI0.LPCB.EC.CRC0,^PCI0.LPCB.EC.CRC1), Local2)
                }

                Store (B1B2(^PCI0.LPCB.EC.CRC0,^PCI0.LPCB.EC.CRC1), Local1)
                If (LGreaterEqual (Local1, 0x8000))
                {
                    If (And (Local0, One))
                    {
                        Subtract (0x00010000, Local1, Local1)
                    }
                    Else
                    {
                        Store (Zero, Local1)
                    }
                }
                ElseIf (LNot (And (Local0, 0x02)))
                {
                    Store (Zero, Local1)
                }

                If (Arg2)
                {
                    Multiply (Local3, Local1, Local1)
                    Divide (Local1, 0x03E8, Local7, Local1)
                    Store (Local0, Local7)
                    Store (Local7, Local0)
                }
            }

            Store (Local0, Index (Arg3, Zero))
            Store (Local1, Index (Arg3, One))
            Store (Local2, Index (Arg3, 0x02))
            Store (Local3, Index (Arg3, 0x03))
            Release (BATM)
            Return (Arg3)
        }
    }
}
//EOF


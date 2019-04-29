// battery
// In config ACPI, _BIF to XBIF
// Find:     5F424946
// Replace:  58424946
// TgtBridge:no
//
// In config ACPI, _BST to XBST 
// Find:     5F425354
// Replace:  58425354
// TgtBridge:no
//
// EC0 to EC
//
DefinitionBlock ("", "SSDT", 2, "hack", "BATT", 0)
{
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(_SB.PCI0.LPCB.EC.BAT0, DeviceObj)
    External(_SB.PCI0.LPCB.EC.ECAV, IntObj)
    External(_SB.PCI0.LPCB.EC.LFCM, MutexObj)
    External(_SB.PCI0.LPCB.EC.HGCT, MutexObj)
    External(_SB.PCI0.LPCB.EC.BAT0.PBIF, PkgObj)
    External(_SB.PCI0.LPCB.EC.BAT0.PBST, PkgObj)
    External(_SB.PCI0.LPCB.EC.B1TY, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.B1ST, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.FBFG, FieldUnitObj)
    
    Method (B1B2, 2, NotSerialized)
    {
        ShiftLeft (Arg1, 8, Local0)
        Or (Arg0, Local0, Local0)
        Return (Local0)
    }

    Scope(_SB.PCI0.LPCB.EC)
    {
        OperationRegion (BRAM, SystemMemory, 0xFF00D400, 0xFF)           
        Field (BRAM, ByteAcc, Lock, Preserve)
        {     
            //Offset (0x8F), 
            //BMN0,   72, //4*16=64+8 =72
            //9F
            //AF
            //BF
            //CF
            //D7 
            //Offset (0xD7),
            //BDN0,   64,
            //
            Offset (0xC1), 
                ,   8, 
            BRC0,8,BRC1,8,//B1RC,   16, 
            BSN0,8,BSN1,8,//B1SN,   16, 
            BFV0,8,BFV1,8,//B1FV,   16, 
            BDV0,8,BDV1,8,//B1DV,   16, 
            BDC0,8,BDC1,8,//B1DC,   16, 
            BFC0,8,BFC1,8,//B1FC,   16, 
                ,   8, 
                ,   8, 
                ,   16, 
            BAC0,8,BAC1,8,//B1AC,   16, 
        }
        //
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
    }   
    
    Scope(_SB.PCI0.LPCB.EC.BAT0)
    {   
        Method (_BIF, 0, NotSerialized)
        {
            If (LEqual (ECAV, One))
            {
                        If (LEqual (Acquire (LFCM, 0xA000), Zero))
                        {
                            Store (B1B2(BDC0, BDC1), Local0)//wxw
                            Multiply (Local0, 0x0A, Local0)
                            Store (Local0, Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, One))
                            Store (B1B2(BFC0, BFC1), Local0)//wxw
                            Multiply (Local0, 0x0A, Local0)
                            Store (Local0, Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x02))
                            Store (B1B2(BDV0, BDV1), Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x04))//wxw
                            If (B1B2(BFC0, BFC1))//wxw
                            {
                                Store (Divide (Multiply (B1B2(BFC0, BFC1), 0x0A), 0x0A, ), Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x05))//wxw
                                Store (Divide (Multiply (B1B2(BFC0, BFC1), 0x0A), 0x19, ), Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x06))//wxw
                                Store (Divide (Multiply (B1B2(BDC0, BDC1), 0x0A), 0x64, ), Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x07))//wxw
                            }

                            Store ("", Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x09))
                            Store ("", Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x0A))
                            Store ("", Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x0B))
                            Store ("", Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x0C))
                            Name (BDNT, Buffer (0x09)
                            {
                                 0x00                                           
                            })
                            Store (\_SB.PCI0.LPCB.EC.RECB (0x8F,72), BDNT)//wxw 
                            Store (ToString (BDNT, Ones), Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x09))
                            Store (B1B2(BSN0, BSN1), Local0)//wxw
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

                            Store (SERN, Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x0A))
                            Name (DCH0, Buffer (0x0A)
                            {
                                 0x00                                           
                            })
                            Name (DCH1, "LION")
                            Name (DCH2, "LiP")
                            If (LEqual (\_SB.PCI0.LPCB.EC.B1TY, One))
                            {
                                Store (DCH1, DCH0)
                                Store (ToString (DCH0, Ones), Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x0B))
                            }
                            Else
                            {
                                Store (DCH2, DCH0)
                                Store (ToString (DCH0, Ones), Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x0B))
                            }

                            Name (BMNT, Buffer (0x0A)
                            {
                                 0x00                                           
                            })
                            Store (\_SB.PCI0.LPCB.EC.RECB (0xD7,64), BMNT)//wxw
                            Store (ToString (BMNT, Ones), Index (\_SB.PCI0.LPCB.EC.BAT0.PBIF, 0x0C))
                            Release (LFCM)
                        }
            }

            Return (\_SB.PCI0.LPCB.EC.BAT0.PBIF)
        }
        
        Name (WBST, Zero)
        Name (WBAC, Zero)
        Name (WBPR, Zero)
        Name (WBRC, Zero)
        Name (WBPV, Zero)
        
        Method (_BST, 0, Serialized)
        {
                    If (LEqual (Acquire (HGCT, 0xA000), Zero))
                    {
                        If (LEqual (ECAV, One))
                        {
                            If (LEqual (Acquire (LFCM, 0xA000), Zero))
                            {
                                Sleep (0x10)
                                Store (\_SB.PCI0.LPCB.EC.B1ST, Local0)
                                Store (DerefOf (Index (\_SB.PCI0.LPCB.EC.BAT0.PBST, Zero)), Local1)
                                Switch (And (Local0, 0x07))
                                {
                                    Case (Zero)
                                    {
                                        Store (And (Local1, 0xF8), WBST)
                                    }
                                    Case (One)
                                    {
                                        Store (Or (One, And (Local1, 0xF8)), WBST)
                                    }
                                    Case (0x02)
                                    {
                                        Store (Or (0x02, And (Local1, 0xF8)), WBST)
                                    }
                                    Case (0x04)
                                    {
                                        Store (Or (0x04, And (Local1, 0xF8)), WBST)
                                    }

                                }

                                Sleep (0x10)
                                Store (B1B2(BAC0, BAC1), WBAC)//wxw
                                If (And (WBST, One))
                                {
                                    If (LNotEqual (WBAC, Zero))
                                    {
                                        Store (And (Not (WBAC), 0x7FFF), WBAC)
                                    }
                                }
                                ElseIf (LNotEqual (\_SB.PCI0.LPCB.EC.FBFG, One))
                                {
                                    If (And (WBAC, 0x8000))
                                    {
                                        Store (Zero, WBAC)
                                    }
                                }

                                Sleep (0x10)
                                Store (B1B2(BRC0, BRC1), WBRC)//wxw
                                Sleep (0x10)
                                Store (B1B2(BFV0, BFV1), WBPV)//wxw
                                Multiply (WBRC, 0x0A, WBRC)
                                Store (Divide (Multiply (WBAC, WBPV), 0x03E8, ), WBPR)
                                Store (WBST, Index (\_SB.PCI0.LPCB.EC.BAT0.PBST, Zero))
                                Store (WBPR, Index (\_SB.PCI0.LPCB.EC.BAT0.PBST, One))
                                Store (WBRC, Index (\_SB.PCI0.LPCB.EC.BAT0.PBST, 0x02))
                                Store (WBPV, Index (\_SB.PCI0.LPCB.EC.BAT0.PBST, 0x03))
                                Release (LFCM)
                            }
                        }

                        Release (HGCT)
                        Return (\_SB.PCI0.LPCB.EC.BAT0.PBST)
                    }
        }
    } 
}
//EOF


// battery
//
//1 UPBI to XPBI
//Find:     55 50 42 49 00
//Replace:  58 50 42 49 00
//TgtBridge:no
//
//2 UPBS to XPBS
//Find:     55 50 42 53 00
//Replace:  58 50 42 53 00
//TgtBridge:no
//
//EC0 to EC
//
DefinitionBlock ("", "SSDT", 2, "hack", "BATT", 0)
{
    External(_SB.BAT0, DeviceObj)
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(_SB.PCI0.LPCB.EC.MBNH, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.MBST, FieldUnitObj)    
    External(_SB.PCI0.LPCB.EC.SW2S, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.BACR, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.BVLB, FieldUnitObj)
    External(_SB.PCI0.LPCB.EC.BVHB, FieldUnitObj)
    External(SMA4, FieldUnitObj)  
    External(_SB.BAT0.PBIF, PkgObj)
    External(_SB.BAT0.PBST, PkgObj)
    External(_SB.BAT0.FABL, IntObj)
    External(_SB.BAT0.UPUM, MethodObj)
   
    Method (B1B2, 2, NotSerialized)
    {
        ShiftLeft (Arg1, 8, Local0)
        Or (Arg0, Local0, Local0)
        Return (Local0)
    }
    Scope(_SB.PCI0.LPCB.EC)
    {
        OperationRegion (BRAM, EmbeddedControl, Zero, 0xFF)           
        Field (BRAM, ByteAcc, NoLock, Preserve)
        {
            Offset (0x70), 
            ADC0,8,ADC1,8, //BADC,   16
            FCC0,8,FCC1,8, //BFCC,   16

            Offset (0x82), 
                ,   8, 
            CUR0,8,CUR1,8, //MCUR,   16
            BRM0,8,BRM1,8, //MBRM,   16
            BCV0,8,BCV1,8, //MBCV,   16
        }
    }
    
    Scope(_SB.BAT0)
    {
            Method (UPBI, 0, NotSerialized)
            {
                Local5 = B1B2(^^PCI0.LPCB.EC.FCC0,^^PCI0.LPCB.EC.FCC1)
                If ((Local5 && !(Local5 & 0x8000)))
                {
                    Local5 >>= 0x05
                    Local5 <<= 0x05
                    PBIF [One] = Local5
                    PBIF [0x02] = Local5
                    Local2 = (Local5 / 0x64)
                    Local2 += One
                    If ((B1B2(^^PCI0.LPCB.EC.ADC0,^^PCI0.LPCB.EC.ADC1) < 0x0C80))
                    {
                        Local4 = (Local2 * 0x0E)
                        PBIF [0x05] = (Local4 + 0x02)
                        Local4 = (Local2 * 0x09)
                        PBIF [0x06] = (Local4 + 0x02)
                        Local4 = (Local2 * 0x0B)
                    }
                    ElseIf ((SMA4 == One))
                    {
                        Local4 = (Local2 * 0x0C)
                        PBIF [0x05] = (Local4 + 0x02)
                        Local4 = (Local2 * 0x07)
                        PBIF [0x06] = (Local4 + 0x02)
                        Local4 = (Local2 * 0x09)
                    }
                    Else
                    {
                        Local4 = (Local2 * 0x0A)
                        PBIF [0x05] = (Local4 + 0x02)
                        Local4 = (Local2 * 0x05)
                        PBIF [0x06] = (Local4 + 0x02)
                        Local4 = (Local2 * 0x07)
                    }

                    FABL = (Local4 + 0x02)
                }

                If (^^PCI0.LPCB.EC.MBNH)
                {
                    Local0 = ^^PCI0.LPCB.EC.BVLB /* \_SB_.PCI0.LPCB.EC_.BVLB */
                    Local1 = ^^PCI0.LPCB.EC.BVHB /* \_SB_.PCI0.LPCB.EC_.BVHB */
                    Local1 <<= 0x08
                    Local0 |= Local1
                    PBIF [0x04] = Local0
                    PBIF [0x09] = "OANI$"
                    PBIF [0x0B] = "NiMH"
                }
                Else
                {
                    Local0 = ^^PCI0.LPCB.EC.BVLB /* \_SB_.PCI0.LPCB.EC_.BVLB */
                    Local1 = ^^PCI0.LPCB.EC.BVHB /* \_SB_.PCI0.LPCB.EC_.BVHB */
                    Local1 <<= 0x08
                    Local0 |= Local1
                    PBIF [0x04] = Local0
                    Sleep (0x32)
                    PBIF [0x0B] = "LION"
                }

                PBIF [0x09] = "Primary"
                UPUM ()
                PBIF [Zero] = One
            }
            Method (UPBS, 0, NotSerialized)
            {
                Local0 = B1B2(^^PCI0.LPCB.EC.CUR0,^^PCI0.LPCB.EC.CUR1)
                If ((Local0 & 0x8000))
                {
                    If ((Local0 == 0xFFFF))
                    {
                        PBST [One] = Ones
                    }
                    Else
                    {
                        Local1 = ~Local0
                        Local1++
                        Local3 = (Local1 & 0xFFFF)
                        PBST [One] = Local3
                    }
                }
                Else
                {
                    PBST [One] = Local0
                }

                Local5 = B1B2(^^PCI0.LPCB.EC.BRM0,^^PCI0.LPCB.EC.BRM1)
                If (!(Local5 & 0x8000))
                {
                    Local5 >>= 0x05
                    Local5 <<= 0x05
                    If ((Local5 != DerefOf (PBST [0x02])))
                    {
                        PBST [0x02] = Local5
                    }
                }

                If ((!^^PCI0.LPCB.EC.SW2S && (^^PCI0.LPCB.EC.BACR == One)))
                {
                    PBST [0x02] = FABL /* \_SB_.BAT0.FABL */
                }
                PBST [0x03] = B1B2(^^PCI0.LPCB.EC.BCV0,^^PCI0.LPCB.EC.BCV1)
                PBST [Zero] = ^^PCI0.LPCB.EC.MBST /* \_SB_.PCI0.LPCB.EC0_.MBST */
            }
    }
}
//EOF


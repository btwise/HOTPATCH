// In config ACPI, I2C1 renamed I2X1
// Find:     49 32 43 31
// Replace:  49 32 58 31
// TgtBridge:no
//
// In config ACPI, I2X1._STA renamed I2X1.XSTA
// Find:     5F 53 54 41
// Replace:  58 53 54 41
// TgtBridge:49 32 58 31
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "I2C1-SKL", 0)
{
#endif
    External(_SB.PCI0.I2X1, DeviceObj)
    External(SB11, FieldUnitObj)
    External(SMD1, FieldUnitObj)
    External(SB01, FieldUnitObj)
    External(SIR1, FieldUnitObj)
    //
    External(_SB.PCI0, DeviceObj)
    External(_SB.PCI0.GETD, MethodObj)
    External(_SB.PCI0.LPD0, MethodObj)
    External(_SB.PCI0.LPD3, MethodObj)
    External(_SB.PCI0.LHRV, MethodObj)
    External(_SB.PCI0.LCRS, MethodObj)
    External(_SB.PCI0.LSTA, MethodObj)

    Scope (_SB.PCI0.I2X1)
    {
        Method (_STA, 0, NotSerialized)
        {
            Return (0)
        }
    }   
    
    Scope (_SB.PCI0)
    {
        Device (I2C1)
        {
            Name (LINK, "\\_SB.PCI0.I2C1")
            Method (_PSC, 0, NotSerialized)
            {
                Return (GETD (SB11))
            }
            
            Method (_PS0, 0, NotSerialized)
            {
                LPD0 (SB11)
            }
            
            Method (_PS3, 0, NotSerialized)
            {
                LPD3 (SB11)
            }
        }
    }   
    
    Scope (_SB.PCI0.I2C1)
    {
            Name (_HID, "INT3443")
            Method (_HRV, 0, NotSerialized)
            {
                Return (LHRV (SB11))
            }

            Method (_CRS, 0, NotSerialized)
            {
                Return (LCRS (SMD1, SB01, SIR1))
            }

            Method (_STA, 0, NotSerialized)
            {
                Return (LSTA (SMD1))
            }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
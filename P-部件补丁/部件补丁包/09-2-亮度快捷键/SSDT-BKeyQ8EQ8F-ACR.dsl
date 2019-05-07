// BrightKey
// In config ACPI, EC0 renamed EC
// Find:     45 43 30 5F
// Replace:  45 43 5F 5F
//
// In config ACPI, _Q8E renamed XQ8E
// Find:     5F 51 38 45
// Replace:  58 51 38 45

// In config ACPI, _Q8F renamed XQ8F
// Find:     5F 51 38 46
// Replace:  58 51 38 46

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "BrightFN", 0)
{
#endif
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    
    Scope (_SB.PCI0.LPCB.EC)
    {
        //path:_SB.PCI0.LPCB.EC._Q8E
        Method (_Q8E, 0, NotSerialized)//up
        {
            Notify(\_SB.PCI0.LPCB.PS2K, 0x0406)
            Notify(\_SB.PCI0.LPCB.PS2K, 0x10)
        }
    
        //path:_SB.PCI0.LPCB.EC._Q8F
        Method (_Q8F, 0, NotSerialized)//down
        {
            Notify(\_SB.PCI0.LPCB.PS2K, 0x0405)
            Notify(\_SB.PCI0.LPCB.PS2K, 0x20)
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF

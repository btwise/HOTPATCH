//Please change the path
// In config ACPI, _SB.PCI0.LPCB.EC.BAT1._STA renamed _SB.PCI0.LPCB.EC.BAT1.XSTA
// Find:     5F535441
// Replace:  58535441
// TgtBridge:42415431
DefinitionBlock("", "SSDT", 2, "hack", "NOBAT1", 0)
{
    //path:_SB.PCI0.LPCB.EC.BAT1
    External(\_SB.PCI0.LPCB.EC.BAT1, DeviceObj)
    Scope (\_SB.PCI0.LPCB.EC.BAT1)
    {
        Method(_STA, 0, NotSerialized)
        {
            Return (0)
        }
    }
}
//EOF
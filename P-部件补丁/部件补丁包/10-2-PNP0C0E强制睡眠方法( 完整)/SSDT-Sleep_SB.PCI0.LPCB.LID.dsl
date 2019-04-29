// Overriding _LID
// In config ACPI, LID0 renamed LID
// Find:     4C 49 44 30
// Replace:  4C 49 44 5F
//
// In config ACPI, _LID renamed XLID
// Find:     5F4C4944 00
// Replace:  584C4944 00
//
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "XLID", 0)
{
#endif
    //note:_LID 's path
    //path:_SB.PCI0.LPCB.LID._LID
    External(_SB.PCI0.LPCB.LID, DeviceObj)
    External(_SB.PCI0.LPCB.LID.XLID, MethodObj)
    External(XWCF.MYLD, IntObj)
    Scope (_SB.PCI0.LPCB.LID)
    {
        Method (_LID, 0, NotSerialized)
        {
            if(\XWCF.MYLD==0)
            {
                Return (0)
            }
            Else
            {
                Return (\_SB.PCI0.LPCB.LID.XLID())
            }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif enable
//EOF
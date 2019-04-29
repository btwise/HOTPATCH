// In config ACPI, ALSD._STA renamed ALSD.XSTA
// Find:     5F535441
// Replace:  58535441
// TgtBridge:414C5344
//
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "ALSDfix", 0)
{
#endif
    // Search "ACPI0008"
    External(ALSD, DeviceObj)
    Scope (ALSD)
    {
        Name (_CID, "smc-als") 
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
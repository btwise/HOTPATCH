//
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "PRWNin1", 0)
{
#endif
    Scope (\_SB)
    {
        Method (PPPW, 0, Serialized)
        {
            Return (Package ()
            {
                0x0D, // or 0x6D,
                0x00
            })
        }
    }
    
    Method (_SB.PCI0.EH01._PRW, 0, NotSerialized)
    {
        Return (PPPW())
    }
    
    Method (_SB.PCI0.EH02._PRW, 0, NotSerialized)
    {
        Return (PPPW())
    }
    
    Method (_SB.PCI0.XHC._PRW, 0, NotSerialized)
    {
        Return (PPPW())
    }
    
    Method (_SB.PCI0.XDCI._PRW, 0, NotSerialized)
    {
        Return (PPPW())
    }
    
    Method (_SB.PCI0.HDEF._PRW, 0, NotSerialized)
    {
        Return (PPPW())
    }
    
    Method (_SB.PCI0.HDAS._PRW, 0, NotSerialized)
    {
        Return (PPPW())
    }
    
    Method (_SB.PCI0.AZAL._PRW, 0, NotSerialized)
    {
        Return (PPPW())
    }
    
    Method (_SB.PCI0.GLAN._PRW, 0, NotSerialized)
    {
        Return (PPPW())
    }
    
    Method (_SB.PCI0.IGBE._PRW, 0, NotSerialized)
    {
        Return (PPPW())
    }
    
    Method (_SB.PCI0.CNVW._PRW, 0, NotSerialized)
    {
        Return (PPPW())
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
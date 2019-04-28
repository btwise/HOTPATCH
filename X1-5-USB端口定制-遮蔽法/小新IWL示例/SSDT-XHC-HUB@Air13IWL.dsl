//
// In config ACPI, _UPC renamed XUPC
// Find:     5F 55 50 43
// Replace:  58 55 50 43
//
DefinitionBlock ("", "SSDT", 2, "hack", "XHC-HUB", 0)
{
    External(_SB.PCI0.XHC.RHUB.HS01, DeviceObj)
    Scope (_SB.PCI0.XHC.RHUB.HS01)
    {
        Name (_UPC, Package ()
        {
            0xFF, 
            0x03, 
            0, 
            0
        })
    }

    External(_SB.PCI0.XHC.RHUB.HS02, DeviceObj)
    Scope (_SB.PCI0.XHC.RHUB.HS02)
    {
        Name (_UPC, Package ()
        {
            0xFF, 
            0x03, 
            0, 
            0
        })
    }
    /*
    External(_SB.PCI0.XHC.RHUB.HS03, DeviceObj)
    Scope (_SB.PCI0.XHC.RHUB.HS03)
    {
        Name (_UPC, Package ()
        {
            0xFF, 
            0x09, 
            0, 
            0
        })
    }
    */

    External(_SB.PCI0.XHC.RHUB.HS05, DeviceObj)
    Scope (_SB.PCI0.XHC.RHUB.HS05)
    {
        Name (_UPC, Package ()
        {
            0xFF, 
            0xFF, 
            0, 
            0
        })
    }

    External(_SB.PCI0.XHC.RHUB.HS10, DeviceObj)
    Scope (_SB.PCI0.XHC.RHUB.HS10)
    {
        Name (_UPC, Package ()
        {
            0xFF, 
            0xFF, 
            0, 
            0
        })
    }

    External(_SB.PCI0.XHC.RHUB.SS01, DeviceObj)
    Scope (_SB.PCI0.XHC.RHUB.SS01)
    {
        Name (_UPC, Package ()
        {
            0xFF, 
            0x03, 
            0, 
            0
        })
    }
    
    External(_SB.PCI0.XHC.RHUB.SS02, DeviceObj)
    Scope (_SB.PCI0.XHC.RHUB.SS02)
    {
        Name (_UPC, Package ()
        {
            0xFF, 
            0x03, 
            0, 
            0
        })
    }
    External(_SB.PCI0.XHC.RHUB.SS03, DeviceObj)
    Scope (_SB.PCI0.XHC.RHUB.SS03)
    {
        Name (_UPC, Package ()
        {
            0xFF, 
            0x09, 
            0, 
            0
        })
    }
}
//EOF
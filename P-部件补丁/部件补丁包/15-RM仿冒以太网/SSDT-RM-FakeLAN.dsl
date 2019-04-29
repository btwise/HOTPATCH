// Fake LAN
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "RehabM", "FakeLAN", 0x00001000)
{
#endif
    Device (RMNE)
    {
        Name (_ADR, Zero)
        Name (_HID, "NULE0000")
        Name (MAC, Buffer (0x06)
        {
             0x11, 0x22, 0x33, 0x44, 0x55, 0x66             
        })
        Method (_DSM, 4, NotSerialized)
        {
            If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "built-in", Buffer() { 0x00 },
                "IOName", "ethernet",
                "name", Buffer() { "ethernet" },
                "model", Buffer() { "RM-NullEthernet-1001" },
                "device_type", Buffer() { "ethernet" },
            })
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF

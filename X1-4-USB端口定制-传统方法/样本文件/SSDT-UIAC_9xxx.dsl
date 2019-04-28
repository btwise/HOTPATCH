// Note:
// portType=0 seems to indicate normal external USB2 port (as seen in MacBookPro8,1)
// portType=2 seems to indicate "internal device" (as seen in MacBookPro8,1)
// portType=4 is used by MacBookPro8,3 (reason/purpose unknown)
//
DefinitionBlock ("", "SSDT", 2, "hack", "USB-port", 0)
{
    Device(UIAC)
    {
        Name(_HID, "UIA00000")
        Name(RMCF, Package()
        {
            "HUB1", Package()
            {
                "port-count", Buffer() { 8, 0, 0, 0 },
                "ports", Package()
                {
                    "HP11", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HP12", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HP13", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HP14", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HP15", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    "HP16", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "HP17", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    "HP18", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 8, 0, 0, 0 },
                    },
                },
            },
            "HUB2", Package()
            {
                "port-count", Buffer() { 6, 0, 0, 0 },
                "ports", Package()
                {
                    "HP21", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HP22", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HP23", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HP24", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HP25", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    "HP26", Package()
                    {
                        //"UsbConnector", 0,
                        "portType", 0,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                },
            },
            "EH01", Package()
            {
                "port-count", Buffer() { 1, 0, 0, 0 },
                "ports", Package()
                {
                    "PR11", Package()
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                },
            },
            "EH02", Package()
            {
                "port-count", Buffer() { 1, 0, 0, 0 },
                "ports", Package()
                {
                    "PR21", Package()
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                },
            },
            "8086_9xxx", Package()
            {
                "port-count", Buffer() { 13, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS04", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HS05", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    "HS06", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "HS07", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    "HS08", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 8, 0, 0, 0 },
                    },
                    "HS09", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 9, 0, 0, 0 },
                    },
                    "SS01", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 10, 0, 0, 0 },
                    },
                    "SS02", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 11, 0, 0, 0 },
                    },
                    "SS03", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 12, 0, 0, 0 },
                    },
                    "SS04", Package()
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                },
            },
        })
    }
}
//EOF
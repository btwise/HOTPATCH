// Overriding EV6
// In config ACPI, EV6 renamed XEV6
// Find:     45 56 36 5F 02
// Replace:  58 45 56 36 02
#define LidManagement 0
#define ButtonManagement 1
//
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "EV6Fix", 0)
{
#endif
    External(XWCF.MYLD, IntObj)
    External(XWCF.MPWS, IntObj)
    External(XWCF.MODE, IntObj)
    External(XEV6, MethodObj)

    Method (EV6, 2, NotSerialized)
    {
        If (Arg0 == 2)
        {
            If (\XWCF.MODE==0)
            {
                If (\XWCF.MYLD!=0)
                {
                    \XWCF.MYLD =0
                }
                Else
                {
                    \XWCF.MYLD =1
                }
                XEV6 (3, Arg1)
            }
            Else
            {
                \XWCF.MPWS =1
                XEV6 (2, Arg1)
            }
        }
        
        If (Arg0 == 3)
        {
            If (\XWCF.MODE==0)
            {
                \XWCF.MYLD =1
                XEV6 (3, Arg1)
            }
            Else
            {
                \XWCF.MPWS =1
                XEV6 (2, Arg1)
            }
        }
    } 
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
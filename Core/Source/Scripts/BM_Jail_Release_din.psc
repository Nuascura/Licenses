Scriptname BM_Jail_Release_din extends Quest  

Event OnStoryServedTime(Location akLocation, Form akCrimeGroup, int aiCrimeGold, int aiDaysJail)
    if (( Game.GetFormFromFile( 0x003E0DE7, "DeviousInterests.esp" ) as GlobalVariable ).GetValue() == 1 )
        din_ServedTime din_ST = ( Game.GetFormFromFile( 0x2E8C65, "DeviousInterests.esp" ) as Quest ) as din_ServedTime
        din_ST.DoDINServedTimeEvent( akLocation, aiDaysJail )
    EndIf
    Self.Stop()
EndEvent
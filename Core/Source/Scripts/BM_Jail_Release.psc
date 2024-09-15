Scriptname BM_Jail_Release extends Quest  

BM_Licenses_Utility Property bmlUtility Auto

Event OnStoryServedTime(Location akLocation, Form akCrimeGroup, int aiCrimeGold, int aiDaysJail)
    bmlUtility.BM_IsInJail.SetValue(0.0)
    Self.Stop()
endEvent
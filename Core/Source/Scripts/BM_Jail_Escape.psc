Scriptname BM_Jail_Escape extends Quest  

BM_Licenses_Utility Property bmlUtility Auto

Event OnStoryEscapeJail(Location akLocation, Form akCrimeGroup)
    bmlUtility.BM_IsInJail.SetValue(0.0)
    Self.Stop()
endEvent
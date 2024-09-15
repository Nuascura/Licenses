Scriptname BM_Jail_Arrest extends Quest  

BM_Licenses Property licenses auto

Event OnStoryJail(ObjectReference akGuard, Form akCrimeGroup, Location akLocation, int aiCrimeGold)
    RegisterForSingleUpdate(0.5)
EndEvent

Event OnUpdate()
    licenses.PlayerJailed()
    Self.Stop()
EndEvent
Scriptname BM_ME_DetectLocTown extends activemagiceffect  

BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    bmlUtility.licenses.isInTown = true
    bmlUtility.lastLoc = akTarget.GetCurrentLocation()
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    if bmlUtility.BM_Towns.HasForm(akNewLoc)
        bmlUtility.lastLoc = akNewLoc
    endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    bmlUtility.licenses.isInTown = false
EndEvent
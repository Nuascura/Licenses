Scriptname BM_ME_DetectLocTown extends activemagiceffect  

BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    bmlUtility.licenses.isInTown = true
    bmlUtility.lastLoc = akTarget.GetCurrentLocation()
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    if akNewLoc
        bmlUtility.ValidateLocNested(akNewLoc, GetTargetActor().GetWorldSpace(), bmlUtility.BM_Towns, Keyword.GetKeyword("LocTypeTown"))
    endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    bmlUtility.licenses.isInTown = false
EndEvent
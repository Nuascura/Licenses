Scriptname BM_ME_DetectLocCity extends activemagiceffect  

BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    bmlUtility.licenses.isInCity = true
    bmlUtility.lastLoc = akTarget.GetCurrentLocation()
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    if akNewLoc
        bmlUtility.ValidateLocNested(akNewLoc, GetTargetActor().GetWorldSpace(), bmlUtility.BM_Cities, Keyword.GetKeyword("LocTypeCity"))
    endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    bmlUtility.licenses.isInCity = false
EndEvent
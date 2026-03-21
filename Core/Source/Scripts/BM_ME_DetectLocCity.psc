Scriptname BM_ME_DetectLocCity extends activemagiceffect  

Actor Property TargetActor Auto
Keyword Property LocTypeCity Auto
BM_Licenses_Utility Property bmlUtility Auto
BM_Licenses Property licenses auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    licenses.isInCity = true
    bmlUtility.lastLoc = TargetActor.GetCurrentLocation()
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    if akNewLoc
        bmlUtility.ValidateLocNested(akNewLoc, TargetActor.GetWorldSpace(), bmlUtility.BM_Cities, LocTypeCity)
    endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    licenses.isInCity = false
EndEvent
Scriptname BM_ME_DetectLocTown extends activemagiceffect  

Actor Property TargetActor Auto
Keyword Property LocTypeTown Auto
BM_Licenses_Utility Property bmlUtility Auto
BM_Licenses Property licenses auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    licenses.isInTown = true
    bmlUtility.lastLoc = TargetActor.GetCurrentLocation()
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    if akNewLoc
        bmlUtility.ValidateLocNested(akNewLoc, TargetActor.GetWorldSpace(), bmlUtility.BM_Towns, LocTypeTown)
    endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    licenses.isInTown = false
EndEvent
Scriptname BM_ME_DetectLocSpace extends activemagiceffect  

Actor Property TargetActor Auto
BM_Licenses_Utility Property bmlUtility Auto
BM_Licenses Property licenses auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    licenses.isInCity = true
    OnLocationChange(none, TargetActor.GetCurrentLocation())
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    if akNewLoc
        bmlUtility.ValidateLocNested(akNewLoc, TargetActor.GetWorldSpace(), bmlUtility.BM_Cities)
    endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if !TargetActor.IsInInterior()
        licenses.isInCity = bmlUtility.GetIsInCity()
        bmlUtility.bmPlayer.CheckViolations()
    endIf
EndEvent
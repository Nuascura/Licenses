Scriptname BM_ME_DetectLocSpace extends activemagiceffect  

BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    bmlUtility.licenses.isInCity = true
    OnLocationChange(none, akTarget.GetCurrentLocation())
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    if akNewLoc
        bmlUtility.ValidateLocNested(akNewLoc, GetTargetActor().GetWorldSpace(), bmlUtility.BM_Cities)
    endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if !akTarget.IsInInterior()
        bmlUtility.licenses.isInCity = bmlUtility.GetIsInCity()
        bmlUtility.bmPlayer.CheckViolations()
    endIf
EndEvent
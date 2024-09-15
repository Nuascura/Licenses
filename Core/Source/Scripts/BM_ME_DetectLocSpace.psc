Scriptname BM_ME_DetectLocSpace extends activemagiceffect  

BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    bmlUtility.licenses.isInCity = true
    bmlUtility.lastLoc = akTarget.GetCurrentLocation()
    bmlUtility.lastSpace = akTarget.GetWorldSpace()
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    if bmlUtility.BM_Cities.HasForm(akNewLoc)
        bmlUtility.lastLoc = akNewLoc
        bmlUtility.lastSpace = GetTargetActor().GetWorldSpace()
    endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if !akTarget.IsInInterior()
        bmlUtility.lastSpace = none
        bmlUtility.licenses.isInCity = bmlUtility.CheckCity(akTarget.GetCurrentLocation(), akTarget.GetWorldSpace())
        bmlUtility.bmPlayer.CheckViolations()
    endIf
EndEvent
Scriptname BM_ME_DetectLocSpaceInterior extends activemagiceffect  

BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    bmlUtility.licenses.isInCity = bmlUtility.CheckCity(akTarget.GetCurrentLocation(), akTarget.GetWorldSpace())
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if !bmlUtility.BM_WorldSpaces.HasForm(akTarget.GetWorldSpace()) ; assume in exterior
        bmlUtility.lastSpace = none
        bmlUtility.licenses.isInCity = bmlUtility.CheckCity(akTarget.GetCurrentLocation(), akTarget.GetWorldSpace())
        bmlUtility.bmPlayer.CheckViolations()
    endIf
EndEvent
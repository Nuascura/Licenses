Scriptname BM_ME_DetectLocSpaceInterior extends activemagiceffect  

BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    bmlUtility.licenses.isInCity = bmlUtility.GetIsInCity()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if !bmlUtility.BM_WorldSpaces.HasForm(akTarget.GetWorldSpace()) ; assume in exterior
        bmlUtility.licenses.isInCity = bmlUtility.GetIsInCity()
        bmlUtility.bmPlayer.CheckViolations()
    endIf
EndEvent
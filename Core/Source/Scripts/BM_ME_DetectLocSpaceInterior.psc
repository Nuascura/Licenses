Scriptname BM_ME_DetectLocSpaceInterior extends activemagiceffect  

Actor Property TargetActor Auto
BM_Licenses_Utility Property bmlUtility Auto
BM_Licenses Property licenses auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    licenses.isInCity = bmlUtility.GetIsInCity()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if !bmlUtility.BM_WorldSpaces.HasForm(TargetActor.GetWorldSpace()) ; assume in exterior
        licenses.isInCity = bmlUtility.GetIsInCity()
        bmlUtility.bmPlayer.CheckViolations()
    endIf
EndEvent
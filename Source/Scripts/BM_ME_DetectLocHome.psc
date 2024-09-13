Scriptname BM_ME_DetectLocHome extends activemagiceffect  

BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    bmlUtility.BM_IsInPlayerHome.SetValue(1.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    bmlUtility.BM_IsInPlayerHome.SetValue(0.0)
EndEvent
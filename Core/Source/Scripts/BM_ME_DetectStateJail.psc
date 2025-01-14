Scriptname BM_ME_DetectStateJail extends activemagiceffect  

BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    bmlUtility.BM_IsInJail.SetValue(bmlUtility.GetIsInJail(none, true) as float)
EndEvent
Scriptname BM_ME_DetectStateJail extends activemagiceffect  

BM_Licenses_Utility Property bmlUtility Auto
GlobalVariable Property BM_IsInJail Auto

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    BM_IsInJail.SetValue(bmlUtility.GetIsInJail(none, true) as float)
EndEvent
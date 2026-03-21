Scriptname BM_ME_DetectLocExcluded extends activemagiceffect  

GlobalVariable Property BM_IsInLocExcluded Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    BM_IsInLocExcluded.SetValue(1.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    BM_IsInLocExcluded.SetValue(0.0)
EndEvent
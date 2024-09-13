Scriptname BM_ME_DetectStateFollower extends activemagiceffect  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    bmlUtility.CheckProximity()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    licenses.isAccompanied = false
EndEvent
Scriptname BM_ME_DetectMQIntro extends activemagiceffect  

Location Property HelgenLocation  Auto  
FormList Property BM_Towns  Auto  
Keyword Property LocTypeTown Auto
Bool Property HelgenModified = false Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	BM_Towns.AddForm(HelgenLocation)
    if !HelgenLocation.HasKeyword(LocTypeTown)
        PO3_SKSEFunctions.AddKeywordToForm(HelgenLocation, LocTypeTown)
        HelgenModified = true
    endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    BM_Towns.RemoveAddedForm(HelgenLocation)
    if HelgenModified
        PO3_SKSEFunctions.RemoveKeywordOnForm(HelgenLocation, LocTypeTown)
    endIf
EndEvent
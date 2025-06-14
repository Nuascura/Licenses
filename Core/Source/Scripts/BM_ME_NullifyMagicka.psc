Scriptname BM_ME_NullifyMagicka extends activemagiceffect  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
Actor Property akCursed auto
Message Property MessageSpell  Auto  
Message Property MessageVoice  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if akTarget == licenses.PlayerActorRef
		if bmlmcm.SlaveTats_State && bmlmcm.ShowCurseTattoos
			licenses.CursedTattoosActive = BM_API_ST.LockCursedTattoos(akTarget, licenses.CursedTattoos, bmlmcm)
		endIf
	endIf
	akCursed = akTarget
	RegisterForAnimationEvent(akTarget, "BeginCastVoice")
	RegisterForAnimationEvent(akTarget, "BeginCastRight")
	RegisterForAnimationEvent(akTarget, "BeginCastLeft")
endEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if asEventName == "BeginCastVoice"
		licenses.bmlUtility.GameMessage(MessageVoice)
		akSource.InterruptCast()
	elseIf asEventName == "BeginCastLeft" || asEventName == "BeginCastRight" 
		licenses.bmlUtility.GameMessage(MessageSpell)
		akSource.InterruptCast()
		DepleteMagicka()
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	if akTarget == licenses.PlayerActorRef
		if bmlmcm.SlaveTats_State
			licenses.CursedTattoosActive = BM_API_ST.UnlockCursedTattoos(akTarget, licenses.CursedTattoosActive)
		endIf
	endIf
EndEvent

Function DepleteMagicka()
    if akCursed && akCursed.GetActorValue("Magicka") > 0.0
        akCursed.DamageActorValue("Magicka", akCursed.GetActorValueMax("Magicka"))
    endIf
EndFunction

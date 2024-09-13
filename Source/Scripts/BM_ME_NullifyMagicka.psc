Scriptname BM_ME_NullifyMagicka extends activemagiceffect  

BM_Licenses Property licenses auto
Actor Property akCursed auto
Message Property MessageSpell  Auto  
Message Property MessageVoice  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if akTarget == licenses.playerRef.GetActorRef()
		if licenses.bmlmcm.SlaveTats_State && licenses.bmlmcm.ShowCurseTattoos
			licenses.LockCursedTattoos(akTarget)
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
	if akTarget == licenses.playerRef.GetActorRef()
		if licenses.bmlmcm.SlaveTats_State
			licenses.UnlockCursedTattoos(akTarget)
		endIf
	endIf
EndEvent

Function DepleteMagicka()
    if akCursed && akCursed.GetActorValue("Magicka") > 0.0
        akCursed.DamageActorValue("Magicka", akCursed.GetActorValueMax("Magicka"))
    endIf
EndFunction

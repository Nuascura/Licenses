Scriptname BM_ME_DetectStateCurfew extends activemagiceffect  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
GlobalVariable Property BM_IsViolatingCurfew Auto
Message Property BM_Licenses_MessageCurfewActive  Auto  
Message Property BM_Licenses_MessageCurfewInactive  Auto  
Message Property BM_Licenses_MessageCurfewWarn  Auto  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	bmlUtility.GameMessage(BM_Licenses_MessageCurfewActive)
	OnLocationChange(none, none)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	BM_IsViolatingCurfew.SetValue(0.0)
	bmlUtility.GameMessage(BM_Licenses_MessageCurfewInactive)
	if !bmlUtility.licenseBountyQuest.IsRunning()
		licenses.isCurfewViolation = false
	endIf
EndEvent

Function CheckCurfewViolation()
    if !(licenses.hasCurfewExemption || licenses.isCurfewViolation)
		bmlUtility.GameMessage(BM_Licenses_MessageCurfewWarn)
        licenses.isCurfewViolation = true
		bmlUtility.bmPlayer.CheckViolations()
    EndIf
EndFunction

Event OnUpdate()
	CheckCurfewViolation()
	RegisterForSingleUpdate(30.0)
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	if GetTargetActor().IsInInterior()
		BM_IsViolatingCurfew.SetValue(0.0)
		UnregisterForUpdate()
	else
		BM_IsViolatingCurfew.SetValue(1.0)
		RegisterForSingleUpdate(10.0)
	endIf
EndEvent
Scriptname BM_ME_DetectStateCurfew extends activemagiceffect  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
BM_Player Property bmPlayer auto
GlobalVariable Property BM_IsViolatingCurfew Auto
GlobalVariable Property BM_LenientCurfewViolation Auto
Message Property BM_Licenses_MessageCurfewActive  Auto  
Message Property BM_Licenses_MessageCurfewInactive  Auto  
Message Property BM_Licenses_MessageCurfewWarn  Auto
Book Property BM_CurfewExemption Auto
FormList Property BM_Empty Auto
Quest Property licenseBountyQuest auto

; Setup -----------------------------------------------------------------------------

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RemoveAllInventoryEventFilters()
	if licenses.curfewExemptionExpirationTime >= 0
		AddInventoryEventFilter(BM_CurfewExemption)
	else
		AddInventoryEventFilter(BM_Empty)
	endIf
    RegisterForModEvent("BM-LPO_CurfewExemption_" + akTarget.GetFormID() + "_Activate", "LPO_OnLicenseActivate")
    RegisterForModEvent("BM-LPO_CurfewExemption_" + akTarget.GetFormID() + "_Deactivate", "LPO_OnLicenseDeactivate")

	bmlUtility.GameMessage(BM_Licenses_MessageCurfewActive)
	BM_LenientCurfewViolation.SetValue(1.0)
	if !licenses.hasCurfewExemption && GetAreaHasCurfew(akTarget, bmlUtility.currLoc)
		GoToState("ActiveViolation")
		RegisterForSingleUpdate(10.0)
	endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	bmlUtility.GameMessage(BM_Licenses_MessageCurfewInactive)
	BM_IsViolatingCurfew.SetValue(0.0)
	if !licenseBountyQuest.IsRunning()
		licenses.isCurfewViolation = false
	endIf
EndEvent

; Effect Main Body -------------------------------------------------------------------

Auto State Default
	Event OnBeginState()
		BM_IsViolatingCurfew.SetValue(0.0)
	EndEvent
	Event OnUpdate()
		; Keep Empty
	EndEvent
EndState

State ActiveViolation
	Event OnBeginState()
		bmlUtility.GameMessage(BM_Licenses_MessageCurfewWarn)
		BM_IsViolatingCurfew.SetValue(1.0)
	EndEvent
	Event OnUpdate()
		If !licenses.isCurfewViolation
			licenses.isCurfewViolation = true
			bmPlayer.CheckViolations()
		EndIf
		RegisterForSingleUpdate(30.0)
	EndEvent
EndState

; Utilities --------------------------------------------------------------------------

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	if akNewLoc
		if GetAreaHasCurfew(GetTargetActor(), akNewLoc)
			bmlUtility.LogNotification("This location has an active curfew.")
			if !licenses.hasCurfewExemption
				GoToState("ActiveViolation")
				RegisterForSingleUpdate(2.0)
			endIf
		else
			GoToState("Default")
			UnregisterForUpdate()
		endIf
	endIf
EndEvent

Bool Function GetAreaHasCurfew(Actor akActor, Location akLocation)
	if akActor && akLocation
		return (!akActor.IsInInterior() && akLocation.HasKeyword(Keyword.GetKeyword("LocTypeHabitation")))
	endIf
	return False
EndFunction

Event OnItemAdded(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
	GoToState("Default")
	UnregisterForUpdate()
EndEvent

Event OnItemRemoved(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
	OnLocationChange(None, bmlUtility.currLoc)
EndEvent

Event LPO_OnLicenseActivate(string eventName, string strArg, float numArg, form sender)
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(BM_CurfewExemption)
	GoToState("Default")
	UnregisterForUpdate()
EndEvent

Event LPO_OnLicenseDeactivate(string eventName, string strArg, float numArg, form sender)
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(BM_Empty)
	OnLocationChange(None, bmlUtility.currLoc)
EndEvent
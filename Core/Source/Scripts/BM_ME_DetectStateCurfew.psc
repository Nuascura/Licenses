Scriptname BM_ME_DetectStateCurfew extends activemagiceffect  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
GlobalVariable Property BM_IsViolatingCurfew Auto
Message Property BM_Licenses_MessageCurfewActive  Auto  
Message Property BM_Licenses_MessageCurfewInactive  Auto  
Message Property BM_Licenses_MessageCurfewWarn  Auto

; Setup -----------------------------------------------------------------------------

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RemoveAllInventoryEventFilters()
	if licenses.curfewExemptionExpirationTime >= 0
		AddInventoryEventFilter(bmlUtility.BM_CurfewExemption)
	else
		AddInventoryEventFilter(bmlUtility.BM_Empty)
	endIf
    RegisterForModEvent("BM-LPO_LicensePurchased", "LPO_OnLicensePurchased")
	RegisterForModEvent("BM-LPO_LicenseExpired", "LPO_OnLicenseExpired")

	bmlUtility.GameMessage(BM_Licenses_MessageCurfewActive)
	bmlUtility.BM_LenientCurfewViolation.SetValue(1.0)
	if !licenses.hasCurfewExemption && GetAreaHasCurfew(akTarget, bmlUtility.currLoc)
		GoToState("ActiveViolation")
		RegisterForSingleUpdate(10.0)
	endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	bmlUtility.GameMessage(BM_Licenses_MessageCurfewInactive)
	BM_IsViolatingCurfew.SetValue(0.0)
	if !bmlUtility.licenseBountyQuest.IsRunning()
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
			bmlUtility.bmPlayer.CheckViolations()
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

Event LPO_OnLicensePurchased(int aiArg1)
    if aiArg1 == 10
		RemoveAllInventoryEventFilters()
		AddInventoryEventFilter(bmlUtility.BM_CurfewExemption)
    	GoToState("Default")
		UnregisterForUpdate()
	endIf
EndEvent

Event LPO_OnLicenseExpired(int aiArg1)
    if aiArg1 == 10
		RemoveAllInventoryEventFilters()
		AddInventoryEventFilter(bmlUtility.BM_Empty)
    	OnLocationChange(None, bmlUtility.currLoc)
	endIf
EndEvent
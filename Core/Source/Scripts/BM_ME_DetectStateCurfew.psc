Scriptname BM_ME_DetectStateCurfew extends activemagiceffect  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
GlobalVariable Property BM_IsViolatingCurfew Auto
Message Property BM_Licenses_MessageCurfewActive  Auto  
Message Property BM_Licenses_MessageCurfewInactive  Auto  
Message Property BM_Licenses_MessageCurfewWarn  Auto  

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
	if !licenses.hasCurfewExemption
		RegisterForSingleUpdate(10.0)
		if !akTarget.IsInInterior()
			BM_IsViolatingCurfew.SetValue(1.0)
		endIf
	endIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	bmlUtility.GameMessage(BM_Licenses_MessageCurfewInactive)
	BM_IsViolatingCurfew.SetValue(0.0)
	if !bmlUtility.licenseBountyQuest.IsRunning()
		licenses.isCurfewViolation = false
	endIf
EndEvent

Event OnItemAdded(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
	BM_IsViolatingCurfew.SetValue(0.0)
	UnregisterForUpdate()
EndEvent

Event OnItemRemoved(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
	OnLocationChange(None, bmlUtility.currLoc)
EndEvent

Event LPO_OnLicensePurchased(int aiArg1)
    if aiArg1 == 10
		RemoveAllInventoryEventFilters()
		AddInventoryEventFilter(bmlUtility.BM_CurfewExemption)
    	BM_IsViolatingCurfew.SetValue(0.0)
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

Function CheckCurfewViolation()
	If !licenses.isCurfewViolation
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
	if akNewLoc
		if !licenses.hasCurfewExemption
			RegisterForSingleUpdate(2.0)
		endIf
		if !GetTargetActor().IsInInterior() && akNewLoc.HasKeyword(Keyword.GetKeyword("LocTypeHabitation"))
			BM_IsViolatingCurfew.SetValue(1.0)
			bmlUtility.LogNotification("This location has an active curfew.")
		else
			BM_IsViolatingCurfew.SetValue(0.0)
		endIf
	endIf
EndEvent
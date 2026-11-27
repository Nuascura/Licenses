Scriptname BM_ME_DetectStateWorkbench extends activemagiceffect  

import SPE_Form
import PO3_Events_AME
import UI

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
Message Property BM_Licenses_MessageCraftingWarn  Auto 

; Setup -----------------------------------------------------------------------------

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if IsMenuOpen("Crafting Menu") && !licenses.hasCraftingLicense
		RegisterForItemCrafted(self)
	endIf
EndEvent

; Effect Main Body -------------------------------------------------------------------

Auto State Default
	Event OnBeginState()
		OnUpdate()
	EndEvent
	Event OnUpdate()
		RegisterForItemCrafted(self)
	EndEvent 
	Event OnItemCrafted(ObjectReference akBench, Location akLocation, Form akCreatedItem)
		UnregisterForItemCrafted(self)
		If IsCraftingViolation(akCreatedItem)
			GoToState("ActiveViolation")
		Else
			RegisterForSingleUpdate(5.0)
		EndIf
	EndEvent
EndState

State ActiveViolation
	Event OnBeginState()
		bmlUtility.GameMessage(BM_Licenses_MessageCraftingWarn)
		if !licenses.isCraftingViolation
			licenses.isCraftingViolation = 1
			bmlUtility.ConsiderViolationCheck()
		EndIf
		RegisterForSingleUpdate(30.0)
	EndEvent
	Event OnUpdate()
		GoToState("")
	EndEvent 
EndState

; Utilities --------------------------------------------------------------------------

Bool Function IsCraftingViolation(Form item)
	Return !IsItemFood(item as Potion) || !FormHasKeywords(item, licenses.KeywordCookItem, false)
EndFunction

Bool Function IsItemFood(Potion item)
	Return item && item.IsFood()
EndFunction

Event OnItemCrafted(ObjectReference akBench, Location akLocation, Form akCreatedItem)
	RegisterForSingleUpdate(30.0)
EndEvent
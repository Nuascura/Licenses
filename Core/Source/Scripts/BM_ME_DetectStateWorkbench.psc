Scriptname BM_ME_DetectStateWorkbench extends activemagiceffect  

import PO3_Events_AME

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
Message Property BM_Licenses_MessageCraftingWarn  Auto 

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if UI.IsMenuOpen("Crafting Menu")
		bmlUtility.GameMessage(BM_Licenses_MessageCraftingWarn)
		CheckFurnitureViolation()
		RegisterForSingleUpdate(5.0)
	endIf
EndEvent

Function CheckFurnitureViolation()
    if !(licenses.hasCraftingLicense || licenses.isCraftingViolation)
		licenses.isCraftingViolation = true
		bmlUtility.ConsiderViolationCheck()
    EndIf
EndFunction

Event OnUpdate()
	RegisterForItemCrafted(self)
EndEvent 

Event OnItemCrafted(ObjectReference akBench, Location akLocation, Form akCreatedItem)
	UnregisterForItemCrafted(self)
	CheckFurnitureViolation()
	RegisterForSingleUpdate(10.0)
EndEvent


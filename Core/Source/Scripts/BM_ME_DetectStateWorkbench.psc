Scriptname BM_ME_DetectStateWorkbench extends activemagiceffect  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
Message Property BM_Licenses_MessageCraftingWarn  Auto 

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if UI.IsMenuOpen("Crafting Menu")
		bmlUtility.GameMessage(BM_Licenses_MessageCraftingWarn)
		CheckFurnitureViolation()
		RegisterForSingleUpdate(15.0)
	endIf
EndEvent

Function CheckFurnitureViolation()
    if !licenses.hasCraftingLicense
		licenses.isCraftingViolation = true
		bmlUtility.ConsiderViolationCheck()
    EndIf
EndFunction

Event OnUpdate()
	CheckFurnitureViolation()
	RegisterForSingleUpdate(15.0)
EndEvent 

Scriptname BM_ME_DetectItemWeaponOut extends activemagiceffect  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	CheckWeaponViolation(akTarget)
EndEvent

Function CheckWeaponViolation(Actor player)
    if !licenses.hasWeaponLicense || !licenses.isInsured
		if bmlUtility.ValidateWeaponForms(player.GetEquippedWeapon(true), player.GetEquippedWeapon(false))
			if (licenses.hasWeaponLicense == true && licenses.isInsured == false)
				licenses.isUninsuredViolation = true
			endIf
			licenses.isWeaponViolation = true
			bmlUtility.LogTrace("Detected Weapon Violation: Unsheathed Weapon")
			bmlUtility.AggregateViolations()
		endIf
    EndIf
EndFunction
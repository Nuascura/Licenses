Scriptname BM_ME_DetectItemMagicOut extends activemagiceffect  

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	CheckMagicViolation(akTarget)
EndEvent

Function CheckMagicViolation(Actor player)
    if (!licenses.hasMagicLicense || !licenses.isInsured) && licenses.CheckNullifyMagickaCurse(player) < 1
        if (bmlUtility.ValidateSpellForms(player, player.GetEquippedSpell(0), player.GetEquippedSpell(1)))
            if (licenses.hasMagicLicense == true && licenses.isInsured == false)
                licenses.isUninsuredViolation = true
            endIf
            licenses.isMagicViolation = true
            bmlUtility.LogTrace("Detected Magic Violation: Unsheathed Spell")
            bmlUtility.AggregateViolations()
        endIf
    EndIf
EndFunction
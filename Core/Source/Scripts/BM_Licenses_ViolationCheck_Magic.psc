Scriptname BM_Licenses_ViolationCheck_Magic extends Quest  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

Auto State Default
    Event OnUpdate()
        bmlUtility.LogTrace("ViolationCheck_Magic")
        ViolationCheck_Magic()
    EndEvent
EndState

Function ViolationCheck_Magic()
    GoToState("")
    if !bmlmcm.isMagicLicenseFeatureEnabled
        return
    endIf

    Actor playerActor = licenses.playerRef.GetActorRef()

    if !licenses.isMagicViolation
        Form[] equippedObjects = PapyrusUtil.GetMatchingForm(PO3_SKSEFunctions.AddItemsOfTypeToArray(playerActor, 26, false, false, true), bmlUtility.BM_PotentialViolations_Ench.ToArray())
        if (equippedObjects)
            licenses.isMagicViolation = true
            bmlUtility.LogTrace("Detected Magic Violation (Armor): " + equippedObjects)
        endIf
    endIf

    ; Check for equipped enchanted weapons in both hands
    if !licenses.isMagicViolation
        if playerActor.GetEquippedWeapon(false) && (bmlUtility.BM_PotentialViolations_Ench.HasForm(playerActor.GetEquippedWeapon(false)))
            licenses.isMagicViolation = true
            bmlUtility.LogTrace("Detected Magic Violation (Weapon): " + playerActor.GetEquippedWeapon(false))
        elseIf playerActor.GetEquippedWeapon(true) && (bmlUtility.BM_PotentialViolations_Ench.HasForm(playerActor.GetEquippedWeapon(true)))
            licenses.isMagicViolation = true
            bmlUtility.LogTrace("Detected Magic Violation (Weapon): " + playerActor.GetEquippedWeapon(true))
        endIf
    endif

    ; Check for equipped spells in both hands
    if !licenses.isMagicViolation
        ; Check for Curse
        if licenses.CheckNullifyMagickaCurse(playerActor) == 0 && (!licenses.hasMagicLicense || !licenses.isInsured)
            if playerActor.IsWeaponDrawn()
                if bmlUtility.ValidateSpellForms(playerActor, playerActor.GetEquippedSpell(0), playerActor.GetEquippedSpell(1))
                    licenses.isMagicViolation = true
                    bmlUtility.LogTrace("Detected Magic Violation (Spell): " + playerActor.GetEquippedSpell(0) + ", " + playerActor.GetEquippedSpell(1))
                endIf
            endIf
            if bmlmcm.NullifyMagickaEnforce
                licenses.isMagicViolation = true
                bmlUtility.LogTrace("Detected Magic Violation (Curse): Missing Curse")
            endIf
        endIf
    endif

    ; Check for uninsured violation
    if !licenses.isUninsuredViolation && !licenses.isInsured
        if licenses.isMagicViolation && licenses.hasMagicLicense
            bmlUtility.LogTrace("Detected Uninsured Violation: Magic Type")
            licenses.isUninsuredViolation = true
        endIf
    endIf

    ; Collect Violations
    if licenses.isMagicViolation
        RegisterForSingleUpdate(1.0)
    endIf
EndFunction
Scriptname BM_Licenses_ViolationCheck_Weapon extends Quest  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

Auto State Default
    Event OnUpdate()
        bmlUtility.LogTrace("ViolationCheck_Weapon")
        ViolationCheck_Weapon()
    EndEvent
EndState

Function ViolationCheck_Weapon()
    GoToState("")
    if !bmlmcm.isWeaponLicenseFeatureEnabled
        return
    endIf

    Actor playerActor = licenses.playerRef.GetActorRef()

    ; Check for equipped weapons / ammo
    if !licenses.isWeaponViolation
        if playerActor.GetEquippedWeapon(false) && (bmlUtility.BM_PotentialViolations.HasForm(playerActor.GetEquippedWeapon(false)))
            licenses.isWeaponViolation = true
            bmlUtility.LogTrace("Detected Weapon Violation: " + playerActor.GetEquippedWeapon(false))
        elseIf playerActor.GetEquippedWeapon(true) && (bmlUtility.BM_PotentialViolations.HasForm(playerActor.GetEquippedWeapon(true)))
            licenses.isWeaponViolation = true
            bmlUtility.LogTrace("Detected Weapon Violation: " + playerActor.GetEquippedWeapon(true))
        elseIf PO3_SKSEFunctions.GetEquippedAmmo(playerActor) && (bmlUtility.BM_PotentialViolations.HasForm(PO3_SKSEFunctions.GetEquippedAmmo(playerActor)))
            licenses.isWeaponViolation = true
            bmlUtility.LogTrace("Detected Weapon Violation: " + PO3_SKSEFunctions.GetEquippedAmmo(playerActor))
        endif
    endif

    ; Check for uninsured violation
    if !licenses.isUninsuredViolation && !licenses.isInsured
        if licenses.isWeaponViolation && licenses.hasWeaponLicense
            bmlUtility.LogTrace("Detected Uninsured Violation: Weapon Type")
            licenses.isUninsuredViolation = true
        endIf
    endIf

    ; Collect Violations
    if licenses.isWeaponViolation
        RegisterForSingleUpdate(1.0)
    endIf
EndFunction
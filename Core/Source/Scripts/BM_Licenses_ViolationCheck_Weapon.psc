Scriptname BM_Licenses_ViolationCheck_Weapon extends Quest  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

Auto State Run
    Event OnUpdate()
        GoToState("")
        bmlUtility.LogTrace("ViolationCheck_Weapon")
        
        if !bmlmcm.isWeaponLicenseFeatureEnabled
            return
        endIf
    
        ; Check for equipped weapons / ammo
        if !licenses.isWeaponViolation
            if licenses.PlayerActorRef.GetEquippedWeapon(false) && (bmlUtility.BM_PotentialViolations.HasForm(licenses.PlayerActorRef.GetEquippedWeapon(false)))
                licenses.isWeaponViolation = true
                bmlUtility.LogTrace("Detected Weapon Violation: " + licenses.PlayerActorRef.GetEquippedWeapon(false))
            elseIf licenses.PlayerActorRef.GetEquippedWeapon(true) && (bmlUtility.BM_PotentialViolations.HasForm(licenses.PlayerActorRef.GetEquippedWeapon(true)))
                licenses.isWeaponViolation = true
                bmlUtility.LogTrace("Detected Weapon Violation: " + licenses.PlayerActorRef.GetEquippedWeapon(true))
            elseIf PO3_SKSEFunctions.GetEquippedAmmo(licenses.PlayerActorRef) && (bmlUtility.BM_PotentialViolations.HasForm(PO3_SKSEFunctions.GetEquippedAmmo(licenses.PlayerActorRef)))
                licenses.isWeaponViolation = true
                bmlUtility.LogTrace("Detected Weapon Violation: " + PO3_SKSEFunctions.GetEquippedAmmo(licenses.PlayerActorRef))
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
    EndEvent
EndState
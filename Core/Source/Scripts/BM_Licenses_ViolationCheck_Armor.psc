Scriptname BM_Licenses_ViolationCheck_Armor extends Quest  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

Auto State Run
    Event OnUpdate()
        GoToState("")
        bmlUtility.LogTrace("ViolationCheck_Armor")
        
        if !bmlmcm.isArmorLicenseFeatureEnabled && !bmlmcm.isClothingLicenseFeatureEnabled && !bmlmcm.isBikiniLicenseFeatureEnabled
            return
        endIf
    
        if !licenses.isArmorViolation
            Form[] equippedObjects = SPE_Utility.IntersectArray_Form(PO3_SKSEFunctions.AddItemsOfTypeToArray(licenses.PlayerActorRef, 26, false, false, true), bmlUtility.BM_PotentialViolations.ToArray())
            if (equippedObjects)
                licenses.isArmorViolation = true
                bmlUtility.LogTrace("Detected Armor Violation: " + equippedObjects)
            endIf
        endIf
    
        ; Check for uninsured violation
        if !licenses.isUninsuredViolation && !licenses.isInsured
            if licenses.isArmorViolation && ((bmlmcm.isArmorLicenseFeatureEnabled && licenses.hasArmorLicense) || (bmlmcm.isBikiniLicenseFeatureEnabled && licenses.hasBikiniLicense) || (bmlmcm.isClothingLicenseFeatureEnabled && licenses.hasClothingLicense))
                bmlUtility.LogTrace("Detected Uninsured Violation: Armor Type")
                licenses.isUninsuredViolation = true
            endIf
        endIf
    
        ; Collect Violations
        if licenses.isArmorViolation
            RegisterForSingleUpdate(1.0)
        endIf
    EndEvent
EndState
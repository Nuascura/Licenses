Scriptname BM_Licenses_ViolationCheck_Armor extends Quest  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

Auto State Run
    Event OnUpdate()
        GoToState("")
        bmlUtility.LogTrace("ViolationCheck_Armor")

        Form[] equippedObjects = SPE_Utility.IntersectArray_Form(PO3_SKSEFunctions.AddItemsOfTypeToArray(licenses.PlayerActorRef, 26, false, false, true), bmlUtility.BM_PotentialViolations.ToArray())
        if equippedObjects
            Form[] equippedArmor = SPE_Utility.FilterFormsByKeyword(equippedObjects, licenses.ItemTypeArmor, false, false)
            if equippedArmor
                if !licenses.hasBikiniExemption && licenses.hasArmorLicense
                    licenses.isBikiniViolation = true
                    bmlUtility.LogTrace("Detected Bikini Armor Violation: " + SPE_Utility.FilterFormsByKeyword(equippedObjects, licenses.ItemTypeBikini, false, false))
                else
                    licenses.isArmorViolation = true
                    bmlUtility.LogTrace("Detected Armor Violation: " + equippedArmor)
                endIf
            endIf
            Form[] equippedClothing = SPE_Utility.FilterFormsByKeyword(equippedObjects, licenses.ItemTypeClothing, false, false)
            if equippedClothing
                if !licenses.hasBikiniExemption && licenses.hasClothingLicense
                    licenses.isBikiniViolation = true
                    bmlUtility.LogTrace("Detected Bikini Clothing Violation: " + SPE_Utility.FilterFormsByKeyword(equippedObjects, licenses.ItemTypeBikini, false, false))
                else
                    licenses.isClothingViolation = true
                    bmlUtility.LogTrace("Detected Clothing Violation: " + equippedClothing)
                endIf
            endIf
        endIf
    
        ; Check for uninsured violation
        if !licenses.isUninsuredViolation && !licenses.isInsured
            if licenses.isArmorViolation || licenses.isClothingViolation || licenses.isBikiniViolation
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
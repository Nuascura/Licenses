Scriptname BM_Licenses_ViolationCheck_Armor extends Quest  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

Auto State Run
    Event OnUpdate()
        GoToState("")
        bmlUtility.LogTrace("ViolationCheck_Armor")

        Bool Uninsured = False

        Form[] equippedObjects = SPE_Utility.IntersectArray_Form(PO3_SKSEFunctions.AddItemsOfTypeToArray(licenses.PlayerActorRef, 26, false, false, true), bmlUtility.BM_PotentialViolations.ToArray())
        if equippedObjects
            Form[] equippedArmor = SPE_Utility.FilterFormsByKeyword(equippedObjects, licenses.ItemTypeArmor, false, false)
            if equippedArmor
                if licenses.hasArmorLicense && (!licenses.hasBikiniExemption || licenses.hasBikiniLicense)
                    Form[] equippedBikini = SPE_Utility.FilterFormsByKeyword(equippedArmor, licenses.ItemTypeBikini, false, false)
                    if equippedBikini
                        licenses.isBikiniViolation = 2
                        if licenses.hasBikiniExemption
                            Uninsured = True
                        endIf
                        bmlUtility.LogTrace("Detected Bikini Violation (Armor Exemption): " + equippedBikini)
                    else
                        licenses.isBikiniViolation = 1
                        if licenses.hasBikiniLicense
                            Uninsured = True
                        endIf
                        bmlUtility.LogTrace("Detected Bikini Violation (Armor Restriction): " + equippedArmor)
                    endIf
                else
                    licenses.isArmorViolation = 1
                    if licenses.hasArmorLicense
                        Uninsured = True
                    endIf
                    bmlUtility.LogTrace("Detected Armor Violation: " + equippedArmor)
                endIf
            endIf
            Form[] equippedClothing = SPE_Utility.FilterFormsByKeyword(equippedObjects, licenses.ItemTypeClothing, false, false)
            if equippedClothing
                if licenses.hasClothingLicense && (!licenses.hasBikiniExemption || licenses.hasBikiniLicense)
                    Form[] equippedBikini = SPE_Utility.FilterFormsByKeyword(equippedClothing, licenses.ItemTypeBikini, false, false)
                    if equippedBikini
                        licenses.isBikiniViolation = 2
                        if licenses.hasBikiniExemption
                            Uninsured = True
                        endIf
                        bmlUtility.LogTrace("Detected Bikini Violation (Clothing Exemption): " + equippedBikini)
                    else
                        licenses.isBikiniViolation = 1
                        if licenses.hasBikiniLicense
                            Uninsured = True
                        endIf
                        bmlUtility.LogTrace("Detected Bikini Violation (Clothing Restriction): " + equippedClothing)
                    endIf
                else
                    licenses.isClothingViolation = 1
                    if licenses.hasClothingLicense
                        Uninsured = True
                    endIf
                    bmlUtility.LogTrace("Detected Clothing Violation: " + equippedClothing)
                endIf
            endIf
        endIf
    
        ; Check for uninsured violation
        if !licenses.isUninsuredViolation && !licenses.isInsured
            if Uninsured
                bmlUtility.LogTrace("Detected Uninsured Violation: Armor Type")
                licenses.isUninsuredViolation = 1
            endIf
        endIf
    
        ; Collect Violations
        if (licenses.isArmorViolation || licenses.isClothingViolation || licenses.isBikiniViolation)
            RegisterForSingleUpdate(1.0)
        endIf
    EndEvent
EndState
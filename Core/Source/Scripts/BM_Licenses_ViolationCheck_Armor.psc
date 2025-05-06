Scriptname BM_Licenses_ViolationCheck_Armor extends Quest  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

Auto State Run
    Event OnUpdate()
        GoToState("")
        bmlUtility.LogTrace("ViolationCheck_Armor")

        Bool hasViolation = GetViolation()
    
        ; Check for uninsured violation
        if !licenses.isUninsuredViolation && !licenses.isInsured
            if hasViolation
                bmlUtility.LogTrace("Detected Uninsured Violation: Armor Type")
                licenses.isUninsuredViolation = true
            endIf
        endIf
    
        ; Collect Violations
        if hasViolation
            RegisterForSingleUpdate(1.0)
        endIf
    EndEvent
EndState

Bool Function GetViolation()
    Form[] equippedObjects = SPE_Utility.IntersectArray_Form(PO3_SKSEFunctions.AddItemsOfTypeToArray(licenses.PlayerActorRef, 26, false, false, true), bmlUtility.BM_PotentialViolations.ToArray())
    if equippedObjects
        Form[] equippedArmor = SPE_Utility.FilterFormsByKeyword(equippedObjects, licenses.ItemTypeArmor, false, false)
        if equippedArmor
            if licenses.hasArmorLicense && (!licenses.hasBikiniExemption || licenses.hasBikiniLicense)
                Form[] equippedBikini = SPE_Utility.FilterFormsByKeyword(equippedArmor, licenses.ItemTypeBikini, false, false)
                if equippedBikini
                    licenses.isBikiniViolation = 2
                    bmlUtility.LogTrace("Detected Bikini Violation (Armor Exemption): " + equippedBikini)
                else
                    licenses.isBikiniViolation = 1
                    bmlUtility.LogTrace("Detected Bikini Violation (Armor Restriction): " + equippedArmor)
                endIf
            else
                licenses.isArmorViolation = true
                bmlUtility.LogTrace("Detected Armor Violation: " + equippedArmor)
            endIf
        endIf
        Form[] equippedClothing = SPE_Utility.FilterFormsByKeyword(equippedObjects, licenses.ItemTypeClothing, false, false)
        if equippedClothing
            if licenses.hasClothingLicense && (!licenses.hasBikiniExemption || licenses.hasBikiniLicense)
                Form[] equippedBikini = SPE_Utility.FilterFormsByKeyword(equippedClothing, licenses.ItemTypeBikini, false, false)
                if equippedBikini
                    licenses.isBikiniViolation = 2
                    bmlUtility.LogTrace("Detected Bikini Violation (Clothing Exemption): " + equippedBikini)
                else
                    licenses.isBikiniViolation = 1
                    bmlUtility.LogTrace("Detected Bikini Violation (Clothing Restriction): " + equippedClothing)
                endIf
            else
                licenses.isClothingViolation = true
                bmlUtility.LogTrace("Detected Clothing Violation: " + equippedClothing)
            endIf
        endIf
    endIf
    return (licenses.isArmorViolation || licenses.isClothingViolation || licenses.isBikiniViolation)
EndFunction
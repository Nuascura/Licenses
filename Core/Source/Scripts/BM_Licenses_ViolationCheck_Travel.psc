Scriptname BM_Licenses_ViolationCheck_Travel extends Quest  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

Auto State Run
    Event OnUpdate()
        GoToState("")
        bmlUtility.LogTrace("ViolationCheck_Travel")

        if !bmlmcm.isTravelPermitFeatureEnabled
            return
        endIf
    
        if !licenses.isTravelViolation
    
            ; Return conditions
            if IsAccompanied()
                bmlUtility.savedLoc = None
                bmlUtility.savedSpace = None
                return
            elseIf bmlmcm.isLimitToCitySpaceEnabled && bmlUtility.BM_LicensesIgnoreWorldspace.HasForm(bmlUtility.currSpace)
                return
            endIf
            
            ; Main module body
            if !licenses.hasTravelPermit
                if !bmlUtility.savedLoc
                    if licenses.isInCity && bmlUtility.currLoc.IsSameLocation(bmlUtility.lastLoc, Keyword.GetKeyword("LocTypeCity")) \
                    || licenses.isInTown && bmlUtility.currLoc.IsSameLocation(bmlUtility.lastLoc, Keyword.GetKeyword("LocTypeTown"))
                    ; if there is no saved location, set current City or Town location as saved location
                        bmlUtility.savedLoc = bmlUtility.lastLoc
                        bmlUtility.savedSpace = bmlUtility.lastSpace
                        bmlUtility.GameMessage(licenses.MessageTravelLocated)
                        return
                    endIf
                    bmlUtility.LogTrace("ViolationCheck_Travel: Licenses couldn't satisfy conditions to mark a saved location or worldspace")
                else
                    if bmlUtility.currLoc
                        if licenses.isInCity && bmlUtility.currLoc.IsSameLocation(bmlUtility.savedLoc, Keyword.GetKeyword("LocTypeCity")) \
                        && (!bmlmcm.isLimitToCitySpaceEnabled || (bmlUtility.savedSpace == bmlUtility.lastSpace))
                            ; check city or worldspace against saved location or worldspace
                            bmlUtility.LogTrace("Found player in marked city.")
                            return
                        elseIf licenses.isInTown && bmlUtility.currLoc.IsSameLocation(bmlUtility.savedLoc, Keyword.GetKeyword("LocTypeTown"))
                            ; check town against saved location
                            bmlUtility.LogTrace("Found player in marked town.")
                            return
                        endIf
                    endIf
                    bmlUtility.LogTrace("ViolationCheck_Travel: Licenses found player outside a marked location or worldspace")
                endIf
                bmlUtility.LogTrace("Detected Travel Violation: Missing Travel Permit")
                SetTravelViolation()
            endIf
        endIf
    
        ; Collect Violations
        if licenses.isTravelViolation
            RegisterForSingleUpdate(1.0)
        endIf
    EndEvent
EndState

Function SetTravelViolation()
    licenses.isTravelViolation = true

    bmlUtility.LogTrace("Debug: savedLoc (" + bmlUtility.savedLoc + "), lastLoc (" + bmlUtility.lastLoc + "), currLoc (" + bmlUtility.currLoc + ")")
    bmlUtility.LogTrace("Debug: savedSpace (" + bmlUtility.savedSpace + "), lastSpace (" + bmlUtility.lastSpace + "), currSpace (" + bmlUtility.currSpace + ")")

    bmlUtility.savedLoc = none
    bmlUtility.savedSpace = none
    bmlUtility.GameMessage(licenses.MessageTravelMissing)
EndFunction

bool Function IsAccompanied()
    if (bmlmcm.BM_FollowerMale.GetValue() as bool) || (bmlmcm.BM_FollowerFemale.GetValue() as bool)
        Actor[] PlayerFollowers = PO3_SKSEFunctions.GetPlayerFollowers()
        int arrayLength = PlayerFollowers.Length
        int i = 0
        while i < arrayLength
            if (PlayerFollowers[i].GetBaseObject() as ActorBase).GetSex() == 0 && (bmlmcm.BM_FollowerMale.GetValue() as bool) \
            || (PlayerFollowers[i].GetBaseObject() as ActorBase).GetSex() == 1 && (bmlmcm.BM_FollowerFemale.GetValue() as bool)
                return true
            endIf
            i += 1
        endWhile
    endIf
    return false
EndFunction
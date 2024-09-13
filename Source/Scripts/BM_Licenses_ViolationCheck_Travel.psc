Scriptname BM_Licenses_ViolationCheck_Travel extends Quest  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

Auto State Default
    Event OnUpdate()
        bmlUtility.LogTrace("ViolationCheck_Travel")
        ViolationCheck_Travel()
    EndEvent
EndState

Function ViolationCheck_Travel()
    GoToState("")
    if !bmlmcm.isTravelPermitFeatureEnabled
        return
    endIf

    Actor playerActor = licenses.playerRef.GetActorRef()

    if !licenses.isTravelViolation
        ; Return condition
        if licenses.isAccompanied
            bmlUtility.savedLoc = None
            bmlUtility.savedSpace = None
            return
        elseIf bmlmcm.isLimitToCitySpaceEnabled && bmlUtility.BM_LicensesIgnoreWorldspace.HasForm(bmlUtility.currSpace)
            return
        endIf
        
        ; Main module body
        if !licenses.hasTravelPermit
            if !bmlUtility.savedLoc
                if (licenses.isInCity || licenses.isInTown); if there is no saved location, set current City or Town location as saved location
                    bmlUtility.savedLoc = bmlUtility.lastLoc
                    bmlUtility.savedSpace = bmlUtility.lastSpace
                    bmlUtility.GameMessage(licenses.MessageTravelLocated)
                elseIf playerActor.IsInInterior() && bmlUtility.currLoc.IsSameLocation(bmlUtility.lastLoc, Keyword.GetKeyword("LocTypeHabitationHasInn"))
                    bmlUtility.LogTrace("Holding off on flagging Travel Violation because player may be in a safe interior.")
                    return
                else
                    ; likely here when travel permit has expired
                    ; violation will immediately occur if player is caught by guard outside settlement, so will need to find a location transfer event
                    bmlUtility.LogTrace("Detected Travel Violation: Licenses did not find a saved location and/or worldspace")
                    SetTravelViolation()
                endIf
            else
                if licenses.isInCity && bmlUtility.currLoc
                    if bmlUtility.currLoc.IsSameLocation(bmlUtility.savedLoc, Keyword.GetKeyword("LocTypeCity")) && (!bmlmcm.isLimitToCitySpaceEnabled || bmlUtility.savedSpace == bmlUtility.lastSpace)
                        ; check city or worldspace against saved location or worldspace
                        bmlUtility.LogTrace("Found player in marked city.")
                        return
                    else
                        bmlUtility.LogTrace("Detected Travel Violation: Licenses found player outside a marked city location or worldspace")
                        SetTravelViolation()
                    endIf
                elseIf licenses.isInTown && bmlUtility.currLoc
                    if bmlUtility.currLoc.IsSameLocation(bmlUtility.savedLoc, Keyword.GetKeyword("LocTypeTown"))
                        ; check town against saved location
                        bmlUtility.LogTrace("Found player in marked town.")
                        return
                    else
                        bmlUtility.LogTrace("Detected Travel Violation: Licenses found player outside a marked town location")
                        SetTravelViolation()
                    endIf
                else
                    bmlUtility.LogTrace("Detected Travel Violation: Licenses found player outside a marked location or worldspace")
                    SetTravelViolation()
                endIf
            endIf
        endIf
    endIf

    ; Collect Violations
    if licenses.isTravelViolation
        RegisterForSingleUpdate(1.0)
    endIf
EndFunction

Function SetTravelViolation()
    licenses.isTravelViolation = true

    bmlUtility.LogTrace("Debug: savedLoc (" + bmlUtility.savedLoc + "), lastLoc (" + bmlUtility.lastLoc + "), currLoc (" + bmlUtility.currLoc + ")")
    bmlUtility.LogTrace("Debug: savedSpace (" + bmlUtility.savedSpace + "), lastSpace (" + bmlUtility.lastSpace + "), currSpace (" + bmlUtility.currSpace + ")")

    bmlUtility.savedLoc = none
    bmlUtility.savedSpace = none
    bmlUtility.GameMessage(licenses.MessageTravelMissing)
EndFunction
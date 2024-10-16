Scriptname BM_Licenses_ViolationCheck_DD extends Quest  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

import BM_API_DD

Auto State Default
    Event OnUpdate()
        bmlUtility.LogTrace("ViolationCheck_DD")
        ViolationCheck_DD()
    EndEvent
EndState

Function ViolationCheck_DD()
    GoToState("")
    if !bmlmcm.isCollarExemptionFeatureEnabled
        return
    endIf

    Actor playerActor = licenses.playerRef.GetActorRef()

    if bmlmcm.DeviousDevices_State
        if !licenses.isCollarViolation && !licenses.hasCollarExemption
            if !BM_API_DD.hasCollarEquipped(playerActor)
                licenses.isCollarViolation = true
                bmlUtility.LogTrace("Detected Collar Violation: Missing Collar")
            endIf
        endIf
    endIf

    ; Collect Violations
    if licenses.isCollarViolation
        RegisterForSingleUpdate(1.0)
    endIf
EndFunction
Scriptname BM_Licenses_ViolationCheck_DD extends Quest  

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

Auto State Run
    Event OnUpdate()
        GoToState("")
        bmlUtility.LogTrace("ViolationCheck_DD")
        
        if !bmlmcm.isCollarExemptionFeatureEnabled
            return
        endIf
    
        if bmlmcm.DeviousDevices_State
            if !licenses.isCollarViolation && !licenses.hasCollarExemption
                if !(bmlUtility.BM_IsPlayerCollared.GetValue() as bool)
                    licenses.isCollarViolation = true
                    bmlUtility.LogTrace("Detected Collar Violation: Missing Collar")
                endIf
            endIf
        endIf
    
        ; Collect Violations
        if licenses.isCollarViolation
            RegisterForSingleUpdate(1.0)
        endIf
    EndEvent
EndState
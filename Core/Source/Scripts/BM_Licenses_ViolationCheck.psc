Scriptname BM_Licenses_ViolationCheck extends Quest  

BM_Licenses_Utility Property bmlUtility Auto

Auto State Start
    Event OnBeginState()
        bmlUtility.LogTrace("ViolationCheck")
        bmlUtility.BM_PotentialViolations.Revert()
        bmlUtility.BM_PotentialViolations.AddForms(bmlUtility.ScanEquippedItems_Base(bmlUtility.licenses.PlayerActorRef))
        bmlUtility.BM_PotentialViolations_Ench.Revert()
        bmlUtility.BM_PotentialViolations_Ench.AddForms(bmlUtility.ScanEquippedItems_Ench(bmlUtility.licenses.PlayerActorRef))
        RegisterForSingleUpdate(0.1)
    EndEvent
    Event OnUpdate()
        GoToState("Run")
    EndEvent
EndState

State Run
    Event OnBeginState()
        SendModEvent("BM-LPO_ViolationCheck")
        RegisterForSingleUpdate(5.0)
        bmlUtility.LogTrace("Violation Check time-out in 5 seconds.")
    EndEvent
    Event OnUpdate()
        GoToState("End")
        bmlUtility.LogTrace("Ending Violation Check.")
    EndEvent
EndState

State End
    Event OnBeginState()
        self.UnregisterForUpdate()
        bmlUtility.AggregateViolations()
        self.stop()
    EndEvent
    Event OnUpdate()
    EndEvent
EndState
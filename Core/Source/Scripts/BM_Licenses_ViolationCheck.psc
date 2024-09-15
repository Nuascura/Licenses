Scriptname BM_Licenses_ViolationCheck extends Quest  

BM_Licenses_Utility Property bmlUtility Auto

Function Setup()
    RegisterForSingleUpdate(0.001)
EndFunction

Auto State Default
    Event OnUpdate()
        bmlUtility.LogTrace("ViolationCheck")
        ViolationCheck()
    EndEvent
EndState

Function ViolationCheck()
    GoToState("")
    bmlUtility.LogTrace("Violation Check time-out in 5 seconds.")
    SendModEvent("BM-LPO_ViolationCheck")
    RegisterForSingleUpdate(5.0)
EndFunction

Event OnUpdate()
    bmlUtility.LogTrace("Violation Check expired.")
    bmlUtility.AggregateViolations()
    self.stop()
EndEvent
Scriptname BM_Licenses_Bounty extends Quest

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
ReferenceAlias Property playerRef auto
ReferenceAlias Property guardRef_1 auto
ReferenceAlias Property guardRef_2 auto
ReferenceAlias Property guardRef_3 auto
ReferenceAlias Property guardRef_4 auto
ReferenceAlias Property guardRef_5 auto

Actor Speaker

Bool Function Setup()
    if guardRef_1.GetActorRef() ; aliases are filled sequentially
        RegisterForSingleUpdate(30.0)
        SendModEvent("BM-LPO_BountyStart")
        RegisterForModEvent("BM-LPO_ConfrontationStart", "LPO_OnConfrontationStart")
        bmlUtility.LogTrace("Alias setup valid. Running periodic bounty update event.")
        return true
    else
        bmlUtility.LogTrace("Alias setup invalid. Stopping bounty quest.")
        return false
    endIf
EndFunction

Event OnUpdate()
    CheckAliasValidity()
endEvent

Function CheckAliasValidity()
    if !IsAliasArrayValid()
        bmlUtility.LogTrace("LPO Bounty: Alias setup invalid. Terminating...")
        Terminate()
    else
        ; refresh to capture quest if it doesn't stop
        RegisterForSingleUpdate(10.0) 
    endIf
EndFunction

Function Terminate()
    licenses.ResetViolations(-1)
    bmlUtility.bmPlayer.CheckViolations()
    StopQuest()
EndFunction

State Walkaway
    Function Terminate()
        licenses.FinishConfrontation(Speaker, -1)
        StopQuest()
    EndFunction
EndState

Function StopQuest()
    SendModEvent("BM-LPO_BountyEnd")
    self.stop()
EndFunction

Bool Function IsAliasArrayValid()
    ; we can drastically simplify the logic of a while loop by casting actor references as booleans, where NONE is false and otherwise filled is true.
    return guardRef_1.GetActorRef() || guardRef_2.GetActorRef() || guardRef_3.GetActorRef() || guardRef_4.GetActorRef() || guardRef_5.GetActorRef()
EndFunction

Event LPO_OnConfrontationStart(Form akForm1)
    Actor ConfrontingEnforcer = akForm1 as actor
    if ConfrontingEnforcer
        Speaker = ConfrontingEnforcer
        GoToState("Walkaway")
        UnregisterForAllModEvents()
        UnregisterForUpdate()
    endIf
EndEvent
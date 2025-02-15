Scriptname BM_Licenses_Bounty extends Quest

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
ReferenceAlias Property playerRef auto
ReferenceAlias Property guardRef_1 auto
ReferenceAlias Property guardRef_2 auto
ReferenceAlias Property guardRef_3 auto
ReferenceAlias Property guardRef_4 auto
ReferenceAlias Property guardRef_5 auto
GlobalVariable Property BM_D_ForceArrest Auto
GlobalVariable Property BM_D_RestrictWalkaway Auto

Actor Speaker

Bool Function Setup()
    if guardRef_1.GetActorRef() ; aliases are filled sequentially
        RegisterForSingleUpdate(30.0)
        SendModEvent("BM-LPO_BountyStart")
        RegisterForModEvent("BM-LPO_ConfrontationStart", "LPO_OnConfrontationStart")
        RegisterForModEvent("BM-LPO_ConfrontationEnd", "LPO_OnConfrontationEnd")
        RegisterForModEvent("BM-LPO_ConfrontationWalkaway", "LPO_OnConfrontationWalkaway")
        bmlUtility.LogTrace("Alias setup valid. Running periodic bounty update event.")
        return true
    else
        bmlUtility.LogTrace("Alias setup invalid. Stopping bounty quest.")
        return false
    endIf
EndFunction

; -----

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

; -----

State Walkaway
    Function CheckAliasValidity()
        if !(BM_D_RestrictWalkaway.GetValue() as bool)
            UnregisterForAllModEvents()
            bmlUtility.LogTrace("LPO Bounty: Walkaway state expired. Terminating...")
            Terminate()
        endIf
    EndFunction
    Function Terminate()
        licenses.FinishConfrontation(Speaker, -1)
        StopQuest()
    EndFunction
EndState

; -----

State WalkawayNoViolation
    Function CheckAliasValidity()
        Terminate()
    EndFunction
    Function Terminate()
        StopQuest()
    EndFunction
EndState

; -----

Event OnUpdate()
    CheckAliasValidity()
endEvent

Function StopQuest()
    BM_D_RestrictWalkaway.SetValue(0.0)
    BM_D_ForceArrest.SetValue(0.0)
    SendModEvent("BM-LPO_BountyEnd")
    self.stop()
EndFunction

Bool Function IsAliasArrayValid()
    ; we can drastically simplify the logic of a while loop by casting actor references as booleans, where NONE is false and otherwise filled is true.
    return guardRef_1.GetActorRef() || guardRef_2.GetActorRef() || guardRef_3.GetActorRef() || guardRef_4.GetActorRef() || guardRef_5.GetActorRef()
EndFunction

Event LPO_OnConfrontationStart(Form akForm1)
    Actor ConfrontingEnforcer = akForm1 as actor
    if ConfrontingEnforcer && GetState() == ""
        Speaker = ConfrontingEnforcer
        GoToState("Walkaway")
        UnregisterForModEvent("BM-LPO_ConfrontationStart")
        UnregisterForUpdate()
    endIf
EndEvent

Event LPO_OnConfrontationWalkaway(Form akForm1)
    if GetState() == "WalkawayNoViolation"
        RegisterForSingleUpdate(0.1)
    else
        RegisterForSingleUpdate(5.0)
    endIf
EndEvent

Event LPO_OnConfrontationEnd(int endType)
    self.UnregisterForUpdate()
    GotoState("WalkawayNoViolation")
EndEvent
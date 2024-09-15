Scriptname BM_Licenses_Bounty extends Quest

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
ReferenceAlias Property playerRef auto
ReferenceAlias Property guardRef_1 auto
ReferenceAlias Property guardRef_2 auto
ReferenceAlias Property guardRef_3 auto
ReferenceAlias Property guardRef_4 auto
ReferenceAlias Property guardRef_5 auto

Bool Function Setup()
    if guardRef_1.GetActorRef() ; aliases are filled sequentially
        RegisterForSingleUpdate(30.0)
        SendModEvent("BM-LPO_BountyStart")
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
    bmlUtility.LogTrace("Running bounty quest alias validity check.")
    if !IsAliasArrayValid()
        bmlUtility.LogTrace("Bounty quest lost all previously-filled aliases. Stopping bounty quest.")
        licenses.ResetViolations(-1)
        bmlUtility.bmPlayer.CheckViolations()
        SendModEvent("BM-LPO_BountyEnd")
        self.stop()
    else
        ; refresh to capture quest if it doesn't stop
        RegisterForSingleUpdate(10.0) 
    endIf
EndFunction

Bool Function IsAliasArrayValid()
    ; we can drastically simplify the logic of a while loop by casting actor references as booleans, where NONE is false and otherwise filled is true.
    if guardRef_1.GetActorRef() || guardRef_2.GetActorRef() || guardRef_3.GetActorRef() || guardRef_4.GetActorRef() || guardRef_5.GetActorRef()
        return true
    else
        return false
    endIf
EndFunction
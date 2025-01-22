Scriptname BM_Licenses_Bounty_ClosestGuard extends ReferenceAlias  

BM_Licenses_Bounty Property bmlBounty auto
Package Property BM_ClosestGuard_ForceGreet  Auto  

Actor enforcer

Event OnInit()
    enforcer = self.GetActorRef()
    if enforcer
        RegisterForModEvent("BM-LPO_ConfrontationStart", "LPO_OnConfrontationStart")
        RegisterForSingleUpdate(10.0)
    endIf
EndEvent

Event OnUpdate()
    if !enforcer.IsInDialogueWithPlayer() && (enforcer.GetDistance(bmlBounty.playerRef.GetActorRef()) > 5000 || PO3_SKSEFunctions.GetRunningPackage(enforcer) != BM_ClosestGuard_ForceGreet)
        self.clear()
        bmlBounty.RegisterForSingleUpdate(1.0)
    else
        RegisterForSingleUpdate(10.0)
    endIf
EndEvent

Event LPO_OnConfrontationStart(Form akForm1)
    UnregisterForAllModEvents()
    UnregisterForUpdate()
EndEvent
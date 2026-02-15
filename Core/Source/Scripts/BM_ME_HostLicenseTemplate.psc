Scriptname BM_ME_HostLicenseTemplate extends activemagiceffect  

Actor Property TargetActor Auto
String Property TargetString Auto
Int Property TargetInteger Auto
Book Property TargetBook Auto
BM_ME_HostLicenseTemplateBridge TemplateBridge

Event OnEffectStart(Actor akTarget, Actor akCaster)
    TargetActor = akTarget
    TemplateBridge = (self as activemagiceffect) as BM_ME_HostLicenseTemplateBridge
    RegisterEvents()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    EndLicense()
EndEvent

State InventoryInactive
    Event OnItemAdded(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
        Utility.Wait(0.1)
        if TargetActor.GetItemCount(TargetBook)
            TemplateBridge.PushStatusUpdate(true, TargetInteger)
            GoToState("InventoryActive")
        endIf
    EndEvent
EndState

State InventoryActive
    Event OnItemRemoved(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
        Utility.Wait(0.1)
        if TargetActor.GetItemCount(TargetBook) < 1
            TemplateBridge.PushStatusUpdate(false, TargetInteger)
            GoToState("InventoryInactive")
        endIf
    EndEvent
EndState

Event OnDeath(Actor akKiller)
    EndLicense()
EndEvent

Event LPO_OnActivate(string eventName, string strArg, float numArg, form sender)
    StartLicense()
EndEvent

Event LPO_OnDeactivate(string eventName, string strArg, float numArg, form sender)
    EndLicense()
EndEvent

; ------------------------------

Function StartLicense()
    TemplateBridge.GoToState("LicenseBridge_" + TargetInteger)
    if TargetActor.getItemCount(TargetBook) == 0
        GoToState("InventoryInactive")
        Utility.Wait(0.5)
        TargetActor.addItem(TargetBook, 1)
    else
        GoToState("InventoryActive")
    endIf
    
EndFunction

Function EndLicense()
    GoToState("")
    if TargetActor.getItemCount(TargetBook) > 0
        TargetActor.removeItem(TargetBook, 1, true)
    endIf
    TemplateBridge.GoToState("")
    
    ;TargetActor.RemoveSpell(PO3_SKSEFunctions.GetActiveEffectSpell(self) as spell)
EndFunction

Function RegisterEvents()
    AddInventoryEventFilter(TargetBook)
    RegisterForModEvent("BM-LPO_" + TargetString + "_" + TargetActor.GetFormID() + "_Activate", "LPO_OnActivate")
    RegisterForModEvent("BM-LPO_" + TargetString + "_" + TargetActor.GetFormID() + "_Deactivate", "LPO_OnDeactivate")
EndFunction


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

    TemplateBridge.GoToState("LicenseBridge_" + TargetInteger)
    If TemplateBridge.IsLicenseActive()
        StartLicense(false)
    EndIf
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

Function StartLicense(Bool abAddItem = True)
    if TargetActor.getItemCount(TargetBook) == 0
        GoToState("InventoryInactive")
        if abAddItem
            Utility.Wait(0.5)
            TargetActor.addItem(TargetBook, 1)
        endIf
    else
        GoToState("InventoryActive")
    endIf
EndFunction

Function EndLicense()
    if TargetActor.getItemCount(TargetBook) > 0
        TargetActor.removeItem(TargetBook, 1, true)
        Utility.Wait(0.5)
    endIf
    GoToState("")
EndFunction

Function RegisterEvents()
    AddInventoryEventFilter(TargetBook)
    RegisterForModEvent("BM-LPO_" + TargetString + "_" + TargetActor.GetFormID() + "_Activate", "LPO_OnActivate")
    RegisterForModEvent("BM-LPO_" + TargetString + "_" + TargetActor.GetFormID() + "_Deactivate", "LPO_OnDeactivate")
EndFunction


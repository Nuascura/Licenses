Scriptname BM_ME_HostLicenseTemplate extends activemagiceffect  

import BM_API

BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto

Actor Property TargetActor Auto
String Property TargetString Auto
Int Property TargetInteger Auto
Book Property TargetBook Auto
FormList Property TargetHolds Auto
BM_ME_HostLicenseTemplateBridge TemplateBridge

Event OnEffectStart(Actor akTarget, Actor akCaster)
    TargetActor = akTarget
    TemplateBridge = (self as activemagiceffect) as BM_ME_HostLicenseTemplateBridge
    RegisterEvents()

    TemplateBridge.GoToState("LicenseBridge_" + TargetInteger)
    If TemplateBridge.IsLicenseActive()
        StartLicense(false)
    ElseIf !bmlmcm.LicenseTerritories
        EndLicense()
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
    else
        GoToState("InventoryActive")
    endIf
EndFunction

Function EndLicense()
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", TargetInteger)
    GoToState("")
    TargetHolds.RemoveAddedForm(bmlUtility.enforcementLoc)
EndFunction

Function RegisterEvents()
    AddInventoryEventFilter(TargetBook)
    Int FID = TargetActor.GetFormID()
    RegisterForModEvent("BM-LPO_" + TargetString + "_" + FID + "_Activate", "LPO_OnActivate")
    RegisterForModEvent("BM-LPO_" + TargetString + "_" + FID + "_Deactivate", "LPO_OnDeactivate")
EndFunction
Scriptname BM_BarterController extends ReferenceAlias  
{ Primary Controller - Sell }

import PO3_SKSEFunctions
import SPE_Actor
import UI

Actor Vendor
Faction VendorFaction
ObjectReference VendorChest

BM_Barter Property bmBarter Auto
BM_Licenses_Utility Property bmlUtility Auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses Property licenses auto
BM_Player Property bmPlayer auto

Actor Property PlayerRef Auto
Faction[] Property WhitelistedFactions  Auto
FormList Property BM_PotentialPlayerBarterViolations  Auto
FormList Property BM_PotentialVendorBarterViolations  Auto
FormList Property BM_PotentialBarterExclusions Auto
MiscObject Property Gold001  Auto 
FormList Property BM_Empty Auto

Event OnPlayerLoadGame()
    OnLoad()
EndEvent

Function OnLoad()
    RegisterForMenu("BarterMenu")
EndFunction

Event OnMenuOpen(String MenuName)
    FillGlobalProperties()

    If IsFailedCondition()
        Return
    EndIf

    FillFormLists()
    
    If !licenses.hasTradingLicense
        GoToState("Active_General")
    ElseIf bmlmcm.ValidateEquipmentTrade
        GoToState("Active_Selective")
    Endif

    If GetState()
        bmBarter.GoToState("Active_Selective")
    EndIf
EndEvent

Event OnMenuClose(String MenuName)
    GoToState("")
    bmBarter.GoToState("")

    Utility.Wait(1.0)

    ClearGlobalProperties()
    ClearFormLists()
    RemoveAllInventoryEventFilters()
    AddInventoryEventFilter(BM_Empty)
    bmBarter.AddInventoryEventFilter(BM_Empty)
EndEvent

State Active_Selective
    Event OnBeginState()
        RemoveAllInventoryEventFilters()
        AddInventoryEventFilter(BM_PotentialPlayerBarterViolations)
    EndEvent

    Event OnItemRemoved(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
        AddInventoryEventFilter(BM_Empty)
        bmlUtility.LogTrace("OnItemRemoved: Trading Violation (Sell, Selective) Found")
        RegisterForSingleUpdate(1.0)
    EndEvent

    Event OnUpdate()
        if !licenses.isTradingViolation
            licenses.isTradingViolation = True
            bmPlayer.CheckViolations()
        endIf
        If IsMenuOpen("BarterMenu")
            GoToState("Active_General")
        EndIf
    EndEvent

    Event OnEndState()
        UnregisterForUpdate()
    EndEvent
EndState

State Active_General
    Event OnBeginState()
        RemoveAllInventoryEventFilters()
        AddInventoryEventFilter(Gold001)
    EndEvent

    Event OnItemAdded(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
        AddInventoryEventFilter(BM_Empty)
        bmlUtility.LogTrace("OnItemRemoved: Trading Violation (Sell, General) Found")
        if !licenses.isTradingViolation
            licenses.isTradingViolation = True
            bmPlayer.CheckViolations()
        endIf
        RegisterForSingleUpdate(10.0)
    EndEvent

    Event OnUpdate()
        If IsMenuOpen("BarterMenu")
            RemoveAllInventoryEventFilters()
            AddInventoryEventFilter(Gold001)
        EndIf
    EndEvent

    Event OnEndState()
        UnregisterForUpdate()
    EndEvent
EndState

Function FillFormLists()
    BM_PotentialPlayerBarterViolations.AddForms(bmlUtility.GetViolatingItemsAll(PlayerRef, false))
    BM_PotentialVendorBarterViolations.AddForms(bmlUtility.GetViolatingItemsAll(VendorChest, false))
    BM_PotentialBarterExclusions.AddForms(ScanVendor())
EndFunction

Function ClearFormLists()
    BM_PotentialPlayerBarterViolations.Revert()
    BM_PotentialVendorBarterViolations.Revert()
    BM_PotentialBarterExclusions.Revert()
EndFunction

Form[] Function ScanVendor()
    Form[] PotentialForms = SPE_ObjectRef.GetItemsByKeyword(VendorChest, licenses.KeywordBarterItem, false)
    PotentialForms = bmlUtility.FilterSensitive(PotentialForms)
    return PotentialForms
EndFunction

Function FillGlobalProperties()
    Vendor = GetPlayerSpeechTarget()
    VendorFaction = GetVendorFaction(Vendor)
    If VendorFaction
        VendorChest = GetVendorFactionContainer(VendorFaction)
    EndIf
    If !VendorChest
        VendorChest = Vendor
    EndIf
EndFunction

Function ClearGlobalProperties()
    Vendor = NONE
    VendorFaction = NONE
    VendorChest = NONE
EndFunction

Bool Function IsFailedCondition()
    return ((bmlmcm.isLimitToCityEnabled && !licenses.isInCity) \
    && (bmlmcm.isLimitToTownEnabled && !licenses.isInTown)) \
    || (Vendor == NONE) || (WhitelistedFactions.Find(VendorFaction) > -1)
EndFunction
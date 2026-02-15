Scriptname BM_Barter extends ReferenceAlias  
{ Secondary Controller - Buy }

import SPE_Form
import UI

BM_Licenses_Utility Property bmlUtility Auto
BM_Licenses Property licenses auto
BM_Player Property bmPlayer auto
MiscObject Property Gold001  Auto 
FormList Property BM_PotentialVendorBarterViolations  Auto
FormList Property BM_PotentialBarterExclusions Auto
FormList Property BM_Empty Auto


State Active_Selective
    Event OnBeginState()
        RemoveAllInventoryEventFilters()
    EndEvent

    Event OnItemAdded(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
        if item == Gold001
            Return
        endIf

        AddInventoryEventFilter(BM_Empty)

        if IsItemViolation(item, sourceContainer)
            bmlUtility.LogTrace("OnItemAdded: Trading Violation (Buy, Selective) Found")
            RegisterForSingleUpdate(1.0)
        else
            RemoveAllInventoryEventFilters()
        endIf
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

    Event OnItemRemoved(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
        AddInventoryEventFilter(BM_Empty)
        bmlUtility.LogTrace("OnItemRemoved: Trading Violation (Buy, General) Found")
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

Bool Function IsItemViolation(Form item, ObjectReference sourceContainer)
    if sourceContainer
        return IsItemViolation_Vendor(item)
    endIf
    return IsItemViolation_Form(item)
EndFunction

Bool Function IsItemViolation_Form(Form item)
    if !licenses.hasTradingLicense
        Return (item as ObjectReference).GetEnchantment() || !FormHasKeywords(item, licenses.KeywordBarterItem, false)
    endIf

    if (item as ObjectReference).GetEnchantment()
        Return FormHasKeywords(item, licenses.KeywordConfiscationEnch, false)
    else
        Return FormHasKeywords(item, licenses.KeywordConfiscation, false)
    endIf
EndFunction

Bool Function IsItemViolation_Vendor(Form item)
    if !licenses.hasTradingLicense
        Return !BM_PotentialBarterExclusions.HasForm(item)
    endIf

    Return BM_PotentialVendorBarterViolations.HasForm(item)
EndFunction
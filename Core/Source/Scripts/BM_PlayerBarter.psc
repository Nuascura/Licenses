Scriptname BM_PlayerBarter extends ReferenceAlias  

BM_Licenses_Utility Property bmlUtility Auto
BM_Licenses Property licenses auto

FormList Property BM_PotentialPlayerBarterViolations  Auto
FormList Property BM_PotentialVendorBarterViolations  Auto
FormList Property BM_PotentialBarterExclusions Auto

Faction Property JobFenceFaction Auto
Faction Property KhajiitCaravanFaction Auto

Actor property Vendor auto Hidden

Event OnInit()
    RegisterForMenu("BarterMenu")
    AddInventoryEventFilter(bmlUtility.BM_Empty)
EndEvent

Event OnMenuOpen(String MenuName)
    bmlUtility.LogTrace("OnMenuOpen")
    ;Vendor = Game.GetCurrentCrosshairRef() as Actor
    Vendor = SPE_Actor.GetPlayerSpeechTarget()
    if (bmlUtility.bmlmcm.isLimitToCityEnabled && !licenses.isInCity) && (bmlUtility.bmlmcm.isLimitToTownEnabled && !licenses.isInTown)
        bmlUtility.LogTrace("OnMenuOpen return")
        return
    elseIf Vendor && !Vendor.IsInFaction(JobFenceFaction) && !Vendor.IsInFaction(KhajiitCaravanFaction)
        bmlUtility.LogTrace("OnMenuOpen satisfied")
        ObjectReference VendorChest = PO3_SKSEFunctions.GetVendorFactionContainer(PO3_SKSEFunctions.GetVendorFaction(Vendor))
        if !VendorChest
            VendorChest = Vendor
        endIf
        FillFormLists(self.GetActorRef(), VendorChest)
        RemoveAllInventoryEventFilters()
    endif
EndEvent

Event OnMenuClose(String MenuName)
    ClearFormLists()
    AddInventoryEventFilter(bmlUtility.BM_Empty)
EndEvent

Event OnItemAdded(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
    ; note that some items do not originate from VendorChest
    ; if sourceContainer isn't VenderChest, the item likely originated from the worldspace.
    if item != bmlUtility.Gold001
        AddInventoryEventFilter(bmlUtility.BM_Empty)
        bmlUtility.LogTrace("OnItemAdded")
        if sourceContainer == none
            bmlUtility.LogTrace("OnItemAdded no container")
            if IsItemViolation_Form(item)
                OnTradingViolation()
            endIf
        else
            bmlUtility.LogTrace("OnItemAdded standard check")
            if IsItemViolation_Vendor(item)
                OnTradingViolation()
            endIf
        endIf
        if UI.IsMenuOpen("BarterMenu")
            RemoveAllInventoryEventFilters()
        endIf
    endIf
EndEvent

Event OnItemRemoved(Form item, int count, ObjectReference itemRef, ObjectReference sourceContainer)
    if item != bmlUtility.Gold001
        AddInventoryEventFilter(bmlUtility.BM_Empty)
        bmlUtility.LogTrace("OnItemRemoved")
        if IsItemViolation_Player(item)
            OnTradingViolation()
        endIf
        if UI.IsMenuOpen("BarterMenu")
            RemoveAllInventoryEventFilters()
        endIf
    endIf
EndEvent

Function FillFormLists(Actor Player, ObjectReference VendorChest)
    BM_PotentialPlayerBarterViolations.AddForms(bmlUtility.GetViolatingItemsAll(Player, false))
    BM_PotentialVendorBarterViolations.AddForms(bmlUtility.GetViolatingItemsAll(VendorChest, false))
    BM_PotentialBarterExclusions.AddForms(ScanVendor(VendorChest))
EndFunction

Form[] Function ScanVendor(ObjectReference VendorChest)
    Form[] PotentialForms = SPE_ObjectRef.GetItemsByKeyword(VendorChest, licenses.KeywordBarterItem, false)
    PotentialForms = bmlUtility.FilterSensitive(PotentialForms)
    return PotentialForms
EndFunction

Function ClearFormLists()
    BM_PotentialPlayerBarterViolations.Revert()
    BM_PotentialVendorBarterViolations.Revert()
    BM_PotentialBarterExclusions.Revert()
EndFunction

Bool Function IsItemViolation_Form(Form item)
    Keyword[] itemKeywords = item.GetKeywords()
    int i = 0
    if licenses.hasTradingLicense
        if bmlUtility.bmlmcm.ValidateEquipmentTrade
            while i < itemKeywords.Length
                if (licenses.KeywordConfiscation.Find(itemKeywords[i]) > -1) || ((item as ObjectReference).GetEnchantment() && licenses.KeywordConfiscationEnch.Find(itemKeywords[i]) > -1)
                    bmlUtility.LogTrace("Barter: Found violation")
                    return True
                endIf
                i += 1
            endWhile
        endIf
        bmlUtility.LogTrace("IsItemViolation_Form found no violation")
        return False
    else
        if (item as ObjectReference).GetEnchantment() == none
            while i < itemKeywords.Length
                if licenses.KeywordBarterItem.Find(itemKeywords[i]) > -1
                    bmlUtility.LogTrace("IsItemViolation_Form found no violation")
                    return False
                endIf
                i += 1
            endWhile
        endIf
        bmlUtility.LogTrace("Barter: Found violation")
        return True
    endIf
EndFunction

Bool Function IsItemViolation_Player(Form item)
    if licenses.hasTradingLicense
        if bmlUtility.bmlmcm.ValidateEquipmentTrade && BM_PotentialPlayerBarterViolations.HasForm(item)
            bmlUtility.LogTrace("Barter: Found violation, selling without correct license")
            return True
        endIf
    else
        bmlUtility.LogTrace("Barter: Found violation, selling invalid item")
        return True
    endIf
    bmlUtility.LogTrace("IsItemViolation_Player found no violation")
    return False
EndFunction

Bool Function IsItemViolation_Vendor(Form item)
    if licenses.hasTradingLicense
        if bmlUtility.bmlmcm.ValidateEquipmentTrade && BM_PotentialVendorBarterViolations.HasForm(item)
            bmlUtility.LogTrace("Barter: Found violation, purchasing without correct license")
            return True
        endIf
    else
        if !BM_PotentialBarterExclusions.HasForm(item)
            bmlUtility.LogTrace("Barter: Found violation, purchasing invalid item")
            return True
        endIf
    endIf
    bmlUtility.LogTrace("IsItemViolation_Vendor found no violation")
    return False
EndFunction

Function OnTradingViolation()
    if !licenses.isTradingViolation
        licenses.isTradingViolation = True
        bmlUtility.bmPlayer.CheckViolations()
    endIf
EndFunction
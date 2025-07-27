Scriptname BM_Licenses extends Quest conditional

; ----------------------------------------------------------------------------------------------------
; -------------------------------------------------- Internal Tools
; ----------------------------------------------------------------------------------------------------

int Function CheckNullifyMagickaCurse(actor player)
    if bmlmcm.isMagicLicenseFeatureEnabled && bmlmcm.NullifyMagickaSource > 0 
        if player.HasMagicEffect(NullifyMagickaMagicEffect)
            return 1
        else
            return 0
        endIf
    endIf
    return -1
EndFunction

Bool Function HasWhitelistedKeyword(Form kForm)
    if kForm.HasKeyword(KeywordQuestItem[0]) && kForm.HasKeyword(KeywordQuestItem[1])
        return true
    endIf

    int i = 0
    while i < KeywordModItem.Length
        if kForm.HasKeyword(KeywordModItem[i])
            return true
        endIf
        i += 1
    endWhile

    return false
EndFunction

; ---------- Post-Confrontation Sequence ----------
Function FinishConfrontation(Actor akEnforcer, int type = 0)
    ; walkaway = -1, arrest = 0, normal = 1, lenient = 2
    bmlUtility.LogTrace("FinishConfrontation Type: " + type)
    bmlUtility.SendCustomEvent_SingleInt("BM-LPO_ConfrontationEnd", type)
    Faction crimeFaction = akEnforcer.GetCrimeFaction()
    if type == -1
        PlayerWalkaway(akEnforcer, crimeFaction)
        ResetViolations(type)
    elseIf type == 0
        ConfiscateItems(bmlmcm.isConfiscateFeatureEnabled, bmlmcm.isConfiscateInventoryFeatureEnabled)
        PlayerArrest(akEnforcer, crimeFaction)
    elseIf type == 1
        PayFine(crimeFaction)
        ConfiscateItems(bmlmcm.isConfiscateFeatureEnabled, bmlmcm.isConfiscateInventoryFeatureEnabled)
        ApplyPunishment()
        ResetViolations(type)
    elseIf type == 2
        bmlUtility.BM_FirstTimeViolation.SetValue(0.0)
        ConfiscateItems(bmlmcm.isConfiscateFeatureEnabled, bmlmcm.isConfiscateInventoryFeatureEnabled)
        ApplyPunishment()
        ResetViolations(type)
    endIf
    SendModEvent("BM-LPO_BountyEnd")
EndFunction

Function PayFine(Faction crimeFaction = none)
    if (bmlmcm.fineAddsToBounty && crimeFaction)
        ApplyCrimeGold(crimeFaction)
    else
        PlayerActorRef.removeItem(Gold001, bmlUtility.BM_FineAmount.GetValue() as int)
    endIf
EndFunction

Function PlayerWalkaway(Actor akEnforcer, Faction crimeFaction)
    ApplyCrimeGold(crimeFaction)

    ; Punish Walk Away
    bmlUtility.BM_FirstTimeViolation.SetValue(0.0)
    if bmlmcm.isMagicLicenseFeatureEnabled && bmlmcm.NullifyMagickaSource > 0
	    bmlUtility.BM_LenientCurseViolation.SetValue(0.0)
    endIf
    if bmlmcm.isCurfewExemptionFeatureEnabled && bmlUtility.BM_IsViolatingCurfew.GetValue() > 0
        bmlUtility.BM_LenientCurfewViolation.SetValue(0.0)
    endIf

    ; Integrations
    if bmlmcm.PrisonOverhaulPatched_State
        akEnforcer.SendModEvent("xpoArrestPC", crimeFaction as string, 1)
    endIf
EndFunction

Function PlayerArrest(Actor akEnforcer, Faction crimeFaction)
    if bmlmcm.PrisonOverhaulPatched_State
        if UI.IsMenuOpen("Dialogue Menu")
            UI.InvokeString("Dialogue Menu", "_global.skse.CloseMenu", "Dialogue Menu")
        endIf
        akEnforcer.SendModEvent("xpoSubArrestPC", crimeFaction as string, bmlUtility.BM_FineAmount.GetValue() as int)
        ResetViolations()
    else
        ApplyCrimeGold(crimeFaction)
        crimeFaction.SendPlayerToJail()
    endIf
EndFunction

Function PlayerJailed(bool abConfiscateItems = true, bool abApplyPunishments = true)
    ; internal function and variable setups
    bmlUtility.BM_IsInJail.SetValue(1.0)
    bmlUtility.insuranceModifier("infamy", bmlUtility.insuranceModifierJail())

    if abConfiscateItems
        ConfiscateItems_Simple()
    endIf
    if abApplyPunishments
        ApplyPunishment(true)
    endIf

    ResetViolations()

    if bmlUtility.licenseBountyQuest.IsRunning()
        bmlUtility.licenseBountyQuest.Stop()
    endIf
EndFunction

Function ApplyCrimeGold(Faction crimeFaction)
    int fine = bmlUtility.BM_FineAmount.GetValue() as int
    if fine > 0
        crimeFaction.modCrimeGold(fine)
        bmlUtility.LogNotification(fine + " bounty added to " + crimeFaction.getName() + " as license violation fine")
        bmlUtility.LogTrace(fine + " bounty added to " + crimeFaction.getName() + " as license violation fine")
    endIf
EndFunction

Function ApplyPunishment(bool force = false)
    ApplyNullifyMagicka(isMagicViolation || force)
    ApplyDeviousDevices()
EndFunction

Function ApplyNullifyMagicka(bool force = false)
    bmlUtility.LogTrace("ApplyNullifyMagicka")
    if force && (CheckNullifyMagickaCurse(PlayerActorRef) == 0)
        bmlUtility.LogTrace("ApplyNullifyMagicka passed conditions")
        if bmlmcm.NullifyMagickaSource == 1
            PlayerActorRef.AddSpell(NullifyMagickaSpell, false)
        elseIf bmlmcm.DeviousDevices_State && bmlmcm.NullifyMagickaSource == 2
            if bmlUtility.BM_IsPlayerCollared.GetValue() as bool
                bmlUtility.LogTrace("RefreshCollar")
                BM_API_DD.RefreshCollar(bmlInit.kzadAPI, PlayerActorRef, NullifyMagickaEnchantment)
            else
                bmlUtility.LogTrace("RenewCollar")
                BM_API_DD.RenewCollar(bmlInit.kzadAPI, bmlInit.kzadxAPI, PlayerActorRef, NullifyMagickaEnchantment, bmlmcm.ddFilter)
            endIf
        endIf
    else
        bmlUtility.LogTrace("ApplyNullifyMagicka failed to apply. isMagicViolation: " + isMagicViolation + "; force: " + force + "; CheckNullifyMagickaCurse(PlayerActorRef): " + CheckNullifyMagickaCurse(PlayerActorRef))
    endIf
EndFunction

Function RemoveNullifyMagicka(bool force = false)
    if (hasMagicLicense || force) && PlayerActorRef.HasMagicEffect(NullifyMagickaMagicEffect)
        if PlayerActorRef.HasSpell(NullifyMagickaSpell)
            PlayerActorRef.RemoveSpell(NullifyMagickaSpell)
        elseIf bmlmcm.DeviousDevices_State
            if hasCollarExemption || force
                BM_API_DD.RemoveCollar(bmlInit.kzadAPI, PlayerActorRef)
            else
                BM_API_DD.RefreshCollar(bmlInit.kzadAPI, PlayerActorRef)
            endIf
        else
            bmlUtility.LogTrace("Licenses could not find or estimate a source for the Nullify Magicka Magic Effect.")
        endIf
    endIf
EndFunction

Function ApplyDeviousDevices()
    if bmlmcm.DeviousDevices_State
        if !hasCollarExemption
            bmlUtility.LogTrace("equipCollar")
            BM_API_DD.equipCollar(bmlInit.kzadAPI, bmlInit.kzadxAPI, PlayerActorRef, bmlmcm.ddFilter)
        endIf
        if bmlmcm.equipDDOnViolation
            bmlUtility.LogTrace("equipRestraint")
            BM_API_DD.equipRestraint(bmlInit.kzadAPI, bmlInit.kzadxAPI, PlayerActorRef, bmlmcm.ddEquipChance, bmlmcm.ddFilter)
        endIf
    endIf
EndFunction

Function RemoveDeviousDevicesCollar()
    Form[] SourceList = PO3_SKSEFunctions.GetMagicEffectSource(PlayerActorRef, NullifyMagickaMagicEffect)
    if !hasMagicLicense && SourceList.Find(NullifyMagickaEnchantment) > -1
        return
    elseIf bmlmcm.DeviousDevices_State
        BM_API_DD.RemoveCollar(bmlInit.kzadAPI, PlayerActorRef)
    endIf
EndFunction

Function ResetViolations(int type = 0)
    bmlUtility.LogTrace("ResetViolations() Type: " + type)

    if type > -1
        isTravelViolation = false
    endIf
    if type > -1 || !(bmlUtility.BM_IsViolatingCurfew.GetValue() as bool)
        isCurfewViolation = false
    endIf
    isArmorViolation = false
    isBikiniViolation = 0
    isClothingViolation = false
    isMagicViolation = false
    isWeaponViolation = false
    isCraftingViolation = false
    isCollarViolation = false
    isUninsuredViolation = false
    isTradingViolation = false
    isWhoreViolation = false

    bmlUtility.BM_FineAmount.SetValue(0.0)
EndFunction

; Equipment-related Functions
Function ConfiscateItems(Bool Confiscate = false, bool ConfiscateInventory = false)
    if bmlmcm.isInsuranceFeatureEnabled && isInsured
        Confiscate = false
    endIf

    if Confiscate
        bmlUtility.GameMessage(MessageItemCheckInv)
        ; Merge two lists, remove dupes
        Form[] ValidatedForms = bmlUtility.GetViolatingItemsAll(PlayerActorRef, !ConfiscateInventory)
        ; Remove items
        if SPE_ObjectRef.RemoveItems(PlayerActorRef, ValidatedForms, BM_ItemConfiscationChest) > 0
            bmlUtility.GameMessage(MessageItemConfiscated)
        endIf
    else
        bmlUtility.GameMessage(MessageItemCheck)
        Form[] ValidatedForms = bmlUtility.GetViolatingItemsAll(PlayerActorRef, true)

        if ValidatedForms.Length
            int index = ValidatedForms.Length
            While index
                index -= 1
                if ValidatedForms[index] as Weapon
                    if ValidatedForms[index] == PlayerActorRef.GetEquippedObject(0)
                        PlayerActorRef.UnequipItemEx(ValidatedForms[index], 2)
                    endIf
                    If ValidatedForms[index] == PlayerActorRef.GetEquippedObject(1)
                        PlayerActorRef.UnequipItemEx(ValidatedForms[index], 1)
                    endIf
                else
                    PlayerActorRef.UnequipItemEx(ValidatedForms[index], 0)
                endIf
                bmlUtility.LogNotification("Unequipped: " + ValidatedForms[index].getName())
            EndWhile
            bmlUtility.GameMessage(MessageItemUnequipped)
        endIf
    endIf

    if (!hasMagicLicense && !isInsured)
        Spell equippedSpell = PlayerActorRef.GetEquippedSpell(0)
        if (equippedSpell && !bmlUtility.BM_LicensesIgnoreSpell.HasForm(equippedSpell))
            PlayerActorRef.UnequipSpell(equippedSpell, 0)
            bmlUtility.LogNotification("Dispelled: " + equippedSpell.getName())
        endIf
        equippedSpell = PlayerActorRef.GetEquippedSpell(1)
        if (equippedSpell && !bmlUtility.BM_LicensesIgnoreSpell.HasForm(equippedSpell))
            PlayerActorRef.UnequipSpell(equippedSpell, 1)
            bmlUtility.LogNotification("Dispelled: " + equippedSpell.getName())
        endif
    endIf
    
    Utility.Wait(2.0) ; give item confiscation some time to finish

    if PlayerActorRef.isWeaponDrawn()
        float break
        while PlayerActorRef.IsWeaponDrawn() && break < 5
			PlayerActorRef.SheatheWeapon()
			Utility.Wait(0.25)
            break += 0.25
		endWhile
        Utility.Wait(0.5)
    endIf
EndFunction

Function ConfiscateItems_Simple()
    Keyword[] KeywordConfiscation_Simple = new Keyword[12]
    Keyword[] KeywordConfiscationEnch_Simple = new Keyword[8]
    if bmlmcm.isClothingLicenseFeatureEnabled || (bmlmcm.isBikiniLicenseFeatureEnabled && bmlmcm.isBikiniClothingFeatureEnabled)
        KeywordConfiscation_Simple[0] = BM_LicensesClothingItem
        KeywordConfiscation_Simple[1] = VendorItemClothing
    endIf
    if bmlmcm.isArmorLicenseFeatureEnabled || (bmlmcm.isBikiniLicenseFeatureEnabled && bmlmcm.isBikiniArmorFeatureEnabled)
        KeywordConfiscation_Simple[2] = BM_LicensesArmorItem
        KeywordConfiscation_Simple[3] = VendorItemArmor
    endIf
    if bmlmcm.isWeaponLicenseFeatureEnabled
        KeywordConfiscation_Simple[4] = BM_LicensesWeaponItem
        KeywordConfiscation_Simple[5] = VendorItemWeapon
        if bmlmcm.isWeaponAmmoFeatureEnabled
            KeywordConfiscation_Simple[6] = BM_LicensesAmmoItem
            KeywordConfiscation_Simple[7] = VendorItemArrow
        endIf
    endIf
    if bmlmcm.isMagicLicenseFeatureEnabled
        Spell equippedSpell = PlayerActorRef.GetEquippedSpell(0)
        if (equippedSpell && !bmlUtility.BM_LicensesIgnoreSpell.HasForm(equippedSpell))
            PlayerActorRef.UnequipSpell(equippedSpell, 0)
        endIf
        equippedSpell = PlayerActorRef.GetEquippedSpell(1)
        if (equippedSpell && !bmlUtility.BM_LicensesIgnoreSpell.HasForm(equippedSpell))
            PlayerActorRef.UnequipSpell(equippedSpell, 1)
        endif
        KeywordConfiscation_Simple[8] = BM_LicensesMagicItem
        KeywordConfiscation_Simple[9] = VendorItemSpellTome
        KeywordConfiscation_Simple[10] = VendorItemScroll
        KeywordConfiscation_Simple[11] = VendorItemStaff ; Some staffs aren't covered by VendorItemWeapon
        if bmlmcm.isEnchantedArmorFeatureEnabled
            KeywordConfiscationEnch_Simple[0] = BM_LicensesArmorItem
            KeywordConfiscationEnch_Simple[1] = VendorItemArmor
        endIf
        if bmlmcm.isEnchantedClothingFeatureEnabled
            KeywordConfiscationEnch_Simple[2] = BM_LicensesClothingItem
            KeywordConfiscationEnch_Simple[3] = VendorItemClothing
        endIf
        if bmlmcm.isEnchantedJewelryFeatureEnabled
            KeywordConfiscationEnch_Simple[4] = BM_LicensesJewelryItem
            KeywordConfiscationEnch_Simple[5] = VendorItemJewelry
        endIf
        if bmlmcm.isEnchantedWeaponryFeatureEnabled
            KeywordConfiscationEnch_Simple[6] = BM_LicensesWeaponItem
            KeywordConfiscationEnch_Simple[7] = VendorItemWeapon
        endIf
    endIf
    ; Get Armor, selecting by slot
    Form[] PotentialForms = bmlUtility.FilterByOccupiedSlotmask(PO3_SKSEFunctions.AddItemsOfTypeToArray(PlayerActorRef, 26, false), bmlmcm.ArmorSlotArray)
    ; Get Weapons
    PotentialForms = PapyrusUtil.MergeFormArray(PotentialForms, PO3_SKSEFunctions.AddItemsOfTypeToArray(PlayerActorRef, 41, false), true)
    ; Get Ammo
    PotentialForms = PapyrusUtil.MergeFormArray(PotentialForms, PO3_SKSEFunctions.AddItemsOfTypeToArray(PlayerActorRef, 42, false), true)
    ; Filter by KeywordConfiscation_Simple
    Form[] array1 = SPE_Utility.IntersectArray_Form(PotentialForms, SPE_ObjectRef.GetItemsByKeyword(PlayerActorRef, KeywordConfiscation_Simple, false))
    ; Filter by KeywordConfiscationEnch_Simple
    Form[] array2 = SPE_Utility.IntersectArray_Form(PotentialForms, SPE_ObjectRef.GetItemsByKeyword(PlayerActorRef, KeywordConfiscationEnch_Simple, false))
    array2 = SPE_Utility.IntersectArray_Form(array2, SPE_ObjectRef.GetEnchantedItems(PlayerActorRef, true, true, false))
    ; Merge Arrays
    PotentialForms = PapyrusUtil.MergeFormArray(array1, array2, true)
    ; Overrides
    PotentialForms = bmlUtility.FilterSensitive(PotentialForms)
    ; Remove items
    SPE_ObjectRef.RemoveItems(PlayerActorRef, PotentialForms, none)
EndFunction
; ------------------------------

; ---------- Array Setup ----------
Function FillItemTypeArray()
    FillItemTypeArrayArmor()
    FillItemTypeArrayClothing()
    FillItemTypeArrayBikini()
EndFunction

Function FillItemTypeArrayArmor()
    ItemTypeArmor = new Keyword[2]
    ItemTypeArmor[0] = BM_LicensesArmorItem
    ItemTypeArmor[1] = VendorItemArmor
EndFunction

Function FillItemTypeArrayClothing()
    ItemTypeClothing = new Keyword[2]
    ItemTypeClothing[0] = BM_LicensesClothingItem
    ItemTypeClothing[1] = VendorItemClothing
EndFunction

Function FillItemTypeArrayBikini()
	String[] BikiniKeyword = PapyrusUtil.StringSplit(bmlmcm.bikiniKeywordString, ",")
    BikiniKeyword = PapyrusUtil.ClearEmpty(BikiniKeyword)
    ItemTypeBikini = new Keyword[32] ; limit to 32 for performance
    ItemTypeBikini[0] = BM_LicensesBikiniItem
    int i = 0
    while i < BikiniKeyword.length && (i + 1) < ItemTypeBikini.length && BikiniKeyword[i]
        ItemTypeBikini[i + 1] = Keyword.GetKeyword(BikiniKeyword[i])
        i += 1
    EndWhile
EndFunction

Function PopulateKeywordConfiscationArray()
    KeywordConfiscation = new Keyword[12]
    KeywordConfiscationEnch = new Keyword[8]

    if bmlmcm.isClothingLicenseFeatureEnabled && (!hasClothingLicense || !isInsured)
        KeywordConfiscation[0] = BM_LicensesClothingItem
        KeywordConfiscation[1] = VendorItemClothing
    endIf
    if bmlmcm.isArmorLicenseFeatureEnabled
        if (!hasArmorLicense || !isInsured)
            KeywordConfiscation[2] = BM_LicensesArmorItem
            KeywordConfiscation[3] = VendorItemArmor
        elseIf bmlmcm.ALClothingImmunity
            KeywordConfiscation[0] = none
            KeywordConfiscation[1] = none
        endIf
    endIf

    if (bmlmcm.isBikiniLicenseFeatureEnabled == 1)
        if bmlmcm.isBikiniClothingFeatureEnabled && (!hasClothingLicense || !bmlmcm.isClothingLicenseFeatureEnabled)
            KeywordConfiscation[0] = BM_LicensesClothingItem
            KeywordConfiscation[1] = VendorItemClothing
        endIf
        if bmlmcm.isBikiniArmorFeatureEnabled && (!hasArmorLicense || !bmlmcm.isArmorLicenseFeatureEnabled)
            KeywordConfiscation[2] = BM_LicensesArmorItem
            KeywordConfiscation[3] = VendorItemArmor
        endIf
    elseIf (bmlmcm.isBikiniLicenseFeatureEnabled == 2) && (!hasBikiniExemption || !isInsured) 
        if bmlmcm.isBikiniClothingFeatureEnabled
            KeywordConfiscation[0] = BM_LicensesClothingItem
            KeywordConfiscation[1] = VendorItemClothing
        endIf
        if bmlmcm.isBikiniArmorFeatureEnabled
            KeywordConfiscation[2] = BM_LicensesArmorItem
            KeywordConfiscation[3] = VendorItemArmor
        endIf
    endIf

    if bmlmcm.isWeaponLicenseFeatureEnabled && (!hasWeaponLicense || !isInsured)
        KeywordConfiscation[4] = BM_LicensesWeaponItem
        KeywordConfiscation[5] = VendorItemWeapon
        if bmlmcm.isWeaponAmmoFeatureEnabled
            KeywordConfiscation[6] = BM_LicensesAmmoItem
            KeywordConfiscation[7] = VendorItemArrow
        endIf
    endIf
    if bmlmcm.isMagicLicenseFeatureEnabled && (!hasMagicLicense || !isInsured)
        KeywordConfiscation[8] = BM_LicensesMagicItem
        KeywordConfiscation[9] = VendorItemSpellTome
        KeywordConfiscation[10] = VendorItemScroll
        KeywordConfiscation[11] = VendorItemStaff ; Some staffs aren't covered by VendorItemWeapon
        if bmlmcm.isEnchantedArmorFeatureEnabled
            KeywordConfiscationEnch[0] = BM_LicensesArmorItem
            KeywordConfiscationEnch[1] = VendorItemArmor
        endIf
        if bmlmcm.isEnchantedClothingFeatureEnabled
            KeywordConfiscationEnch[2] = BM_LicensesClothingItem
            KeywordConfiscationEnch[3] = VendorItemClothing
        endIf
        if bmlmcm.isEnchantedJewelryFeatureEnabled
            KeywordConfiscationEnch[4] = BM_LicensesJewelryItem
            KeywordConfiscationEnch[5] = VendorItemJewelry
        endIf
        if bmlmcm.isEnchantedWeaponryFeatureEnabled
            KeywordConfiscationEnch[6] = BM_LicensesWeaponItem
            KeywordConfiscationEnch[7] = VendorItemWeapon
        endIf
    endIf
EndFunction

Function PopulateCursedTattoosArray()
    CursedTattoos = new String[7]
    ; neck
    if bmlmcm.Curse_Neck
        PO3_SKSEFunctions.AddStringToArray("Neck Lower Seal Gradient", CursedTattoos)
    endIf
    ; torso
    if bmlmcm.Curse_Torso
        if !bmlmcm.Curse_ReduceSlotUsage
            PO3_SKSEFunctions.AddStringToArray("Torso Seal Gradient", CursedTattoos)
            PO3_SKSEFunctions.AddStringToArray("Nipple Seal Gradient", CursedTattoos)
            PO3_SKSEFunctions.AddStringToArray("Spine Seal Gradient", CursedTattoos)
        else
            PO3_SKSEFunctions.AddStringToArray("Body Seal Gradient", CursedTattoos)
        endIf
    endIf
    ; wrists
    if bmlmcm.Curse_Arms
        PO3_SKSEFunctions.AddStringToArray("Wrist Seal Gradient", CursedTattoos)
    endIf
    ; legs
    if bmlmcm.Curse_Legs
        if !bmlmcm.Curse_ReduceSlotUsage
            PO3_SKSEFunctions.AddStringToArray("Thigh Seal Gradient", CursedTattoos)
        endIf
        PO3_SKSEFunctions.AddStringToArray("Ankle Seal Gradient", CursedTattoos)
    endIf
    CursedTattoos = PapyrusUtil.ClearEmpty(CursedTattoos)
EndFunction

Function PopulateKeywordExclusionArray()
    KeywordQuestItem = new Keyword[2]
    KeywordQuestItem[0] = MagicDisallowEnchanting
    KeywordQuestItem[1] = VendorNoSale

    KeywordModItem = new Keyword[5]
    KeywordModItem[0] = BM_LicensesIgnoreItem
    KeywordModItem[1] = Keyword.GetKeyword("zad_QuestItem")
    KeywordModItem[2] = Keyword.GetKeyword("zad_Lockable")
    KeywordModItem[3] = Keyword.GetKeyword("zad_InventoryDevice")
    KeywordModItem[4] = Keyword.GetKeyword("zbfWornDevice")

    KeywordBarterItem = new Keyword[5]
    KeywordBarterItem[0] = BM_LicensesBarterItem
    KeywordBarterItem[1] = VendorItemGem
    KeywordBarterItem[2] = VendorItemJewelry
    KeywordBarterItem[3] = VendorItemFood
    KeywordBarterItem[4] = VendorItemFoodRaw
EndFunction

Function ValidateArmorSlotArray()
    if bmlmcm.ArmorSlotArray.Length != 32
        bmlmcm.ArmorSlotArray = Utility.CreateIntArray(32, 0)
    else
        int i = 0
        while i < bmlmcm.ArmorSlotArray.Length
            if bmlmcm.ArmorSlotArray[i] && bmlmcm.ArmorSlotArray[i] != (i + 30)
                bmlmcm.ArmorSlotArray[i] = 0
            endIf
            i += 1
        endWhile
    endIf
EndFunction
; ------------------------------

; ----------------------------------------------------------------------------------------------------
; -------------------------------------------------- End Internal Tools
; ----------------------------------------------------------------------------------------------------

Actor Property PlayerActorRef auto hidden

ReferenceAlias Property playerRef auto
BM_Licenses_Init Property bmlInit auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto
MiscObject Property Gold001  Auto
ObjectReference Property BM_ItemConfiscationChest Auto

bool Property hasArmorLicense = true auto conditional
bool Property ArmorLicense
    bool Function Get()
        Return hasArmorLicense
    EndFunction
    Function Set(bool value)
        hasArmorLicense = BM_API.ActualizeValue("ArmorLicense", value, bmlmcm.isArmorLicenseFeatureEnabled)
    EndFunction
EndProperty

bool Property hasBikiniLicense = true auto conditional
bool Property BikiniLicense
    bool Function Get()
        Return hasBikiniLicense
    EndFunction
    Function Set(bool value)
        hasBikiniLicense = BM_API.ActualizeValue("BikiniLicense", value, bmlmcm.isBikiniLicenseFeatureEnabled == 1)
    EndFunction
EndProperty
bool Property hasBikiniExemption = true auto conditional
bool Property BikiniExemption
    bool Function Get()
        Return hasBikiniExemption
    EndFunction
    Function Set(bool value)
        hasBikiniExemption = BM_API.ActualizeValue("BikiniExemption", value, bmlmcm.isBikiniLicenseFeatureEnabled == 2)
    EndFunction
EndProperty

bool Property hasClothingLicense = true auto conditional
bool Property ClothingLicense
    bool Function Get()
        Return hasClothingLicense
    EndFunction
    Function Set(bool value)
        hasClothingLicense = BM_API.ActualizeValue("ClothingLicense", value, bmlmcm.isClothingLicenseFeatureEnabled)
    EndFunction
EndProperty

bool Property hasMagicLicense = true auto conditional
bool Property MagicLicense
    bool Function Get()
        Return hasMagicLicense
    EndFunction
    Function Set(bool value)
        hasMagicLicense = BM_API.ActualizeValue("MagicLicense", value, bmlmcm.isMagicLicenseFeatureEnabled)
    EndFunction
EndProperty

bool Property hasWeaponLicense = true auto conditional
bool Property WeaponLicense
    bool Function Get()
        Return hasWeaponLicense
    EndFunction
    Function Set(bool value)
        hasWeaponLicense = BM_API.ActualizeValue("WeaponLicense", value, bmlmcm.isWeaponLicenseFeatureEnabled)
    EndFunction
EndProperty

bool Property hasCraftingLicense = true auto conditional
bool Property CraftingLicense
    bool Function Get()
        Return hasCraftingLicense
    EndFunction
    Function Set(bool value)
        hasCraftingLicense = BM_API.ActualizeValue("CraftingLicense", value, bmlmcm.isCraftingLicenseFeatureEnabled)
    EndFunction
EndProperty

bool Property hasTradingLicense = true auto conditional
bool Property TradingLicense
    bool Function Get()
        Return hasTradingLicense
    EndFunction
    Function Set(bool value)
        hasTradingLicense = BM_API.ActualizeValue("TradingLicense", value, bmlmcm.isTradingLicenseFeatureEnabled)
    EndFunction
EndProperty

bool Property hasWhoreLicense = true auto conditional
bool Property WhoreLicense
    bool Function Get()
        Return hasWhoreLicense
    EndFunction
    Function Set(bool value)
        hasWhoreLicense = BM_API.ActualizeValue("WhoreLicense", value, bmlmcm.isWhoreLicenseFeatureEnabled)
    EndFunction
EndProperty

bool Property hasTravelPermit = true auto conditional
bool Property TravelPermit
    bool Function Get()
        Return hasTravelPermit
    EndFunction
    Function Set(bool value)
        hasTravelPermit = BM_API.ActualizeValue("TravelPermit", value, bmlmcm.isTravelPermitFeatureEnabled)
    EndFunction
EndProperty

bool Property hasCollarExemption = true auto conditional
bool Property CollarExemption
    bool Function Get()
        Return hasCollarExemption
    EndFunction
    Function Set(bool value)
        hasCollarExemption = BM_API.ActualizeValue("CollarExemption", value, bmlmcm.isCollarExemptionFeatureEnabled)
    EndFunction
EndProperty

bool Property hasInsurance = true auto conditional
bool Property Insurance
    bool Function Get()
        Return hasInsurance
    EndFunction
    Function Set(bool value)
        hasInsurance = BM_API.ActualizeValue("Insurance", value, bmlmcm.isInsuranceFeatureEnabled)
    EndFunction
EndProperty

bool Property hasCurfewExemption = true auto conditional
bool Property CurfewExemption
    bool Function Get()
        Return hasCurfewExemption
    EndFunction
    Function Set(bool value)
        hasCurfewExemption = BM_API.ActualizeValue("CurfewExemption", value, bmlmcm.isCurfewExemptionFeatureEnabled)
    EndFunction
EndProperty

bool Property isArmorViolation auto conditional
int Property isBikiniViolation auto conditional
bool Property isClothingViolation auto conditional
bool Property isMagicViolation auto conditional
bool Property isWeaponViolation auto conditional
bool Property isCraftingViolation auto conditional
bool Property isTravelViolation auto conditional
bool Property isCollarViolation auto conditional
bool Property isUninsuredViolation auto conditional
bool Property isCurfewViolation auto conditional
bool Property isTradingViolation auto conditional
bool Property isWhoreViolation auto conditional

bool Property isInCity = false auto conditional
bool Property isInTown = false auto conditional
bool Property isLicenseLimit = false auto conditional
bool Property isThane = false auto
bool Property isInsured
    bool Function Get()
        return hasInsurance || (bmlmcm.isInsuranceFeatureEnabled && bmlmcm.thaneImmunityInsurance && isThane)
    EndFunction
EndProperty

; if expiration time == -1.0 -> not purchased yet
; resets after license runs out
float property armorLicenseExpirationTime = -1.0 auto conditional
float property bikiniLicenseExpirationTime = -1.0 auto conditional
float property bikiniExemptionExpirationTime = -1.0 auto conditional
float property clothingLicenseExpirationTime = -1.0 auto conditional
float property magicLicenseExpirationTime = -1.0 auto conditional
float property weaponLicenseExpirationTime = -1.0 auto conditional
float property craftingLicenseExpirationTime = -1.0 auto conditional
float property tradingLicenseExpirationTime = -1.0 auto conditional
float property whoreLicenseExpirationTime = -1.0 auto conditional
float property travelPermitExpirationTime = -1.0 auto conditional
float property collarExemptionExpirationTime = -1.0 auto conditional
float property insuranceExpirationTime = -1.0 auto conditional
float property curfewExemptionExpirationTime = -1.0 auto conditional

; if cooldown time == -1.0 -> delay inactive
float property armorLicenseCooldownTime = -1.0 auto conditional
float property bikiniLicenseCooldownTime = -1.0 auto conditional
float property bikiniExemptionCooldownTime = -1.0 auto conditional
float property clothingLicenseCooldownTime = -1.0 auto conditional
float property magicLicenseCooldownTime = -1.0 auto conditional
float property weaponLicenseCooldownTime = -1.0 auto conditional
float property craftingLicenseCooldownTime = -1.0 auto conditional
float property tradingLicenseCooldownTime = -1.0 auto conditional
float property whoreLicenseCooldownTime = -1.0 auto conditional
float property travelPermitCooldownTime = -1.0 auto conditional
float property collarExemptionCooldownTime = -1.0 auto conditional
float property insuranceCooldownTime = -1.0 auto conditional
float property curfewExemptionCooldownTime = -1.0 auto conditional

float property insuranceMisbehaviourMultiplier = 1.0 auto
float property insurancePopularityMultiplier = 1.0 auto

float property NextStatusCheck = 0.0 auto conditional
float property previousLicenseStatusCheckTime auto

Keyword Property VendorItemWeapon Auto
Keyword Property VendorItemArmor Auto
Keyword Property VendorItemClothing Auto
Keyword Property VendorItemSpellTome Auto
Keyword Property VendorItemStaff Auto
Keyword Property VendorItemArrow Auto
Keyword Property VendorItemScroll Auto
Keyword Property VendorItemGem Auto
Keyword Property VendorItemJewelry Auto
Keyword Property VendorItemFood Auto
Keyword Property VendorItemFoodRaw Auto
Keyword Property VendorNoSale Auto
Keyword Property MagicDisallowEnchanting Auto
Keyword Property BM_LicensesIgnoreItem Auto
Keyword Property BM_LicensesBarterItem Auto
Keyword Property BM_LicensesBikiniItem Auto
Keyword Property BM_LicensesArmorItem Auto
Keyword Property BM_LicensesClothingItem Auto
Keyword Property BM_LicensesWeaponItem Auto
Keyword Property BM_LicensesAmmoItem Auto
Keyword Property BM_LicensesMagicItem Auto
Keyword Property BM_LicensesJewelryItem Auto

Enchantment Property NullifyMagickaEnchantment  Auto  
Spell Property NullifyMagickaSpell  Auto  
MagicEffect Property NullifyMagickaMagicEffect  Auto  

Message Property MessageTravelLocated  Auto  
Message Property MessageTravelMissing  Auto 
Message Property MessageArmorCountdown  Auto  
Message Property MessageArmorExpired  Auto 
Message Property MessageBikini1Countdown  Auto  
Message Property MessageBikini1Expired  Auto 
Message Property MessageBikini2Countdown  Auto  
Message Property MessageBikini2Expired  Auto 
Message Property MessageClothingCountdown  Auto  
Message Property MessageClothingExpired  Auto 
Message Property MessageMagicCountdown  Auto  
Message Property MessageMagicExpired  Auto 
Message Property MessageWeaponCountdown  Auto  
Message Property MessageWeaponExpired  Auto 
Message Property MessageCraftingCountdown  Auto  
Message Property MessageCraftingExpired  Auto 
Message Property MessageTradingCountdown  Auto  
Message Property MessageTradingExpired  Auto 
Message Property MessageWhoreCountdown  Auto  
Message Property MessageWhoreExpired  Auto 
Message Property MessageTravelCountdown  Auto  
Message Property MessageTravelExpired  Auto 
Message Property MessageCollarCountdown  Auto  
Message Property MessageCollarExpired  Auto 
Message Property MessageInsuranceCountdown  Auto  
Message Property MessageInsuranceExpired  Auto 
Message Property MessageCurfewCountdown  Auto  
Message Property MessageCurfewExpired  Auto 
Message Property MessageItemCheck  Auto 
Message Property MessageItemCheckInv  Auto 
Message Property MessageItemConfiscated  Auto 
Message Property MessageItemUnequipped  Auto 

String[] Property CursedTattoos Auto
String[] Property CursedTattoosActive Auto
Keyword[] Property KeywordQuestItem Auto
Keyword[] Property KeywordModItem Auto
Keyword[] Property KeywordBarterItem Auto
Keyword[] Property KeywordConfiscation Auto
Keyword[] Property KeywordConfiscationEnch Auto

Keyword[] Property ItemTypeArmor Auto
Keyword[] Property ItemTypeClothing Auto
Keyword[] Property ItemTypeBikini Auto

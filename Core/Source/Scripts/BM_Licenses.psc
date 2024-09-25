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
        if bmlmcm.NullifyMagickaSource > 0
            bmlUtility.BM_LenientCurseViolation.SetValue(0.0)
        endIf
        ConfiscateItems(bmlmcm.isConfiscateFeatureEnabled, bmlmcm.isConfiscateInventoryFeatureEnabled)
        ApplyPunishment()
        ResetViolations(type)
    endIf
    SendModEvent("BM-LPO_BountyEnd")
EndFunction

Function PayFine(Faction crimeFaction = none)
    Actor player = playerRef.GetActorRef()
    if (bmlmcm.fineAddsToBounty && crimeFaction)
        ApplyCrimeGold(crimeFaction)
    else
        player.removeItem(Gold001, bmlUtility.BM_FineAmount.GetValue() as int)
    endIf
EndFunction

Function PlayerWalkaway(Actor akEnforcer, Faction crimeFaction)
    ApplyCrimeGold(crimeFaction)
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

Function PlayerJailed(bool soft = false)
    ; internal function and variable setups
    bmlUtility.BM_IsInJail.SetValue(1.0)
    bmlUtility.insuranceModifier("infamy", bmlUtility.insuranceModifierJail())

    if !soft
        ; remove all valid items
        ConfiscateItems_Simple()
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
    Actor player = playerRef.GetActorRef()
    if force && (CheckNullifyMagickaCurse(player) == 0)
        bmlUtility.LogTrace("ApplyNullifyMagicka passed conditions")
        if bmlmcm.NullifyMagickaSource == 1
            player.AddSpell(NullifyMagickaSpell, false)
        elseIf bmlmcm.NullifyMagickaSource == 2 && bmlmcm.DeviousDevices_State
            if BM_API_DD.hasCollarEquipped(player)
                bmlUtility.LogTrace("RefreshCollar")
                BM_API_DD.RefreshCollar(player, NullifyMagickaEnchantment)
            else
                bmlUtility.LogTrace("RenewCollar")
                BM_API_DD.RenewCollar(player, NullifyMagickaEnchantment, bmlmcm.ddFilter)
            endIf
        endIf
    else
        bmlUtility.LogTrace("ApplyNullifyMagicka failed to apply. isMagicViolation: " + isMagicViolation + "; force: " + force + "; CheckNullifyMagickaCurse(player): " + CheckNullifyMagickaCurse(player))
    endIf
EndFunction

Function RemoveNullifyMagicka(bool force = false)
    Actor player = playerRef.GetActorRef()
    if (hasMagicLicense || force) && player.HasMagicEffect(NullifyMagickaMagicEffect)
        if player.HasSpell(NullifyMagickaSpell)
            player.RemoveSpell(NullifyMagickaSpell)
        elseIf bmlmcm.DeviousDevices_State
            if hasCollarExemption || force
                BM_API_DD.RemoveCollar(player)
            else
                BM_API_DD.RefreshCollar(player)
            endIf
        else
            bmlUtility.LogTrace("Licenses could not find or estimate a source for the Nullify Magicka Magic Effect.")
        endIf
    endIf
EndFunction

Function ApplyDeviousDevices()
    Actor player = playerRef.GetActorRef()
    if bmlmcm.DeviousDevices_State
        if !hasCollarExemption
            BM_API_DD.equipCollar(player, bmlmcm.ddFilter)
        endIf
        If bmlmcm.equipDDOnViolation
            BM_API_DD.equipRestraint(player, bmlmcm.ddEquipChance, bmlmcm.ddFilter)
        endIf
    endIf
EndFunction

Function RemoveDeviousDevicesCollar()
    Actor player = playerRef.GetActorRef()
    Form[] SourceList = PO3_SKSEFunctions.GetMagicEffectSource(player, NullifyMagickaMagicEffect)
    if !hasMagicLicense && SourceList.Find(NullifyMagickaEnchantment) > -1
        return
    elseIf bmlmcm.DeviousDevices_State
        BM_API_DD.RemoveCollar(player)
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
    Actor playerActor = playerRef.GetActorRef()

    if bmlmcm.isInsuranceFeatureEnabled && isInsured
        Confiscate = false
    endIf

    if Confiscate && ConfiscateInventory
        bmlUtility.GameMessage(MessageItemCheckInv)
        ; Merge two lists, remove dupes
        Form[] ValidatedForms = PapyrusUtil.MergeFormArray(bmlUtility.ScanInventory_Base(playerActor), bmlUtility.ScanInventory_Ench(playerActor), true)
        ; Remove items
        if PyramidUtils.RemoveForms(playerActor, ValidatedForms, BM_ItemConfiscationChest) > 0
            bmlUtility.GameMessage(MessageItemConfiscated)
        endIf
    elseIf Confiscate
        bmlUtility.GameMessage(MessageItemCheck)
        ; Merge two lists, remove dupes
        Form[] ValidatedForms = PapyrusUtil.MergeFormArray(bmlUtility.ScanEquippedItems_Base(playerActor), bmlUtility.ScanEquippedItems_Ench(playerActor), true)
        ; Remove items
        if PyramidUtils.RemoveForms(playerActor, ValidatedForms, BM_ItemConfiscationChest) > 0
            bmlUtility.GameMessage(MessageItemConfiscated)
        endIf
    else
        bmlUtility.GameMessage(MessageItemCheck)
        bmlUtility.BM_PotentialViolations.AddForms(PapyrusUtil.MergeFormArray(bmlUtility.ScanEquippedItems_Base(playerActor), bmlUtility.ScanEquippedItems_Ench(playerActor), true))

        if bmlUtility.BM_PotentialViolations.GetAt(0)
            int i = bmlUtility.BM_PotentialViolations.GetSize()
            While (i > -1)
                if bmlUtility.BM_PotentialViolations.GetAt(i)
                    playerActor.UnequipItem(bmlUtility.BM_PotentialViolations.GetAt(i), false, true)
                    bmlUtility.LogNotification("Unequipped: " + bmlUtility.BM_PotentialViolations.GetAt(i).getName())
                endIf
                i -= 1
            EndWhile
            
            bmlUtility.GameMessage(MessageItemUnequipped)
        endIf

        ; Clean Up
        bmlUtility.BM_PotentialViolations.Revert()
    endIf

    if (!hasMagicLicense && !isInsured)
        Spell equippedSpell = playerActor.GetEquippedSpell(0)
        if (equippedSpell && !bmlUtility.BM_LicensesIgnoreSpell.HasForm(equippedSpell))
            playerActor.UnequipSpell(equippedSpell, 0)
            bmlUtility.LogNotification("Dispelled: " + equippedSpell.getName())
        endIf
        equippedSpell = playerActor.GetEquippedSpell(1)
        if (equippedSpell && !bmlUtility.BM_LicensesIgnoreSpell.HasForm(equippedSpell))
            playerActor.UnequipSpell(equippedSpell, 1)
            bmlUtility.LogNotification("Dispelled: " + equippedSpell.getName())
        endif
    endIf
EndFunction

Function ConfiscateItems_Simple()
    Actor playerActor = playerRef.GetActorRef()

    Keyword[] KeywordConfiscation_Simple = new Keyword[7]
    Keyword[] KeywordConfiscationEnch_Simple = new Keyword[4]
    if bmlmcm.isClothingLicenseFeatureEnabled || (bmlmcm.isBikiniLicenseFeatureEnabled && bmlmcm.isBikiniClothingFeatureEnabled)
        KeywordConfiscation_Simple[0] = VendorItemClothing
    endIf
    if bmlmcm.isArmorLicenseFeatureEnabled || (bmlmcm.isBikiniLicenseFeatureEnabled && bmlmcm.isBikiniArmorFeatureEnabled)
        KeywordConfiscation_Simple[1] = VendorItemArmor
    endIf
    if bmlmcm.isWeaponLicenseFeatureEnabled
        KeywordConfiscation_Simple[2] = VendorItemWeapon
        if bmlmcm.isWeaponAmmoFeatureEnabled
            KeywordConfiscation_Simple[3] = VendorItemArrow
        endIf
    endIf
    if bmlmcm.isMagicLicenseFeatureEnabled
        Spell equippedSpell = playerActor.GetEquippedSpell(0)
        if (equippedSpell && !bmlUtility.BM_LicensesIgnoreSpell.HasForm(equippedSpell))
            playerActor.UnequipSpell(equippedSpell, 0)
        endIf
        equippedSpell = playerActor.GetEquippedSpell(1)
        if (equippedSpell && !bmlUtility.BM_LicensesIgnoreSpell.HasForm(equippedSpell))
            playerActor.UnequipSpell(equippedSpell, 1)
        endif
        KeywordConfiscation_Simple[4] = VendorItemSpellTome
        KeywordConfiscation_Simple[5] = VendorItemScroll
        KeywordConfiscation_Simple[6] = VendorItemStaff ; Some staffs aren't covered by VendorItemWeapon
        if bmlmcm.isEnchantedArmorFeatureEnabled
            KeywordConfiscationEnch_Simple[0] = VendorItemArmor
        endIf
        if bmlmcm.isEnchantedClothingFeatureEnabled
            KeywordConfiscationEnch_Simple[1] = VendorItemClothing
        endIf
        if bmlmcm.isEnchantedJewelryFeatureEnabled
            KeywordConfiscationEnch_Simple[2] = VendorItemJewelry
        endIf
        if bmlmcm.isEnchantedWeaponryFeatureEnabled
            KeywordConfiscationEnch_Simple[3] = VendorItemWeapon
        endIf
    endIf
    ; Get items matching valid keywords per license features
    Form[] PotentialForms = PyramidUtils.GetItemsByKeyword(playerActor, KeywordConfiscation_Simple, false)
    ; Get potentially enchanted items matching valid keywords per license features
    Form[] PotentialFormsEnch = PyramidUtils.GetItemsByKeyword(playerActor, KeywordConfiscationEnch_Simple, false)
    ; Filter for only enchanted items
    PotentialFormsEnch = PyramidUtils.FilterByEnchanted(playerActor, PotentialFormsEnch, true)
    ; Merge two lists, remove dupes
    Form[] ValidatedForms = PapyrusUtil.MergeFormArray(PotentialForms, PotentialFormsEnch, true)
    ; Filter out items matching keyword combinations
    ValidatedForms = PyramidUtils.FilterFormsByKeyword(ValidatedForms, KeywordQuestItem, true, true)
    ValidatedForms = PyramidUtils.FilterFormsByKeyword(ValidatedForms, KeywordModItem, false, true)
    ; Remove items
    PyramidUtils.RemoveForms(playerActor, ValidatedForms, none) ; banish default jail outfit items to the void!
EndFunction
; ------------------------------

; ---------- Array Setup ----------
Function PopulateKeywordConfiscationArray()
    KeywordConfiscation = new Keyword[7]
    KeywordConfiscationEnch = new Keyword[4]

    if (!hasClothingLicense || !isInsured) && bmlmcm.isClothingLicenseFeatureEnabled
        KeywordConfiscation[0] = VendorItemClothing
    endIf
    if (!hasBikiniLicense || !isInsured) && bmlmcm.isBikiniLicenseFeatureEnabled
        if (!hasClothingLicense || !bmlmcm.isClothingLicenseFeatureEnabled) && bmlmcm.isBikiniClothingFeatureEnabled
            KeywordConfiscation[0] = VendorItemClothing
        endIf
        if (!hasArmorLicense || !bmlmcm.isArmorLicenseFeatureEnabled) && bmlmcm.isBikiniArmorFeatureEnabled
            KeywordConfiscation[1] = VendorItemArmor
        endIf
    endIf
    if bmlmcm.isArmorLicenseFeatureEnabled
        if (!hasArmorLicense || !isInsured)
            KeywordConfiscation[1] = VendorItemArmor
        else
            KeywordConfiscation[0] = None
            KeywordConfiscation[1] = None
        endIf
    endIf
    if (!hasWeaponLicense || !isInsured) && bmlmcm.isWeaponLicenseFeatureEnabled
        KeywordConfiscation[2] = VendorItemWeapon
        if bmlmcm.isWeaponAmmoFeatureEnabled
            KeywordConfiscation[3] = VendorItemArrow
        endIf
    endIf
    if (!hasMagicLicense || !isInsured) && bmlmcm.isMagicLicenseFeatureEnabled
        KeywordConfiscation[4] = VendorItemSpellTome
        KeywordConfiscation[5] = VendorItemScroll
        KeywordConfiscation[6] = VendorItemStaff ; Some staffs aren't covered by VendorItemWeapon
        if bmlmcm.isEnchantedArmorFeatureEnabled
            KeywordConfiscationEnch[0] = VendorItemArmor
        endIf
        if bmlmcm.isEnchantedClothingFeatureEnabled
            KeywordConfiscationEnch[1] = VendorItemClothing
        endIf
        if bmlmcm.isEnchantedJewelryFeatureEnabled
            KeywordConfiscationEnch[2] = VendorItemJewelry
        endIf
        if bmlmcm.isEnchantedWeaponryFeatureEnabled
            KeywordConfiscationEnch[3] = VendorItemWeapon
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
            if !bmlmcm.Curse_FormatOverride
                PO3_SKSEFunctions.AddStringToArray("Torso Seal Gradient", CursedTattoos)
                PO3_SKSEFunctions.AddStringToArray("Nipple Seal Gradient", CursedTattoos)
            else
                PO3_SKSEFunctions.AddStringToArray("Torso Seal Gradient BHUNP", CursedTattoos)
                PO3_SKSEFunctions.AddStringToArray("Nipple Seal Gradient BHUNP", CursedTattoos)
            endIf
            PO3_SKSEFunctions.AddStringToArray("Spine Seal Gradient", CursedTattoos)
        else
            if !bmlmcm.Curse_FormatOverride
                PO3_SKSEFunctions.AddStringToArray("Body Seal Gradient", CursedTattoos)
            else
                PO3_SKSEFunctions.AddStringToArray("Body Seal Gradient BHUNP", CursedTattoos)
            endIf
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
        if !bmlmcm.Curse_FormatOverride
            PO3_SKSEFunctions.AddStringToArray("Ankle Seal Gradient", CursedTattoos)
        else
            PO3_SKSEFunctions.AddStringToArray("Ankle Seal Gradient BHUNP", CursedTattoos)
        endIf
    endIf
    CursedTattoos = PapyrusUtil.ClearEmpty(CursedTattoos)
EndFunction

Function PopulateKeywordExclusionArray()
    KeywordQuestItem = new Keyword[2]
    KeywordQuestItem[0] = Keyword.GetKeyword("MagicDisallowEnchanting")
    KeywordQuestItem[1] = Keyword.GetKeyword("VendorNoSale")

    KeywordModItem = new Keyword[4]
    KeywordModItem[0] = Keyword.GetKeyword("BM_LicensesIgnoreItem")
    KeywordModItem[1] = Keyword.GetKeyword("zad_Lockable")
    KeywordModItem[2] = Keyword.GetKeyword("zad_InventoryDevice")
    KeywordModItem[3] = Keyword.GetKeyword("zbfWornDevice")

    KeywordBarterItem = new Keyword[4]
    KeywordBarterItem[0] = VendorItemGem
    KeywordBarterItem[1] = VendorItemJewelry
    KeywordBarterItem[2] = VendorItemFood
    KeywordBarterItem[3] = VendorItemFoodRaw
EndFunction

Function PopulateLicenseBooksArray()
    LicenseBooks = new Book[12]
    LicenseBooks[0] = bmlUtility.BM_ArmorLicense
    LicenseBooks[1] = bmlUtility.BM_BikiniLicense
    LicenseBooks[2] = bmlUtility.BM_ClothingLicense
    LicenseBooks[3] = bmlUtility.BM_MagicLicense
    LicenseBooks[4] = bmlUtility.BM_WeaponLicense
    LicenseBooks[5] = bmlUtility.BM_CraftingLicense
    LicenseBooks[6] = bmlUtility.BM_TradingLicense
    LicenseBooks[7] = bmlUtility.BM_WhoreLicense
    LicenseBooks[8] = bmlUtility.BM_TravelPermit
    LicenseBooks[9] = bmlUtility.BM_CollarExemption
    LicenseBooks[10] = bmlUtility.BM_Insurance
    LicenseBooks[11] = bmlUtility.BM_CurfewExemption
EndFunction

Function PopulateKeywordBikiniItemArray()
	String[] BikiniKeyword = PapyrusUtil.StringSplit(bmlmcm.bikiniKeywordString, ", ")
    BikiniKeyword = PapyrusUtil.ClearEmpty(BikiniKeyword)
    KeywordBikiniItem = new Keyword[15] ; limit to 15 for performance
    int i = 0
    while i < BikiniKeyword.length
        if BikiniKeyword[i]
            KeywordBikiniItem[i] = Keyword.GetKeyword(BikiniKeyword[i])
        endIf
        i += 1
    EndWhile
EndFunction
; ------------------------------

; ----------------------------------------------------------------------------------------------------
; -------------------------------------------------- End Internal Tools
; ----------------------------------------------------------------------------------------------------

ReferenceAlias Property playerRef auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Utility Property bmlUtility Auto
MiscObject Property Gold001  Auto
ObjectReference Property BM_ItemConfiscationChest Auto

bool Property hasArmorLicense = true auto conditional
bool Property hasBikiniLicense = true auto conditional
bool Property hasClothingLicense = true auto conditional
bool Property hasMagicLicense = true auto conditional
bool Property hasWeaponLicense = true auto conditional
bool Property hasCraftingLicense = true auto conditional
bool Property hasTradingLicense = true auto conditional
bool Property hasWhoreLicense = true auto conditional
bool Property hasTravelPermit = true auto conditional
bool Property hasCollarExemption = true auto conditional
bool Property hasInsurance = true auto conditional
bool Property hasCurfewExemption = true auto conditional

bool Property isArmorViolation auto conditional
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
bool Property isThane = false auto
bool Property isAccompanied = false auto
bool Property isInsured
    bool Function Get()
        return hasInsurance || (bmlmcm.isInsuranceFeatureEnabled && bmlmcm.thaneImmunityInsurance && isThane)
    EndFunction
EndProperty

; Below variables are 'trapped' when true. They remain true even if player loses Thaneship due to Civil War. This behavior is FINE.
bool Property isWhiterunThane auto
bool Property isWinterholdThane auto
bool Property isRiftThane auto
bool Property isReachThane auto
bool Property isPaleThane auto
bool Property isHjaalmarchThane auto
bool Property isHaafingarThane auto
bool Property isFalkreathThane auto
bool Property isEastmarchThane auto

bool Property isLicenseLimit = false auto conditional

; if expiration time == -1.0 -> not purchased yet
; resets after license runs out
float property armorLicenseExpirationTime = -1.0 auto conditional
float property bikiniLicenseExpirationTime = -1.0 auto conditional
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

Enchantment Property NullifyMagickaEnchantment  Auto  
Spell Property NullifyMagickaSpell  Auto  
MagicEffect Property NullifyMagickaMagicEffect  Auto  

Message Property MessageTravelLocated  Auto  
Message Property MessageTravelMissing  Auto 
Message Property MessageArmorCountdown  Auto  
Message Property MessageArmorExpired  Auto 
Message Property MessageBikiniCountdown  Auto  
Message Property MessageBikiniExpired  Auto 
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
Book[] Property LicenseBooks Auto
Keyword[] Property KeywordBikiniItem Auto
Keyword[] Property KeywordQuestItem Auto
Keyword[] Property KeywordModItem Auto
Keyword[] Property KeywordBarterItem Auto
Keyword[] Property KeywordConfiscation Auto
Keyword[] Property KeywordConfiscationEnch Auto
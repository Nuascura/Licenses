Scriptname BM_API Hidden

; ----------------------------------------------------------------------------------------------------
; -------------------------------------------------- API
; ----------------------------------------------------------------------------------------------------

; - Guide -
; BM_Licenses is the central script
; BM_Player is for Player Quest Alias and any Events that run with said alias
; BM_Licenses_Utility holds internally shared functions
; Scripts prefixed with BM_ME indicate that they are Magic Effects linked to a spell or enchantment
; Scripts prefixed with BM_D indicate they are dialogue scripts holding start and end fragments
; Scripts prefixed with BM_Licenses indicate they are quest scripts

; - Available Events -
; --Vanilla--
; BM-LPO_ReporterLOSGain
; BM-LPO_ViolationCheck
; BM-LPO_ViolationFound
; BM-LPO_BountyStart
; BM-LPO_BountyEnd
; --Custom--
; BM-LPO_ConfrontationStart
; BM-LPO_ConfrontationWalkaway
; BM-LPO_ConfrontationEnd
; BM-LPO_LicenseAdded
; BM-LPO_LicenseRemoved
; BM-LPO_LicensePurchased
; BM-LPO_LicenseExpired

; -------------------------------------------------- Interface Tools --------------------------------------------------
; By and large, these are template functions, though some may be used as is by my own scripts, now or in the future.

; Get - Mod Version
string Function GetModVersion() Global
    return "1.25.1"
EndFunction

; Get - Config Version
int Function GetConfigVersion() Global
	return 21
EndFunction

; Get - Script Version
int Function GetVersion() Global
	return 0x01250121 ; 0x01020304
EndFunction

; Get - Mod Name
string Function GetModName(bool cache = true) Global
	if cache
		return GetMCM().modname
	else
		return "Licenses - Player Oppression"
	endIf
EndFunction

; Get - Mod State
float Function GetModState() Global
    return GetMCM().Licenses_State.GetValue()
EndFunction

; Get - Utility
BM_Licenses_Utility Function GetUtility() Global
	return Quest.GetQuest("BM_Licenses_Utility") as BM_Licenses_Utility
EndFunction

; Get - MCM
BM_Licenses_MCM Function GetMCM() Global
	return Quest.GetQuest("BM_Licenses_MCM") as BM_Licenses_MCM
EndFunction

; Get - Core
BM_Licenses Function GetLPO() Global
	return Quest.GetQuest("BM_Licenses") as BM_Licenses
EndFunction

; Get - License ID
; Parameter 0 asks for a license or violation prefix as string.
; Note that Life Insurance uses "Insurance" as its prefix within scripts.
; If function returns -1, prefix couldn't retrieve an ID.
int Function GetLicenseID(string LicensePrefix) Global
    if LicensePrefix
        if LicensePrefix == "Armor"
            return 1
        elseIf LicensePrefix == "Bikini1"
            return 2
        elseIf LicensePrefix == "Bikini2"
            return 3
        elseIf LicensePrefix == "Clothing"
            return 4
        elseIf LicensePrefix == "Magic"
            return 5
        elseIf LicensePrefix == "Weapon"
            return 6
        elseIf LicensePrefix == "Crafting"
            return 7
        elseIf LicensePrefix == "Travel"
            return 8
        elseIf LicensePrefix == "Collar"
            return 9
        elseIf LicensePrefix == "Insurance"
            return 10
        elseIf LicensePrefix == "Curfew"
            return 11
        elseIf LicensePrefix == "Trading"
            return 12
        elseIf LicensePrefix == "Whore"
            return 13
        endIf
    endIf

    return -1
EndFunction

; Get - License SID
; Parameter 0 asks for a license ID as int.
; Parameter 1 asks for a license prefix as string.
; Whereas prefixes are shorthands for mod authors, SIDs have an internal use.
string Function GetLicenseSID(string inputID = "") Global
    if inputID
        if inputID == "Armor" || (inputID as int) == 1
            return "ArmorLicense"
        elseIf inputID == "Bikini1" || (inputID as int) == 2
            return "BikiniLicense"
        elseIf inputID == "Bikini2" || (inputID as int) == 3
            return "BikiniExemption"
        elseIf inputID == "Clothing" || (inputID as int) == 4
            return "ClothingLicense"
        elseIf inputID == "Magic" || (inputID as int) == 5
            return "MagicLicense"
        elseIf inputID == "Weapon" || (inputID as int) == 6
            return "WeaponLicense"
        elseIf inputID == "Crafting" || (inputID as int) == 7
            return "CraftingLicense"
        elseIf inputID == "Travel" || (inputID as int) == 8
            return "TravelPermit"
        elseIf inputID == "Collar" || (inputID as int) == 9
            return "CollarExemption"
        elseIf inputID == "Insurance" || (inputID as int) == 10
            return "Insurance"
        elseIf inputID == "Curfew" || (inputID as int) == 11
            return "CurfewExemption"
        elseIf inputID == "Trading" || (inputID as int) == 12
            return "TradingLicense"
        elseIf inputID == "Whore" || (inputID as int) == 13
            return "WhoreLicense"
        endIf
    endIf

    return ""
EndFunction

; Get - License Time left
; Parameter 0 asks for a license or violation prefix as string.
; This function returns a remaining time per in-game hours.
; If function returns a negative value, the subject license cycle is inactive.
; If function returns 0, either the subject license cycle is waiting for a refresh or function was given an invalid input.
float Function GetLicenseTimeLeft(int LicenseType, BM_Licenses_Utility bmlUtility = none) Global
    if !bmlUtility
        bmlUtility = GetUtility()
    endIf
    BM_Licenses bml = bmlUtility.licenses
    
    float currentTime = bmlUtility.GameDaysPassed.GetValue()

    if LicenseType == 1
        return bml.armorLicenseExpirationTime - currentTime
    elseIf LicenseType == 2
        return bml.bikiniLicenseExpirationTime - currentTime
    elseIf LicenseType == 3
        return bml.bikiniExemptionExpirationTime - currentTime
    elseIf LicenseType == 4
        return bml.clothingLicenseExpirationTime - currentTime
    elseIf LicenseType == 5
        return bml.magicLicenseExpirationTime - currentTime
    elseIf LicenseType == 6
        return bml.weaponLicenseExpirationTime - currentTime
    elseIf LicenseType == 7
        return bml.craftingLicenseExpirationTime - currentTime
    elseIf LicenseType == 8
        return bml.travelPermitExpirationTime - currentTime
    elseIf LicenseType == 9
        return bml.collarExemptionExpirationTime - currentTime
    elseIf LicenseType == 10
        return bml.insuranceExpirationTime - currentTime
    elseIf LicenseType == 11
        return bml.curfewExemptionExpirationTime - currentTime
    elseIf LicenseType == 12
        return bml.tradingLicenseExpirationTime - currentTime
    elseIf LicenseType == 13
        return bml.whoreLicenseExpirationTime - currentTime
    else
        return 0
    endIf
EndFunction

; Flag Violation
; Parameter 0 asks for an integer corresponding to a violation type. 
; Parameter 1 asks if you want to push to aggregate violations and invoke the bounty quest. If manually flagging multiple violations in succession, pass true only with the last FlagViolation call.
; Parameter 2 asks if you want to skip safety checks. Don't change this boolean from its default unless absolutely necessary.
bool Function FlagViolation(int ViolationType, bool Push = true, bool CheckSafety = true, BM_Licenses_Utility bmlUtility = none) Global
    if !bmlUtility
        bmlUtility = GetUtility()
    endIf
    BM_Licenses bml = bmlUtility.licenses

    if CheckSafety && bmlUtility.IsExceptionState()
        return false
    endIf

    if ViolationType == 0
        ; Empty
    elseIf ViolationType == 1
        bml.isArmorViolation = true
    elseIf ViolationType == 2
        bml.isBikiniViolation = 1
    elseIf ViolationType == 3
        bml.isBikiniViolation = 2
    elseIf ViolationType == 4
        bml.isClothingViolation = true
    elseIf ViolationType == 5
        bml.isMagicViolation = true
    elseIf ViolationType == 6
        bml.isWeaponViolation = true
    elseIf ViolationType == 7
        bml.isCraftingViolation = true
    elseIf ViolationType == 8
        bml.isTravelViolation = true
    elseIf ViolationType == 9
        bml.isCollarViolation = true
    elseIf ViolationType == 10
        bml.isUninsuredViolation = true
    elseIf ViolationType == 11
        bml.isCurfewViolation = true
    elseIf ViolationType == 12
        bml.isTradingViolation = true
    elseIf ViolationType == 13
        bml.isWhoreViolation = true
    else
        return false
    endIf

    if Push
        bmlUtility.AggregateViolations()
    endIf

    return true
EndFunction

; Clear Violations
; Parameter 0 asks if you want to clear persistent violations.
; Parameter 1 asks if you want to skip safety checks. Don't change this boolean from its default unless absolutely necessary.
; Note: This is an API layer above ResetViolations(). This function is intended to be called directly, outside LPO events, and will refresh LOS quest and active Fine amounts when run.
;       If you'd like to pass a Confrontation type, or require finer control over violation resetting, you should either call ResetViolations() directly or design your own function.
bool Function ClearViolations(bool ClearPersistent = false, bool CheckSafety = true, BM_Licenses_Utility bmlUtility = none) Global
    if !bmlUtility
        bmlUtility = GetUtility()
    endIf
    BM_Licenses bml = bmlUtility.licenses

    if CheckSafety && bmlUtility.licenseBountyQuest.IsRunning()
        return false
    endIf

    if ClearPersistent
        bml.ResetViolations()
    else
        bml.ResetViolations(-1)
    endIf

    return true
EndFunction

; Purchase License
; Parameter 0 asks for an integer corresponding to a license type.
; Parameter 1 asks if you'd like to subtract a corresponding cost from player gold. Note that the function doesn't check whether the player has enough gold on-hand.
; Parameter 2 asks if you want to skip safety checks. Don't change this boolean from its default unless absolutely necessary.
bool Function PurchaseLicense(int LicenseType, bool SubtractGold = true, bool CheckSafety = true, BM_Licenses_Utility bmlUtility = none) Global
    if !bmlUtility
        bmlUtility = GetUtility()
    endIf
    
    if CheckSafety && bmlUtility.IsExceptionState()
        return false
    endIf

    if LicenseType == 0
        ; Empty
    elseIf LicenseType == 1
        bmlUtility.BM_PurchaseArmorLicense(SubtractGold)
    elseIf LicenseType == 2
        bmlUtility.BM_PurchaseBikiniLicense(SubtractGold)
    elseIf LicenseType == 3
        bmlUtility.BM_PurchaseBikiniExemption(SubtractGold)
    elseIf LicenseType == 4
        bmlUtility.BM_PurchaseClothingLicense(SubtractGold)
    elseIf LicenseType == 5
        bmlUtility.BM_PurchaseMagicLicense(SubtractGold)
    elseIf LicenseType == 6
        bmlUtility.BM_PurchaseWeaponLicense(SubtractGold)
    elseIf LicenseType == 7
        bmlUtility.BM_PurchaseCraftingLicense(SubtractGold)
    elseIf LicenseType == 8
        bmlUtility.BM_PurchaseTravelPermit(SubtractGold)
    elseIf LicenseType == 9
        bmlUtility.BM_PurchaseCollarExemption(SubtractGold)
    elseIf LicenseType == 10
        bmlUtility.BM_PurchaseLifeInsurance(SubtractGold)
    elseIf LicenseType == 11
        bmlUtility.BM_PurchaseCurfewExemption(SubtractGold)
    elseIf LicenseType == 12
        bmlUtility.BM_PurchaseTradingLicense(SubtractGold)
    elseIf LicenseType == 13
        bmlUtility.BM_PurchaseWhoreLicense(SubtractGold)
    else
        return false
    endIf

    return true
EndFunction

; Expire License
; Parameter 0 asks for an integer corresponding to a license type.
; Parameter 1 asks if you want to push to refresh mod-wide variables. If manually expiring multiple licenses in succession, pass true only with the last ExpireLicense call.
; Note: This function prematurely ends active license cycles. If you want to steal a license, use RemoveItem() or RemoveLicense() below.
bool Function ExpireLicense(int LicenseType, bool Push = true, BM_Licenses_Utility bmlUtility = none) Global
    if !bmlUtility
        bmlUtility = GetUtility()
    endIf
    
    if LicenseType == 0
        ; Empty
    elseIf LicenseType == 1
        bmlUtility.BM_ExpireArmorLicense()
    elseIf LicenseType == 2
        bmlUtility.BM_ExpireBikiniLicense()
    elseIf LicenseType == 3
        bmlUtility.BM_ExpireBikiniExemption()
    elseIf LicenseType == 4
        bmlUtility.BM_ExpireClothingLicense()
    elseIf LicenseType == 5
        bmlUtility.BM_ExpireMagicLicense()
    elseIf LicenseType == 6
        bmlUtility.BM_ExpireWeaponLicense()
    elseIf LicenseType == 7
        bmlUtility.BM_ExpireCraftingLicense()
    elseIf LicenseType == 8
        bmlUtility.BM_ExpireTravelPermit()
    elseIf LicenseType == 9
        bmlUtility.BM_ExpireCollarExemption()
    elseIf LicenseType == 10
        bmlUtility.BM_ExpireLifeInsurance()
    elseIf LicenseType == 11
        bmlUtility.BM_ExpireCurfewExemption()
    elseIf LicenseType == 12
        bmlUtility.BM_ExpireTradingLicense()
    elseIf LicenseType == 13
        bmlUtility.BM_ExpireWhoreLicense()
    else
        return false
    endIf

    if Push
        bmlUtility.ModeratorUpdater()
    endIf

    return true
EndFunction

; Remove License
; Parameter 0 asks for an integer corresponding to a license type.
; Parameter 1 asks for an integer corresponding to a license book amount.
; Parameter 2 asks for a destination container.
; Parameter 3 asks if you want to skip safety checks. Don't change this boolean from its default unless absolutely necessary.
; Note: This function only removes license book items. If you want to end an active license cycle, use ExpireLicense().
; Note: LPO catches book item add and remove events filtered only for enabled license features. Disabled licenses disable corresponding book item filters. 
;       Item removals in such scenarios won't create hard issues but are likely counter-intuitive unless you're sure of what you're doing.
bool Function RemoveLicense(int LicenseType, int LicenseCount = 0, ObjectReference DestinationContainer = None, bool CheckSafety = true, BM_Licenses_Utility bmlUtility = none) Global
    if !bmlUtility
        bmlUtility = GetUtility()
    endIf
    BM_Licenses bml = bmlUtility.licenses
    BM_Licenses_MCM bmlmcm = bmlUtility.bmlmcm
    Book LicenseToRemove = none

    if LicenseType == 0
        ; Empty
    elseIf LicenseType == 1
        if !CheckSafety || bmlmcm.isArmorLicenseFeatureEnabled
            LicenseToRemove = bmlUtility.BM_ArmorLicense
        endIf
    elseIf LicenseType == 2
        if !CheckSafety || bmlmcm.isBikiniLicenseFeatureEnabled == 1
            LicenseToRemove = bmlUtility.BM_BikiniLicense
        endIf
    elseIf LicenseType == 3
        if !CheckSafety || bmlmcm.isBikiniLicenseFeatureEnabled == 2
            LicenseToRemove = bmlUtility.BM_BikiniExemption
        endIf
    elseIf LicenseType == 4
        if !CheckSafety || bmlmcm.isClothingLicenseFeatureEnabled
            LicenseToRemove = bmlUtility.BM_ClothingLicense
        endIf
    elseIf LicenseType == 5
        if !CheckSafety || bmlmcm.isMagicLicenseFeatureEnabled
            LicenseToRemove = bmlUtility.BM_MagicLicense
        endIf
    elseIf LicenseType == 6
        if !CheckSafety || bmlmcm.isWeaponLicenseFeatureEnabled
            LicenseToRemove = bmlUtility.BM_WeaponLicense
        endIf
    elseIf LicenseType == 7
        if !CheckSafety || bmlmcm.isCraftingLicenseFeatureEnabled
            LicenseToRemove = bmlUtility.BM_CraftingLicense
        endIf
    elseIf LicenseType == 8
        if !CheckSafety || bmlmcm.isTravelPermitFeatureEnabled
            LicenseToRemove = bmlUtility.BM_TravelPermit
        endIf
    elseIf LicenseType == 9
        if !CheckSafety || bmlmcm.isCollarExemptionFeatureEnabled
            LicenseToRemove = bmlUtility.BM_CollarExemption
        endIf
    elseIf LicenseType == 10
        if !CheckSafety || bmlmcm.isInsuranceFeatureEnabled
            LicenseToRemove = bmlUtility.BM_Insurance
        endIf
    elseIf LicenseType == 11
        if !CheckSafety || bmlmcm.isCurfewExemptionFeatureEnabled
            LicenseToRemove = bmlUtility.BM_CurfewExemption
        endIf
    elseIf LicenseType == 12
        if !CheckSafety || bmlmcm.isTradingLicenseFeatureEnabled
            LicenseToRemove = bmlUtility.BM_TradingLicense
        endIf
    elseIf LicenseType == 13
        if !CheckSafety || bmlmcm.isWhoreLicenseFeatureEnabled
            LicenseToRemove = bmlUtility.BM_WhoreLicense
        endIf
    else
        return false
    endIf

    if LicenseToRemove
        if LicenseCount < 1
            LicenseCount = bml.PlayerActorRef.GetItemCount(LicenseToRemove)
        endIf
        if bml.PlayerActorRef.GetItemCount(LicenseToRemove) > 0
            bml.PlayerActorRef.RemoveItem(LicenseToRemove, LicenseCount, true, DestinationContainer)
        endIf
    else
        return false
    endIf

    return true
EndFunction

; Toggle License Feature
; Parameter 0 asks for an integer corresponding to a license type.
; Parameter 1 asks for a desired feature state.
; Parameter 2 asks if you want to push to refresh mod-wide variables. If manually toggling multiple licenses in succession, pass true only with the last ToggleLicenseFeature call.
bool Function ToggleLicenseFeature(int LicenseType, bool FeatureFlag, bool Push = true, BM_Licenses_Utility bmlUtility = none) Global
    if !bmlUtility
        bmlUtility = GetUtility()
    endIf
    BM_Licenses_MCM bmlmcm = bmlUtility.bmlmcm

    If LicenseType == 1
        bmlmcm.isArmorLicenseFeatureEnabled = FeatureFlag
    elseIf LicenseType == 2
        if FeatureFlag
            bmlmcm.isBikiniLicenseFeatureEnabled = 1
        else
            bmlmcm.isBikiniLicenseFeatureEnabled = 0
        endIf
    elseIf LicenseType == 3
        if FeatureFlag
            bmlmcm.isBikiniLicenseFeatureEnabled = 2
        else
            bmlmcm.isBikiniLicenseFeatureEnabled = 0
        endIf
    elseIf LicenseType == 4
        bmlmcm.isClothingLicenseFeatureEnabled = FeatureFlag
    elseIf LicenseType == 5
        bmlmcm.isMagicLicenseFeatureEnabled = FeatureFlag
    elseIf LicenseType == 6
        bmlmcm.isWeaponLicenseFeatureEnabled = FeatureFlag
    elseIf LicenseType == 7
        bmlmcm.isCraftingLicenseFeatureEnabled = FeatureFlag
    elseIf LicenseType == 8
        bmlmcm.isTravelPermitFeatureEnabled = FeatureFlag
    elseIf LicenseType == 9
        bmlmcm.isCollarExemptionFeatureEnabled = FeatureFlag
    elseIf LicenseType == 10
        bmlmcm.isInsuranceFeatureEnabled = FeatureFlag
    elseIf LicenseType == 11
        bmlmcm.isCurfewExemptionFeatureEnabled = FeatureFlag
    elseIf LicenseType == 12
        bmlmcm.isTradingLicenseFeatureEnabled = FeatureFlag
    elseIf LicenseType == 13
        bmlmcm.isWhoreLicenseFeatureEnabled = FeatureFlag
    else
        return false
    endIf

    if Push
        bmlUtility.RefreshLicenses()
    endIf

    return true
EndFunction

; -------------------------------------------------- Common Tools --------------------------------------------------
Bool Function ActualizeValue(String sid, Bool abFlag1, Bool abFlag2) Global
    abFlag1 = ((abFlag1 && abFlag2) || !abFlag2)
    StorageUtil.SetIntValue(None, "LPO_" + sid, (abFlag1 as int) - (2 * ((!abFlag2) as int)))
    return abFlag1
EndFunction

Location Function FindLocFromList(Location[] LocArray, FormList LocList) Global
    int index = LocArray.length
    while index
        index -= 1
        if LocList.HasForm(LocArray[index])
            return LocArray[index]
        endIf
    endWhile
    return none
EndFunction

Location Function FindLocFromParent(Location akLoc, FormList LocList, Keyword akKeyword = none) Global
    int index = 0
    While(index < LocList.GetSize())
        If akLoc.IsSameLocation(LocList.GetAt(index) as location, akKeyword)
            Return LocList.GetAt(index) as location
        EndIf
        index += 1
    EndWhile
    return none
EndFunction

WorldSpace Function FindWorldFromList(WorldSpace[] WorldArray, FormList WorldList) Global
    int index = WorldArray.length
    WorldSpace CachedSpace = none
    while index
        index -= 1
        if WorldList.HasForm(WorldArray[index])
            return WorldArray[index]
        endIf
    endWhile
    return CachedSpace
EndFunction

WorldSpace Function FindWorldFromDoor(ObjectReference[] DoorArray, FormList WorldList) Global
    int index = 0
    WorldSpace CachedSpace = none
    while index < DoorArray.Length
        if DoorArray[index] && PO3_SKSEFunctions.IsLoadDoor(DoorArray[index])
            WorldSpace CurrExteriorWorld = PO3_SKSEFunctions.GetDoorDestination(DoorArray[index]).GetWorldSpace()
            if CurrExteriorWorld
                if WorldList.HasForm(CurrExteriorWorld)
                    return CurrExteriorWorld
                endIf
            endIf
        endIf
        index += 1
    endWhile
    return CachedSpace
EndFunction

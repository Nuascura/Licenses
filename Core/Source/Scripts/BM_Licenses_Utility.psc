Scriptname BM_Licenses_Utility extends Quest  

; ----------------------------------------------------------------------------------------------------
; -------------------------------------------------- Utility
; ----------------------------------------------------------------------------------------------------

; - Guide -
; BM_Licenses is the central script
; BM_Player is for Player Quest Alias and any Events that run with said alias
; BM_Licenses_Utility holds shared/common functions AND functions that external mods may wish to use
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

; -------------------------------------------------- Simple Tools --------------------------------------------------
; By and large, these are template functions, though some may be used as is by my own scripts, now or in the future.

; Get - Mod Version
; This is a shortcut function.
string Function GetModVersion()
    return bmlmcm.GetModVersion()
EndFunction

; Get - License ID
; Parameter 1 asks for a license or violation prefix as string.
; Note that Life Insurance uses "Insurance" as its prefix within scripts.
; If function returns 0, prefix couldn't retrieve an ID. If function returns -1, function was given an invalid input.
int Function GetLicenseID(string LicensePrefix)
    if LicensePrefix
        if LicensePrefix == "Armor"
            return 1
        elseIf LicensePrefix == "Bikini"
            return 2
        elseIf LicensePrefix == "Clothing"
            return 3
        elseIf LicensePrefix == "Magic"
            return 4
        elseIf LicensePrefix == "Weapon"
            return 5
        elseIf LicensePrefix == "Crafting"
            return 6
        elseIf LicensePrefix == "Travel"
            return 7
        elseIf LicensePrefix == "Collar"
            return 8
        elseIf LicensePrefix == "Insurance"
            return 9
        elseIf LicensePrefix == "Curfew"
            return 10
        elseIf LicensePrefix == "Trading"
            return 11
        elseIf LicensePrefix == "Whore"
            return 12
        else
            LogTrace("GetLicenseID(): Parameter(1) failed to retrieve an ID from index, returning 0.")
            return 0
        endIf
    endIf

    LogTrace("GetLicenseID(): Ran to function default. Invalid parameter(1)")
    return -1
EndFunction

; Get - License Time left
; Parameter 1 asks for a license or violation prefix as string.
; This function returns a remaining time per in-game hours.
; If function returns a negative value, the subject license cycle is inactive.
; If function returns 0, either the subject license cycle is waiting for a refresh or function was given an invalid input.
Float Function GetLicenseTimeLeft(int LicenseType)
    float currentTime = GameDaysPassed.GetValue()
    if LicenseType == 1
        return licenses.armorLicenseExpirationTime - currentTime
    elseIf LicenseType == 2
        return licenses.bikiniLicenseExpirationTime - currentTime
    elseIf LicenseType == 3
        return licenses.clothingLicenseExpirationTime - currentTime
    elseIf LicenseType == 4
        return licenses.magicLicenseExpirationTime - currentTime
    elseIf LicenseType == 5
        return licenses.weaponLicenseExpirationTime - currentTime
    elseIf LicenseType == 6
        return licenses.craftingLicenseExpirationTime - currentTime
    elseIf LicenseType == 7
        return licenses.travelPermitExpirationTime - currentTime
    elseIf LicenseType == 8
        return licenses.collarExemptionExpirationTime - currentTime
    elseIf LicenseType == 9
        return licenses.insuranceExpirationTime - currentTime
    elseIf LicenseType == 10
        return licenses.curfewExemptionExpirationTime - currentTime
    elseIf LicenseType == 11
        return licenses.tradingLicenseExpirationTime - currentTime
    elseIf LicenseType == 12
        return licenses.whoreLicenseExpirationTime - currentTime
    else
        LogTrace("GetLicenseTimeLeft(): Invalid parameter(1)")
        return 0
    endIf
EndFunction

; Flag Violation
; Parameter 1 asks for an integer corresponding to a violation type. 
; Parameter 2 asks if you want to push to aggregate violations and invoke the bounty quest. If manually flagging multiple violations in succession, pass true only with the last FlagViolation call.
; Parameter 3 asks if you want to skip safety checks. Don't change this boolean from its default unless absolutely necessary.
bool Function FlagViolation(int ViolationType, bool Push = true, bool CheckSafety = true)
    if CheckSafety && IsExceptionState()
        LogTrace("FlagViolation(): Detected an Exception State. Exit function.")
        return false
    endIf

    if ViolationType == 0
        ; Empty
        LogTrace("FlagViolation(): Received integer 0 for parameter(1)")
    elseIf (ViolationType == 1) || (ViolationType == 2) || (ViolationType == 3)
        licenses.isArmorViolation = true
    elseIf ViolationType == 4
        licenses.isMagicViolation = true
    elseIf ViolationType == 5
        licenses.isWeaponViolation = true
    elseIf ViolationType == 6
        licenses.isCraftingViolation = true
    elseIf ViolationType == 7
        licenses.isTravelViolation = true
    elseIf ViolationType == 8
        licenses.isCollarViolation = true
    elseIf ViolationType == 9
        licenses.isUninsuredViolation = true
    elseIf ViolationType == 10
        licenses.isCurfewViolation = true
    elseIf ViolationType == 11
        licenses.isTradingViolation = true
    elseIf ViolationType == 12
        licenses.isWhoreViolation = true
    else
        LogTrace("FlagViolation(): Invalid parameter(1)")
        return false
    endIf

    if Push
        AggregateViolations()
    endIf

    return true
EndFunction

; Clear Violations
; Parameter 1 asks if you want to clear persistent violations.
; Parameter 2 asks if you want to skip safety checks. Don't change this boolean from its default unless absolutely necessary.
; Note: This is an API layer above ResetViolations(). This function is intended to be called directly, outside LPO events, and will refresh LOS quest and active Fine amounts when run.
;       If you'd like to pass a Confrontation type, or require finer control over violation resetting, you should either call ResetViolations() directly or design your own function.
bool Function ClearViolations(bool ClearPersistent = false, bool CheckSafety = true)
    if CheckSafety && licenseBountyQuest.IsRunning()
        LogTrace("ClearViolations(): Detected an Exception State. Exit function.")
        return false
    endIf

    if ClearPersistent
        licenses.ResetViolations()
    else
        licenses.ResetViolations(-1)
    endIf

    return true
EndFunction

; Purchase License
; Parameter 1 asks for an integer corresponding to a license type.
; Parameter 2 asks if you'd like to subtract a corresponding cost from player gold. Note that the function doesn't check whether the player has enough gold on-hand.
; Parameter 3 asks if you want to skip safety checks. Don't change this boolean from its default unless absolutely necessary.
bool Function PurchaseLicense(int LicenseType, bool SubtractGold = true, bool CheckSafety = true)
    if CheckSafety && IsExceptionState()
        LogTrace("PurchaseLicense(): Detected an Exception State. Exit function.")
        return false
    endIf

    if LicenseType == 0
        ; Empty
        LogTrace("PurchaseLicense(): Received integer 0 for parameter(1)")
    elseIf LicenseType == 1
        BM_PurchaseArmorLicense(SubtractGold)
    elseIf LicenseType == 2
        BM_PurchaseBikiniLicense(SubtractGold)
    elseIf LicenseType == 3
        BM_PurchaseClothingLicense(SubtractGold)
    elseIf LicenseType == 4
        BM_PurchaseMagicLicense(SubtractGold)
    elseIf LicenseType == 5
        BM_PurchaseWeaponLicense(SubtractGold)
    elseIf LicenseType == 6
        BM_PurchaseCraftingLicense(SubtractGold)
    elseIf LicenseType == 7
        BM_PurchaseTravelPermit(SubtractGold)
    elseIf LicenseType == 8
        BM_PurchaseCollarExemption(SubtractGold)
    elseIf LicenseType == 9
        BM_PurchaseLifeInsurance(SubtractGold)
    elseIf LicenseType == 10
        BM_PurchaseCurfewExemption(SubtractGold)
    elseIf LicenseType == 11
        BM_PurchaseTradingLicense(SubtractGold)
    elseIf LicenseType == 12
        BM_PurchaseWhoreLicense(SubtractGold)
    else
        LogTrace("PurchaseLicense(): Invalid parameter(1)")
        return false
    endIf

    return true
EndFunction

; Expire License
; Parameter 1 asks for an integer corresponding to a license type.
; Parameter 2 asks if you want to push to refresh mod-wide variables. If manually expiring multiple licenses in succession, pass true only with the last ExpireLicense call.
; Note: This function prematurely ends active license cycles. If you want to steal a license, use RemoveItem() or RemoveLicense() below.
bool Function ExpireLicense(int LicenseType, bool Push = true)
    if LicenseType == 0
        ; Empty
        LogTrace("ExpireLicense(): Received integer 0 for parameter(1)")
    elseIf LicenseType == 1
        BM_ExpireArmorLicense()
    elseIf LicenseType == 2
        BM_ExpireBikiniLicense()
    elseIf LicenseType == 3
        BM_ExpireClothingLicense()
    elseIf LicenseType == 4
        BM_ExpireMagicLicense()
    elseIf LicenseType == 5
        BM_ExpireWeaponLicense()
    elseIf LicenseType == 6
        BM_ExpireCraftingLicense()
    elseIf LicenseType == 7
        BM_ExpireTravelPermit()
    elseIf LicenseType == 8
        BM_ExpireCollarExemption()
    elseIf LicenseType == 9
        BM_ExpireLifeInsurance()
    elseIf LicenseType == 10
        BM_ExpireCurfewExemption()
    elseIf LicenseType == 11
        BM_ExpireTradingLicense()
    elseIf LicenseType == 12
        BM_ExpireWhoreLicense()
    else
        LogTrace("ExpireLicense(): Invalid parameter(1)")
        return false
    endIf

    if Push
        ModeratorUpdater()
    else
        LogTrace("ExpireLicense(): Push is required. Waiting for push...")
    endIf

    return true
EndFunction

; Remove License
; Parameter 1 asks for an integer corresponding to a license type.
; Parameter 2 asks for an integer corresponding to a license book amount.
; Parameter 3 asks for a destination container.
; Parameter 4 asks if you want to skip safety checks. Don't change this boolean from its default unless absolutely necessary.
; Note: This function only removes license book items. If you want to end an active license cycle, use ExpireLicense().
; Note: LPO catches book item add and remove events filtered only for enabled license features. Disabled licenses disable corresponding book item filters. 
;       Item removals in such scenarios won't create hard issues but are likely counter-intuitive unless you're sure of what you're doing.
bool Function RemoveLicense(int LicenseType, int LicenseCount = 0, ObjectReference DestinationContainer = None, bool CheckSafety = true)
    Book LicenseToRemove = none

    if LicenseType == 0
        ; Empty
        LogTrace("RemoveLicense(): Received integer 0 for parameter(1)")
    elseIf LicenseType == 1
        if !CheckSafety || bmlmcm.isArmorLicenseFeatureEnabled
            LicenseToRemove = BM_ArmorLicense
        endIf
    elseIf LicenseType == 2
        if !CheckSafety || bmlmcm.isBikiniLicenseFeatureEnabled
            LicenseToRemove = BM_BikiniLicense
        endIf
    elseIf LicenseType == 3
        if !CheckSafety || bmlmcm.isClothingLicenseFeatureEnabled
            LicenseToRemove = BM_ClothingLicense
        endIf
    elseIf LicenseType == 4
        if !CheckSafety || bmlmcm.isMagicLicenseFeatureEnabled
            LicenseToRemove = BM_MagicLicense
        endIf
    elseIf LicenseType == 5
        if !CheckSafety || bmlmcm.isWeaponLicenseFeatureEnabled
            LicenseToRemove = BM_WeaponLicense
        endIf
    elseIf LicenseType == 6
        if !CheckSafety || bmlmcm.isCraftingLicenseFeatureEnabled
            LicenseToRemove = BM_CraftingLicense
        endIf
    elseIf LicenseType == 7
        if !CheckSafety || bmlmcm.isTravelPermitFeatureEnabled
            LicenseToRemove = BM_TravelPermit
        endIf
    elseIf LicenseType == 8
        if !CheckSafety || bmlmcm.isCollarExemptionFeatureEnabled
            LicenseToRemove = BM_CollarExemption
        endIf
    elseIf LicenseType == 9
        if !CheckSafety || bmlmcm.isInsuranceFeatureEnabled
            LicenseToRemove = BM_Insurance
        endIf
    elseIf LicenseType == 10
        if !CheckSafety || bmlmcm.isCurfewExemptionFeatureEnabled
            LicenseToRemove = BM_CurfewExemption
        endIf
    elseIf LicenseType == 11
        if !CheckSafety || bmlmcm.isTradingLicenseFeatureEnabled
            LicenseToRemove = BM_TradingLicense
        endIf
    elseIf LicenseType == 12
        if !CheckSafety || bmlmcm.isWhoreLicenseFeatureEnabled
            LicenseToRemove = BM_WhoreLicense
        endIf
    else
        LogTrace("RemoveLicense(): Invalid parameter(1)")
        return false
    endIf

    if LicenseToRemove
        if LicenseCount < 1
            LicenseCount = PlayerActorRef.GetItemCount(LicenseToRemove)
        endIf
        if PlayerActorRef.GetItemCount(LicenseToRemove) > 0
            PlayerActorRef.RemoveItem(LicenseToRemove, LicenseCount, true, DestinationContainer)
        endIf
    else
        LogTrace("RemoveLicense(): Parameter(1) returned an invalid or ineligible license to remove: LicenseType " + LicenseType + " for book item " + LicenseToRemove)
        return false
    endIf

    return true
EndFunction

; -------------------------------------------------- Common Tools --------------------------------------------------

; ---------- Startup ----------
Function Startup()
    LogNotification("Initializing Licenses...", true)
    LogTrace("State Change - INITIALIZING", true)

    ; Set Imperatives
    bmlmcm.allowJailQuestNodes = true
    bmlmcm.ConfigWarn = true

    ; Start Core Quests
    licenses.start()
    licenseBarterQuest.start()
    if licenseModeratorQuest.start()
        bmlModeratorAlias.OnLoad()
    endIf

    ; Start Add-on Quests
    if Game.GetModByName("Licenses - Ambience.esp") != 255
        Quest.GetQuest("LPO_WIComment").Start()
    endIf

    ; Buffer
    Utility.Wait(1.0)

    ; Initialize Variables
    FillLocalPlayer(licenses.PlayerRef.GetActorRef())
    ReloadMCMVariables()
    RefreshFeatures()
    RefreshStatus()
    

    ; Cache State
    Licenses_State = true
    LogNotification("Completed initialization sequence.", true)
    LogTrace("State Change - INITIALIZED", true)
EndFunction

Function FillLocalPlayer(Actor Player)
    PlayerActorRef = Player
    licenses.PlayerActorRef = Player
EndFunction
; ------------------------------

; ---------- Shutdown ----------
Function Shutdown()
    LogNotification("Terminating Licenses...", true)
    LogTrace("State Change - TERMINATING", true)

    ; Set Imperatives
    bmlmcm.allowJailQuestNodes = false
    bmlmcm.ConfigWarn = true

    ; Reset Additional Variables
    savedLoc = None
	savedSpace = None
    BM_IsPlayerCollared.SetValue(0.0) ; false by default
    BM_FirstTimeViolation.SetValue(1.0) ; true by default
	BM_LenientCurseViolation.SetValue(1.0) ; true by default
    BM_LenientCurfewViolation.SetValue(1.0) ; true by default

    ; Stop Add-on Quests
    if Game.GetModByName("Licenses - Ambience.esp") != 255
        Quest.GetQuest("LPO_WIComment").Stop()
    endIf

    ; Stop Quests
    licenses.stop()
    licenseViolationCheckQuest.stop()
    licenseThaneshipCheckQuest.stop()
    licenseBountyQuest.stop()
    licenseBarterQuest.stop()
    licenseDetectionQuest.stop()
    licenseModeratorQuest.stop()

    ; Cache State
    Licenses_State = false
    LogNotification("Completed termination sequence.", true)
    LogTrace("State Change - TERMINATED", true)
EndFunction
; ------------------------------

; ---------- Location Checkers ----------
Function CheckLocation()
    if PlayerActorRef.GetCurrentLocation()
        licenses.isInCity = GetIsInCity()
        licenses.isInTown = GetIsInTown()
    endIf
EndFunction

Function ValidateLocNested(Location akNewLoc, WorldSpace akNewSpace, FormList LocList, Keyword akKeyword = none)
    Location validatedLoc = FindLocFromParent(akNewLoc, LocList, akKeyword)
    if validatedLoc
        lastLoc = validatedLoc
        lastSpace = akNewSpace
    endIf
EndFunction

Location Function FindLocFromList(Location[] LocArray, FormList LocList)
    int index = LocArray.length
    while index
        index -= 1
        if LocList.HasForm(LocArray[index])
            return LocArray[index]
        endIf
    endWhile
    return none
EndFunction

Location Function FindLocFromParent(Location akLoc, FormList LocList, Keyword akKeyword = none)
    int index = 0
    While(index < LocList.GetSize())
        If akLoc.IsSameLocation(LocList.GetAt(index) as location, akKeyword)
            Return LocList.GetAt(index) as location
        EndIf
        index += 1
    EndWhile
    return none
EndFunction

WorldSpace Function FindWorldFromList(WorldSpace[] WorldArray, FormList WorldList)
    int index = WorldArray.length
    while index
        index -= 1
        if WorldList.HasForm(WorldArray[index])
            return WorldArray[index]
        endIf
    endWhile
    return none
EndFunction

WorldSpace Function FindWorldFromDoor(ObjectReference[] DoorArray)
    int index = 0
    while index < DoorArray.Length
        if DoorArray[index] && PO3_SKSEFunctions.IsLoadDoor(DoorArray[index])
            WorldSpace CurrExteriorWorld = PO3_SKSEFunctions.GetDoorDestination(DoorArray[index]).GetWorldSpace()
            if CurrExteriorWorld
                return CurrExteriorWorld
            endIf
        endIf
        index += 1
    endWhile
    return none
EndFunction

Bool Function GetIsInCity()
    Location[] ExteriorLocations = SPE_Cell.GetExteriorLocations(PlayerActorRef.GetParentCell())
    if ExteriorLocations
        lastLoc = FindLocFromList(ExteriorLocations, BM_Cities)
    else
        lastLoc = FindLocFromParent(PlayerActorRef.GetCurrentLocation(), BM_Cities, Keyword.GetKeyword("LocTypeCity"))
    endIf
    return lastLoc && (!bmlmcm.isLimitToCitySpaceEnabled || GetIsInCitySpace())
EndFunction

Bool Function GetIsInCitySpace()
    if BM_LicensesIgnoreWorldspace.HasForm(PlayerActorRef.GetWorldSpace())  
        return licenses.isInCity
    endIf
    WorldSpace[] ExteriorWorldSpaces = SPE_Cell.GetExteriorWorldSpaces(PlayerActorRef.GetParentCell())
    if ExteriorWorldSpaces
        lastSpace = FindWorldFromList(ExteriorWorldSpaces, BM_WorldSpaces)
    else
        lastSpace = FindWorldFromDoor(PO3_SKSEFunctions.FindAllReferencesOfFormType(PlayerActorRef, 29, 0))
    endIf
    return lastSpace
EndFunction

Bool Function GetIsInTown()
    Location[] ExteriorLocations = SPE_Cell.GetExteriorLocations(PlayerActorRef.GetParentCell())
    if ExteriorLocations
        lastLoc = FindLocFromList(ExteriorLocations, BM_Towns)
    else
        lastLoc = FindLocFromParent(PlayerActorRef.GetCurrentLocation(), BM_Towns, Keyword.GetKeyword("LocTypeTown"))
    endIf
    return lastLoc
EndFunction

Bool Function GetIsInPlayerHome(location targetLoc)
    return targetLoc && targetLoc.HasKeywordString("LocTypePlayerHouse")
EndFunction

Bool Function GetIsInJail(location targetLoc, bool ignoreLoc = false)
    ; approximation method
    if !(bmlmcm.PrisonAlternative_State || bmlmcm.PrisonOverhaulPatched_State) && (BM_IsInJail.GetValue() as bool)
        return !(ignoreLoc || (targetLoc && !targetLoc.HasKeywordString("LocTypeJail")))
    endIf
    return BM_IsInJail.GetValue()
EndFunction
; ------------------------------

; ---------- Form Validation (Solo) ----------
Bool Function ValidateSpellForms(Actor player, Spell leftSpell, Spell rightSpell)
    if leftSpell
        if !BM_LicensesIgnoreSpell.HasForm(leftSpell)
            return true
        endIf
    else
        if player.GetEquippedObject(0) as Scroll
            return true
        endIf
    endIf

    if rightSpell
        if !BM_LicensesIgnoreSpell.HasForm(rightSpell)
            return true
        endIf
    else
        if player.GetEquippedObject(1) as Scroll
            return true
        endIf
    endIf

    return false
EndFunction

Bool Function ValidateWeaponForms(Weapon leftWeapon, Weapon rightWeapon)
    if leftWeapon && !licenses.HasWhitelistedKeyword(leftWeapon)
        return true
    elseIf rightWeapon && !licenses.HasWhitelistedKeyword(rightWeapon)
        return true
    endIf

    return false
EndFunction
; ------------------------------

; ---------- Inventory Scanners ----------
Form[] Function ScanInventory_CommonFilter(Form[] Array)
    ; Filter out items matching keyword combinations
    Array = SPE_Utility.FilterFormsByKeyword(Array, licenses.KeywordQuestItem, true, true)
    Array = SPE_Utility.FilterFormsByKeyword(Array, licenses.KeywordModItem, false, true)
    return Array
EndFunction

Form[] Function ScanEquippedItems_Base(Actor playerActor)
    Form[] PotentialForms = PO3_SKSEFunctions.AddAllEquippedItemsToArray(playerActor)
    PotentialForms = SPE_Utility.FilterFormsByKeyword(PotentialForms, licenses.KeywordConfiscation, false, false)
    PotentialForms = ScanInventory_CommonFilter(PotentialForms)
    if (licenses.hasBikiniLicense && licenses.isInsured)
        PotentialForms = SPE_Utility.FilterFormsByKeyword(PotentialForms, licenses.KeywordBikiniItem, false, true)
    endIf
    return PotentialForms
EndFunction

Form[] Function ScanEquippedItems_Ench(Actor playerActor)
    Form[] PotentialFormsEnch = PO3_SKSEFunctions.AddAllEquippedItemsToArray(playerActor)
    PotentialFormsEnch = SPE_Utility.FilterFormsByKeyword(PotentialFormsEnch, licenses.KeywordConfiscationEnch, false, false)
    PotentialFormsEnch = SPE_Utility.IntersectArray_Form(PotentialFormsEnch, SPE_ObjectRef.GetEnchantedItems(playerActor, true, true, false))
    PotentialFormsEnch = ScanInventory_CommonFilter(PotentialFormsEnch)
    return PotentialFormsEnch
EndFunction

Form[] Function ScanInventory_Base(ObjectReference playerActor)
    ; Get items matching valid keywords per license features
    Form[] PotentialForms = SPE_ObjectRef.GetItemsByKeyword(playerActor, licenses.KeywordConfiscation, false)
    ; Filter
    PotentialForms = ScanInventory_CommonFilter(PotentialForms)
    if (licenses.hasBikiniLicense && licenses.isInsured)
        PotentialForms = SPE_Utility.FilterFormsByKeyword(PotentialForms, licenses.KeywordBikiniItem, false, true)
    endIf
    return PotentialForms
EndFunction

Form[] Function ScanInventory_Ench(ObjectReference playerActor)
    ; Get potentially enchanted items matching valid keywords per license features
    Form[] PotentialFormsEnch = SPE_ObjectRef.GetItemsByKeyword(playerActor, licenses.KeywordConfiscationEnch, false)
    ; Filter for only enchanted items
    PotentialFormsEnch = SPE_Utility.IntersectArray_Form(PotentialFormsEnch, SPE_ObjectRef.GetEnchantedItems(playerActor, true, true, false))
    ; Final Filter
    PotentialFormsEnch = ScanInventory_CommonFilter(PotentialFormsEnch)
    return PotentialFormsEnch
EndFunction
; ------------------------------

; ---------- Exception State Functions ----------
; Check Exception State
Function CheckExceptionState()
    BM_IsInPlayerHome.SetValue(GetIsInPlayerHome(currLoc) as float)
    BM_IsInJail.SetValue(GetIsInJail(currLoc) as float)
EndFunction

; Return Exception State
bool Function IsExceptionState()
    ; if the following conditions are true, don't run
    if licenseBountyQuest.IsRunning()
        LogTrace("Bounty Quest is already running")
        return true
    elseIf bmlmcm.thaneImmunityUniversal && licenses.isThane
        LogTrace("Player holds Thaneship in their current location")
        return true
    elseIf BM_IsInAnimation.GetValue() as bool
        LogTrace("Player is in SL or OS animation")
        return true
    elseIf BM_IsInJail.GetValue() as bool
        LogTrace("Player is a prisoner")
        return true
    elseIf BM_IsInPlayerHome.GetValue() as bool
        LogTrace("Player is at home")
        return true
    elseIf BM_IsInDHLPEvent.GetValue() as bool
        LogTrace("Player is in DHLP event")
        return true
    elseIf BM_IsInSSLV.GetValue() as bool
        LogTrace("Player is in SSLV")
        return true
    else
        LogTrace("No exception state detected")
        return false
    endIf
EndFunction
; ------------------------------

; ---------- Core Licenses Updaters ----------
Function CheckLicenseStatus()
    float currentTime = GameDaysPassed.GetValue()

    RefreshLicenseStatus(currentTime)

    ; Set values for next check
    licenses.previousLicenseStatusCheckTime = currentTime
    ; currentTime as 4.0 indicates midnight between day 3 and day 4
    ; so, all we need to do is add 1.0 to the current time and cast it as an int, which auto 'floors' the value
    ; example: if currentTime is 3.5, which indicates halfway through day 3, we add 1.0 to 3.5, giving us 4.5. Casting this float as int gives us 4.0
    licenses.NextStatusCheck = (currentTime + 1.0) as int

    LogTrace("Current Time: " + CurrentTime)
    LogTrace("Next Status Check: " + licenses.NextStatusCheck)

    ModeratorUpdater()
EndFunction

Function ModeratorMaintanence()
    CheckThaneship()
    ModeratorUpdater()
EndFunction

Function ModeratorUpdater()
    refreshActivationLimit()
    licenses.PopulateKeywordConfiscationArray()
EndFunction

Function CheckThaneship()
    if licenseThaneshipCheckQuest.start()
        licenses.isThane = bmlThaneshipCheck.Run()
        licenseThaneshipCheckQuest.stop()
    else
        licenses.isThane = false
    endIf
EndFunction
; ------------------------------

; ---------- Core Licenses Counters ----------
Int Function CountValidLicenses()
    Bool[] LicenseArray = new Bool[12]
    LicenseArray[0] = licenses.hasArmorLicense
    LicenseArray[1] = licenses.hasBikiniLicense
    LicenseArray[2] = licenses.hasClothingLicense
    LicenseArray[3] = licenses.hasMagicLicense
    LicenseArray[4] = licenses.hasWeaponLicense
    LicenseArray[5] = licenses.hasCraftingLicense
    LicenseArray[6] = licenses.hasTradingLicense
    LicenseArray[7] = licenses.hasWhoreLicense
    LicenseArray[8] = licenses.hasTravelPermit
    LicenseArray[9] = licenses.hasCollarExemption
    LicenseArray[10] = licenses.hasInsurance
    LicenseArray[11] = licenses.hasCurfewExemption
    int count = 0
    int i = 0
    while i < LicenseArray.Length
        if LicenseArray[i]
            count += 1
        endIf
        i += 1
    EndWhile
    return count
EndFunction

Int Function CountActiveLicenses()
    Bool[] LicenseArray = new Bool[12]
    LicenseArray[0] = (licenses.armorLicenseExpirationTime != -1) && bmlmcm.isArmorLicenseFeatureEnabled
    LicenseArray[1] = (licenses.bikiniLicenseExpirationTime != -1) && bmlmcm.isBikiniLicenseFeatureEnabled
    LicenseArray[2] = (licenses.clothingLicenseExpirationTime != -1) && bmlmcm.isClothingLicenseFeatureEnabled
    LicenseArray[3] = (licenses.magicLicenseExpirationTime != -1) && bmlmcm.isMagicLicenseFeatureEnabled
    LicenseArray[4] = (licenses.weaponLicenseExpirationTime != -1) && bmlmcm.isWeaponLicenseFeatureEnabled
    LicenseArray[5] = (licenses.craftingLicenseExpirationTime != -1) && bmlmcm.isCraftingLicenseFeatureEnabled
    LicenseArray[6] = (licenses.tradingLicenseExpirationTime != -1) && bmlmcm.isTradingLicenseFeatureEnabled
    LicenseArray[7] = (licenses.whoreLicenseExpirationTime != -1) && bmlmcm.isWhoreLicenseFeatureEnabled
    LicenseArray[8] = (licenses.travelPermitExpirationTime != -1) && bmlmcm.isTravelPermitFeatureEnabled
    LicenseArray[9] = (licenses.collarExemptionExpirationTime != -1) && bmlmcm.isCollarExemptionFeatureEnabled
    LicenseArray[10] = (licenses.insuranceExpirationTime != -1) && bmlmcm.isInsuranceFeatureEnabled
    LicenseArray[11] = (licenses.curfewExemptionExpirationTime != -1) && bmlmcm.isCurfewExemptionFeatureEnabled
    int count = 0
    int i = 0
    while i < LicenseArray.Length
        if LicenseArray[i]
            count += 1
        endIf
        i += 1
    EndWhile
    return count
EndFunction

Int Function CountActiveViolations()
    Bool[] ActiveViolations = new Bool[10]
    ActiveViolations[0] = licenses.isArmorViolation
    ActiveViolations[1] = licenses.isMagicViolation
    ActiveViolations[2] = licenses.isWeaponViolation
    ActiveViolations[3] = licenses.isCraftingViolation
    ActiveViolations[4] = licenses.isTravelViolation
    ActiveViolations[5] = licenses.isCollarViolation
    ActiveViolations[6] = licenses.isUninsuredViolation
    ActiveViolations[7] = licenses.isCurfewViolation
    ActiveViolations[8] = licenses.isTradingViolation
    ActiveViolations[9] = licenses.isWhoreViolation
    int count = 0
    int i = 0
    while i < ActiveViolations.Length
        if ActiveViolations[i]
            count += 1
        endIf
        i += 1
    EndWhile
    return count
EndFunction

bool Function CheckViolationExists()
    Bool[] violations = new Bool[10]
    violations[0] = licenses.isArmorViolation
    violations[1] = licenses.isMagicViolation
    violations[2] = licenses.isWeaponViolation
    violations[3] = licenses.isCraftingViolation
    violations[4] = licenses.isTravelViolation
    violations[5] = licenses.isCollarViolation
    violations[6] = licenses.isUninsuredViolation
    violations[7] = licenses.isCurfewViolation
    violations[8] = licenses.isTradingViolation
    violations[9] = licenses.isWhoreViolation
    if violations.Find(true) >= 0
        return true
    endIf
    return false
EndFunction
; ------------------------------

; ---------- Violation Check Sequence ----------
Function startDetectionQuest()
    LogTrace("Attempting to start Detection Quest.")
    licenseDetectionQuest.stop()
    if licenseDetectionQuest.start()
        LogTrace("Started Detection Quest.")
        bmlDetection.Setup()
    else
        LogTrace("Detection Quest failed to start.")
    endIf
EndFunction

Function ConsiderViolationCheck()
    If licenseBountyQuest.IsRunning()
        LogTrace("Bounty Quest is running. Checking Alias Validity instead.")
        bmlBounty.RegisterForSingleUpdate(1.0)
    elseIf !IsExceptionState()
        LogTrace("Violation Checker passed initial conditions.")
        if bmlmcm.isCheckLOSFeatureEnabled
            LogTrace("Called startDetectionQuest()")
            startDetectionQuest()
        else
            LogTrace("Called startViolationCheckQuest()")
            startViolationCheckQuest()
        endIf
    endIf
EndFunction

Function startViolationCheckQuest()
    if !licenseViolationCheckQuest.IsRunning() && licenseViolationCheckQuest.start()
        LogTrace("Started Violation Check Quest.")
        BM_PotentialViolations.Revert()
        BM_PotentialViolations.AddForms(ScanEquippedItems_Base(PlayerActorRef))
        BM_PotentialViolations_Ench.Revert()
        BM_PotentialViolations_Ench.AddForms(ScanEquippedItems_Ench(PlayerActorRef))
        bmlViolationCheck.Setup()
    else
        LogTrace("Error: Violation Check Quest is already running.")
    endIf
EndFunction

Function AggregateViolations()
    if CheckViolationExists() && CheckBountyValidity()
        SendModEvent("BM-LPO_ViolationFound")
        startBountyQuest()
    elseIf !licenseBountyQuest.IsRunning()
        licenses.ResetViolations(-1)
    endIf
    licenseDetectionQuest.stop()
    licenseViolationCheckQuest.stop()
    BM_PotentialViolations.Revert()
    BM_PotentialViolations_Ench.Revert()
Endfunction

Function startBountyQuest()
    LogTrace("Attempting to start Bounty Quest.")
    BM_FineAmount.SetValue(GetFine())
    licenseDetectionQuest.stop()
    if licenseBountyQuest.start() && bmlBounty.Setup()
        insuranceModifier("infamy", insuranceModifierViolation())
        LogTrace("Successfully started Bounty Quest.")
    else
        licenseBountyQuest.stop()
        LogTrace("Failed to start Bounty Quest.")
        licenses.ResetViolations(-1)
    endIf
Endfunction

Bool Function CheckBountyValidity()
    if IsExceptionState() ; bounty primary condition exclusions
        return false
    elseIf licenses.isTravelViolation || licenses.isCurfewViolation ; bounty primary violation exceptions. These run regardless of location
        return true
    endIf
    return LocationValidity()
EndFunction

Bool Function LocationValidity()
    if (bmlmcm.isLimitToCityEnabled || bmlmcm.isLimitToTownEnabled)
        if bmlmcm.isLimitToCityEnabled && licenses.isInCity
            return true
        elseIf bmlmcm.isLimitToTownEnabled && licenses.isInTown
            return true
        else
            return false
        endIf
    endIf
    return true
EndFunction
; ------------------------------

; ---------- Misc Functions ----------
Int Function ClampInt(int value, int minValue, int maxValue)
    If value < minValue
        Return minValue
    ElseIf value > maxValue
        Return maxValue
    Else
        Return value
    EndIf
EndFunction

Float Function ClampFloat(float value, float minValue, float maxValue)
    If value < minValue
        Return minValue
    ElseIf value > maxValue
        Return maxValue
    Else
        Return value
    EndIf
EndFunction

Int Function AdjustStringToInt(string OldValue)
    int NewValue = PO3_SKSEFunctions.StringToInt(OldValue)
    if NewValue == -1
        return 0
    else
        return NewValue
    endIf
EndFunction

bool Function IsInLocation(Location akLocation)
	if currLoc == None
		return false
	else
		return akLocation.IsChild(currLoc) || currLoc == akLocation
	endif
endFunction

Function LogTrace(String LogMessage, Bool Force = False)
    if LogMessage
        if Force || bmlmcm.LogTrace
	        Debug.Trace("[BM-LPO] " + LogMessage)
        endIf
    endIf
EndFunction

Function LogNotification(String LogMessage, Bool Force = False)
    if LogMessage
        if Force
            Debug.Notification("LPO: " + LogMessage)
        elseIf bmlmcm.LogNotification
            Debug.Notification(LogMessage)
        endIf
    endIf
EndFunction

Int Function GameMessage(Message LogMessage, float afArg1 = 0.0, float afArg2 = 0.0, float afArg3 = 0.0, float afArg4 = 0.0, float afArg5 = 0.0, float afArg6 = 0.0, float afArg7 = 0.0, float afArg8 = 0.0, float afArg9 = 0.0)
    if LogMessage
        if bmlmcm.GameMessage
            return LogMessage.Show(afArg1, afArg2, afArg3, afArg4, afArg5, afArg6, afArg7, afArg8, afArg9)
        endIf
    endIf
    return 0
EndFunction
; ------------------------------

; ---------- Getters ----------
Float Function GetCooldown(Float LicenseCooldown, Float LicenseDuration)
    if LicenseCooldown == 0.0
        return LicenseCooldown
    endIf
    Float RandomCooldown = Utility.RandomFloat(1.0, LicenseCooldown)
    if bmlmcm.isInsuranceFeatureEnabled
        RandomCooldown *= licenses.insuranceMisbehaviourMultiplier * licenses.insurancePopularityMultiplier
    endIf
    RandomCooldown = ClampFloat(RandomCooldown, 1.0, LicenseDuration)
    return RandomCooldown
EndFunction

Float Function GetFine()
    Float Fine = 0.0
    Int Base = bmlmcm.FineBase
    Float Percentage = bmlmcm.FinePercentage / 100.0

    Int ArmorFine = (licenses.isArmorViolation as int)
    if !licenses.hasClothingLicense
        ArmorFine *= (bmlmcm.BM_CLCost.GetValue() as int)
    elseIf !licenses.hasBikiniLicense
        ArmorFine *= (bmlmcm.BM_BLCost.GetValue() as int)
    else
        ArmorFine *= (bmlmcm.BM_ALCost.GetValue() as int)
    endIf
    Int MagicFine = (licenses.isMagicViolation as int) * (bmlmcm.BM_MLCost.GetValue() as int)
    Int WeaponFine = (licenses.isWeaponViolation as int) * (bmlmcm.BM_WLCost.GetValue() as int)
    Int CraftingFine = (licenses.isCraftingViolation as int) * (bmlmcm.BM_CrfLCost.GetValue() as int)
    Int TravelFine = (licenses.isTravelViolation as int) * (bmlmcm.BM_TPCost.GetValue() as int)
    Int CollarFine = (licenses.isCollarViolation as int) * (bmlmcm.BM_CECost.GetValue() as int)
    Int InsuranceFine = (licenses.isUninsuredViolation as int) * (bmlmcm.BM_InsurCost.GetValue() as int)
    Int CurfewFine = (licenses.isCurfewViolation as int) * (bmlmcm.BM_CuECost.GetValue() as int)
    Int TradingFine = (licenses.isTradingViolation as int) * (bmlmcm.BM_TLCost.GetValue() as int)
    Int WhoreFine = (licenses.isWhoreViolation as int) * (bmlmcm.BM_WhLCost.GetValue() as int)

    Fine = Base + (Percentage * (ArmorFine + MagicFine + WeaponFine + CraftingFine + TravelFine + CollarFine + InsuranceFine + CurfewFine + TradingFine + WhoreFine))
    ;LogTrace("Base: " + Base + "; Percentage: " + Percentage + "; Armor: " + ArmorFine + "; Magic: " + MagicFine + "; Weapon: " + WeaponFine + "; Crafting: " + CraftingFine + "; Travel: " + TravelFine + "; Collar: " + CollarFine + "; Insurance: " + InsuranceFine + "; Curfew: " + CurfewFine + "; Trading: " + TradingFine + "; Whore: " + WhoreFine)
    LogTrace("Generated Fine Total: " + Fine)
    return Fine
EndFunction
; ------------------------------

; ---------- License Purchase Functions ----------
Function BM_PurchaseArmorLicense(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_ArmorLicense)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_ALCost.GetValueInt())
    endIf
    licenses.armorLicenseExpirationTime = (GameDaysPassed.getValue() + BM_ALDuration.GetValue()) as int
    if PlayerActorRef.getItemCount(BM_ArmorLicense) < 1
        PlayerActorRef.addItem(BM_ArmorLicense, 1)
    endIf
    licenses.ArmorLicense = true
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 1)
EndFunction

Function BM_PurchaseBikiniLicense(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_BikiniLicense)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_BLCost.GetValueInt())
    endIf
    licenses.bikiniLicenseExpirationTime = (GameDaysPassed.getValue() + BM_BLDuration.getValue()) as int
    if PlayerActorRef.getItemCount(BM_BikiniLicense) < 1
        PlayerActorRef.addItem(BM_BikiniLicense, 1)
    endIf
    licenses.BikiniLicense = true
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 2)
EndFunction

Function BM_PurchaseClothingLicense(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_ClothingLicense)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_CLCost.GetValueInt())
    endIf
    licenses.clothingLicenseExpirationTime = (GameDaysPassed.getValue() + BM_CLDuration.getValue()) as int
    if PlayerActorRef.getItemCount(BM_ClothingLicense) < 1
        PlayerActorRef.addItem(BM_ClothingLicense, 1)
    endIf
    licenses.ClothingLicense = true
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 3)
EndFunction

Function BM_PurchaseMagicLicense(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_MagicLicense)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_MLCost.GetValueInt())
    endIf
    licenses.magicLicenseExpirationTime = (GameDaysPassed.getValue() + BM_MLDuration.getValue()) as int
    if PlayerActorRef.getItemCount(BM_MagicLicense) < 1
        PlayerActorRef.addItem(BM_MagicLicense, 1)
    endIf
    licenses.MagicLicense = true
    licenses.RemoveNullifyMagicka()
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 4)
EndFunction

Function BM_PurchaseWeaponLicense(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_WeaponLicense)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_WLCost.GetValueInt())
    endIf
    licenses.weaponLicenseExpirationTime = (GameDaysPassed.getValue() + BM_WLDuration.getValue()) as int
    if PlayerActorRef.getItemCount(BM_WeaponLicense) < 1
        PlayerActorRef.addItem(BM_WeaponLicense, 1)
    endIf
    licenses.WeaponLicense = true
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 5)
Endfunction

Function BM_PurchaseCraftingLicense(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_CraftingLicense)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_CrfLCost.GetValueInt())
    endIf
    licenses.craftingLicenseExpirationTime = (GameDaysPassed.getValue() + BM_CrfLDuration.getValue()) as int
    if PlayerActorRef.getItemCount(BM_CraftingLicense) < 1
        PlayerActorRef.addItem(BM_CraftingLicense, 1)
    endIf
    licenses.CraftingLicense = true
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 6)
EndFunction

Function BM_PurchaseTravelPermit(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_TravelPermit)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_TPCost.GetValueInt())
    endIf
    licenses.travelPermitExpirationTime = (GameDaysPassed.getValue() + BM_TPDuration.getValue()) as int
    if PlayerActorRef.getItemCount(BM_TravelPermit) < 1
        PlayerActorRef.addItem(BM_TravelPermit, 1)
    endIf
    licenses.TravelPermit = true
    savedLoc = None
    savedSpace = None
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 7)
EndFunction

Function BM_PurchaseCollarExemption(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_CollarExemption)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_CECost.GetValueInt())
    endIf
    licenses.collarExemptionExpirationTime = (GameDaysPassed.getValue() + BM_CEDuration.getValue()) as int
    if PlayerActorRef.getItemCount(BM_CollarExemption) < 1
        PlayerActorRef.addItem(BM_CollarExemption, 1)
    endIf
    licenses.CollarExemption = true
    licenses.RemoveDeviousDevicesCollar()
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 8)
EndFunction

Function BM_PurchaseLifeInsurance(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_Insurance)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_InsurCost.GetValueInt())
    endIf
    licenses.insuranceExpirationTime = (GameDaysPassed.getValue() + BM_InsurDuration.getValue()) as int
    if PlayerActorRef.getItemCount(BM_Insurance) < 1
        PlayerActorRef.addItem(BM_Insurance, 1)
    endIf
    licenses.Insurance = true
    licenses.RemoveNullifyMagicka()
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 9)
EndFunction

Function BM_PurchaseCurfewExemption(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_CurfewExemption)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_CuECost.GetValueInt())
    endIf
    licenses.curfewExemptionExpirationTime = (GameDaysPassed.getValue() + BM_CuEDuration.GetValue()) as int
    if PlayerActorRef.getItemCount(BM_CurfewExemption) < 1
        PlayerActorRef.addItem(BM_CurfewExemption, 1)
    endIf
    licenses.CurfewExemption = true
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 10)
EndFunction

Function BM_PurchaseTradingLicense(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_TradingLicense)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_TLCost.GetValueInt())
    endIf
    licenses.tradingLicenseExpirationTime = (GameDaysPassed.getValue() + BM_TLDuration.GetValue()) as int
    if PlayerActorRef.getItemCount(BM_TradingLicense) < 1
        PlayerActorRef.addItem(BM_TradingLicense, 1)
    endIf
    licenses.TradingLicense = true
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 11)
EndFunction

Function BM_PurchaseWhoreLicense(bool pay = true)
    bmlModeratorAlias.AddInventoryEventFilter(BM_WhoreLicense)
    if pay
        PlayerActorRef.removeItem(Gold001, BM_WhLCost.GetValueInt())
    endIf
    licenses.whoreLicenseExpirationTime = (GameDaysPassed.getValue() + BM_WhLDuration.getValue()) as int
    if PlayerActorRef.getItemCount(BM_WhoreLicense) < 1
        PlayerActorRef.addItem(BM_WhoreLicense, 1)
    endIf
    licenses.WhoreLicense = true
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 12)
EndFunction
; ------------------------------

; ---------- License Expire Functions ----------
; These are manual expiration calls that can run independent of the usual daily checker
; Call ModeratorUpdater() after license expirations if they are run outside daily checker
Function BM_ExpireArmorLicense()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_ArmorLicense)
    licenses.armorLicenseExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_ArmorLicense) > 0
        PlayerActorRef.removeItem(BM_ArmorLicense, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.armorLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_ALDuration.GetValue())) as int
    endIf
    licenses.ArmorLicense = false
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 1)
EndFunction

Function BM_ExpireBikiniLicense()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_BikiniLicense)
    licenses.bikiniLicenseExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_BikiniLicense) > 0
        PlayerActorRef.removeItem(BM_BikiniLicense, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.bikiniLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_BLDuration.GetValue())) as int
    endIf
    licenses.BikiniLicense = false
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 2)
EndFunction

Function BM_ExpireClothingLicense()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_ClothingLicense)
    licenses.clothingLicenseExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_ClothingLicense) > 0
        PlayerActorRef.removeItem(BM_ClothingLicense, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.clothingLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_CLDuration.GetValue())) as int
    endIf
    licenses.ClothingLicense = false
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 3)
EndFunction

Function BM_ExpireMagicLicense()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_MagicLicense)
    licenses.magicLicenseExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_MagicLicense) > 0
        PlayerActorRef.removeItem(BM_MagicLicense, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.magicLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_MLDuration.GetValue())) as int
    endIf
    licenses.MagicLicense = false
    BM_LenientCurseViolation.SetValue(1.0)
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 4)
EndFunction

Function BM_ExpireWeaponLicense()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_WeaponLicense)
    licenses.weaponLicenseExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_WeaponLicense) > 0
        PlayerActorRef.removeItem(BM_WeaponLicense, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.weaponLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_WLDuration.GetValue())) as int
    endIf
    licenses.WeaponLicense = false
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 5)
Endfunction

Function BM_ExpireCraftingLicense()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_CraftingLicense)
    licenses.craftingLicenseExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_CraftingLicense) > 0
        PlayerActorRef.removeItem(BM_CraftingLicense, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.craftingLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_CrfLDuration.GetValue())) as int
    endIf
    licenses.CraftingLicense = false
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 6)
EndFunction

Function BM_ExpireTravelPermit()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_TravelPermit)
    licenses.travelPermitExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_TravelPermit) > 0
        PlayerActorRef.removeItem(BM_TravelPermit, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.travelPermitCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_TPDuration.GetValue())) as int
    endIf
    licenses.TravelPermit = false
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 7)
EndFunction

Function BM_ExpireCollarExemption()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_CollarExemption)
    licenses.collarExemptionExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_CollarExemption) > 0
        PlayerActorRef.removeItem(BM_CollarExemption, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.collarExemptionCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_CEDuration.GetValue())) as int
    endIf
    licenses.hasCollarExemption = false
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 8)
EndFunction

Function BM_ExpireLifeInsurance()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_Insurance)
    licenses.insuranceExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_Insurance) > 0
        PlayerActorRef.removeItem(BM_Insurance, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.insuranceCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_InsurDuration.GetValue())) as int
    endIf
    licenses.Insurance = false
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 9)
EndFunction

Function BM_ExpireCurfewExemption()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_CurfewExemption)
    licenses.curfewExemptionExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_CurfewExemption) > 0
        PlayerActorRef.removeItem(BM_CurfewExemption, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.curfewExemptionCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_CuEDuration.GetValue())) as int
    endIf
    licenses.CurfewExemption = false
    BM_LenientCurfewViolation.SetValue(1.0)
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 10)
EndFunction

Function BM_ExpireTradingLicense()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_TradingLicense)
    licenses.tradingLicenseExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_TradingLicense) > 0
        PlayerActorRef.removeItem(BM_TradingLicense, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.tradingLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_TLDuration.GetValue())) as int
    endIf
    licenses.TradingLicense = false
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 11)
EndFunction

Function BM_ExpireWhoreLicense()
    bmlModeratorAlias.RemoveInventoryEventFilter(BM_WhoreLicense)
    licenses.whoreLicenseExpirationTime = -1.0
    if PlayerActorRef.getItemCount(BM_WhoreLicense) > 0
        PlayerActorRef.removeItem(BM_WhoreLicense, 1, true)
    endIf
    if bmlmcm.LicenseCooldown != 0
        licenses.whoreLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_WhLDuration.GetValue())) as int
    endIf
    licenses.WhoreLicense = false
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 12)
EndFunction
; ------------------------------

; ---------- Debuggers / Back-end Refreshers ----------
; Refresh license timers and immunities
Function RefreshStatus()
    CheckLocation()
    CheckThaneship()
    CheckExceptionState()
    CheckLicenseStatus()
    CheckDeviousDevicesStatus()
EndFunction

; Refresh license statuses
Function RefreshLicenseStatus(float currentTime)
    if (licenses.armorLicenseExpirationTime >= 0)
        if (currentTime >= licenses.armorLicenseExpirationTime)
            GameMessage(licenses.MessageArmorExpired)
            BM_ExpireArmorLicense()
        elseIf (licenses.armorLicenseExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageArmorCountdown, Math.ceiling(24 * (licenses.armorLicenseExpirationTime - currentTime)))
        endIf
    endif
    if (licenses.bikiniLicenseExpirationTime >= 0)
        if (currentTime >= licenses.bikiniLicenseExpirationTime)
            GameMessage(licenses.MessageBikiniExpired)
            BM_ExpireBikiniLicense()
        elseIf (licenses.bikiniLicenseExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageBikiniCountdown, Math.ceiling(24 * (licenses.bikiniLicenseExpirationTime - currentTime)))
        endIf
    endif
    if (licenses.clothingLicenseExpirationTime >= 0)
        if (currentTime >= licenses.clothingLicenseExpirationTime)
            GameMessage(licenses.MessageClothingExpired)
            BM_ExpireClothingLicense()
        elseIf (licenses.clothingLicenseExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageClothingCountdown, Math.ceiling(24 * (licenses.clothingLicenseExpirationTime - currentTime)))
        endIf
    endif
    if (licenses.magicLicenseExpirationTime >= 0)
        if (currentTime >= licenses.magicLicenseExpirationTime)
            GameMessage(licenses.MessageMagicExpired)
            BM_ExpireMagicLicense()
        elseIf (licenses.magicLicenseExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageMagicCountdown, Math.ceiling(24 * (licenses.magicLicenseExpirationTime - currentTime)))
        endIf
    endif
    if (licenses.weaponLicenseExpirationTime >= 0)
        if (currentTime >= licenses.weaponLicenseExpirationTime)
            GameMessage(licenses.MessageWeaponExpired)
            BM_ExpireWeaponLicense()
        elseIf (licenses.weaponLicenseExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageWeaponCountdown, Math.ceiling(24 * (licenses.weaponLicenseExpirationTime - currentTime)))
        endIf
    endif
    if (licenses.craftingLicenseExpirationTime >= 0)
        if (currentTime >= licenses.craftingLicenseExpirationTime)
            GameMessage(licenses.MessageCraftingExpired)
            BM_ExpireCraftingLicense()
        elseIf (licenses.craftingLicenseExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageCraftingCountdown, Math.ceiling(24 * (licenses.craftingLicenseExpirationTime - currentTime)))
        endIf
    endif
    if (licenses.tradingLicenseExpirationTime >= 0)
        if (currentTime >= licenses.tradingLicenseExpirationTime)
            GameMessage(licenses.MessageTradingExpired)
            BM_ExpireTradingLicense()
        elseIf (licenses.tradingLicenseExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageTradingCountdown, Math.ceiling(24 * (licenses.tradingLicenseExpirationTime - currentTime)))
        endIf
    endif
    if (licenses.whoreLicenseExpirationTime >= 0)
        if (currentTime >= licenses.whoreLicenseExpirationTime)
            GameMessage(licenses.MessageWhoreExpired)
            BM_ExpireWhoreLicense()
        elseIf (licenses.whoreLicenseExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageWhoreCountdown, Math.ceiling(24 * (licenses.whoreLicenseExpirationTime - currentTime)))
        endIf
    endif
    if (licenses.travelPermitExpirationTime >= 0)
        if (currentTime >= licenses.travelPermitExpirationTime)
            GameMessage(licenses.MessageTravelExpired)
            BM_ExpireTravelPermit()
        elseIf (licenses.travelPermitExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageTravelCountdown, Math.ceiling(24 * (licenses.travelPermitExpirationTime - currentTime)))
        endIf
    endif
    if (licenses.collarExemptionExpirationTime >= 0)
        if (currentTime >= licenses.collarExemptionExpirationTime)
            GameMessage(licenses.MessageCollarExpired)
            BM_ExpireCollarExemption()
        elseIf (licenses.collarExemptionExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageCollarCountdown, Math.ceiling(24 * (licenses.collarExemptionExpirationTime - currentTime)))
        endIf
    endif
    if (licenses.insuranceExpirationTime >= 0)
        if (currentTime >= licenses.insuranceExpirationTime)
            GameMessage(licenses.MessageInsuranceExpired)
            BM_ExpireLifeInsurance()
        elseIf (licenses.insuranceExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageInsuranceCountdown, Math.ceiling(24 * (licenses.insuranceExpirationTime - currentTime)))
        endIf
    endif
    insuranceModifier("fame", insuranceModifierFame())
    insuranceRateDegradation(currentTime - licenses.previousLicenseStatusCheckTime)
    if (licenses.curfewExemptionExpirationTime >= 0)
        if (currentTime >= licenses.curfewExemptionExpirationTime)
            GameMessage(licenses.MessageCurfewExpired)
            BM_ExpireCurfewExemption()
        elseIf (licenses.curfewExemptionExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageCurfewCountdown, Math.ceiling(24 * (licenses.curfewExemptionExpirationTime - currentTime)))
        endIf
    endif

    if (currentTime >= licenses.armorLicenseCooldownTime)
        licenses.armorLicenseCooldownTime = -1.0
    endif
    if (currentTime >= licenses.bikiniLicenseCooldownTime)
        licenses.bikiniLicenseCooldownTime = -1.0
    endif
    if (currentTime >= licenses.clothingLicenseCooldownTime)
        licenses.clothingLicenseCooldownTime = -1.0
    endif
    if (currentTime >= licenses.magicLicenseCooldownTime)
        licenses.magicLicenseCooldownTime = -1.0
    endif
    if (currentTime >= licenses.weaponLicenseCooldownTime)
        licenses.weaponLicenseCooldownTime = -1.0
    endif
    if (currentTime >= licenses.craftingLicenseCooldownTime)
        licenses.craftingLicenseCooldownTime = -1.0
    endif
    if (currentTime >= licenses.tradingLicenseCooldownTime)
        licenses.tradingLicenseCooldownTime = -1.0
    endif
    if (currentTime >= licenses.whoreLicenseCooldownTime)
        licenses.whoreLicenseCooldownTime = -1.0
    endif
    if (currentTime >= licenses.travelPermitCooldownTime)
        licenses.travelPermitCooldownTime = -1.0
    endif
    if (currentTime >= licenses.collarExemptionCooldownTime)
        licenses.collarExemptionCooldownTime = -1.0
    endif
    if (currentTime >= licenses.insuranceCooldownTime)
        licenses.insuranceCooldownTime = -1.0
    endif
    if (currentTime >= licenses.curfewExemptionCooldownTime)
        licenses.curfewExemptionCooldownTime = -1.0
    endif
EndFunction

; Refresh Tattoos
Function RefreshTattoos()
    if bmlmcm.SlaveTats_State
        licenses.CursedTattoosActive = BM_API_ST.UnlockCursedTattoos(PlayerActorRef, licenses.CursedTattoosActive)
        if licenses.CheckNullifyMagickaCurse(PlayerActorRef) == 1 && bmlmcm.ShowCurseTattoos
            licenses.CursedTattoosActive = BM_API_ST.LockCursedTattoos(PlayerActorRef, licenses.CursedTattoos)
        endIf
    endIf
EndFunction

; Refresh Features
Function RefreshFeatures()
    refreshIntervalCheckFeature()
	refreshRoutineCalls()
	refreshPopularityModifier()
	refreshLicenseSeller()
    refreshLicenseFeatures()
    refreshActivationLimit()
    refreshInventoryEventFilters()
    refreshArrays()
EndFunction

Function refreshLicenseFeatures()
	licenses.ArmorLicense = (licenses.armorLicenseExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_ArmorLicense) > 0)
	licenses.BikiniLicense = (licenses.bikiniLicenseExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_BikiniLicense) > 0)
	licenses.ClothingLicense = (licenses.clothingLicenseExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_ClothingLicense) > 0)
	licenses.MagicLicense = (licenses.magicLicenseExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_MagicLicense) > 0)
	licenses.WeaponLicense = (licenses.weaponLicenseExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_WeaponLicense) > 0)
	licenses.CraftingLicense = (licenses.craftingLicenseExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_CraftingLicense) > 0)
	licenses.TradingLicense = (licenses.tradingLicenseExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_TradingLicense) > 0)
	licenses.WhoreLicense = (licenses.whoreLicenseExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_WhoreLicense) > 0)
	licenses.TravelPermit = (licenses.travelPermitExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_TravelPermit) > 0)
	licenses.CollarExemption = (licenses.collarExemptionExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_CollarExemption) > 0)
	licenses.Insurance = (licenses.insuranceExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_Insurance) > 0)
	licenses.CurfewExemption = (licenses.curfewExemptionExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_CurfewExemption) > 0)
EndFunction

Function refreshActivationLimit()
    licenses.isLicenseLimit = false
    if bmlmcm.LicenseLimit == 0
        licenses.isLicenseLimit = (CountValidLicenses() >= licenses.LicenseBooks.Length)
    else
        licenses.isLicenseLimit = (CountActiveLicenses() >= bmlmcm.LicenseLimit)
    endIf
EndFunction

Function refreshInventoryEventFilters()
    bmlModeratorAlias.RemoveAllInventoryEventFilters()
    bmlModeratorAlias.AddInventoryEventFilter(BM_Empty)
    if bmlmcm.isArmorLicenseFeatureEnabled && licenses.armorLicenseExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_ArmorLicense)
    endIf
    if bmlmcm.isBikiniLicenseFeatureEnabled && licenses.bikiniLicenseExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_BikiniLicense)
    endIf
    if bmlmcm.isClothingLicenseFeatureEnabled && licenses.clothingLicenseExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_ClothingLicense)
    endIf
    if bmlmcm.isMagicLicenseFeatureEnabled && licenses.magicLicenseExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_MagicLicense)
    endIf
    if bmlmcm.isWeaponLicenseFeatureEnabled && licenses.weaponLicenseExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_WeaponLicense)
    endIf
    if bmlmcm.isCraftingLicenseFeatureEnabled && licenses.craftingLicenseExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_CraftingLicense)
    endIf
    if bmlmcm.isTradingLicenseFeatureEnabled && licenses.tradingLicenseExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_TradingLicense)
    endIf
    if bmlmcm.isWhoreLicenseFeatureEnabled && licenses.whoreLicenseExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_WhoreLicense)
    endIf
    if bmlmcm.isTravelPermitFeatureEnabled && licenses.travelPermitExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_TravelPermit)
    endIf
    if bmlmcm.isCollarExemptionFeatureEnabled && licenses.collarExemptionExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_CollarExemption)
    endIf
    if bmlmcm.isInsuranceFeatureEnabled && licenses.insuranceExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_Insurance)
    endIf
    if bmlmcm.isCurfewExemptionFeatureEnabled && licenses.curfewExemptionExpirationTime >= 0
        bmlModeratorAlias.AddInventoryEventFilter(BM_CurfewExemption)
    endIf
EndFunction

Function refreshPopularityModifier()
	insuranceModifier("fame", insuranceModifierFame())
EndFunction

Function refreshIntervalCheckFeature()
	if !(bmlmcm.isCheckIntervalFeatureEnabled)
		bmPlayer.UnregisterForUpdate()
    else
        bmPlayer.RegisterForSingleUpdate(bmlmcm.checkInterval)
	endIf
EndFunction

Function refreshRoutineCalls()
	licenseDetectionQuest.stop()
    licenseViolationCheckQuest.stop()
    licenseThaneshipCheckQuest.stop()
EndFunction

Function refreshLicenseSeller()
	bmlmcm.BM_SellerGuard.SetValue(0.0)
	bmlmcm.BM_SellerSteward.SetValue(0.0)
	if bmlmcm.licenseSellerFaction == 1
		bmlmcm.BM_SellerGuard.SetValue(1.0)
	elseIf bmlmcm.licenseSellerFaction == 2
		bmlmcm.BM_SellerSteward.SetValue(1.0)
	endIf
EndFunction

Function refreshArrays()
    licenses.PopulateKeywordConfiscationArray()
    licenses.PopulateKeywordExclusionArray()
    licenses.PopulateKeywordBikiniItemArray()
    licenses.PopulateLicenseBooksArray()
    licenses.PopulateCursedTattoosArray()
EndFunction
; ------------------------------

; ---------- MCM Utilities ----------
Function ResetMCM()
    bmlmcm.Stop()
    While !bmlmcm.IsStopped()
        Utility.Wait(0.1)
    EndWhile
    bmlmcm.Start()
    While !bmlmcm.IsRunning()
        Utility.Wait(0.1)
    EndWhile
    ReloadMCMVariables(true)
    RefreshFeatures()
EndFunction

Function ReloadMCMVariables(bool abSilent = false)
    if !bmlmcm.checkHardDependencies() && abSilent
        LogNotification("Detected missing dependencies. Check Auxiliary tab for details.", true)
    endIf
	bmlmcm.checkSoftDependencies()
	bmlmcm.updateGlobals()
EndFunction
; ------------------------------

; ---------- Mod-specific Functions ----------
Function DF_AdjustResistance(float factor = 0.0)
    if bmlmcm.DeviousFollowers_State
        if factor >= 10.0
            SendModEvent("DF-ResistanceLoss", "", factor)
        else
            SendModEvent("DF-ResistanceLossWithSeverity", "2", factor)
        endIf
    endIf
EndFunction

Function DD_FlagPlayerCollar(bool isWorn)
    BM_IsPlayerCollared.SetValue(isWorn as int)
EndFunction

Function CheckDeviousDevicesStatus()
    if bmlmcm.DeviousDevices_State
        BM_IsPlayerCollared.SetValue(BM_API_DD.HasCollarEquipped(PlayerActorRef) as int)
    endIf
EndFunction
; ------------------------------

; ---------- Insurance Calculations ----------
Function insuranceModifier(string type, float value)
    if type == "infamy"
        ; multiplicative 
        licenses.insuranceMisbehaviourMultiplier = licenses.insuranceMisbehaviourMultiplier * (1.0 + value)
        licenses.insuranceMisbehaviourMultiplier = ClampFloat(licenses.insuranceMisbehaviourMultiplier, 1.0, 15.0)
    elseif type == "fame"
        ; non-multiplicative
        licenses.insurancePopularityMultiplier = value
        licenses.insurancePopularityMultiplier = ClampFloat(licenses.insurancePopularityMultiplier, 1.0, 50.0)
        if bmlmcm.invertPopularityMultiplier
            licenses.insurancePopularityMultiplier = 1.0 / licenses.insurancePopularityMultiplier
        endIf
    endIf
    bmlmcm.BM_InsurCost.setValue(bmlmcm.BM_InsurCostBase * licenses.insuranceMisbehaviourMultiplier * licenses.insurancePopularityMultiplier)
    licenses.UpdateCurrentInstanceGlobal(BM_InsurCost)
EndFunction

Float Function insuranceModifierViolation()
    ; Define weights for each infraction (adjust as needed)
    Float weightArmor = 0.3 * (licenses.isArmorViolation as float)
    Float weightMagic = 0.2 * (licenses.isMagicViolation as float)
    Float weightWeapon = 0.2 * (licenses.isWeaponViolation as float)
    Float weightCrafting = 0.1 * (licenses.isCraftingViolation as float)
    Float weightTravel = 0.1 * (licenses.isTravelViolation as float)
    Float weightCollar = 0.2 * (licenses.isCollarViolation as float)
    Float weightUninsured = 0.1 * (licenses.isUninsuredViolation as float)
    Float weightCurfew = 0.1 * (licenses.isCurfewViolation as float)
    Float weightTrading = 0.1 * (licenses.isTradingViolation as float)

    Return (weightArmor + weightMagic + weightWeapon + weightCrafting + weightTravel + weightCollar + weightUninsured + weightCurfew + weightTrading)
EndFunction

Float Function insuranceModifierFame()
    float TitleFameCount = 0.0
    float ThaneshipFameCount = 0.0
    int i = 0

    ; Weight of a Title: 4.5
    ; Weight of a Thaneship: 1.7
    ; Max Popularity modifier: 18.0 + 15.3 = 33.3

    Quest[] TitleFame = new Quest[4]
    TitleFame[0] = Game.GetFormFromFile(0x02610C, "Skyrim.esm") as Quest; dragonborn
    TitleFame[1] = Game.GetFormFromFile(0x01CEF6, "Skyrim.esm") as Quest; harbinger
    TitleFame[2] = Game.GetFormFromFile(0x01F258, "Skyrim.esm") as Quest; arch-mage
    TitleFame[3] = Game.GetFormFromFile(0x096E71, "Skyrim.esm") as Quest; Civil War: Siege any city, radiant quest
    while i < TitleFame.Length
        if TitleFame[i].IsCompleted()
            TitleFameCount += 4.5
        endIf
        i += 1
    EndWhile

    Bool[] ThaneshipFame = new Bool[9]
    ThaneshipFame[0] = licenses.isWhiterunThane
    ThaneshipFame[1] = licenses.isWinterholdThane
    ThaneshipFame[2] = licenses.isRiftThane
    ThaneshipFame[3] = licenses.isReachThane
    ThaneshipFame[4] = licenses.isPaleThane
    ThaneshipFame[5] = licenses.isHjaalmarchThane
    ThaneshipFame[6] = licenses.isHaafingarThane
    ThaneshipFame[7] = licenses.isFalkreathThane
    ThaneshipFame[8] = licenses.isEastmarchThane
    i = 0
    while i < ThaneshipFame.Length
        if ThaneshipFame[i]
            ThaneshipFameCount += 1.7
        endIf
        i += 1
    EndWhile

    return ((TitleFameCount / TitleFame.Length) + (ThaneshipFameCount / ThaneshipFame.Length))
EndFunction

Float Function insuranceModifierJail()
    Int aiCrimeGold = BM_FineAmount.GetValue() as int

    ; reference values: 1000 for murder, 10 for stealing
    int lowestBounty = 0
    int highestBounty = 2500

    ; data points for the modifier curve
    Float x0 = 0
    Float y0 = 0.1
    Float x1 = 500
    Float y1 = 0.3
    Float x2 = 1000
    Float y2 = 0.6
    Float x3 = 2000
    Float y3 = 1.0

    ; Clamp the aiCrimeGold just in case
    aiCrimeGold = ClampInt(aiCrimeGold, lowestBounty, highestBounty)

    ; Linear interpolation
    Float modifier

    If aiCrimeGold < x0
        modifier = y0
    ElseIf aiCrimeGold >= x0 && aiCrimeGold < x1
        modifier = y0 + (y1 - y0) * (aiCrimeGold - x0) / (x1 - x0)
    ElseIf aiCrimeGold >= x1 && aiCrimeGold < x2
        modifier = y1 + (y2 - y1) * (aiCrimeGold - x1) / (x2 - x1)
    ElseIf aiCrimeGold >= x2 && aiCrimeGold < x3
        modifier = y2 + (y3 - y2) * (aiCrimeGold - x2) / (x3 - x2)
    Else
        modifier = y3
    EndIf

    Return modifier
EndFunction

Function insuranceRateDegradation(float timeElapsed)
    if licenses.insuranceMisbehaviourMultiplier > 1.0
        licenses.insuranceMisbehaviourMultiplier -= 0.00225 * (bmlmcm.BM_InsurCost.GetValue() / bmlmcm.BM_InsurCostBase) * timeElapsed
    endIf

    if licenses.insuranceMisbehaviourMultiplier < 1.0
        licenses.insuranceMisbehaviourMultiplier = 1.0
    endIf
EndFunction
; ------------------------------

; ---------- Custom Events ----------
Function SendCustomEvent_SingleInt(string EventName, int aiArg1 = 0)
    int handle = ModEvent.Create(EventName)
    if (handle)
        ModEvent.PushInt(handle, aiArg1)
        if ModEvent.Send(handle)
            LogTrace("Sent " + EventName)
            return
        else
            ModEvent.Release(handle)
        endIf
    endIf
    LogTrace("Failed to create event for " + EventName)
EndFunction
Function SendCustomEvent_SingleForm(string EventName, form akForm1 = none)
    int handle = ModEvent.Create(EventName)
    if (handle)
        ModEvent.PushForm(handle, akForm1)
        if ModEvent.Send(handle)
            LogTrace("Sent " + EventName)
            return
        else
            ModEvent.Release(handle)
        endIf
    endIf
    LogTrace("Failed to create event for " + EventName)
EndFunction
; ------------------------------

; ----------------------------------------------------------------------------------------------------
; -------------------------------------------------- End API
; ----------------------------------------------------------------------------------------------------

Actor PlayerActorRef

BM_Licenses Property licenses auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Detection Property bmlDetection auto
BM_Licenses_ViolationCheck Property bmlViolationCheck auto
BM_Licenses_Bounty Property bmlBounty auto
BM_Player Property bmPlayer auto
BM_Licenses_Moderator_Alias Property bmlModeratorAlias auto
BM_Licenses_ThaneshipCheck Property bmlThaneshipCheck auto

Book Property BM_ArmorLicense Auto
Book Property BM_BikiniLicense Auto
Book Property BM_ClothingLicense Auto
Book Property BM_MagicLicense Auto
Book Property BM_WeaponLicense Auto
Book Property BM_CraftingLicense Auto
Book Property BM_TradingLicense Auto
Book Property BM_WhoreLicense Auto
Book Property BM_TravelPermit Auto
Book Property BM_CollarExemption Auto
Book Property BM_Insurance Auto
Book Property BM_CurfewExemption Auto

Quest Property licenseViolationCheckQuest auto
Quest Property licenseThaneshipCheckQuest auto
Quest Property licenseDetectionQuest auto
Quest Property licenseBountyQuest auto
Quest Property licenseBarterQuest auto
Quest Property licenseModeratorQuest auto

; -- Vanilla
GlobalVariable Property GameDaysPassed auto
; -- License Vars
GlobalVariable Property BM_ALCost Auto
GlobalVariable Property BM_ALDuration Auto
GlobalVariable Property BM_BLCost Auto
GlobalVariable Property BM_BLDuration Auto
GlobalVariable Property BM_CLCost Auto
GlobalVariable Property BM_CLDuration Auto
GlobalVariable Property BM_MLCost Auto
GlobalVariable Property BM_MLDuration Auto
GlobalVariable Property BM_WLCost Auto
GlobalVariable Property BM_WLDuration Auto
GlobalVariable Property BM_CrfLCost Auto
GlobalVariable Property BM_CrfLDuration Auto
GlobalVariable Property BM_TLCost Auto
GlobalVariable Property BM_TLDuration Auto
GlobalVariable Property BM_CuECost Auto
GlobalVariable Property BM_CuEDuration Auto
GlobalVariable Property BM_TPCost Auto
GlobalVariable Property BM_TPDuration Auto
GlobalVariable Property BM_InsurCost Auto
GlobalVariable Property BM_InsurDuration Auto
GlobalVariable Property BM_WhLCost Auto
GlobalVariable Property BM_WhLDuration Auto
GlobalVariable Property BM_CECost Auto
GlobalVariable Property BM_CEDuration Auto
; -- Exception State
GlobalVariable Property BM_IsInSSLV Auto
GlobalVariable Property BM_IsInDHLPEvent Auto
GlobalVariable Property BM_IsInPlayerHome Auto
GlobalVariable Property BM_IsInJail Auto
GlobalVariable Property BM_IsInAnimation Auto
; -- Violation State
GlobalVariable Property BM_IsViolatingCurfew Auto
; -- Others
GlobalVariable Property BM_IsPlayerCollared auto
GlobalVariable Property BM_FineAmount auto
GlobalVariable Property BM_FirstTimeViolation auto
GlobalVariable Property BM_LenientCurseViolation auto
GlobalVariable Property BM_LenientCurfewViolation auto

MiscObject Property Gold001  Auto 

FormList Property BM_WorldSpaces  Auto
FormList Property BM_Cities  Auto 
FormList Property BM_Towns  Auto
FormList Property BM_LicenseBooks  Auto
FormList Property BM_Empty auto

Location Property currLoc auto
Location Property savedLoc auto
Location Property lastLoc auto
FormList Property BM_PotentialViolations  Auto
FormList Property BM_PotentialViolations_Ench  Auto
FormList Property BM_LicensesIgnoreSpell  Auto
FormList Property BM_LicensesIgnoreWorldspace  Auto

WorldSpace Property currSpace auto
WorldSpace Property savedSpace auto
WorldSpace Property lastSpace auto

Bool Property Licenses_State = false Auto
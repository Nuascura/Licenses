Scriptname BM_Licenses_Utility extends Quest  

import PO3_SKSEFunctions
import PapyrusUtil
import SPE_Cell
import SPE_Utility
import SPE_ObjectRef
import BM_API
import BM_API_DD

; ----------------------------------------------------------------------------------------------------
; -------------------------------------------------- Utility
; ----------------------------------------------------------------------------------------------------

; -------------------------------------------------- Shortcuts --------------------------------------------------
string Function GetModVersion()
    return BM_API.GetModVersion()
EndFunction

int Function GetLicenseID(string LicensePrefix)
    return BM_API.GetLicenseID(LicensePrefix)
EndFunction

Float Function GetLicenseTimeLeft(int LicenseType)
    return BM_API.GetLicenseTimeLeft(LicenseType, self)
EndFunction

bool Function FlagViolation(int ViolationType, bool Push = true, bool CheckSafety = true)
    return BM_API.FlagViolation(ViolationType, Push, CheckSafety, self)
EndFunction

bool Function ClearViolations(bool ClearPersistent = false, bool CheckSafety = true)
    return BM_API.ClearViolations(ClearPersistent, CheckSafety, self)
EndFunction

bool Function PurchaseLicense(int LicenseType, bool SubtractGold = true, bool Lifetime = false, bool CheckSafety = true)
    return BM_API.PurchaseLicense(LicenseType, SubtractGold, Lifetime, CheckSafety, self)
EndFunction

bool Function ExpireLicense(int LicenseType, bool Push = true)
    return BM_API.ExpireLicense(LicenseType, Push, self)
EndFunction

bool Function RemoveLicense(int LicenseType, int LicenseCount = 0, ObjectReference DestinationContainer = None, bool CheckSafety = true)
    return BM_API.RemoveLicense(LicenseType, LicenseCount, DestinationContainer, CheckSafety, self)
EndFunction

bool Function ToggleLicenseFeature(int LicenseType, bool FeatureFlag, bool Push = true, BM_Licenses_Utility bmlUtility)
    return BM_API.ToggleLicenseFeature(LicenseType, FeatureFlag, Push, self)
EndFunction

; -------------------------------------------------- Common Tools --------------------------------------------------
; ---------- Startup ----------
Function Startup(Bool abAutoLoad)
    LogNotification("Initializing Licenses...", true)
    LogTrace("State Change - INITIALIZING", true)

    ; Set Imperatives
    bmlmcm.allowJailQuestNodes = true
    bmlmcm.ConfigWarn = true

    ; Start Core Quests
    if licenses.start()
        bmPlayer.OnLoad()
        bmBarterController.OnLoad()
    endIf
    if licenseModeratorQuest.start()
        bmlModeratorAlias.OnLoad()
    endIf

    ; Start Add-on Quests
    if Game.GetModByName("Licenses - Ambience.esp") != 255
        Quest.GetQuest("LPO_WIComment").Start()
        Quest.GetQuest("LPO_WICommentGuard").Start()
        Quest.GetQuest("LPO_WICommentUncommon").Start()
    endIf

    ; Buffer
    Utility.Wait(1.0)

    ; Initialize Variables
    FillLocalPlayer(licenses.PlayerRef.GetActorRef())
    ReloadMCMVariables()
    if abAutoLoad && bmlmcm.importConfig(true)
        LogNotification("Auto loaded configuration.", true)
    else
        RefreshFeatures()
    endIf
    RefreshStatus()
    
    ; Cache State
    Licenses_CachedState = true
    Licenses_State.SetValue(1.0)
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

    ; Reset Global Variables
    BM_NextStatusCheck.SetValue(0.0)
    BM_NextStorageClear.SetValue(0.0)
    BM_IsInSSLV.SetValue(0.0)
    BM_IsInDHLPEvent.SetValue(0.0)
    BM_IsInPlayerHome.SetValue(0.0)
    BM_IsInJail.SetValue(0.0)
    BM_IsInAnimation.SetValue(0.0)
    BM_IsViolatingCurfew.SetValue(0.0)
    BM_IsPlayerCollared.SetValue(0.0) ; false by default
    BM_FineAmount.SetValue(0.0) ; 0.0 by default
    BM_FirstTimeViolation.SetValue(1.0) ; true by default
	BM_LenientCurseViolation.SetValue(1.0) ; true by default
    BM_LenientCurfewViolation.SetValue(1.0) ; true by default

    ; Reset Local Variables
    savedLoc = None
	savedSpace = None
    LicenseActiveCount_CachedAmt = 0
    LicenseValidCount_CachedAmt = 0
    ViolationActiveCount_CachedAmt = 0

    ; Stop Add-on Quests
    if Game.GetModByName("Licenses - Ambience.esp") != 255
        StopQuest("LPO_WIComment")
        StopQuest("LPO_WICommentGuard")
        StopQuest("LPO_WICommentUncommon")
    endIf

    ; Stop Quests
    StopQuest("BM_Licenses")
    StopQuest("BM_Licenses_ViolationCheck")
    StopQuest("BM_Licenses_ThaneshipCheck")
    StopQuest("BM_Licenses_Bounty")
    StopQuest("BM_Licenses_Barter")
    StopQuest("BM_Licenses_Detection")
    StopQuest("BM_Licenses_Moderator")

    ; Cache State
    Licenses_CachedState = false
    Licenses_State.SetValue(0.0)
    LogNotification("Completed termination sequence.", true)
    LogTrace("State Change - TERMINATED", true)
EndFunction

Function StopQuest(string asQuestName)
    Quest kQuest = Quest.GetQuest(asQuestName)
    kQuest.reset()
    kQuest.stop()
EndFunction
; ------------------------------

; ---------- Location Checkers ----------
Function CheckLocation()
    currLoc = PlayerActorRef.GetCurrentLocation()
    if currLoc
        if PlayerActorRef.IsInInterior()
            currSpace = GetWorldSpaceFromInterior(PlayerActorRef)
        else
            currSpace = PlayerActorRef.GetWorldSpace()
        endIf
        licenses.isInCity = GetIsInCity()
        licenses.isInTown = GetIsInTown()
    endIf
EndFunction

Function ValidateLocNested(Location akNewLoc, WorldSpace akNewSpace, FormList LocList, Keyword akKeyword = none)
    Location validatedLoc = FindLocFromParent(akNewLoc, LocList, akKeyword)
    if validatedLoc
        lastLoc = validatedLoc
        if !BM_LicensesIgnoreWorldspace.HasForm(akNewSpace)
            lastSpace = akNewSpace
        endIf
    endIf
EndFunction

WorldSpace Function GetWorldSpaceFromInterior(ObjectReference akObjRef)
    WorldSpace[] ExteriorWorldSpaces = GetExteriorWorldSpaces(akObjRef.GetParentCell())
    WorldSpace cachedSpace = none
    if ExteriorWorldSpaces
        cachedSpace = FindWorldFromList(ExteriorWorldSpaces, BM_WorldSpaces)
    else
        ObjectReference[] InteriorDoors = FindAllReferencesOfFormType(akObjRef, 29, 0)
        if InteriorDoors
            cachedSpace = FindWorldFromDoor(InteriorDoors, BM_WorldSpaces)
        endIf
    endIf

    if cachedSpace && BM_LicensesIgnoreWorldspace.HasForm(cachedSpace)
        cachedSpace = lastSpace
    endIf
    return cachedSpace
EndFunction

Bool Function GetIsInCity()
    Location[] ExteriorLocations = GetExteriorLocations(PlayerActorRef.GetParentCell())
    if ExteriorLocations
        lastLoc = FindLocFromList(ExteriorLocations, BM_Cities)
    else
        lastLoc = FindLocFromParent(PlayerActorRef.GetCurrentLocation(), BM_Cities, Keyword.GetKeyword("LocTypeCity"))
    endIf
    return (!bmlmcm.isLimitToCitySpaceEnabled || GetIsInCitySpace()) && lastLoc
EndFunction

Bool Function GetIsInCitySpace()
    WorldSpace tempSpace = PlayerActorRef.GetWorldSpace()
    if tempSpace
        If BM_WorldSpaces.HasForm(tempSpace)
            lastSpace = tempSpace
        elseIf BM_LicensesIgnoreWorldspace.HasForm(tempSpace)
            return licenses.isInCity
        else
            lastSpace = none
        endIf
    else
        lastSpace = GetWorldSpaceFromInterior(PlayerActorRef)
    endIf
    return lastSpace
EndFunction

Bool Function GetIsInTown()
    Location[] ExteriorLocations = GetExteriorLocations(PlayerActorRef.GetParentCell())
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
    if (bmlmcm.PrisonAlternative_State || bmlmcm.PrisonOverhaulPatched_State || bmlmcm.DeviousInterests_State)
        return BM_IsInJail.GetValue()
    elseIf BM_IsInJail.GetValue() > 0
        return !(ignoreLoc || (targetLoc && !targetLoc.HasKeywordString("LocTypeJail")))
    endIf
    return false
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
Form[] Function FilterSensitive(Form[] arr)
    ; Filter out items matching keyword combinations
    arr = FilterFormsByKeyword(arr, licenses.KeywordQuestItem, true, true)
    arr = FilterFormsByKeyword(arr, licenses.KeywordModItem, false, true)
    return arr
EndFunction

Form[] Function FilterBikini(Form[] arr, int aiType)
    if licenses.isInsured
        if aiType == 1
            if licenses.hasBikiniLicense
                arr = FilterFormsByKeyword(arr, licenses.ItemTypeBikini, false, true)
            endIf
        elseIf aiType == 2
            if !licenses.hasBikiniExemption
                if licenses.hasClothingLicense
                    arr = FilterByComparison(arr, licenses.ItemTypeClothing, licenses.ItemTypeBikini)
                endIf
                if licenses.hasArmorLicense
                    arr = FilterByComparison(arr, licenses.ItemTypeArmor, licenses.ItemTypeBikini)
                endIf
            endIf
        endIf
    endIf
    return arr
EndFunction

Form[] Function GetViolatingItems(ObjectReference akObjRef, Bool abEquippedOnly, Bool abEnchantedOnly = false)
    ; Get Armor by Slot
    Form[] PotentialForms = FilterByOccupiedSlotmask(AddItemsOfTypeToArray(akObjRef, 26, false), bmlmcm.ArmorSlotArray)
    ; Get Weapons
    PotentialForms = MergeFormArray(PotentialForms, AddItemsOfTypeToArray(akObjRef, 41, false), true)
    ; Get Ammo
    PotentialForms = MergeFormArray(PotentialForms, AddItemsOfTypeToArray(akObjRef, 42, false), true)
    ; Filter by Keywords
    if abEnchantedOnly
        PotentialForms = IntersectArray_Form(PotentialForms, GetItemsByKeyword(akObjRef, licenses.KeywordConfiscationEnch, false))
        PotentialForms = IntersectArray_Form(PotentialForms, GetEnchantedItems(akObjRef, true, true, abEquippedOnly))
    else
        PotentialForms = IntersectArray_Form(PotentialForms, GetItemsByKeyword(akObjRef, licenses.KeywordConfiscation, false))
        PotentialForms = FilterBikini(PotentialForms, bmlmcm.isBikiniLicenseFeatureEnabled)
    endIf
    ; Filter by Equipped
    if abEquippedOnly && (akObjRef as Actor)
        PotentialForms = IntersectArray_Form(PotentialForms, AddAllEquippedItemsToArray(akObjRef as Actor))
    endIf
    ; Overrides
    PotentialForms = FilterSensitive(PotentialForms)
    return PotentialForms
EndFunction

Form[] Function GetViolatingItemsAll(ObjectReference akObjRef, Bool abEquippedOnly)
    return MergeFormArray(GetViolatingItems(akObjRef, abEquippedOnly), GetViolatingItems(akObjRef, abEquippedOnly, true), true)
EndFunction

Int Function GetCombinedSlotMask(int[] aiSlotArray)
	aiSlotArray = RemoveInt(aiSlotArray, 0)
	int slotMask = 0
	int index = aiSlotArray.length
	while index
		index -= 1
		slotMask = Math.LogicalOr(slotMask, Armor.GetMaskForSlot(aiSlotArray[index]))
	endWhile
	return slotMask
EndFunction

Form[] Function FilterByOccupiedSlotmask(Form[] akForms, int[] aiSlotArray, bool abAll = false)
    Armor[] armors = FilterBySlotmask(akForms, GetCombinedSlotMask(aiSlotArray), abAll)
    Form[] ret = Utility.CreateFormArray(armors.Length)
    int i = 0
    While (i < armors.Length)
        ret[i] = armors[i]
        i += 1
    EndWhile
    return ret
EndFunction

Form[] Function FilterByComparison(Form[] arr, Keyword[] kwRemain, Keyword[] kwRemove)
    return FilterArray_Form(\
    arr, FilterFormsByKeyword(\
    FilterFormsByKeyword(\
    arr, kwRemain, false, false\
    ), kwRemove, false, false\
    )\
    )
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
Function CheckStorageStatus(Bool NoQuestItem = true)
    if BM_NextStorageClear.GetValue()
        ItemRetrievalActor.RemoveAllItems(ItemConfiscationChest, false, true)

        if BM_ExpiringItems.GetSize()
            RemoveListFromContainer(ItemConfiscationChest, BM_ExpiringItems, abNoQuestItem = NoQuestItem)
            BM_ExpiringItems.Revert()
        endIf
        
        AddAllItemsToList(ItemConfiscationChest, BM_ExpiringItems, abNoQuestItem = NoQuestItem)
    endIf

    BM_NextStorageClear.SetValue((BM_NextStatusCheck.GetValue() + 7.0) as int)
EndFunction

Function CheckLicenseStatus()
    float currentTime = GameDaysPassed.GetValue()

    RefreshLicenseStatus(currentTime)

    ; Set values for next check
    LastStatusCheck = currentTime
    ; currentTime as 4.0 indicates midnight between day 3 and day 4
    ; so, all we need to do is add 1.0 to the current time and cast it as an int, which auto 'floors' the value
    ; example: if currentTime is 3.5, which indicates halfway through day 3, we add 1.0 to 3.5, giving us 4.5. Casting this float as int gives us 4.0
    BM_NextStatusCheck.SetValue((currentTime + 1.0) as int)

    LogTrace("Current Time: " + CurrentTime)
    LogTrace("Next Status Check: " + BM_NextStatusCheck)

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
        licenses.isThane = true
    else
        licenses.isThane = false
    endIf
    licenseThaneshipCheckQuest.stop()
EndFunction
; ------------------------------

; ---------- Core Licenses Counters ----------
Int Function CountValidLicenses()
    Bool[] LicenseArray = new Bool[13]
    LicenseArray[0] = licenses.hasArmorLicense
    LicenseArray[1] = licenses.hasBikiniLicense
    LicenseArray[2] = licenses.hasBikiniExemption
    LicenseArray[3] = licenses.hasClothingLicense
    LicenseArray[4] = licenses.hasMagicLicense
    LicenseArray[5] = licenses.hasWeaponLicense
    LicenseArray[6] = licenses.hasCraftingLicense
    LicenseArray[7] = licenses.hasTravelPermit
    LicenseArray[8] = licenses.hasCollarExemption
    LicenseArray[9] = licenses.hasInsurance
    LicenseArray[10] = licenses.hasCurfewExemption
    LicenseArray[11] = licenses.hasTradingLicense
    LicenseArray[12] = licenses.hasWhoreLicense
    return CountBool(LicenseArray, true)
EndFunction

Int Function CountActiveLicenses()
    Bool[] LicenseArray = new Bool[13]
    LicenseArray[0] = (licenses.armorLicenseExpirationTime != -1) && bmlmcm.isArmorLicenseFeatureEnabled
    LicenseArray[1] = (licenses.bikiniLicenseExpirationTime != -1) && (bmlmcm.isBikiniLicenseFeatureEnabled == 1)
    LicenseArray[2] = (licenses.bikiniExemptionExpirationTime != -1) && (bmlmcm.isBikiniLicenseFeatureEnabled == 2)
    LicenseArray[3] = (licenses.clothingLicenseExpirationTime != -1) && bmlmcm.isClothingLicenseFeatureEnabled
    LicenseArray[4] = (licenses.magicLicenseExpirationTime != -1) && bmlmcm.isMagicLicenseFeatureEnabled
    LicenseArray[5] = (licenses.weaponLicenseExpirationTime != -1) && bmlmcm.isWeaponLicenseFeatureEnabled
    LicenseArray[6] = (licenses.craftingLicenseExpirationTime != -1) && bmlmcm.isCraftingLicenseFeatureEnabled
    LicenseArray[7] = (licenses.travelPermitExpirationTime != -1) && bmlmcm.isTravelPermitFeatureEnabled
    LicenseArray[8] = (licenses.collarExemptionExpirationTime != -1) && bmlmcm.isCollarExemptionFeatureEnabled
    LicenseArray[9] = (licenses.insuranceExpirationTime != -1) && bmlmcm.isInsuranceFeatureEnabled
    LicenseArray[10] = (licenses.curfewExemptionExpirationTime != -1) && bmlmcm.isCurfewExemptionFeatureEnabled
    LicenseArray[11] = (licenses.tradingLicenseExpirationTime != -1) && bmlmcm.isTradingLicenseFeatureEnabled
    LicenseArray[12] = (licenses.whoreLicenseExpirationTime != -1) && bmlmcm.isWhoreLicenseFeatureEnabled
    return CountBool(LicenseArray, true)
EndFunction

Int Function CountActiveViolations()
    Bool[] ActiveViolations = new Bool[12]
    ActiveViolations[0] = licenses.isArmorViolation
    ActiveViolations[1] = licenses.isBikiniViolation as bool
    ActiveViolations[2] = licenses.isClothingViolation
    ActiveViolations[3] = licenses.isMagicViolation
    ActiveViolations[4] = licenses.isWeaponViolation
    ActiveViolations[5] = licenses.isCraftingViolation
    ActiveViolations[6] = licenses.isTravelViolation
    ActiveViolations[7] = licenses.isCollarViolation
    ActiveViolations[8] = licenses.isUninsuredViolation
    ActiveViolations[9] = licenses.isCurfewViolation
    ActiveViolations[10] = licenses.isTradingViolation
    ActiveViolations[11] = licenses.isWhoreViolation
    return CountBool(ActiveViolations, true)
EndFunction

bool Function CheckViolationExists()
    Bool[] violations = new Bool[12]
    violations[0] = licenses.isArmorViolation
    violations[1] = licenses.isBikiniViolation as bool
    violations[2] = licenses.isClothingViolation
    violations[3] = licenses.isMagicViolation
    violations[4] = licenses.isWeaponViolation
    violations[5] = licenses.isCraftingViolation
    violations[6] = licenses.isTravelViolation
    violations[7] = licenses.isCollarViolation
    violations[8] = licenses.isUninsuredViolation
    violations[9] = licenses.isCurfewViolation
    violations[10] = licenses.isTradingViolation
    violations[11] = licenses.isWhoreViolation
    return violations.Find(true) != -1
EndFunction
; ------------------------------

; ---------- Violation Check Sequence ----------
Function startDetectionQuest()
    LogTrace("Attempting to start Detection Quest.")
    licenseDetectionQuest.stop()
    if licenseDetectionQuest.start()
        LogTrace("Started Detection Quest.")
        bmlDetection.GoToState("Default")
    else
        LogTrace("Detection Quest failed to start.")
    endIf
EndFunction

Function ConsiderViolationCheck()
    If licenseBountyQuest.IsRunning()
        if bmlBounty.GetState() == ""
            LogTrace("Bounty Quest is running. Checking Alias Validity instead.")
            bmlBounty.RegisterForSingleUpdate(1.0)
        endIf
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
        bmlViolationCheck.GoToState("Start")
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
    ViolationActiveCount_CachedAmt = CountActiveViolations()

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
Int Function ClampInt(int value, int minValue, int maxValue) Global
    If value < minValue
        Return minValue
    ElseIf value > maxValue
        Return maxValue
    Else
        Return value
    EndIf
EndFunction

Float Function ClampFloat(float value, float minValue, float maxValue) Global
    If value < minValue
        Return minValue
    ElseIf value > maxValue
        Return maxValue
    Else
        Return value
    EndIf
EndFunction

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

Function LogMessageBox(String LogMessage)
    if LogMessage
        Debug.MessageBox(LogMessage)
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

    Int[] FineList = new Int[12]
    FineList[0] = (licenses.isArmorViolation as int) * (bmlmcm.BM_ALCost.GetValue() as int)
    FineList[1] = ((licenses.isBikiniViolation as bool) as int) * (bmlmcm.BM_BLCost.GetValue() as int)
    FineList[2] = (licenses.isClothingViolation as int) * (bmlmcm.BM_CLCost.GetValue() as int)
    FineList[3] = (licenses.isMagicViolation as int) * (bmlmcm.BM_MLCost.GetValue() as int)
    FineList[4] = (licenses.isWeaponViolation as int) * (bmlmcm.BM_WLCost.GetValue() as int)
    FineList[5] = (licenses.isCraftingViolation as int) * (bmlmcm.BM_CrfLCost.GetValue() as int)
    FineList[6] = (licenses.isTravelViolation as int) * (bmlmcm.BM_TPCost.GetValue() as int)
    FineList[7] = (licenses.isCollarViolation as int) * (bmlmcm.BM_CECost.GetValue() as int)
    FineList[8] = (licenses.isUninsuredViolation as int) * (bmlmcm.BM_InsurCost.GetValue() as int)
    FineList[9] = (licenses.isCurfewViolation as int) * (bmlmcm.BM_CuECost.GetValue() as int)
    FineList[10] = (licenses.isTradingViolation as int) * (bmlmcm.BM_TLCost.GetValue() as int)
    FineList[11] = (licenses.isWhoreViolation as int) * (bmlmcm.BM_WhLCost.GetValue() as int)

    Fine = Base + (Percentage * AddIntValues(FineList))
    LogTrace("Generated Fine Total: " + Fine)
    return Fine
EndFunction
; ------------------------------

; ---------- License Purchase Functions ----------
Function BM_PurchaseArmorLicense(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_ArmorLicense_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.armorLicenseExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_ALCostLT.GetValue() as int)
        endIf
    else
        licenses.armorLicenseExpirationTime = (GameDaysPassed.getValue() + BM_ALDuration.GetValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_ALCost.GetValue() as int)
        endIf
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 1)
EndFunction

Function BM_PurchaseBikiniLicense(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_BikiniLicense_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.bikiniLicenseExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_BLCostLT.GetValue() as int)
        endIf
    else
        licenses.bikiniLicenseExpirationTime = (GameDaysPassed.getValue() + BM_BLDuration.getValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_BLCost.GetValue() as int)
        endIf
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 2)
EndFunction

Function BM_PurchaseBikiniExemption(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_BikiniExemption_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.bikiniExemptionExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_BLCostLT.GetValue() as int)
        endIf
    else
        licenses.bikiniExemptionExpirationTime = (GameDaysPassed.getValue() + BM_BLDuration.getValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_BLCost.GetValue() as int)
        endIf
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 3)
EndFunction

Function BM_PurchaseClothingLicense(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_ClothingLicense_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.clothingLicenseExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_CLCostLT.GetValue() as int)
        endIf
    else
        licenses.clothingLicenseExpirationTime = (GameDaysPassed.getValue() + BM_CLDuration.getValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_CLCost.GetValue() as int)
        endIf
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 4)
EndFunction

Function BM_PurchaseMagicLicense(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_MagicLicense_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.magicLicenseExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_MLCostLT.GetValue() as int)
        endIf
    else
        licenses.magicLicenseExpirationTime = (GameDaysPassed.getValue() + BM_MLDuration.getValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_MLCost.GetValue() as int)
        endIf
    endIf
    licenses.RemoveNullifyMagicka()
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 5)
EndFunction

Function BM_PurchaseWeaponLicense(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_WeaponLicense_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.weaponLicenseExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_WLCostLT.GetValue() as int)
        endIf
    else
        licenses.weaponLicenseExpirationTime = (GameDaysPassed.getValue() + BM_WLDuration.getValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_WLCost.GetValue() as int)
        endIf
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 6)
Endfunction

Function BM_PurchaseCraftingLicense(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_CraftingLicense_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.craftingLicenseExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_CrfLCostLT.GetValue() as int)
        endIf
    else
        licenses.craftingLicenseExpirationTime = (GameDaysPassed.getValue() + BM_CrfLDuration.getValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_CrfLCost.GetValue() as int)
        endIf
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 7)
EndFunction

Function BM_PurchaseTravelPermit(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_TravelPermit_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.travelPermitExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_TPCostLT.GetValue() as int)
        endIf
    else
        licenses.travelPermitExpirationTime = (GameDaysPassed.getValue() + BM_TPDuration.getValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_TPCost.GetValue() as int)
        endIf
    endIf
    savedLoc = None
    savedSpace = None
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 8)
EndFunction

Function BM_PurchaseCollarExemption(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_CollarExemption_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.collarExemptionExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_CECostLT.GetValue() as int)
        endIf
    else
        licenses.collarExemptionExpirationTime = (GameDaysPassed.getValue() + BM_CEDuration.getValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_CECost.GetValue() as int)
        endIf
    endIf
    licenses.RemoveDeviousDevicesCollar()
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 9)
EndFunction

Function BM_PurchaseLifeInsurance(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_Insurance_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.insuranceExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, (BM_InsurCost.GetValue() * bmlmcm.LifetimeMultiplier) as int)
        endIf
    else
        licenses.insuranceExpirationTime = (GameDaysPassed.getValue() + BM_InsurDuration.getValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_InsurCost.GetValue() as int)
        endIf
    endIf
    licenses.RemoveNullifyMagicka()
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 10)
EndFunction

Function BM_PurchaseCurfewExemption(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_CurfewExemption_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.curfewExemptionExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_CuECostLT.GetValue() as int)
        endIf
    else
        licenses.curfewExemptionExpirationTime = (GameDaysPassed.getValue() + BM_CuEDuration.GetValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_CuECost.GetValue() as int)
        endIf
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 11)
EndFunction

Function BM_PurchaseTradingLicense(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_TradingLicense_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.tradingLicenseExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_TLCostLT.GetValue() as int)
        endIf
    else
        licenses.tradingLicenseExpirationTime = (GameDaysPassed.getValue() + BM_TLDuration.GetValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_TLCost.GetValue() as int)
        endIf
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 12)
EndFunction

Function BM_PurchaseWhoreLicense(bool pay = true, bool lifetime = false)
    SendModEvent("BM-LPO_WhoreLicense_" + PlayerActorRef.GetFormID() + "_Activate")
    if lifetime
        licenses.whoreLicenseExpirationTime = -2
        if pay
            PlayerActorRef.removeItem(Gold001, BM_WhLCostLT.GetValue() as int)
        endIf
    else
        licenses.whoreLicenseExpirationTime = (GameDaysPassed.getValue() + BM_WhLDuration.getValue()) as int
        if pay
            PlayerActorRef.removeItem(Gold001, BM_WhLCost.GetValue() as int)
        endIf
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicensePurchased", 13)
EndFunction
; ------------------------------

; ---------- License Expire Functions ----------
; These are manual expiration calls that can run independent of the usual daily checker
; Call ModeratorUpdater() after license expirations if they are run outside daily checker
Function BM_ExpireArmorLicense()
    SendModEvent("BM-LPO_ArmorLicense_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.armorLicenseExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.armorLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_ALDuration.GetValue())) as int
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 1)
EndFunction

Function BM_ExpireBikiniLicense()
    SendModEvent("BM-LPO_BikiniLicense_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.bikiniLicenseExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.bikiniLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_BLDuration.GetValue())) as int
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 2)
EndFunction

Function BM_ExpireBikiniExemption()
    SendModEvent("BM-LPO_BikiniExemption_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.bikiniExemptionExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.bikiniExemptionCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_BLDuration.GetValue())) as int
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 3)
EndFunction

Function BM_ExpireClothingLicense()
    SendModEvent("BM-LPO_ClothingLicense_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.clothingLicenseExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.clothingLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_CLDuration.GetValue())) as int
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 4)
EndFunction

Function BM_ExpireMagicLicense()
    SendModEvent("BM-LPO_MagicLicense_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.magicLicenseExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.magicLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_MLDuration.GetValue())) as int
    endIf
    BM_LenientCurseViolation.SetValue(1.0)
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 5)
EndFunction

Function BM_ExpireWeaponLicense()
    SendModEvent("BM-LPO_WeaponLicense_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.weaponLicenseExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.weaponLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_WLDuration.GetValue())) as int
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 6)
Endfunction

Function BM_ExpireCraftingLicense()
    SendModEvent("BM-LPO_CraftingLicense_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.craftingLicenseExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.craftingLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_CrfLDuration.GetValue())) as int
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 7)
EndFunction

Function BM_ExpireTravelPermit()
    SendModEvent("BM-LPO_TravelPermit_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.travelPermitExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.travelPermitCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_TPDuration.GetValue())) as int
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 8)
EndFunction

Function BM_ExpireCollarExemption()
    SendModEvent("BM-LPO_CollarExemption_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.collarExemptionExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.collarExemptionCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_CEDuration.GetValue())) as int
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 9)
EndFunction

Function BM_ExpireLifeInsurance()
    SendModEvent("BM-LPO_Insurance_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.insuranceExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.insuranceCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_InsurDuration.GetValue())) as int
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 10)
EndFunction

Function BM_ExpireCurfewExemption()
    SendModEvent("BM-LPO_CurfewExemption_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.curfewExemptionExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.curfewExemptionCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_CuEDuration.GetValue())) as int
    endIf
    BM_LenientCurfewViolation.SetValue(1.0)
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 11)
EndFunction

Function BM_ExpireTradingLicense()
    SendModEvent("BM-LPO_TradingLicense_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.tradingLicenseExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.tradingLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_TLDuration.GetValue())) as int
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 12)
EndFunction

Function BM_ExpireWhoreLicense()
    SendModEvent("BM-LPO_WhoreLicense_" + PlayerActorRef.GetFormID() + "_Deactivate")
    licenses.whoreLicenseExpirationTime = -1.0
    if bmlmcm.LicenseCooldown != 0
        licenses.whoreLicenseCooldownTime = (GameDaysPassed.getValue() + GetCooldown(bmlmcm.LicenseCooldown, bmlmcm.BM_WhLDuration.GetValue())) as int
    endIf
    SendCustomEvent_SingleInt("BM-LPO_LicenseExpired", 13)
EndFunction
; ------------------------------

; ---------- Debuggers / Back-end Refreshers ----------
; Refresh license timers and immunities
Function RefreshStatus()
    CheckLocation()
    CheckThaneship()
    CheckExceptionState()
    CheckLicenseStatus()
    CheckStorageStatus(false)
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
            GameMessage(licenses.MessageBikini1Expired)
            BM_ExpireBikiniLicense()
        elseIf (licenses.bikiniLicenseExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageBikini1Countdown, Math.ceiling(24 * (licenses.bikiniLicenseExpirationTime - currentTime)))
        endIf
    endif
    if (licenses.bikiniExemptionExpirationTime >= 0)
        if (currentTime >= licenses.bikiniExemptionExpirationTime)
            GameMessage(licenses.MessageBikini2Expired)
            BM_ExpireBikiniExemption()
        elseIf (licenses.bikiniExemptionExpirationTime - currentTime < 2)
            GameMessage(licenses.MessageBikini2Countdown, Math.ceiling(24 * (licenses.bikiniExemptionExpirationTime - currentTime)))
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
    insuranceRateDegradation(currentTime - LastStatusCheck)
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
    if (currentTime >= licenses.bikiniExemptionCooldownTime)
        licenses.bikiniExemptionCooldownTime = -1.0
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
            licenses.CursedTattoosActive = BM_API_ST.LockCursedTattoos(PlayerActorRef, licenses.CursedTattoos, bmlmcm)
        endIf
    endIf
EndFunction

; Refresh Licenses
Function RefreshLicenses()
    refreshLicenseFeatures()
    bmlModeratorAlias.RefreshLicenseValidity()
EndFunction

; Refresh Features
Function RefreshFeatures()
    refreshIntervalCheckFeature()
	refreshRoutineCalls()
	refreshPopularityModifier()
	refreshLicenseSeller()
    refreshLicenseFeatures()
    refreshActivationLimit()
    refreshArrays()
EndFunction

Function refreshLicenseFeatures()
	licenses.ArmorLicense = (licenses.armorLicenseExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_ArmorLicense) > 0)
	licenses.BikiniLicense = (licenses.bikiniLicenseExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_BikiniLicense) > 0)
    licenses.BikiniExemption = (licenses.bikiniExemptionExpirationTime != -1.0 && PlayerActorRef.getItemCount(BM_BikiniExemption) > 0)
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
    LicenseActiveCount_CachedAmt = CountActiveLicenses()
    LicenseValidCount_CachedAmt = CountValidLicenses()
    if bmlmcm.LicenseLimit == 0
        licenses.isLicenseLimit = (LicenseValidCount_CachedAmt >= BM_LicenseBooks.GetSize())
    else
        licenses.isLicenseLimit = (LicenseActiveCount_CachedAmt >= bmlmcm.LicenseLimit)
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
    licenses.PopulateCursedTattoosArray()

    licenses.FillItemTypeArray()
    
    licenses.ValidateArmorSlotArray()
EndFunction
; ------------------------------

; ---------- MCM Utilities ----------
Function ResetMCM()
    Quest kQuest = Quest.GetQuest("BM_Licenses_MCM")
    kQuest.Reset()
    Utility.Wait(2.0)
    kQuest.Stop()
    While !kQuest.IsStopped()
        Utility.Wait(0.1)
    EndWhile
    if kQuest.Start()
        ReloadMCMVariables(true)
        RefreshFeatures()
        LogMessageBox("Successfully reset the MCM. If Licenses was recently updated, you may also want to restart the mod.")
    else
        LogMessageBox("The MCM failed to restart. Please check your Papyrus log and notify the author of this error.")
    endIf
EndFunction

Function ReloadMCMVariables(bool abSilent = false)
    if !bmlInit.CheckHardDependencies(bmlmcm) && abSilent
        LogNotification("Detected missing dependencies. Check Auxiliary tab for details.", true)
    endIf
	bmlInit.CheckSoftDependencies(bmlmcm)
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
        BM_IsPlayerCollared.SetValue(HasCollarEquipped(bmlInit.kzadAPI, PlayerActorRef) as int)
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
    Float[] ViolationWeight = new Float[12]
    ViolationWeight[0] = 0.1 * (licenses.isArmorViolation as float)
    ViolationWeight[1] = 0.1 * ((licenses.isBikiniViolation as bool) as float)
    ViolationWeight[2] = 0.1 * (licenses.isClothingViolation as float)
    ViolationWeight[3] = 0.2 * (licenses.isMagicViolation as float)
    ViolationWeight[4] = 0.2 * (licenses.isWeaponViolation as float)
    ViolationWeight[5] = 0.1 * (licenses.isCraftingViolation as float)
    ViolationWeight[6] = 0.1 * (licenses.isTravelViolation as float)
    ViolationWeight[7] = 0.2 * (licenses.isCollarViolation as float)
    ViolationWeight[8] = 0.1 * (licenses.isUninsuredViolation as float)
    ViolationWeight[9] = 0.1 * (licenses.isCurfewViolation as float)
    ViolationWeight[10] = 0.1 * (licenses.isTradingViolation as float)
    ViolationWeight[11] = 0.1 * (licenses.isWhoreViolation as float)

    Return AddFloatValues(ViolationWeight)
EndFunction

Float Function insuranceModifierFame()
    ; Weight of a Title: 4.5
    ; Weight of a Thaneship: 1.7
    ; Max Popularity modifier: 18.0 + 15.3 = 33.3

    Bool[] TitleFame = new Bool[4]
    TitleFame[0] = MQ104.IsCompleted(); Dragonborn (0x02610C)
    TitleFame[1] = C06.IsCompleted(); Harbinger (0x01CEF6)
    TitleFame[2] = MG08.IsCompleted(); Arch-Mage (0x01F258)
    TitleFame[3] = CWSiegeObj.IsCompleted(); Civil War (0x096E71)

    Bool[] ThaneshipFame = new Bool[9]
    ThaneshipFame[0] = FJMF.WhiterunImpGetOutofJail + FJMF.WhiterunSonsGetOutofJail
    ThaneshipFame[1] = FJMF.WinterholdImpGetOutofJail + FJMF.WinterholdSonsGetOutofJail
    ThaneshipFame[2] = FJMF.RiftImpGetOutofJail + FJMF.RiftSonsGetOutofJail
    ThaneshipFame[3] = FJMF.ReachImpGetOutofJail + FJMF.ReachSonsGetOutofJail
    ThaneshipFame[4] = FJMF.PaleImpGetOutofJail + FJMF.PaleSonsGetOutofJail
    ThaneshipFame[5] = FJMF.HjaalmarchImpGetOutofJail + FJMF.HjaalmarchSonsGetOutofJail
    ThaneshipFame[6] = FJMF.HaafingarImpGetOutofJail + FJMF.HaafingarSonsGetOutofJail
    ThaneshipFame[7] = FJMF.FalkreathImpGetOutofJail + FJMF.FalkreathSonsGetOutofJail
    ThaneshipFame[8] = FJMF.EastmarchImpGetOutofJail + FJMF.EastmarchSonsGetOutofJail

    return (((CountBool(TitleFame, true) * 4.5) / TitleFame.Length) \
    + ((CountBool(ThaneshipFame, true) * 1.7) / ThaneshipFame.Length))
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
; -------------------------------------------------- End Utility
; ----------------------------------------------------------------------------------------------------

Actor PlayerActorRef

BM_Licenses Property licenses auto
BM_Licenses_Bounty Property bmlBounty auto
BM_Licenses_Detection Property bmlDetection auto
BM_Licenses_Init Property bmlInit auto
BM_Licenses_MCM Property bmlmcm auto
BM_Licenses_Moderator_Alias Property bmlModeratorAlias auto
BM_Licenses_ViolationCheck Property bmlViolationCheck auto
BM_Player Property bmPlayer auto
BM_BarterController Property bmBarterController auto

Book Property BM_ArmorLicense Auto
Book Property BM_BikiniLicense Auto
Book Property BM_BikiniExemption Auto
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
Quest Property licenseModeratorQuest auto

; -- Vanilla Vars
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
; -- Lifetime Vars
GlobalVariable Property BM_ALCostLT Auto
GlobalVariable Property BM_BLCostLT Auto
GlobalVariable Property BM_CLCostLT Auto
GlobalVariable Property BM_MLCostLT Auto
GlobalVariable Property BM_WLCostLT Auto
GlobalVariable Property BM_CrfLCostLT Auto
GlobalVariable Property BM_TLCostLT Auto
GlobalVariable Property BM_WhLCostLT Auto
GlobalVariable Property BM_TPCostLT Auto
GlobalVariable Property BM_CECostLT Auto
GlobalVariable Property BM_CuECostLT Auto
; -- Exception Vars
GlobalVariable Property BM_IsInSSLV Auto
GlobalVariable Property BM_IsInDHLPEvent Auto
GlobalVariable Property BM_IsInPlayerHome Auto
GlobalVariable Property BM_IsInJail Auto
GlobalVariable Property BM_IsInAnimation Auto
; -- Violation Vars
GlobalVariable Property BM_IsViolatingCurfew Auto
; -- Misc Vars
GlobalVariable Property BM_IsPlayerCollared auto
GlobalVariable Property BM_FineAmount auto
GlobalVariable Property BM_FirstTimeViolation auto
GlobalVariable Property BM_LenientCurseViolation auto
GlobalVariable Property BM_LenientCurfewViolation auto
GlobalVariable Property BM_NextStatusCheck auto
GlobalVariable Property BM_NextStorageClear auto

; Objects
MiscObject Property Gold001  Auto 
ObjectReference Property ItemConfiscationChest Auto
Actor Property ItemRetrievalActor Auto

; Utility forms
FormList Property BM_WorldSpaces  Auto
FormList Property BM_Cities  Auto 
FormList Property BM_Towns  Auto
FormList Property BM_LicenseBooks  Auto
FormList Property BM_ExpiringItems auto
FormList Property BM_PotentialViolations  Auto
FormList Property BM_PotentialViolations_Ench  Auto
FormList Property BM_LicensesIgnoreSpell  Auto
FormList Property BM_LicensesIgnoreWorldspace  Auto
Location Property currLoc auto
Location Property savedLoc auto
Location Property lastLoc auto
WorldSpace Property currSpace auto
WorldSpace Property savedSpace auto
WorldSpace Property lastSpace auto

;Caches
GlobalVariable Property Licenses_State auto
Bool Property Licenses_CachedState auto hidden
Int Property LicenseActiveCount_CachedAmt auto hidden
Int Property LicenseValidCount_CachedAmt auto hidden
Int Property ViolationActiveCount_CachedAmt auto hidden
Float Property LastStatusCheck auto hidden

; Vanilla Quests
Quest Property MQ104 auto
Quest Property C06 auto
Quest Property MG08 auto
Quest Property CWSiegeObj auto
FavorJarlsMakeFriendsScript Property FJMF auto
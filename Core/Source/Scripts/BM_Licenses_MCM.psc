Scriptname BM_Licenses_MCM extends SKI_ConfigBase conditional

BM_Licenses Property licenses auto
BM_Licenses_Init Property bmlInit auto
BM_Licenses_Utility Property bmlUtility Auto
GlobalVariable Property GameDaysPassed auto
bool Property SessionModified auto
Message Property MessageConfigWarn  Auto  
string config = "../../../Interface/Licenses/Settings.json"
string[] ModVersionCache
GlobalVariable Property Licenses_State auto

import JsonUtil

; Page 1 - General
; Basic Settings
bool Property isKinkyDialogueFeatureEnabled = false auto conditional
bool Property isCheckIntervalFeatureEnabled = false auto
float Property checkInterval = 45.0 auto
bool Property isCheckLOSFeatureEnabled = false auto
; Additional Settings
int Property licenseSellerFaction = 1 auto conditional
float Property LicenseEnforcerCount = 3.0 auto conditional
string[] sellerList
GlobalVariable Property BM_SellerGuard Auto
GlobalVariable Property BM_SellerSteward Auto
int Property LicenseLimit = 0 auto
float Property LicenseCooldown = 0.0 auto conditional
bool Property LicenseRenewal = false auto conditional
bool Property isWaterDamageEnabled = false auto conditional
bool Property thaneImmunityUniversal = false auto
; Filters
bool Property isLimitToCityEnabled = true auto
bool Property isLimitToCitySpaceEnabled = false auto conditional
bool Property isLimitToTownEnabled = true auto
bool Property ValidateEquipmentTrade = true auto
GlobalVariable Property BM_isMaleGuardEnabled  Auto
GlobalVariable Property BM_isFemaleGuardEnabled  Auto
; Punishments
int Property FineBase = 250 auto
float Property FinePercentage = 25.0 auto
bool Property fineAddsToBounty = false auto conditional
bool Property isConfiscateFeatureEnabled = false auto conditional
bool Property isConfiscateInventoryFeatureEnabled = false auto

; Page 2 - Licenses - Primary
bool Property isArmorLicenseFeatureEnabled = true auto conditional
GlobalVariable Property BM_ALCost Auto
GlobalVariable Property BM_ALDuration Auto
bool Property ALClothingImmunity Auto

int Property isBikiniLicenseFeatureEnabled = 0 auto conditional
string[] BikiniLicenseFeatureState
GlobalVariable Property BM_BLCost Auto
GlobalVariable Property BM_BLDuration Auto
bool Property isBikiniArmorFeatureEnabled = true auto
bool Property isBikiniClothingFeatureEnabled = true auto
String Property bikiniKeywordString = "EroticArmor" auto

bool Property isClothingLicenseFeatureEnabled = false auto conditional
GlobalVariable Property BM_CLCost Auto
GlobalVariable Property BM_CLDuration Auto

bool Property isMagicLicenseFeatureEnabled = true auto conditional
GlobalVariable Property BM_MLCost Auto
GlobalVariable Property BM_MLDuration Auto
bool Property isEnchantedArmorFeatureEnabled = false auto
bool Property isEnchantedClothingFeatureEnabled = false auto
bool Property isEnchantedJewelryFeatureEnabled = false auto
bool Property isEnchantedWeaponryFeatureEnabled = false auto
int Property NullifyMagickaSource = 0 auto conditional
string[] NullifyMagickaSourceList
bool Property NullifyMagickaEnforce = false auto

bool Property isWeaponLicenseFeatureEnabled = true auto conditional
GlobalVariable Property BM_WLCost Auto
GlobalVariable Property BM_WLDuration Auto
bool Property isWeaponAmmoFeatureEnabled = true auto

; Page 3 - Licenses - Secondary
bool Property isCraftingLicenseFeatureEnabled = true auto conditional
GlobalVariable Property BM_CrfLCost Auto
GlobalVariable Property BM_CrfLDuration Auto

bool Property isTradingLicenseFeatureEnabled = true auto conditional
GlobalVariable Property BM_TLCost Auto
GlobalVariable Property BM_TLDuration Auto

bool Property isCurfewExemptionFeatureEnabled = false auto conditional
GlobalVariable Property BM_CuECost Auto
GlobalVariable Property BM_CuEDuration Auto
GlobalVariable Property BM_CurfewStart Auto
GlobalVariable Property BM_CurfewEnd Auto

bool Property isTravelPermitFeatureEnabled = false auto conditional
GlobalVariable Property BM_TPCost Auto
GlobalVariable Property BM_TPDuration Auto
GlobalVariable Property BM_FollowerMale  Auto
GlobalVariable Property BM_FollowerFemale  Auto

bool Property isInsuranceFeatureEnabled = false auto conditional
GlobalVariable Property BM_InsurCost Auto
float Property BM_InsurCostBase = 3500.0 Auto
GlobalVariable Property BM_InsurDuration Auto
bool property invertPopularityMultiplier = false auto
bool property thaneImmunityInsurance = false auto

; Page 4 - Licenses - Tertiary
bool Property isWhoreLicenseFeatureEnabled = false auto conditional
GlobalVariable Property BM_WhLCost Auto
GlobalVariable Property BM_WhLDuration Auto

bool Property isCollarExemptionFeatureEnabled = false auto conditional
GlobalVariable Property BM_CECost Auto
GlobalVariable Property BM_CEDuration Auto

; Page 5 - Slot Filtering
Int[] Property ArmorSlotArray Auto

; Page 6 - Integrations
; Devious Devices
bool Property equipDDOnViolation = false auto
int Property ddEquipChance = 50 auto
int Property ddFilter = 2 auto
string[] ddFilterList

; SlaveTats
bool Property ShowCurseTattoos = false auto
int Property Curse_Color = 0x99FFFF auto
int Property Curse_Glow = 0x007A87 auto
float Property Curse_Alpha = 1.0 auto
bool Property Curse_Neck = true auto
bool Property Curse_Torso = true auto
bool Property Curse_Arms = true auto
bool Property Curse_Legs = true auto
bool Property Curse_ReduceSlotUsage = false auto

; Page 7 - Auxiliary
; Dependency Check
; Hard dependency - PapyrusExtender
string Property PapyrusExtender_Status = "$LPO_Null" auto Hidden
; Hard dependency - PapyrusUtil
string Property PapyrusUtil_Status = "$LPO_Null" auto Hidden
; Hard dependency - ScrabsPapyrusExtender
string Property ScrabsPapyrusExtender_Status = "$LPO_Null" auto Hidden
; Soft dependency - Devious Devices - Assets.esm
; Soft dependency - Devious Devices - Expansion.esm
; Soft dependency - Devious Devices - Integration.esm
; Soft dependency - Devious Devices - Contraptions.esm
bool Property DeviousDevices_State = false auto Hidden
string Property DeviousDevices_Status = "" auto Hidden
; Soft dependency - DeviousFollowers.esp
bool Property DeviousFollowers_State = false auto Hidden
string Property DeviousFollowers_Status = "" auto Hidden
; Soft dependency - xazPrisonOverhaulPatched.esp
bool Property PrisonOverhaulPatched_State = false auto conditional
string Property PrisonOverhaulPatched_Status = "" auto
; Soft dependency - SexLabAroused.esm
bool Property SexLabAroused_State = false auto
string Property SexLabAroused_Status = "" auto
; Soft dependency - SlaveTats.esp
bool Property SlaveTats_State = false auto
string Property SlaveTats_Status = "" auto
; Compatibility Check
; Soft dependency - DeviousInterests.esp
bool Property DeviousInterests_State = false auto conditional
string Property DeviousInterests_Status = "" auto
; Soft dependency - OStim.esp
bool Property OStim_State = false auto conditional
string Property OStim_Status = "" auto
; Soft dependency - PamaPrisonAlternative.esm
bool Property PrisonAlternative_State = false auto conditional
string Property PrisonAlternative_Status = "" auto
; Soft dependency - SexLab.esm
bool Property SexLab_State = false auto
string Property SexLab_Status = "" auto
; Soft dependency - SimpleSlavery.esp
bool Property SimpleSlavery_State = false auto
string Property SimpleSlavery_Status = "" auto
; Advanced Settings
bool Property GameMessage = true auto
bool Property LogNotification = false auto
bool Property LogTrace = false auto
bool Property ConfigWarn = true auto
bool Property allowJailQuestNodes = true auto conditional
float Property standardEventDelay = 2.0 auto
GlobalVariable Property BM_WICommentChance auto

string Function GetModName()
	return modname
EndFunction

string Function GetModVersion()
	return BM_API.GetModVersion()
EndFunction

int Function GetVersion()
	return BM_API.GetConfigVersion()
EndFunction

bool Function CheckVersionConflict()
	; potential conflict if config version number is incremented across a different or new major or minor version.
	string[] ModVersionCurrent = PapyrusUtil.StringSplit(GetModVersion(), ".")
	if !ModVersionCache
		return true
	elseIf (ModVersionCache[0] != ModVersionCurrent[0]) || (ModVersionCache[1] != ModVersionCurrent[1]) || (ModVersionCurrent[2] as int == 0) ; invalid strings are displayed as 0, which is fine
		return true
	endIf
	return false
EndFunction

Event OnVersionUpdate(int version)
	if (CurrentVersion != 0) && (version > CurrentVersion)
		bmlUtility.LogTrace("Found LPO MCM version " + GetVersion(), true)
		bmlUtility.LogNotification("Detected a newer config version. Refreshing...", true)
		RegisterForSingleUpdate(2.0)
	endIf
EndEvent

Event OnUpdate()
	VersionUpdate()
	bmlUtility.LogTrace("Finished update cycle.", true)
EndEvent

Function VersionUpdate()
	if CheckVersionConflict()
		if ConfigWarn && MessageConfigWarn.Show() == 0
			bmlUtility.ResetMCM()
			return
		else
			bmlUtility.LogNotification("Detected potential config version conflict.", true)
		endIf
	endIf
	OnConfigInit()
	bmlUtility.LogNotification("Updated internal configuration for " + GetModVersion(), true)
EndFunction

Event OnConfigInit()
	sellerList = new string[3]
	sellerList[0] = "$LPO_SellerList0"
	sellerList[1] = "$LPO_SellerList1"
	sellerList[2] = "$LPO_SellerList2"

	ddFilterList = new string[4]
	ddFilterList[0] = "$LPO_ddFilterList0"
	ddFilterList[1] = "$LPO_ddFilterList1"
	ddFilterList[2] = "$LPO_ddFilterList2"
	ddFilterList[3] = "$LPO_ddFilterList3"

	NullifyMagickaSourceList = new string[3]
	NullifyMagickaSourceList[0] = "$LPO_NullifyMagickaSourceList0"
	NullifyMagickaSourceList[1] = "$LPO_NullifyMagickaSourceList1"
	NullifyMagickaSourceList[2] = "$LPO_NullifyMagickaSourceList2"

	BikiniLicenseFeatureState = new string[3]
	BikiniLicenseFeatureState[0] = "$LPO_BikiniLicenseFeatureState0"
	BikiniLicenseFeatureState[1] = "$LPO_BikiniLicenseFeatureState1"
	BikiniLicenseFeatureState[2] = "$LPO_BikiniLicenseFeatureState2"

	ModVersionCache = PapyrusUtil.StringSplit(GetModVersion(), ".")
	if JsonExists(config)
		Load(config)
	endIf
	if CurrentVersion == 0
		bmlUtility.LogNotification("Installed Licenses " + GetModVersion(), true)
		bmlUtility.LogTrace("Installed Licenses " + GetModVersion(), true)
		if Licenses_State.GetValue() == 0 && GetIntValue(config, "!!doautostart") == 1
			GoToState("AutoStartST")
		endIf
	endIf
EndEvent

Event OnConfigOpen()
	UnregisterForUpdate()
	GoToState("")

	SessionModified = false
	if Licenses_State.GetValue() == 1
		Pages = new string[8]
		Pages[0] = "$LPO_Pages0"
		Pages[1] = "$LPO_Pages1"
		Pages[2] = "$LPO_Pages2"
		Pages[3] = "$LPO_Pages3"
		Pages[4] = "$LPO_Pages4"
		Pages[5] = "$LPO_Pages5"
		Pages[6] = "$LPO_Pages6"
		Pages[7] = "$LPO_Pages7"
	else
		Pages = new string[1]
		Pages[0] = "$LPO_Pages0"
	endIf
EndEvent

Event OnConfigClose()
	if SessionModified && Licenses_State.GetValue() == 1
		SessionModified = false
		bmlUtility.RefreshLicenses()
	endIf
EndEvent

String Function GetModState()
	if Licenses_State.GetValue() == 1
		return "$LPO_Licenses_StateInitialized"
	elseIf Licenses_State.GetValue() == 0
		return "$LPO_Licenses_StateInitialize"
	elseIf Licenses_State.GetValue() == -1
		if bmlUtility.Licenses_CachedState
			return "$LPO_Licenses_StateTerminating"
		else
			return "$LPO_Licenses_StateInitializing"
		endIf
	else
		return "$LPO_Licenses_StateErrored" ; function default
	endIf
EndFunction

Event OnPageReset(string page)
	GoToState("")
	if Licenses_State.GetValue() != 1 || (page == "$LPO_Pages0")
		ShowPage0()
	elseIf (page == "")
		ShowPageSplash()
    elseIf (page == "$LPO_Pages1")
		ShowPage1()
    elseIf (page == "$LPO_Pages2")
		ShowPage2()
	elseIf (page == "$LPO_Pages3")
		ShowPage3()
	elseIf (page == "$LPO_Pages4")
		ShowPage4()
    elseIf (page == "$LPO_Pages5")
		ShowPage5()
	elseIf (page == "$LPO_Pages6")
		ShowPage6()
	elseIf (page == "$LPO_Pages7")
		ShowPage7()
    endIf
EndEvent

Int Function AddFeatureState(String DisplayName, Bool FeatureFlag, Bool StateFlag, Float ExpirationTime, Float CooldownTime)
	String DisplayState
	if FeatureFlag
		if StateFlag
			DisplayState = "$LPO_Valid"
		else
			DisplayState = "$LPO_Invalid"
		endIf
	elseIf (ExpirationTime != -1.0) || (CooldownTime != -1.0)
		DisplayState = "$LPO_Unnecessary"
	endIf
	if DisplayState
		AddTextOption(DisplayName, DisplayState)
		if ExpirationTime != -1.0
			AddTextOption("$LPO_ExpirationTime{" + Math.ceiling(24.0 * (ExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf CooldownTime != -1.0
			AddTextOption("$LPO_CooldownTime{" + Math.ceiling(24.0 * (CooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf
		return 1
	endIf
	return 0
EndFunction
Function ShowPageSplash()
	SetCursorFillMode(LEFT_TO_RIGHT)
	SetTitleText("$LPO_Monitor")
	AddHeaderOption("$LPO_LicenseStatuses")
	AddEmptyOption()
	Int iSplashFlag 
	iSplashFlag += AddFeatureState("$LPO_ArmorLicense", isArmorLicenseFeatureEnabled, licenses.hasArmorLicense, licenses.armorLicenseExpirationTime, licenses.armorLicenseCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_BikiniLicense", isBikiniLicenseFeatureEnabled == 1, licenses.hasBikiniLicense, licenses.bikiniLicenseExpirationTime, licenses.bikiniLicenseCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_BikiniExemption", isBikiniLicenseFeatureEnabled == 2, licenses.hasBikiniExemption, licenses.bikiniExemptionExpirationTime, licenses.bikiniExemptionCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_ClothingLicense", isClothingLicenseFeatureEnabled, licenses.hasClothingLicense, licenses.clothingLicenseExpirationTime, licenses.clothingLicenseCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_MagicLicense", isMagicLicenseFeatureEnabled, licenses.hasMagicLicense, licenses.magicLicenseExpirationTime, licenses.magicLicenseCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_WeaponLicense", isWeaponLicenseFeatureEnabled, licenses.hasWeaponLicense, licenses.weaponLicenseExpirationTime, licenses.weaponLicenseCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_CraftingLicense", isCraftingLicenseFeatureEnabled, licenses.hasCraftingLicense, licenses.craftingLicenseExpirationTime, licenses.craftingLicenseCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_TradingLicense", isTradingLicenseFeatureEnabled, licenses.hasTradingLicense, licenses.tradingLicenseExpirationTime, licenses.tradingLicenseCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_CurfewExemption", isCurfewExemptionFeatureEnabled, licenses.hasCurfewExemption, licenses.curfewExemptionExpirationTime, licenses.curfewExemptionCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_TravelPermit", isTravelPermitFeatureEnabled, licenses.hasTravelPermit, licenses.travelPermitExpirationTime, licenses.travelPermitCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_Insurance", isInsuranceFeatureEnabled, licenses.hasInsurance, licenses.insuranceExpirationTime, licenses.insuranceCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_WhoreLicense", isWhoreLicenseFeatureEnabled, licenses.hasWhoreLicense, licenses.whoreLicenseExpirationTime, licenses.whoreLicenseCooldownTime)
	iSplashFlag += AddFeatureState("$LPO_CollarExemption", isCollarExemptionFeatureEnabled, licenses.hasCollarExemption, licenses.collarExemptionExpirationTime, licenses.collarExemptionCooldownTime)
	if iSplashFlag == 0
		AddTextOption("$LPO_Splash_Empty", "", OPTION_FLAG_DISABLED)
	endIf
EndFunction
Function ShowPage0()
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetTitleText("$LPO_Pages0")
	AddHeaderOption("$LPO_Setup")
	AddTextOptionST("Licenses_StateST", "$LPO_Licenses_State", GetModState())
	AddEmptyOption()
	AddHeaderOption("$LPO_ConfigurationFile")
	AddTextOptionST("exportConfigST", "$LPO_exportConfig", "", (Licenses_State.GetValue() != 1) as int)
	AddTextOptionST("importConfigST", "$LPO_importConfig", "", (Licenses_State.GetValue() != 1) as int)
	SetCursorPosition(1)
	AddHeaderOption("")
	AddTextOption("$LPO_ModVersion", GetModVersion(), OPTION_FLAG_DISABLED)
	AddTextOption("$LPO_Version", GetVersion(), OPTION_FLAG_DISABLED)
	AddTextOption("$LPO_CacheIndexDiff1Int2", (PapyrusUtil.StringSplit(GetModVersion(), ".")[1] as int - ModVersionCache[1] as int) + "," + PapyrusUtil.StringSplit(GetModVersion(), ".")[2] as int, OPTION_FLAG_DISABLED)
	if bmlInit.CheckHardDependencies(self)
		AddTextOption("$LPO_DependencyCheck", "$LPO_Safe", OPTION_FLAG_DISABLED)
	else
		AddTextOption("$LPO_DependencyCheck", "$LPO_Failed", OPTION_FLAG_DISABLED)
	endIf
	if bmlUtility.IsExceptionState()
		AddTextOption("$LPO_ExceptionState", "$LPO_Active", OPTION_FLAG_DISABLED)
	else
		AddTextOption("$LPO_ExceptionState", "$LPO_Inactive", OPTION_FLAG_DISABLED)
	endIf
EndFunction
Function ShowPage1()
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("$LPO_BasicSettings")
	AddToggleOptionST("isKinkyDialogueFeatureEnabledST", "$LPO_isKinkyDialogueFeatureEnabled", isKinkyDialogueFeatureEnabled)
	AddToggleOptionST("isCheckIntervalFeatureEnabledST", "$LPO_isCheckIntervalFeatureEnabled", isCheckIntervalFeatureEnabled)
	AddSliderOptionST("checkIntervalST", "$LPO_checkInterval", checkInterval, "{0} second(s)", (!isCheckIntervalFeatureEnabled) as int)
	AddToggleOptionST("isCheckLOSFeatureEnabledST", "$LPO_isCheckLOSFeatureEnabled", isCheckLOSFeatureEnabled)
	AddSliderOptionST("BM_WICommentChanceST", "$LPO_BM_WICommentChance", BM_WICommentChance.GetValue(), "{0}%")
	AddEmptyOption()
	AddHeaderOption("$LPO_AdditionalSettings")
	AddMenuOptionST("licenseSellerST", "$LPO_licenseSeller", sellerList[licenseSellerFaction])
	AddSliderOptionST("LicenseEnforcerCountST", "$LPO_LicenseEnforcerCount", LicenseEnforcerCount, "{0}")
	AddSliderOptionST("LicenseLimitST", "$LPO_LicenseLimit", LicenseLimit, "{0}")
	AddSliderOptionST("LicenseCooldownST", "$LPO_LicenseCooldown", LicenseCooldown, "{0} day(s)")
	AddToggleOptionST("LicenseRenewalST", "$LPO_LicenseRenewal", LicenseRenewal)
	AddToggleOptionST("isWaterDamageEnabledST", "$LPO_isWaterDamageEnabled", isWaterDamageEnabled)
	AddToggleOptionST("thaneImmunityUniversalST", "$LPO_thaneImmunityUniversal", thaneImmunityUniversal)
	AddToggleOptionST("ValidateEquipmentTradeST", "$LPO_ValidateEquipmentTrade", ValidateEquipmentTrade)

	SetCursorPosition(1)
	AddHeaderOption("$LPO_Filters")
	AddToggleOptionST("isLimitToCityEnabledST", "$LPO_isLimitToCityEnabled", isLimitToCityEnabled)
	AddToggleOptionST("isLimitToTownEnabledST", "$LPO_isLimitToTownEnabled", isLimitToTownEnabled)
	AddToggleOptionST("isLimitToCitySpaceEnabledST", "$LPO_isLimitToCitySpaceEnabled", isLimitToCitySpaceEnabled)
	AddToggleOptionST("BM_isMaleGuardEnabledST", "$LPO_BM_isMaleGuardEnabled", BM_isMaleGuardEnabled.GetValue() as bool)
	AddToggleOptionST("BM_isFemaleGuardEnabledST", "$LPO_BM_isFemaleGuardEnabled", BM_isFemaleGuardEnabled.GetValue() as bool)
	AddEmptyOption()
	AddHeaderOption("$LPO_Punishments")
	AddSliderOptionST("FineBaseST", "$LPO_FineBase", FineBase, "{0} gold")
	AddSliderOptionST("FinePercentageST", "$LPO_FinePercentage", FinePercentage, "{1}%")
	AddToggleOptionST("fineAddsToBountyST", "$LPO_fineAddsToBounty", fineAddsToBounty)
	AddToggleOptionST("isConfiscateFeatureEnabledST", "$LPO_isConfiscateFeatureEnabled", isConfiscateFeatureEnabled)
	AddToggleOptionST("isConfiscateInventoryFeatureEnabledST", "$LPO_isConfiscateInventoryFeatureEnabled", isConfiscateInventoryFeatureEnabled, (!isConfiscateFeatureEnabled) as int)
EndFunction
Function ShowPage2()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("$LPO_ArmorLicense")
	AddTextOptionST("isArmorLicenseFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isArmorLicenseFeatureEnabled))
	AddSliderOptionST("BM_ALCostST", "$LPO_BM_ALCost", BM_ALCost.getValue(), "{0} gold")
	AddSliderOptionST("BM_ALDurationST", "$LPO_BM_ALDuration", BM_ALDuration.getValue(), "{0} day(s)")
	AddToggleOptionST("ALClothingImmunityST", "$LPO_ALClothingImmunity", ALClothingImmunity)
	AddEmptyOption()
	AddEmptyOption()
	AddEmptyOption()
	AddHeaderOption("$LPO_BikiniLicense")
	AddMenuOptionST("isBikiniLicenseFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isBikiniLicenseFeatureEnabled, isBikiniLicenseFeatureEnabled))
	AddSliderOptionST("BM_BLCostST", "$LPO_BM_BLCost", BM_BLCost.getValue(), "{0} gold")
	AddSliderOptionST("BM_BLDurationST", "$LPO_BM_BLDuration", BM_BLDuration.getValue(), "{0} day(s)")
	AddToggleOptionST("isBikiniArmorFeatureEnabledST", "$LPO_isBikiniArmorFeatureEnabled", isBikiniArmorFeatureEnabled)
	AddToggleOptionST("isBikiniClothingFeatureEnabledST", "$LPO_isBikiniClothingFeatureEnabled", isBikiniClothingFeatureEnabled)
	AddInputOptionST("bikiniKeywordStringST", "$LPO_bikiniKeywordString", "$LPO_InputModify")
	AddEmptyOption()
	AddEmptyOption()
	AddEmptyOption()
	AddHeaderOption("$LPO_ClothingLicense")
	AddTextOptionST("isClothingLicenseFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isClothingLicenseFeatureEnabled))
	AddSliderOptionST("BM_CLCostST", "$LPO_BM_CLCost", BM_CLCost.getValue(), "{0} gold")
	AddSliderOptionST("BM_CLDurationST", "$LPO_BM_CLDuration", BM_CLDuration.getValue(), "{0} day(s)")
	AddEmptyOption()
	AddEmptyOption()
	AddHeaderOption("$LPO_MagicLicense")
	AddTextOptionST("isMagicLicenseFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isMagicLicenseFeatureEnabled))
	AddSliderOptionST("BM_MLCostST", "$LPO_BM_MLCost", BM_MLCost.getValue(), "{0} gold")
	AddSliderOptionST("BM_MLDurationST", "$LPO_BM_MLDuration", BM_MLDuration.getValue(), "{0} day(s)")
	AddToggleOptionST("isEnchantedArmorFeatureEnabledST", "$LPO_isEnchantedArmorFeatureEnabled", isEnchantedArmorFeatureEnabled)
	AddToggleOptionST("isEnchantedClothingFeatureEnabledST", "$LPO_isEnchantedClothingFeatureEnabled", isEnchantedClothingFeatureEnabled)
	AddToggleOptionST("isEnchantedJewelryFeatureEnabledST", "$LPO_isEnchantedJewelryFeatureEnabled", isEnchantedJewelryFeatureEnabled)
	AddToggleOptionST("isEnchantedWeaponryFeatureEnabledST", "$LPO_isEnchantedWeaponryFeatureEnabled", isEnchantedWeaponryFeatureEnabled)
	AddMenuOptionST("NullifyMagickaSourceST", "$LPO_NullifyMagickaSource", NullifyMagickaSourceList[NullifyMagickaSource])
	AddToggleOptionST("NullifyMagickaEnforceST", "$LPO_NullifyMagickaEnforce", NullifyMagickaEnforce, (!(NullifyMagickaSource as bool)) as int)
	AddEmptyOption()
	AddEmptyOption()
	AddHeaderOption("$LPO_WeaponLicense")
	AddTextOptionST("isWeaponLicenseFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isWeaponLicenseFeatureEnabled))
	AddSliderOptionST("BM_WLCostST", "$LPO_BM_WLCost", BM_WLCost.getValue(), "{0} gold")
	AddSliderOptionST("BM_WLDurationST", "$LPO_BM_WLDuration", BM_WLDuration.getValue(), "{0} day(s)")
	AddToggleOptionST("isWeaponAmmoFeatureEnabledST", "$LPO_isWeaponAmmoFeatureEnabled", isWeaponAmmoFeatureEnabled)
EndFunction
Function ShowPage3()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("$LPO_CraftingLicense")
	AddTextOptionST("isCraftingLicenseFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isCraftingLicenseFeatureEnabled))
	AddSliderOptionST("BM_CrfLCostST", "$LPO_BM_CrfLCost", BM_CrfLCost.getValue(), "{0} gold")
	AddSliderOptionST("BM_CrfLDurationST", "$LPO_BM_CrfLDuration", BM_CrfLDuration.getValue(), "{0} day(s)")
	AddEmptyOption()
	AddEmptyOption()
	AddHeaderOption("$LPO_TradingLicense")
	AddTextOptionST("isTradingLicenseFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isTradingLicenseFeatureEnabled))
	AddSliderOptionST("BM_TLCostST", "$LPO_BM_TLCost", BM_TLCost.getValue(), "{0} gold")
	AddSliderOptionST("BM_TLDurationST", "$LPO_BM_TLDuration", BM_TLDuration.getValue(), "{0} day(s)")
	AddEmptyOption()
	AddEmptyOption()
	AddHeaderOption("$LPO_CurfewExemption")
	AddTextOptionST("isCurfewExemptionFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isCurfewExemptionFeatureEnabled))
	AddSliderOptionST("BM_CuECostST", "$LPO_BM_CuECost", BM_CuECost.getValue(), "{0} gold")
	AddSliderOptionST("BM_CuEDurationST", "$LPO_BM_CuEDuration", BM_CuEDuration.getValue(), "{0} day(s)")
	AddSliderOptionST("BM_CurfewStartST", "$LPO_BM_CurfewStart", BM_CurfewStart.getValue(), "{0}:00")
	AddSliderOptionST("BM_CurfewEndST", "$LPO_BM_CurfewEnd", BM_CurfewEnd.getValue(), "{0}:00")
	AddEmptyOption()
	AddEmptyOption()
	AddHeaderOption("$LPO_TravelPermit")
	AddTextOptionST("isTravelPermitFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isTravelPermitFeatureEnabled))
	AddSliderOptionST("BM_TPCostST", "$LPO_BM_TPCost", BM_TPCost.getValue(), "{0} gold")
	AddSliderOptionST("BM_TPDurationST", "$LPO_BM_TPDuration", BM_TPDuration.getValue(), "{0} day(s)")
	AddToggleOptionST("BM_FollowerMaleST", "$LPO_BM_FollowerMale", BM_FollowerMale.GetValue() as bool)
	AddEmptyOption()
	AddToggleOptionST("BM_FollowerFemaleST", "$LPO_BM_FollowerFemale", BM_FollowerFemale.GetValue() as bool)
	AddEmptyOption()
	AddEmptyOption()
	AddEmptyOption()
	AddHeaderOption("$LPO_Insurance")
	AddTextOptionST("isInsuranceFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isInsuranceFeatureEnabled))
	AddSliderOptionST("BM_InsurCostBaseST", "$LPO_BM_InsurCostBase", BM_InsurCostBase, "{0} gold")
	AddSliderOptionST("BM_InsurDurationST", "$LPO_BM_InsurDuration", BM_InsurDuration.getValue(), "{0} day(s)")
	AddTextOptionST("insuranceMisbehaviourMonitorST", "$LPO_MisbehaviourMultiplier", licenses.insuranceMisbehaviourMultiplier + "x")
	AddEmptyOption()
	AddTextOptionST("insurancePopularityMonitorST", "$LPO_PopularityMultiplier", licenses.insurancePopularityMultiplier + "x")
	AddEmptyOption()
	AddToggleOptionST("invertPopularityMultiplierST", "$LPO_invertPopularityMultiplier", invertPopularityMultiplier)
	AddEmptyOption()
	AddToggleOptionST("thaneImmunityInsuranceST", "$LPO_thaneImmunityInsurance", thaneImmunityInsurance)
EndFunction
Function ShowPage4()
	SetCursorFillMode(LEFT_TO_RIGHT)
	AddHeaderOption("$LPO_WhoreLicense")
	AddTextOptionST("isWhoreLicenseFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isWhoreLicenseFeatureEnabled))
	AddSliderOptionST("BM_WhLCostST", "$LPO_BM_WhLCost", BM_WhLCost.getValue(), "{0} gold")
	AddSliderOptionST("BM_WhLDurationST", "$LPO_BM_WhLDuration", BM_WhLDuration.getValue(), "{0} day(s)")
	AddEmptyOption()
	AddEmptyOption()
	AddHeaderOption("$LPO_CollarExemption")
	AddTextOptionST("isCollarExemptionFeatureEnabledST", "$LPO_FeatureState", GetBoolString(isCollarExemptionFeatureEnabled), (!DeviousDevices_State) as int)
	AddSliderOptionST("BM_CECostST", "$LPO_BM_CECost", BM_CECost.getValue(), "{0} gold", (!DeviousDevices_State) as int)
	AddSliderOptionST("BM_CEDurationST", "$LPO_BM_CEDuration", BM_CEDuration.getValue(), "{0} day(s)", (!DeviousDevices_State) as int)
EndFunction
Function ShowPage5()
	SetCursorFillMode(LEFT_TO_RIGHT)
	GoToState("SlotFilteringST")
EndFunction
Function ShowPage6()
	SetCursorFillMode(TOP_TO_BOTTOM)
	if !DeviousDevices_State && !SlaveTats_State
		AddTextOption("$LPO_Integrations_Empty", "", OPTION_FLAG_DISABLED)
	endIf

	if DeviousDevices_State
		AddHeaderOption("$LPO_DeviousDevices")
		AddToggleOptionST("equipDDOnViolationST", "$LPO_equipDDOnViolation", equipDDOnViolation)
		AddSliderOptionST("ddEquipChanceST", "$LPO_ddEquipChance", ddEquipChance, "{0}%", (!equipDDOnViolation) as int)
		AddMenuOptionST("ddFilterST", "$LPO_ddFilter", ddFilterList[ddFilter])
	endIf

	SetCursorPosition(1)

	if SlaveTats_State
		AddHeaderOption("$LPO_SlaveTats")
		AddToggleOptionST("ShowCurseTattoosST", "$LPO_ShowCurseTattoos", ShowCurseTattoos)
		AddColorOptionST("Curse_ColorST", "$LPO_Curse_Color", Curse_Color, (!ShowCurseTattoos) as int)
		AddColorOptionST("Curse_GlowST", "$LPO_Curse_Glow", Curse_Glow, (!ShowCurseTattoos) as int)
		AddSliderOptionST("Curse_AlphaST", "$LPO_Curse_Alpha", Curse_Alpha, "{1}", (!ShowCurseTattoos) as int)
		AddToggleOptionST("Curse_NeckST", "$LPO_Curse_Neck", Curse_Neck, (!ShowCurseTattoos) as int)
		AddToggleOptionST("Curse_TorsoST", "$LPO_Curse_Torso", Curse_Torso, (!ShowCurseTattoos) as int)
		AddToggleOptionST("Curse_ArmsST", "$LPO_Curse_Arms", Curse_Arms, (!ShowCurseTattoos) as int)
		AddToggleOptionST("Curse_LegsST", "$LPO_Curse_Legs", Curse_Legs, (!ShowCurseTattoos) as int)
		AddToggleOptionST("Curse_ReduceSlotUsageST", "$LPO_Curse_ReduceSlotUsage", Curse_ReduceSlotUsage, (!ShowCurseTattoos) as int)
	endIf
EndFunction
Function ShowPage7()
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("$LPO_DebugFunctions")
	AddTextOptionST("RefreshFeaturesST", "$LPO_RefreshFeatures", "")
	AddTextOptionST("RefreshStatusST", "$LPO_RefreshStatus", "")
	if SlaveTats_State
		AddTextOptionST("RefreshTattoosST", "$LPO_RefreshTattoos", "")
	endIf
	AddTextOptionST("ResetMenuST", "$LPO_ResetMenu", "")
	AddEmptyOption()
	AddHeaderOption("$LPO_AdvancedSettings")
	AddToggleOptionST("GameMessageST", "$LPO_GameMessage", GameMessage)
	AddToggleOptionST("LogNotificationST", "$LPO_LogNotification", LogNotification)
	AddToggleOptionST("LogTraceST", "$LPO_LogTrace", LogTrace)
	AddToggleOptionST("ConfigWarnST", "$LPO_ConfigWarn", ConfigWarn)
	AddToggleOptionST("allowJailQuestNodesST", "$LPO_allowJailQuestNodes", allowJailQuestNodes)
	AddSliderOptionST("standardEventDelayST", "$LPO_standardEventDelay", standardEventDelay, "{0} seconds")

	SetCursorPosition(1)
	AddHeaderOption("$LPO_HardDependencies")
	AddTextOption("$LPO_PapyrusExtender_State", PapyrusExtender_Status)
	AddTextOption("$LPO_PapyrusUtil_State", PapyrusUtil_Status)
	AddTextOption("$LPO_ScrabsPapyrusExtender_State", ScrabsPapyrusExtender_Status)
	AddEmptyOption()
	AddHeaderOption("$LPO_SoftDependencies")
	AddTextOption("$LPO_DeviousDevices_State", DeviousDevices_Status, (!DeviousDevices_State) as int)
	AddTextOption("$LPO_DeviousFollowers_State", DeviousFollowers_Status, (!DeviousFollowers_State) as int)
	AddTextOption("$LPO_PrisonOverhaulPatched_State", PrisonOverhaulPatched_Status, (!PrisonOverhaulPatched_State) as int)
	AddTextOption("$LPO_SexLabAroused_State", SexLabAroused_Status, (!SexLabAroused_State) as int)
	AddTextOption("$LPO_SlaveTats_State", SlaveTats_Status, (!SlaveTats_State) as int)
	if DeviousInterests_State || OStim_State || PrisonAlternative_State || SexLab_State || SimpleSlavery_State
		AddEmptyOption()
		AddHeaderOption("$LPO_Compatibility")
		if DeviousInterests_State
			AddTextOption("$LPO_DeviousInterests_State", DeviousInterests_Status)
		endIf
		if OStim_State
			AddTextOption("$LPO_OStim_State", OStim_Status)
		endIf
		if PrisonAlternative_State
			AddTextOption("$LPO_PrisonAlternative_State", PrisonAlternative_Status)
		endIf
		if SexLab_State
			AddTextOption("$LPO_SexLab_State", SexLab_Status)
		endIf
		if SimpleSlavery_State
			AddTextOption("$LPO_SimpleSlavery_State", SimpleSlavery_Status)
		endIf
	endIf
EndFunction

Int[] SlotFilteringOID
state SlotFilteringST
	Event OnBeginState()
		SlotFilteringOID = new Int[32]
		Int i = 0
		While i < SlotFilteringOID.Length
			SlotFilteringOID[i] = AddToggleOption("$LPO_EquipmentSlot-" + (i + 30), ArmorSlotArray[i] == (i + 30))
			Armor OccupiedItem = licenses.PlayerActorRef.GetEquippedArmorInSlot(ArmorSlotArray[i])
			if OccupiedItem && OccupiedItem.GetName() != ""
				AddTextOption("$LPO_EquipmentSlotOccupiedItem_{" + OccupiedItem.GetName() + "}", "", OPTION_FLAG_DISABLED)
			else
				AddEmptyOption()
			endIf
			i += 1
		EndWhile
	EndEvent
	Event OnOptionSelect(Int OptionID)
		Int i = SlotFilteringOID.Find(OptionID)
		if ArmorSlotArray[i]
			ArmorSlotArray[i] = 0
		else
			ArmorSlotArray[i] = i + 30
		endIf
		SetToggleOptionValue(OptionID, ArmorSlotArray[i] == (i + 30))
	EndEvent
	Event OnOptionDefault(Int OptionID)
		Int i = SlotFilteringOID.Find(OptionID)
		if i > 13
			ArmorSlotArray[i] = 0
		else
			ArmorSlotArray[i] = i + 30
		endIf
		SetToggleOptionValue(OptionID, ArmorSlotArray[i] == (i + 30))
	EndEvent
	Event OnOptionHighlight(Int OptionID)
		Int i = SlotFilteringOID.Find(OptionID)
		if i != -1
			Armor OccupiedItem = licenses.PlayerActorRef.GetEquippedArmorInSlot(ArmorSlotArray[i])
			if OccupiedItem && OccupiedItem.GetName() != "" && OccupiedItem.GetNthKeyword(0)
				SetInfoText("$LPO_EquipmentSlotHighlight_{" + OccupiedItem.GetKeywords().Length + "}")
			else
				SetInfoText("$LPO_EquipmentSlotHighlight")
			endIf
		endIf
	EndEvent
endState

State AutoStartST
	Event OnBeginState()
		RegisterForSingleUpdate(10.0)
	EndEvent
	Event OnUpdate()
		StartupLicenses()
		GoToState("")
	EndEvent
EndState

Function StartupLicenses()
	Licenses_State.SetValue(-1.0)
	bmlUtility.reset()
	bmlUtility.stop()
	while !bmlUtility.IsStopped()
		Utility.Wait(0.1)
	endWhile
	if bmlUtility.start()
		bmlUtility.Startup(GetIntValue(config, "!!doautoload") == 1)
	endIf
EndFunction

Function ShutdownLicenses()
	Licenses_State.SetValue(-1.0)
	; Remove currently held license book items
	Actor ActorRef = licenses.PlayerActorRef
	ActorRef.removeItem(bmlUtility.BM_ArmorLicense, ActorRef.getItemCount(bmlUtility.BM_ArmorLicense))
	ActorRef.removeItem(bmlUtility.BM_BikiniLicense, ActorRef.getItemCount(bmlUtility.BM_BikiniLicense))
	ActorRef.removeItem(bmlUtility.BM_BikiniExemption, ActorRef.getItemCount(bmlUtility.BM_BikiniExemption))
	ActorRef.removeItem(bmlUtility.BM_ClothingLicense, ActorRef.getItemCount(bmlUtility.BM_ClothingLicense))
	ActorRef.removeItem(bmlUtility.BM_MagicLicense, ActorRef.getItemCount(bmlUtility.BM_MagicLicense))
	ActorRef.removeItem(bmlUtility.BM_WeaponLicense, ActorRef.getItemCount(bmlUtility.BM_WeaponLicense))
	ActorRef.removeItem(bmlUtility.BM_CraftingLicense, ActorRef.getItemCount(bmlUtility.BM_CraftingLicense))
	ActorRef.removeItem(bmlUtility.BM_TradingLicense, ActorRef.getItemCount(bmlUtility.BM_TradingLicense))
	ActorRef.removeItem(bmlUtility.BM_WhoreLicense, ActorRef.getItemCount(bmlUtility.BM_WhoreLicense))
	ActorRef.removeItem(bmlUtility.BM_TravelPermit, ActorRef.getItemCount(bmlUtility.BM_TravelPermit))
	ActorRef.removeItem(bmlUtility.BM_CollarExemption, ActorRef.getItemCount(bmlUtility.BM_CollarExemption))
	ActorRef.removeItem(bmlUtility.BM_Insurance, ActorRef.getItemCount(bmlUtility.BM_Insurance))
	ActorRef.removeItem(bmlUtility.BM_CurfewExemption, ActorRef.getItemCount(bmlUtility.BM_CurfewExemption))
	; Remove Nullify Magicka
	licenses.RemoveNullifyMagicka(true)
	; shutdown
	bmlUtility.Shutdown()
EndFunction

state Licenses_StateST
    event OnSelectST()
        if Licenses_State.GetValue() == 0
			Licenses_State.SetValue(-1.0)
			SetTextOptionValueST("$LPO_Licenses_StateInitializing")
			ShowMessage("$LPO_Licenses_StateMessageInitialize1", false)
			StartupLicenses()
        elseIf Licenses_State.GetValue() == 1
			if ShowMessage("$LPO_Licenses_StateMessageShutdown1")
				Licenses_State.SetValue(-1.0)
				SetTextOptionValueST("$LPO_Licenses_StateTerminating")
				ShutdownLicenses()
				SessionModified = false
				ForcePageReset()
			endIf
        endIf
	endEvent
	event OnHighlightST()
		if Licenses_State.GetValue() == 1
			SetInfoText("$LPO_Licenses_StateHighlight")
		endIf
	endEvent
endState

state isKinkyDialogueFeatureEnabledST
	event OnSelectST()
		isKinkyDialogueFeatureEnabled = !isKinkyDialogueFeatureEnabled
		SetToggleOptionValueST(isKinkyDialogueFeatureEnabled)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isKinkyDialogueFeatureEnabledHighlight")
	endEvent
endState

state isCheckIntervalFeatureEnabledST
	event OnSelectST()
		isCheckIntervalFeatureEnabled = !isCheckIntervalFeatureEnabled
		SetOptionFlagsST((!isCheckIntervalFeatureEnabled) as int, true, "checkIntervalST")
		SetToggleOptionValueST(isCheckIntervalFeatureEnabled)
        bmlUtility.refreshIntervalCheckFeature()
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isCheckIntervalFeatureEnabledHighlight")
	endEvent
endState

state checkIntervalST
	event OnSliderOpenST()
		SetSliderDialogStartValue(checkInterval)
		SetSliderDialogDefaultValue(45.0)
		SetSliderDialogRange(30.0, 300.0)
		SetSliderDialogInterval(5.0)
	endEvent
	event OnSliderAcceptST(float value)
		checkInterval = value as int
		SetSliderOptionValueST(checkInterval, "{0} seconds")
        bmlUtility.refreshIntervalCheckFeature()
	endEvent
	event OnDefaultST()
		checkInterval = 45.0
		SetSliderOptionValueST(checkInterval, "{0} seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_checkIntervalHighlight")
	endEvent
endState

state isCheckLOSFeatureEnabledST
	event OnSelectST()
		isCheckLOSFeatureEnabled = !isCheckLOSFeatureEnabled
		SetToggleOptionValueST(isCheckLOSFeatureEnabled)
        bmlUtility.licenseDetectionQuest.stop()
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isCheckLOSFeatureEnabledHighlight")
	endEvent
endState

state LicenseEnforcerCountST
	event OnSliderOpenST()
		SetSliderDialogStartValue(LicenseEnforcerCount)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(1.0, 5.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		LicenseEnforcerCount = value as int
		SetSliderOptionValueST(LicenseEnforcerCount)
        bmlUtility.licenseDetectionQuest.stop()
	endEvent
	event OnDefaultST()
		LicenseEnforcerCount = 3.0
		SetSliderOptionValueST(LicenseEnforcerCount)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_LicenseEnforcerCountHighlight")
	endEvent
endState

state licenseSellerST
	event OnMenuOpenST()
		SetMenuDialogOptions(sellerList)
		SetMenuDialogStartIndex(licenseSellerFaction)
		SetMenuDialogDefaultIndex(1)
	endEvent
	event OnMenuAcceptST(int index)
		licenseSellerFaction = index
		SetMenuOptionValueST(sellerList[licenseSellerFaction])
		bmlUtility.refreshLicenseSeller()
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_licenseSellerHighlight")
	endEvent
endState

State exportConfigST
	Event OnSelectST()
		SetTextOptionValueST("$LPO_Processing")
		if exportConfig()
			SetTextOptionValueST("$LPO_Done")
		else
			SetTextOptionValueST("$LPO_Errored")
		endIf
	EndEvent
EndState

State importConfigST
	Event OnSelectST()
		SetTextOptionValueST("$LPO_Processing")
		if importConfig()
			SetTextOptionValueST("$LPO_Done")
		else
			SetTextOptionValueST("$LPO_Errored")
		endIf
	EndEvent
EndState

State ResetMenuST
	Event OnSelectST()
		if ShowMessage("$LPO_ResetMenuMessage1")
			SetTextOptionValueST("$LPO_Processing")
			ShowMessage("$LPO_ResetMenuMessage2", false)
			bmlUtility.ResetMCM()
		endIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("$LPO_ResetMenuHighlight")
	EndEvent
EndState

State RefreshFeaturesST
	Event OnSelectST()
		if ShowMessage("$LPO_RefreshFeaturesMessage1")
			SetTextOptionValueST("$LPO_Processing")
			bmlUtility.RefreshFeatures()
			ShowMessage("$LPO_RefreshFeaturesMessage2", false)
			SetTextOptionValueST("$LPO_Done")
		endIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("$LPO_RefreshFeaturesHighlight")
	EndEvent
EndState

State RefreshStatusST
	Event OnSelectST()
		if ShowMessage("$LPO_RefreshStatusMessage1")
			SetTextOptionValueST("$LPO_Processing")
			ShowMessage("$LPO_RefreshStatusMessage2", false)
			bmlUtility.RefreshStatus()
			bmlUtility.LogNotification("Refreshed Status.", true)
		endIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("$LPO_RefreshStatusHighlight")
	EndEvent
EndState

state standardEventDelayST
	event OnSliderOpenST()
		SetSliderDialogStartValue(standardEventDelay)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(2.0, 8.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		standardEventDelay = value as int
		SetSliderOptionValueST(standardEventDelay, "{0} seconds")
	endEvent
	event OnDefaultST()
		standardEventDelay = 2.0
		SetSliderOptionValueST(standardEventDelay, "{0} seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_standardEventDelayHighlight")
	endEvent
endState

state BM_WICommentChanceST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_WICommentChance.GetValue())
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_WICommentChance.SetValue(value)
		SetSliderOptionValueST(BM_WICommentChance.GetValue(), "{0}%")
	endEvent
	event OnDefaultST()
		BM_WICommentChance.SetValue(100.0)
		SetSliderOptionValueST(BM_WICommentChance.GetValue(), "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_BM_WICommentChanceHighlight")
	endEvent
endState

state isLimitToCityEnabledST
	event OnSelectST()
		isLimitToCityEnabled = !isLimitToCityEnabled
		SetToggleOptionValueST(isLimitToCityEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isLimitToCityEnabledHighlight")
	endEvent
endState

state isLimitToCitySpaceEnabledST
	event OnSelectST()
		isLimitToCitySpaceEnabled = !isLimitToCitySpaceEnabled
		SetToggleOptionValueST(isLimitToCitySpaceEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isLimitToCitySpaceEnabledHighlight")
	endEvent
endState

state isLimitToTownEnabledST
	event OnSelectST()
		isLimitToTownEnabled = !isLimitToTownEnabled
		SetToggleOptionValueST(isLimitToTownEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isLimitToTownEnabledHighlight")
	endEvent
endState

state ValidateEquipmentTradeST
	event OnSelectST()
		ValidateEquipmentTrade = !ValidateEquipmentTrade
		SetToggleOptionValueST(ValidateEquipmentTrade)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_ValidateEquipmentTradeHighlight")
	endEvent
endState

state BM_isMaleGuardEnabledST
	event OnSelectST()
		bool value = !(BM_isMaleGuardEnabled.GetValue() as bool)
		BM_isMaleGuardEnabled.SetValue(value as float)
		SetToggleOptionValueST(value)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_BM_isXGuardEnabledHighlight")
	endEvent
endState

state BM_isFemaleGuardEnabledST
	event OnSelectST()
		bool value = !(BM_isFemaleGuardEnabled.GetValue() as bool)
		BM_isFemaleGuardEnabled.SetValue(value as float)
		SetToggleOptionValueST(value)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_BM_isXGuardEnabledHighlight")
	endEvent
endState

state isWaterDamageEnabledST
	event OnSelectST()
		isWaterDamageEnabled = !isWaterDamageEnabled
		SetToggleOptionValueST(isWaterDamageEnabled)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isWaterDamageEnabledHighlight")
	endEvent
endState

state thaneImmunityUniversalST
	event OnSelectST()
		thaneImmunityUniversal = !thaneImmunityUniversal
		SetToggleOptionValueST(thaneImmunityUniversal)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_thaneImmunityUniversalHighlight")
	endEvent
endState

state LicenseLimitST
	event OnSliderOpenST()
		SetSliderDialogStartValue(LicenseLimit)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, licenses.LicenseBooks.Length - 1.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		LicenseLimit = value as int
		SetSliderOptionValueST(LicenseLimit, "{0}")
		bmlUtility.refreshActivationLimit()
	endEvent
	event OnDefaultST()
		LicenseLimit = 0
		SetSliderOptionValueST(LicenseLimit, "{0}")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_LicenseLimitHighlight")
	endEvent
endState

state LicenseCooldownST
	event OnSliderOpenST()
		SetSliderDialogStartValue(LicenseCooldown)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		LicenseCooldown = value
		SetSliderOptionValueST(LicenseCooldown, "{0} day(s)")
	endEvent
	event OnDefaultST()
		LicenseCooldown = 0
		SetSliderOptionValueST(LicenseCooldown, "{0} day(s)")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_LicenseCooldownHighlight")
	endEvent
endState

state LicenseRenewalST
	event OnSelectST()
		LicenseRenewal = !LicenseRenewal
		SetToggleOptionValueST(LicenseRenewal)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_LicenseRenewalHighlight")
	endEvent
endState

state GameMessageST
	event OnSelectST()
		GameMessage = !GameMessage
		SetToggleOptionValueST(GameMessage)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_GameMessageHighlight")
	endEvent
endState

state LogNotificationST
	event OnSelectST()
		LogNotification = !LogNotification
		SetToggleOptionValueST(LogNotification)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_LogNotificationHighlight")
	endEvent
endState

state LogTraceST
	event OnSelectST()
		LogTrace = !LogTrace
		SetToggleOptionValueST(LogTrace)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_LogTraceHighlight")
	endEvent
endState

state ConfigWarnST
	event OnSelectST()
		ConfigWarn = !ConfigWarn
		SetToggleOptionValueST(ConfigWarn)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_ConfigWarnHighlight")
	endEvent
endState

state allowJailQuestNodesST
	event OnSelectST()
		allowJailQuestNodes = !allowJailQuestNodes
		SetToggleOptionValueST(allowJailQuestNodes)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_allowJailQuestNodesHighlight")
	endEvent
endState

state isArmorLicenseFeatureEnabledST
	event OnSelectST()
		isArmorLicenseFeatureEnabled = !isArmorLicenseFeatureEnabled
		SetTextOptionValueST(GetBoolString(isArmorLicenseFeatureEnabled))
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isArmorLicenseFeatureEnabledHighlight")
	endEvent
endState

state BM_ALCostST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_ALCost.getValue())
		SetSliderDialogDefaultValue(2000.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_ALCost.setValue(value)
		SetSliderOptionValueST(BM_ALCost.getValue(), "{0} gold")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_ALCost.setValue(2000.0)
		SetSliderOptionValueST(BM_ALCost.getValue(), "{0} gold")
	endEvent
endState

state BM_ALDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_ALDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_ALDuration.SetValue(value)
		SetSliderOptionValueST(BM_ALDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_ALDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_ALDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state ALClothingImmunityST
	event OnSelectST()
		ALClothingImmunity = !ALClothingImmunity
		SetToggleOptionValueST(ALClothingImmunity)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_ALClothingImmunityHighlight")
	endEvent
endState

state isBikiniLicenseFeatureEnabledST
	event OnMenuOpenST()
		SetMenuDialogOptions(BikiniLicenseFeatureState)
		SetMenuDialogStartIndex(isBikiniLicenseFeatureEnabled)
		SetMenuDialogDefaultIndex(0)
	endEvent
	event OnMenuAcceptST(int index)
		if isBikiniLicenseFeatureEnabled != index
			isBikiniLicenseFeatureEnabled = index
			SessionModified = true
		endIf
		SetMenuOptionValueST(GetBoolString(isBikiniLicenseFeatureEnabled, isBikiniLicenseFeatureEnabled))
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isBikiniLicenseFeatureEnabledHighlight")
	endEvent
endState

state BM_BLCostST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_BLCost.getValue())
		SetSliderDialogDefaultValue(1250.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_BLCost.setValue(value)
		SetSliderOptionValueST(BM_BLCost.getValue(), "{0} gold")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_BLCost.setValue(1250.0)
		SetSliderOptionValueST(BM_BLCost.getValue(), "{0} gold")
	endEvent
endState

state BM_BLDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_BLDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_BLDuration.SetValue(value)
		SetSliderOptionValueST(BM_BLDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_BLDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_BLDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state isBikiniArmorFeatureEnabledST
	event OnSelectST()
		isBikiniArmorFeatureEnabled = !isBikiniArmorFeatureEnabled
		SetToggleOptionValueST(isBikiniArmorFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isBikiniArmorFeatureEnabledHighlight")
	endEvent
endState

state isBikiniClothingFeatureEnabledST
	event OnSelectST()
		isBikiniClothingFeatureEnabled = !isBikiniClothingFeatureEnabled
		SetToggleOptionValueST(isBikiniClothingFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isBikiniClothingFeatureEnabledHighlight")
	endEvent
endState

state bikiniKeywordStringST
	event OnInputOpenST()
        SetInputDialogStartText(bikiniKeywordString)
	endEvent
    event OnInputAcceptST(string value)
        bikiniKeywordString = value
		licenses.FillItemTypeArrayBikini()
		SessionModified = true
    endEvent
	event OnHighlightST()
		SetInfoText("$LPO_bikiniKeywordStringHighlight")
	endEvent
endState

state isClothingLicenseFeatureEnabledST
	event OnSelectST()
		isClothingLicenseFeatureEnabled = !isClothingLicenseFeatureEnabled
		SetTextOptionValueST(GetBoolString(isClothingLicenseFeatureEnabled))
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isClothingLicenseFeatureEnabledHighlight")
	endEvent
endState

state BM_CLCostST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_CLCost.getValue())
		SetSliderDialogDefaultValue(650.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_CLCost.setValue(value)
		SetSliderOptionValueST(BM_CLCost.getValue(), "{0} gold")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_CLCost.setValue(650.0)
		SetSliderOptionValueST(BM_CLCost.getValue(), "{0} gold")
	endEvent
endState

state BM_CLDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_CLDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_CLDuration.SetValue(value)
		SetSliderOptionValueST(BM_CLDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_CLDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_CLDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state isMagicLicenseFeatureEnabledST
	event OnSelectST()
		isMagicLicenseFeatureEnabled = !isMagicLicenseFeatureEnabled
		SetTextOptionValueST(GetBoolString(isMagicLicenseFeatureEnabled))
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isMagicLicenseFeatureEnabledHighlight")
	endEvent
endState

state BM_MLCostST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_MLCost.getValue())
		SetSliderDialogDefaultValue(1500.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_MLCost.setValue(value)
		SetSliderOptionValueST(BM_MLCost.getValue(), "{0} gold")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_MLCost.setValue(1500.0)
		SetSliderOptionValueST(BM_MLCost.getValue(), "{0} gold")
	endEvent
endState

state BM_MLDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_MLDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_MLDuration.SetValue(value)
		SetSliderOptionValueST(BM_MLDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_MLDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_MLDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state isEnchantedJewelryFeatureEnabledST
	event OnSelectST()
		isEnchantedJewelryFeatureEnabled = !isEnchantedJewelryFeatureEnabled
		SetToggleOptionValueST(isEnchantedJewelryFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isEnchantedJewelryFeatureEnabledHighlight")
	endEvent
endState

state isEnchantedClothingFeatureEnabledST
	event OnSelectST()
		isEnchantedClothingFeatureEnabled = !isEnchantedClothingFeatureEnabled
		SetToggleOptionValueST(isEnchantedClothingFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isEnchantedClothingFeatureEnabledHighlight")
	endEvent
endState

state isEnchantedArmorFeatureEnabledST
	event OnSelectST()
		isEnchantedArmorFeatureEnabled = !isEnchantedArmorFeatureEnabled
		SetToggleOptionValueST(isEnchantedArmorFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isEnchantedArmorFeatureEnabledHighlight")
	endEvent
endState

state isEnchantedWeaponryFeatureEnabledST
	event OnSelectST()
		isEnchantedWeaponryFeatureEnabled = !isEnchantedWeaponryFeatureEnabled
		SetToggleOptionValueST(isEnchantedWeaponryFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isEnchantedWeaponryFeatureEnabledHighlight")
	endEvent
endState

state NullifyMagickaSourceST
	event OnMenuOpenST()
		SetMenuDialogOptions(NullifyMagickaSourceList)
		SetMenuDialogStartIndex(NullifyMagickaSource)
		SetMenuDialogDefaultIndex(0)
	endEvent
	event OnMenuAcceptST(int index)
		NullifyMagickaSource = index
		SetOptionFlagsST((!(NullifyMagickaSource as bool)) as int, true, "NullifyMagickaEnforceST")
		SetMenuOptionValueST(NullifyMagickaSourceList[NullifyMagickaSource])
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_NullifyMagickaSourceHighlight")
	endEvent
endState

state NullifyMagickaEnforceST
	event OnSelectST()
		NullifyMagickaEnforce = !NullifyMagickaEnforce
		SetToggleOptionValueST(NullifyMagickaEnforce)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_NullifyMagickaEnforceHighlight")
	endEvent
endState

state isWeaponLicenseFeatureEnabledST
	event OnSelectST()
		isWeaponLicenseFeatureEnabled = !isWeaponLicenseFeatureEnabled
		SetTextOptionValueST(GetBoolString(isWeaponLicenseFeatureEnabled))
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isWeaponLicenseFeatureEnabledHighlight")
	endEvent
endState

state BM_WLCostST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_WLCost.getValue())
		SetSliderDialogDefaultValue(1500.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_WLCost.setValue(value)
		SetSliderOptionValueST(BM_WLCost.getValue(), "{0} gold")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_WLCost.setValue(1500.0)
		SetSliderOptionValueST(BM_WLCost.getValue(), "{0} gold")
	endEvent
endState

state BM_WLDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_WLDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_WLDuration.SetValue(value)
		SetSliderOptionValueST(BM_WLDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_WLDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_WLDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state isWeaponAmmoFeatureEnabledST
	event OnSelectST()
		isWeaponAmmoFeatureEnabled = !isWeaponAmmoFeatureEnabled
		SetToggleOptionValueST(isWeaponAmmoFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isWeaponAmmoFeatureEnabledHighlight")
	endEvent
endState

state isCraftingLicenseFeatureEnabledST
	event OnSelectST()
		isCraftingLicenseFeatureEnabled = !isCraftingLicenseFeatureEnabled
		SetTextOptionValueST(GetBoolString(isCraftingLicenseFeatureEnabled))
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isCraftingLicenseFeatureEnabledHighlight")
	endEvent
endState

state BM_CrfLCostST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_CrfLCost.getValue())
		SetSliderDialogDefaultValue(1000.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_CrfLCost.setValue(value)
		SetSliderOptionValueST(BM_CrfLCost.getValue(), "{0} gold")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_CrfLCost.setValue(1000.0)
		SetSliderOptionValueST(BM_CrfLCost.getValue(), "{0} gold")
	endEvent
endState

state BM_CrfLDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_CrfLDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_CrfLDuration.SetValue(value)
		SetSliderOptionValueST(BM_CrfLDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_CrfLDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_CrfLDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state isTradingLicenseFeatureEnabledST
	event OnSelectST()
		isTradingLicenseFeatureEnabled = !isTradingLicenseFeatureEnabled
		SetTextOptionValueST(GetBoolString(isTradingLicenseFeatureEnabled))
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isTradingLicenseFeatureEnabledHighlight")
	endEvent
endState

state BM_TLCostST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_TLCost.getValue())
		SetSliderDialogDefaultValue(1000.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_TLCost.setValue(value)
		SetSliderOptionValueST(BM_TLCost.getValue(), "{0} gold")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_TLCost.setValue(1000.0)
		SetSliderOptionValueST(BM_TLCost.getValue(), "{0} gold")
	endEvent
endState

state BM_TLDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_TLDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_TLDuration.SetValue(value)
		SetSliderOptionValueST(BM_TLDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_TLDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_TLDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state isCurfewExemptionFeatureEnabledST
	event OnSelectST()
		isCurfewExemptionFeatureEnabled = !isCurfewExemptionFeatureEnabled
		SetTextOptionValueST(GetBoolString(isCurfewExemptionFeatureEnabled))
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isCurfewExemptionFeatureEnabledHighlight")
	endEvent
endState

state BM_CuECostST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_CuECost.getValue())
		SetSliderDialogDefaultValue(1000.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_CuECost.setValue(value)
		SetSliderOptionValueST(BM_CuECost.getValue(), "{0} gold")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_CuECost.setValue(1000.0)
		SetSliderOptionValueST(BM_CuECost.getValue(), "{0} gold")
	endEvent
endState

state BM_CuEDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_CuEDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_CuEDuration.SetValue(value)
		SetSliderOptionValueST(BM_CuEDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_CuEDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_CuEDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state BM_CurfewStartST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_CurfewStart.getValue())
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(12.0, 23.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_CurfewStart.SetValue(value)
		SetSliderOptionValueST(BM_CurfewStart.GetValue(), "{0}:00")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_CurfewStart.SetValue(20.0)
		SetSliderOptionValueST(BM_CurfewStart.GetValue(), "{0}:00")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_BM_CurfewStartHighlight")
	endEvent
endState

state BM_CurfewEndST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_CurfewEnd.getValue())
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 12.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_CurfewEnd.SetValue(value)
		SetSliderOptionValueST(BM_CurfewEnd.GetValue(), "{0}:00")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_CurfewEnd.SetValue(6.0)
		SetSliderOptionValueST(BM_CurfewEnd.GetValue(), "{0}:00")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_BM_CurfewEndHighlight")
	endEvent
endState

state isWhoreLicenseFeatureEnabledST
	event OnSelectST()
		isWhoreLicenseFeatureEnabled = !isWhoreLicenseFeatureEnabled
		SetTextOptionValueST(GetBoolString(isWhoreLicenseFeatureEnabled))
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isWhoreLicenseFeatureEnabledHighlight")
	endEvent
endState

state BM_WhLCostST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_WhLCost.getValue())
		SetSliderDialogDefaultValue(500.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_WhLCost.setValue(value)
		SetSliderOptionValueST(BM_WhLCost.getValue(), "{0} gold")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_WhLCost.setValue(500.0)
		SetSliderOptionValueST(BM_WhLCost.getValue(), "{0} gold")
	endEvent
endState

state BM_WhLDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_WhLDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_WhLDuration.SetValue(value)
		SetSliderOptionValueST(BM_WhLDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_WhLDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_WhLDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state isTravelPermitFeatureEnabledST
	event OnSelectST()
		isTravelPermitFeatureEnabled = !isTravelPermitFeatureEnabled
		SetTextOptionValueST(GetBoolString(isTravelPermitFeatureEnabled))
		if !isTravelPermitFeatureEnabled
			bmlUtility.savedLoc = None
			bmlUtility.savedSpace = None
			licenses.isTravelViolation = false
		endIf
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isTravelPermitFeatureEnabledHighlight")
	endEvent
endState

state BM_TPCostST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_TPCost.getValue())
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_TPCost.setValue(value)
		SetSliderOptionValueST(BM_TPCost.getValue(), "{0} gold")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_TPCost.setValue(100.0)
		SetSliderOptionValueST(BM_TPCost.getValue(), "{0} gold")
	endEvent
endState

state BM_TPDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_TPDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_TPDuration.SetValue(value)
		SetSliderOptionValueST(BM_TPDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_TPDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_TPDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state BM_FollowerMaleST
	event OnSelectST()
		bool value = !(BM_FollowerMale.GetValue() as bool)
		BM_FollowerMale.SetValue(value as float)
		SetToggleOptionValueST(value)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_BM_FollowerMaleHighlight")
	endEvent
endState

state BM_FollowerFemaleST
	event OnSelectST()
		bool value = !(BM_FollowerFemale.GetValue() as bool)
		BM_FollowerFemale.SetValue(value as float)
		SetToggleOptionValueST(value)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_BM_FollowerFemaleHighlight")
	endEvent
endState

state isCollarExemptionFeatureEnabledST
	event OnSelectST()
		isCollarExemptionFeatureEnabled = !isCollarExemptionFeatureEnabled
		SetTextOptionValueST(GetBoolString(isCollarExemptionFeatureEnabled))
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isCollarExemptionFeatureEnabledHighlight")
	endEvent
endState

state BM_CECostST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_CECost.getValue())
		SetSliderDialogDefaultValue(3500.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_CECost.setValue(value)
		SetSliderOptionValueST(BM_CECost.getValue(), "{0} gold")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_CECost.setValue(3500.0)
		SetSliderOptionValueST(BM_CECost.getValue(), "{0} gold")
	endEvent
endState

state BM_CEDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_CEDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_CEDuration.SetValue(value)
		SetSliderOptionValueST(BM_CEDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_CEDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_CEDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state isInsuranceFeatureEnabledST
	event OnSelectST()
		isInsuranceFeatureEnabled = !isInsuranceFeatureEnabled
		SetTextOptionValueST(GetBoolString(isInsuranceFeatureEnabled))
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isInsuranceFeatureEnabledHighlight")
	endEvent
endState

state BM_InsurCostBaseST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_InsurCostBase)
		SetSliderDialogDefaultValue(3500.0)
		SetSliderDialogRange(0.0, 10000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_InsurCostBase = value
		SetSliderOptionValueST(BM_InsurCostBase, "{0} gold")
		BM_InsurCost.setValue(BM_InsurCostBase * licenses.insuranceMisbehaviourMultiplier * licenses.insurancePopularityMultiplier)
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_InsurCostBase = 3500.0
		BM_InsurCost.setValue(BM_InsurCostBase)
		SetSliderOptionValueST(BM_InsurCostBase, "{0} gold")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_BM_InsurCostBaseHighlight")
	endEvent
endState

state BM_InsurDurationST
	event OnSliderOpenST()
		SetSliderDialogStartValue(BM_InsurDuration.getValue())
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(1.0, 60.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		BM_InsurDuration.SetValue(value)
		SetSliderOptionValueST(BM_InsurDuration.GetValue(), "{0} day(s)")
        updateGlobals()
	endEvent
	event OnDefaultST()
		BM_InsurDuration.SetValue(5.0)
		SetSliderOptionValueST(BM_InsurDuration.GetValue(), "{0} day(s)")
	endEvent
endState

state insuranceMisbehaviourMonitorST
	event OnHighlightST()
		SetInfoText("$LPO_insuranceMisbehaviourMonitorHighlight")
	endEvent
endState

state insurancePopularityMonitorST
	event OnHighlightST()
		SetInfoText("$LPO_insurancePopularityMonitorHighlight")
	endEvent
endState

state invertPopularityMultiplierST
	event OnSelectST()
		invertPopularityMultiplier = !invertPopularityMultiplier
		SetToggleOptionValueST(invertPopularityMultiplier)
		bmlUtility.refreshPopularityModifier()
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_invertPopularityMultiplierHighlight")
	endEvent
endState

state thaneImmunityInsuranceST
	event OnSelectST()
		thaneImmunityInsurance = !thaneImmunityInsurance
		SetToggleOptionValueST(thaneImmunityInsurance)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_thaneImmunityInsuranceHighlight")
	endEvent
endState

state FineBaseST
	event OnSliderOpenST()
		SetSliderDialogStartValue(FineBase)
		SetSliderDialogDefaultValue(250.0)
		SetSliderDialogRange(0.0, 1000.0)
		SetSliderDialogInterval(25.0)
	endEvent
	event OnSliderAcceptST(float value)
		FineBase = value as int
		SetSliderOptionValueST(FineBase, "{0} gold")
		updateGlobals()
	endEvent
	event OnDefaultST()
		FineBase = 250
		SetSliderOptionValueST(FineBase, "{0} gold")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_FineBaseHighlight")
	endEvent
endState

state FinePercentageST
	event OnSliderOpenST()
		SetSliderDialogStartValue(FinePercentage)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	endEvent
	event OnSliderAcceptST(float value)
		FinePercentage = value
		SetSliderOptionValueST(FinePercentage, "{1}%")
		updateGlobals()
	endEvent
	event OnDefaultST()
		FinePercentage = 25.0
		SetSliderOptionValueST(FinePercentage, "{1}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_FinePercentageHighlight")
	endEvent
endState

state fineAddsToBountyST
	event OnSelectST()
		fineAddsToBounty = !fineAddsToBounty
		SetToggleOptionValueST(fineAddsToBounty)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_fineAddsToBountyHighlight")
	endEvent
endState

state isConfiscateFeatureEnabledST
	event OnSelectST()
		isConfiscateFeatureEnabled = !isConfiscateFeatureEnabled
		SetOptionFlagsST((!isConfiscateFeatureEnabled) as int, true, "isConfiscateInventoryFeatureEnabledST")
		SetToggleOptionValueST(isConfiscateFeatureEnabled)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isConfiscateFeatureEnabledHighlight")
	endEvent
endState

state isConfiscateInventoryFeatureEnabledST
	event OnSelectST()
		isConfiscateInventoryFeatureEnabled = !isConfiscateInventoryFeatureEnabled
		SetToggleOptionValueST(isConfiscateInventoryFeatureEnabled)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_isConfiscateInventoryFeatureEnabledHighlight")
	endEvent
endState

state equipDDOnViolationST
	event OnSelectST()
		equipDDOnViolation = !equipDDOnViolation
		SetOptionFlagsST((!equipDDOnViolation) as int, true, "ddEquipChanceST")
		SetToggleOptionValueST(equipDDOnViolation)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_equipDDOnViolationHighlight")
	endEvent
endState

state ddEquipChanceST
	event OnSliderOpenST()
		SetSliderDialogStartValue(ddEquipChance)
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		ddEquipChance = value as int
		SetSliderOptionValueST(ddEquipChance, "{0}%")
	endEvent
	event OnDefaultST()
		ddEquipChance = 50
		SetSliderOptionValueST(ddEquipChance, "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_ddEquipChanceHighlight")
	endEvent
endState

state ddFilterST
	event OnMenuOpenST()
		SetMenuDialogOptions(ddFilterList)
		SetMenuDialogStartIndex(ddFilter)
		SetMenuDialogDefaultIndex(0)
	endEvent
	event OnMenuAcceptST(int index)
		ddFilter = index
		SetMenuOptionValueST(ddFilterList[ddFilter])
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_ddFilterHighlight")
	endEvent
EndState

state ShowCurseTattoosST
	event OnSelectST()
		ShowCurseTattoos = !ShowCurseTattoos
		SetOptionFlagsST((!ShowCurseTattoos) as int, true, "Curse_ColorST")
		SetOptionFlagsST((!ShowCurseTattoos) as int, true, "Curse_GlowST")
		SetOptionFlagsST((!ShowCurseTattoos) as int, true, "Curse_AlphaST")
		SetOptionFlagsST((!ShowCurseTattoos) as int, true, "Curse_NeckST")
		SetOptionFlagsST((!ShowCurseTattoos) as int, true, "Curse_TorsoST")
		SetOptionFlagsST((!ShowCurseTattoos) as int, true, "Curse_ArmsST")
		SetOptionFlagsST((!ShowCurseTattoos) as int, true, "Curse_LegsST")
		SetOptionFlagsST((!ShowCurseTattoos) as int, false, "Curse_ReduceSlotUsageST")
		SetToggleOptionValueST(ShowCurseTattoos)
	endEvent
endState

state Curse_ColorST
	event OnColorOpenST()
        SetColorDialogStartColor(Curse_Color)
		SetColorDialogDefaultColor(0x99FFFF)
	endEvent
    event OnColorAcceptST(int value)
        Curse_Color = value
		SetColorOptionValueST(Curse_Color)
    endEvent
	event OnDefaultST()
		Curse_Color = 0x99FFFF
		SetColorOptionValueST(Curse_Color)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_Curse_ColorHighlight")
	endEvent
endState

state Curse_GlowST
	event OnColorOpenST()
        SetColorDialogStartColor(Curse_Glow)
		SetColorDialogDefaultColor(0x007A87)
	endEvent
    event OnColorAcceptST(int value)
        Curse_Glow = value
		SetColorOptionValueST(Curse_Glow)
    endEvent
	event OnDefaultST()
		Curse_Glow = 0x007A87
		SetColorOptionValueST(Curse_Glow)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_Curse_GlowHighlight")
	endEvent
endState

state Curse_AlphaST
	event OnSliderOpenST()
		SetSliderDialogStartValue(Curse_Alpha)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.1)
	endEvent
	event OnSliderAcceptST(float value)
		Curse_Alpha = value
		SetSliderOptionValueST(Curse_Alpha, "{1}")
	endEvent
	event OnDefaultST()
		Curse_Alpha = 100
		SetSliderOptionValueST(Curse_Alpha, "{1}")
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_Curse_AlphaHighlight")
	endEvent
endState

state Curse_NeckST
	event OnSelectST()
		Curse_Neck = !Curse_Neck
		SetToggleOptionValueST(Curse_Neck)
		licenses.PopulateCursedTattoosArray()
	endEvent
endState

state Curse_TorsoST
	event OnSelectST()
		Curse_Torso = !Curse_Torso
		SetToggleOptionValueST(Curse_Torso)
		licenses.PopulateCursedTattoosArray()
	endEvent
endState

state Curse_ArmsST
	event OnSelectST()
		Curse_Arms = !Curse_Arms
		SetToggleOptionValueST(Curse_Arms)
		licenses.PopulateCursedTattoosArray()
	endEvent
endState

state Curse_LegsST
	event OnSelectST()
		Curse_Legs = !Curse_Legs
		SetToggleOptionValueST(Curse_Legs)
		licenses.PopulateCursedTattoosArray()
	endEvent
endState

state Curse_ReduceSlotUsageST
	event OnSelectST()
		Curse_ReduceSlotUsage = !Curse_ReduceSlotUsage
		SetToggleOptionValueST(Curse_ReduceSlotUsage)
		licenses.PopulateCursedTattoosArray()
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_Curse_ReduceSlotUsageHighlight")
	endEvent
endState

state RefreshTattoosST
	event OnSelectST()
		SetTextOptionValueST("$LPO_Processing")
		ShowMessage("$LPO_RefreshTattoosMessage1", false)
		bmlUtility.RefreshTattoos()
		bmlUtility.LogNotification("Refreshed tattoos.", true)
	endEvent
	event OnHighlightST()
		SetInfoText("$LPO_RefreshTattoosHighlight")
	endEvent
endState

String Function GetBoolString(Bool varb, String id = "")
	if varb
		if id
			return "$LPO_Enabled{" + id + "}"
		endIf
		return "$LPO_Enabled"
	else
		return "$LPO_Disabled"
	endIf
EndFunction

Function updateGlobals()
    licenses.UpdateCurrentInstanceGlobal(BM_ALCost)
    licenses.UpdateCurrentInstanceGlobal(BM_BLCost)
    licenses.UpdateCurrentInstanceGlobal(BM_CLCost)
    licenses.UpdateCurrentInstanceGlobal(BM_MLCost)
    licenses.UpdateCurrentInstanceGlobal(BM_WLCost)
	licenses.UpdateCurrentInstanceGlobal(BM_CrfLCost)
	licenses.UpdateCurrentInstanceGlobal(BM_TLCost)
	licenses.UpdateCurrentInstanceGlobal(BM_WhLCost)
	licenses.UpdateCurrentInstanceGlobal(BM_TPCost)
	licenses.UpdateCurrentInstanceGlobal(BM_CECost)
	licenses.UpdateCurrentInstanceGlobal(BM_InsurCost)
	licenses.UpdateCurrentInstanceGlobal(BM_CuECost)
EndFunction

Bool Function exportConfig()
	; Check config state
	if JsonExists(config)
		if IsPendingSave(config)
			if !ShowMessage("$LPO_ExportConfigMessage1")
				return false
			endIf
		else
			if !ShowMessage("$LPO_ExportConfigMessage2")
				return false
			endIf
		endIf
	endIf
			
	; Set safety values
	SetStringValue(config, "Mod Name", GetModName())
	SetStringValue(config, "Mod Version", GetModVersion())
	SetIntValue(config, "Mod Config Version", GetVersion())

	; General - Basic Settings
	SetIntValue(config, "isKinkyDialogueFeatureEnabled", isKinkyDialogueFeatureEnabled as int)
	SetIntValue(config, "isCheckIntervalFeatureEnabled", isCheckIntervalFeatureEnabled as int)
	SetFloatValue(config, "checkInterval", checkInterval)
	SetIntValue(config, "isCheckLOSFeatureEnabled", isCheckLOSFeatureEnabled as int)
	SetFloatValue(config, "BM_WICommentChance", BM_WICommentChance.GetValue())

	; General - Additional Settings
	SetIntValue(config, "licenseSellerFaction", licenseSellerFaction)
	SetFloatValue(config, "LicenseEnforcerCount", LicenseEnforcerCount)
	SetIntValue(config, "LicenseLimit", LicenseLimit)
	SetFloatValue(config, "LicenseCooldown", LicenseCooldown)
	SetIntValue(config, "LicenseRenewal", LicenseRenewal as int)
	SetIntValue(config, "isWaterDamageEnabled", isWaterDamageEnabled as int)
	SetIntValue(config, "thaneImmunityUniversal", thaneImmunityUniversal as int)
	SetIntValue(config, "ValidateEquipmentTrade", ValidateEquipmentTrade as int)

	; General - Filters
	SetIntValue(config, "isLimitToCityEnabled", isLimitToCityEnabled as int)
	SetIntValue(config, "isLimitToTownEnabled", isLimitToTownEnabled as int)
	SetIntValue(config, "isLimitToCitySpaceEnabled", isLimitToCitySpaceEnabled as int)
	SetFloatValue(config, "BM_isMaleGuardEnabled", BM_isMaleGuardEnabled.GetValue())
	SetFloatValue(config, "BM_isFemaleGuardEnabled", BM_isFemaleGuardEnabled.GetValue())

	; General - Punishments
	SetIntValue(config, "FineBase", FineBase)
	SetFloatValue(config, "FinePercentage", FinePercentage)
	SetIntValue(config, "fineAddsToBounty", fineAddsToBounty as int)
	SetIntValue(config, "isConfiscateFeatureEnabled", isConfiscateFeatureEnabled as int)
	SetIntValue(config, "isConfiscateInventoryFeatureEnabled", isConfiscateInventoryFeatureEnabled as int)

	; Primary Licenses
	SetIntValue(config, "isArmorLicenseFeatureEnabled", isArmorLicenseFeatureEnabled as int)
	SetFloatValue(config, "BM_ALCost", BM_ALCost.getValue())
	SetFloatValue(config, "BM_ALDuration", BM_ALDuration.getValue())
	SetIntValue(config, "ALClothingImmunity", ALClothingImmunity as int)
	SetIntValue(config, "isBikiniLicenseFeatureEnabled", isBikiniLicenseFeatureEnabled as int)
	SetFloatValue(config, "BM_BLCost", BM_BLCost.getValue())
	SetFloatValue(config, "BM_BLDuration", BM_BLDuration.getValue())
	SetIntValue(config, "isBikiniArmorFeatureEnabled", isBikiniArmorFeatureEnabled as int)
	SetIntValue(config, "isBikiniClothingFeatureEnabled", isBikiniClothingFeatureEnabled as int)
	SetStringValue(config, "bikiniKeywordString", bikiniKeywordString)
	SetIntValue(config, "isClothingLicenseFeatureEnabled", isClothingLicenseFeatureEnabled as int)
	SetFloatValue(config, "BM_CLCost", BM_CLCost.getValue())
	SetFloatValue(config, "BM_CLDuration", BM_CLDuration.getValue())
	SetIntValue(config, "isMagicLicenseFeatureEnabled", isMagicLicenseFeatureEnabled as int)
	SetFloatValue(config, "BM_MLCost", BM_MLCost.getValue())
	SetFloatValue(config, "BM_MLDuration", BM_MLDuration.getValue())
	SetIntValue(config, "isEnchantedArmorFeatureEnabled", isEnchantedArmorFeatureEnabled as int)
	SetIntValue(config, "isEnchantedClothingFeatureEnabled", isEnchantedClothingFeatureEnabled as int)
	SetIntValue(config, "isEnchantedJewelryFeatureEnabled", isEnchantedJewelryFeatureEnabled as int)
	SetIntValue(config, "isEnchantedWeaponryFeatureEnabled", isEnchantedWeaponryFeatureEnabled as int)
	SetIntValue(config, "NullifyMagickaSource", NullifyMagickaSource)
	SetIntValue(config, "NullifyMagickaEnforce", NullifyMagickaEnforce as int)
	SetIntValue(config, "isWeaponLicenseFeatureEnabled", isWeaponLicenseFeatureEnabled as int)
	SetFloatValue(config, "BM_WLCost", BM_WLCost.getValue())
	SetFloatValue(config, "BM_WLDuration", BM_WLDuration.getValue())
	SetIntValue(config, "isWeaponAmmoFeatureEnabled", isWeaponAmmoFeatureEnabled as int)

	; Secondary Licenses
	SetIntValue(config, "isCraftingLicenseFeatureEnabled", isCraftingLicenseFeatureEnabled as int)
	SetFloatValue(config, "BM_CrfLCost", BM_CrfLCost.getValue())
	SetFloatValue(config, "BM_CrfLDuration", BM_CrfLDuration.getValue())
	SetIntValue(config, "isTradingLicenseFeatureEnabled", isTradingLicenseFeatureEnabled as int)
	SetFloatValue(config, "BM_TLCost", BM_TLCost.getValue())
	SetFloatValue(config, "BM_TLDuration", BM_TLDuration.getValue())
	SetIntValue(config, "isCurfewExemptionFeatureEnabled", isCurfewExemptionFeatureEnabled as int)
	SetFloatValue(config, "BM_CuECost", BM_CuECost.getValue())
	SetFloatValue(config, "BM_CuEDuration", BM_CuEDuration.getValue())
	SetFloatValue(config, "BM_CurfewStart", BM_CurfewStart.getValue())
	SetFloatValue(config, "BM_CurfewEnd", BM_CurfewEnd.getValue())
	SetIntValue(config, "isTravelPermitFeatureEnabled", isTravelPermitFeatureEnabled as int)
	SetFloatValue(config, "BM_TPCost", BM_TPCost.getValue())
	SetFloatValue(config, "BM_TPDuration", BM_TPDuration.getValue())
	SetFloatValue(config, "BM_FollowerMale", BM_FollowerMale.GetValue())
	SetFloatValue(config, "BM_FollowerFemale", BM_FollowerFemale.GetValue())
	SetIntValue(config, "isInsuranceFeatureEnabled", isInsuranceFeatureEnabled as int)
	SetFloatValue(config, "BM_InsurCostBase", BM_InsurCostBase)
	SetFloatValue(config, "BM_InsurDuration", BM_InsurDuration.getValue())
	SetIntValue(config, "invertPopularityMultiplier", invertPopularityMultiplier as int)
	SetIntValue(config, "thaneImmunityInsurance", thaneImmunityInsurance as int)

	; Tertiary Licenses
	SetIntValue(config, "isWhoreLicenseFeatureEnabled", isWhoreLicenseFeatureEnabled as int)
	SetFloatValue(config, "BM_WhLCost", BM_WhLCost.getValue())
	SetFloatValue(config, "BM_WhLDuration", BM_WhLDuration.getValue())
	SetIntValue(config, "isCollarExemptionFeatureEnabled", isCollarExemptionFeatureEnabled as int)
	SetFloatValue(config, "BM_CECost", BM_CECost.getValue())
	SetFloatValue(config, "BM_CEDuration", BM_CEDuration.getValue())

	; Slot Filtering
	IntListCopy(config, "ArmorSlotArray", ArmorSlotArray)

	; Integrations - Devious Devices
	SetIntValue(config, "equipDDOnViolation", equipDDOnViolation as int)
	SetIntValue(config, "ddEquipChance", ddEquipChance)
	SetIntValue(config, "ddFilter", ddFilter)

	; Integrations - SlaveTats
	SetIntValue(config, "ShowCurseTattoos", ShowCurseTattoos as int)
	SetIntValue(config, "Curse_Color", Curse_Color)
	SetIntValue(config, "Curse_Glow", Curse_Glow)
	SetFloatValue(config, "Curse_Alpha", Curse_Alpha)
	SetIntValue(config, "Curse_Neck", Curse_Neck as int)
	SetIntValue(config, "Curse_Torso", Curse_Torso as int)
	SetIntValue(config, "Curse_Arms", Curse_Arms as int)
	SetIntValue(config, "Curse_Legs", Curse_Legs as int)
	SetIntValue(config, "Curse_ReduceSlotUsage", Curse_ReduceSlotUsage as int)

	; Auxiliary - Advanced Settings
	SetIntValue(config, "GameMessage", GameMessage as int)
	SetIntValue(config, "LogNotification", LogNotification as int)
	SetIntValue(config, "LogTrace", LogTrace as int)
	SetIntValue(config, "ConfigWarn", ConfigWarn as int)
	SetIntValue(config, "allowJailQuestNodes", allowJailQuestNodes as int)
	SetFloatValue(config, "standardEventDelay", standardEventDelay)

	Save(config)
	ShowMessage("$LPO_ExportConfigMessage3", false)
	return true
EndFunction

Bool Function importConfig(Bool abSilent = false)
	; Check config health
	bool IgnoredWarning = false
	if !abSilent
		if !(Load(config) && IsGood(config) && GetStringValue(config, "Mod Name") == GetModName() )
			ShowMessage("$LPO_ImportConfigMessageError1", false)
			return false
		endIf
		if GetVersion() != GetIntValue(config, "Mod Config Version") && GetModVersion() == GetStringValue(config, "Mod Version")
			ShowMessage("$LPO_ImportConfigMessageError2_{" + GetModVersion() + "_" + GetVersion() + "}_{" + GetStringValue(config, "Mod Version") + "_" + GetIntValue(config, "Mod Config Version") + "}", false)
			return false
		endIf
		if GetModVersion() != GetStringValue(config, "Mod Version")
			if ShowMessage("$LPO_ImportConfigMessage1")
				ShowMessage("$LPO_ImportConfigMessageError3_{" + GetModVersion() + "}_{" + GetStringValue(config, "Mod Version") + "}", false)
				return false
			endIf
			IgnoredWarning = true
		endIf
		if GetVersion() > GetIntValue(config, "Mod Config Version")
			if ShowMessage("$LPO_ImportConfigMessage2")
				ShowMessage("$LPO_ImportConfigMessageError4_{" + GetVersion() + "}_{" + GetIntValue(config, "Mod Config Version") + "}", false)
				return false
			endIf
			IgnoredWarning = true
		elseIf GetVersion() < GetIntValue(config, "Mod Config Version")
			if ShowMessage("$LPO_ImportConfigMessage3")
				ShowMessage("$LPO_ImportConfigMessageError5_{" + GetVersion() + "}_{" + GetIntValue(config, "Mod Config Version") + "}", false)
				return false
			endIf
			IgnoredWarning = true
		endIf
	endIf

	; General - Basic Settings
	isKinkyDialogueFeatureEnabled = GetIntValue(config, "isKinkyDialogueFeatureEnabled", isKinkyDialogueFeatureEnabled as int) as Bool
	isCheckIntervalFeatureEnabled = GetIntValue(config, "isCheckIntervalFeatureEnabled", isCheckIntervalFeatureEnabled as int) as Bool
	checkInterval = GetFloatValue(config, "checkInterval", checkInterval)
	isCheckLOSFeatureEnabled = GetIntValue(config, "isCheckLOSFeatureEnabled", isCheckLOSFeatureEnabled as int) as Bool
	BM_WICommentChance.SetValue(GetFloatValue(config, "BM_WICommentChance", BM_WICommentChance.GetValue()))

	; General - Additional Settings
	licenseSellerFaction = GetIntValue(config, "licenseSellerFaction", licenseSellerFaction)
	LicenseEnforcerCount = GetFloatValue(config, "LicenseEnforcerCount", LicenseEnforcerCount)
	LicenseLimit = GetIntValue(config, "LicenseLimit", LicenseLimit)
	LicenseCooldown = GetFloatValue(config, "LicenseCooldown", LicenseCooldown)
	LicenseRenewal = GetIntValue(config, "LicenseRenewal", LicenseRenewal as int) as Bool
	isWaterDamageEnabled = GetIntValue(config, "isWaterDamageEnabled", isWaterDamageEnabled as int) as Bool
	thaneImmunityUniversal = GetIntValue(config, "thaneImmunityUniversal", thaneImmunityUniversal as int) as Bool
	ValidateEquipmentTrade = GetIntValue(config, "ValidateEquipmentTrade", ValidateEquipmentTrade as int) as Bool

	; General - Filters
	isLimitToCityEnabled = GetIntValue(config, "isLimitToCityEnabled", isLimitToCityEnabled as int) as Bool
	isLimitToTownEnabled = GetIntValue(config, "isLimitToTownEnabled", isLimitToTownEnabled as int) as Bool
	isLimitToCitySpaceEnabled = GetIntValue(config, "isLimitToCitySpaceEnabled", isLimitToCitySpaceEnabled as int) as Bool
	BM_isMaleGuardEnabled.SetValue(GetFloatValue(config, "BM_isMaleGuardEnabled", BM_isMaleGuardEnabled.GetValue()))
	BM_isFemaleGuardEnabled.SetValue(GetFloatValue(config, "BM_isFemaleGuardEnabled", BM_isFemaleGuardEnabled.GetValue()))

	; General - Punishments
	FineBase = GetIntValue(config, "FineBase", FineBase)
	FinePercentage = GetFloatValue(config, "FinePercentage", FinePercentage)
	fineAddsToBounty = GetIntValue(config, "fineAddsToBounty", fineAddsToBounty as int) as Bool
	isConfiscateFeatureEnabled = GetIntValue(config, "isConfiscateFeatureEnabled", isConfiscateFeatureEnabled as int) as Bool
	isConfiscateInventoryFeatureEnabled = GetIntValue(config, "isConfiscateInventoryFeatureEnabled", isConfiscateInventoryFeatureEnabled as int) as Bool

	; Primary Licenses
	isArmorLicenseFeatureEnabled = GetIntValue(config, "isArmorLicenseFeatureEnabled", isArmorLicenseFeatureEnabled as int) as Bool
	BM_ALCost.SetValue(GetFloatValue(config, "BM_ALCost", BM_ALCost.getValue()))
	BM_ALDuration.SetValue(GetFloatValue(config, "BM_ALDuration", BM_ALDuration.getValue()))
	ALClothingImmunity = GetIntValue(config, "ALClothingImmunity", ALClothingImmunity as int) as Bool
	isBikiniLicenseFeatureEnabled = GetIntValue(config, "isBikiniLicenseFeatureEnabled", isBikiniLicenseFeatureEnabled)
	BM_BLCost.SetValue(GetFloatValue(config, "BM_BLCost", BM_BLCost.getValue()))
	BM_BLDuration.SetValue(GetFloatValue(config, "BM_BLDuration", BM_BLDuration.getValue()))
	isBikiniArmorFeatureEnabled = GetIntValue(config, "isBikiniArmorFeatureEnabled", isBikiniArmorFeatureEnabled as int) as Bool
	isBikiniClothingFeatureEnabled = GetIntValue(config, "isBikiniClothingFeatureEnabled", isBikiniClothingFeatureEnabled as int) as Bool
	bikiniKeywordString = GetStringValue(config, "bikiniKeywordString", bikiniKeywordString)
	isClothingLicenseFeatureEnabled = GetIntValue(config, "isClothingLicenseFeatureEnabled", isClothingLicenseFeatureEnabled as int) as Bool
	BM_CLCost.SetValue(GetFloatValue(config, "BM_CLCost", BM_CLCost.getValue()))
	BM_CLDuration.SetValue(GetFloatValue(config, "BM_CLDuration", BM_CLDuration.getValue()))
	isMagicLicenseFeatureEnabled = GetIntValue(config, "isMagicLicenseFeatureEnabled", isMagicLicenseFeatureEnabled as int) as Bool
	BM_MLCost.SetValue(GetFloatValue(config, "BM_MLCost", BM_MLCost.getValue()))
	BM_MLDuration.SetValue(GetFloatValue(config, "BM_MLDuration", BM_MLDuration.getValue()))
	isEnchantedArmorFeatureEnabled = GetIntValue(config, "isEnchantedArmorFeatureEnabled", isEnchantedArmorFeatureEnabled as int) as Bool
	isEnchantedClothingFeatureEnabled = GetIntValue(config, "isEnchantedClothingFeatureEnabled", isEnchantedClothingFeatureEnabled as int) as Bool
	isEnchantedJewelryFeatureEnabled = GetIntValue(config, "isEnchantedJewelryFeatureEnabled", isEnchantedJewelryFeatureEnabled as int) as Bool
	isEnchantedWeaponryFeatureEnabled = GetIntValue(config, "isEnchantedWeaponryFeatureEnabled", isEnchantedWeaponryFeatureEnabled as int) as Bool
	NullifyMagickaSource = GetIntValue(config, "NullifyMagickaSource", NullifyMagickaSource)
	NullifyMagickaEnforce = GetIntValue(config, "NullifyMagickaEnforce", NullifyMagickaEnforce as int)
	isWeaponLicenseFeatureEnabled = GetIntValue(config, "isWeaponLicenseFeatureEnabled", isWeaponLicenseFeatureEnabled as int) as Bool
	BM_WLCost.SetValue(GetFloatValue(config, "BM_WLCost", BM_WLCost.getValue()))
	BM_WLDuration.SetValue(GetFloatValue(config, "BM_WLDuration", BM_WLDuration.getValue()))
	isWeaponAmmoFeatureEnabled = SetIntValue(config, "isWeaponAmmoFeatureEnabled", isWeaponAmmoFeatureEnabled as int) as Bool

	; Secondary Licenses
	isCraftingLicenseFeatureEnabled = GetIntValue(config, "isCraftingLicenseFeatureEnabled", isCraftingLicenseFeatureEnabled as int) as Bool
	BM_CrfLCost.SetValue(GetFloatValue(config, "BM_CrfLCost", BM_CrfLCost.getValue()))
	BM_CrfLDuration.SetValue(GetFloatValue(config, "BM_CrfLDuration", BM_CrfLDuration.getValue()))
	isTradingLicenseFeatureEnabled = GetIntValue(config, "isTradingLicenseFeatureEnabled", isTradingLicenseFeatureEnabled as int) as Bool
	BM_TLCost.SetValue(GetFloatValue(config, "BM_TLCost", BM_TLCost.getValue()))
	BM_TLDuration.SetValue(GetFloatValue(config, "BM_TLDuration", BM_TLDuration.getValue()))
	isCurfewExemptionFeatureEnabled = GetIntValue(config, "isCurfewExemptionFeatureEnabled", isCurfewExemptionFeatureEnabled as int) as Bool
	BM_CuECost.SetValue(GetFloatValue(config, "BM_CuECost", BM_CuECost.getValue()))
	BM_CuEDuration.SetValue(GetFloatValue(config, "BM_CuEDuration", BM_CuEDuration.getValue()))
	BM_CurfewStart.SetValue(GetFloatValue(config, "BM_CurfewStart", BM_CurfewStart.getValue()))
	BM_CurfewEnd.SetValue(GetFloatValue(config, "BM_CurfewEnd", BM_CurfewEnd.getValue()))
	isTravelPermitFeatureEnabled = GetIntValue(config, "isTravelPermitFeatureEnabled", isTravelPermitFeatureEnabled as int) as Bool
	BM_TPCost.SetValue(GetFloatValue(config, "BM_TPCost", BM_TPCost.getValue()))
	BM_TPDuration.SetValue(GetFloatValue(config, "BM_TPDuration", BM_TPDuration.getValue()))
	BM_FollowerMale.SetValue(GetFloatValue(config, "BM_FollowerMale", BM_FollowerMale.GetValue()))
	BM_FollowerFemale.SetValue(GetFloatValue(config, "BM_FollowerFemale", BM_FollowerFemale.GetValue()))
	isInsuranceFeatureEnabled = GetIntValue(config, "isInsuranceFeatureEnabled", isInsuranceFeatureEnabled as int) as Bool
	BM_InsurCostBase = GetFloatValue(config, "BM_InsurCostBase", BM_InsurCostBase)
	BM_InsurDuration.SetValue(GetFloatValue(config, "BM_InsurDuration", BM_InsurDuration.getValue()))
	invertPopularityMultiplier = GetIntValue(config, "invertPopularityMultiplier", invertPopularityMultiplier as int) as Bool
	thaneImmunityInsurance = GetIntValue(config, "thaneImmunityInsurance", thaneImmunityInsurance as int) as Bool

	; Tertiary Licenses
	isWhoreLicenseFeatureEnabled = GetIntValue(config, "isWhoreLicenseFeatureEnabled", isWhoreLicenseFeatureEnabled as int) as Bool
	BM_WhLCost.SetValue(GetFloatValue(config, "BM_WhLCost", BM_WhLCost.getValue()))
	BM_WhLDuration.SetValue(GetFloatValue(config, "BM_WhLDuration", BM_WhLDuration.getValue()))
	isCollarExemptionFeatureEnabled = GetIntValue(config, "isCollarExemptionFeatureEnabled", isCollarExemptionFeatureEnabled as int) as Bool
	BM_CECost.SetValue(GetFloatValue(config, "BM_CECost", BM_CECost.getValue()))
	BM_CEDuration.SetValue(GetFloatValue(config, "BM_CEDuration", BM_CEDuration.getValue()))

	; Slot Filtering
	ArmorSlotArray = IntListToArray(config, "ArmorSlotArray")

	; Integrations - Devious Devices
	equipDDOnViolation = GetIntValue(config, "equipDDOnViolation", equipDDOnViolation as int) as Bool
	ddEquipChance = GetIntValue(config, "ddEquipChance", ddEquipChance)
	ddFilter = GetIntValue(config, "ddFilter", ddFilter)

	; Integrations - SlaveTats
	ShowCurseTattoos = GetIntValue(config, "ShowCurseTattoos", ShowCurseTattoos as int) as Bool
	Curse_Color = GetIntValue(config, "Curse_Color", Curse_Color)
	Curse_Glow = GetIntValue(config, "Curse_Glow", Curse_Glow)
	Curse_Alpha = GetFloatValue(config, "Curse_Alpha", Curse_Alpha)
	Curse_Neck = GetIntValue(config, "Curse_Neck", Curse_Neck as int) as Bool
	Curse_Torso = GetIntValue(config, "Curse_Torso", Curse_Torso as int) as Bool
	Curse_Arms = GetIntValue(config, "Curse_Arms", Curse_Arms as int) as Bool
	Curse_Legs = GetIntValue(config, "Curse_Legs", Curse_Legs as int) as Bool
	Curse_ReduceSlotUsage = GetIntValue(config, "Curse_ReduceSlotUsage", Curse_ReduceSlotUsage as int) as Bool

	; Auxiliary - Advanced Settings
	GameMessage = GetIntValue(config, "GameMessage", GameMessage as int) as Bool
	LogNotification = GetIntValue(config, "LogNotification", LogNotification as int) as Bool
	LogTrace = GetIntValue(config, "LogTrace", LogTrace as int) as Bool
	ConfigWarn = GetIntValue(config, "ConfigWarn", ConfigWarn as int) as Bool
	allowJailQuestNodes = GetIntValue(config, "allowJailQuestNodes", allowJailQuestNodes as int) as Bool
	standardEventDelay = GetFloatValue(config, "standardEventDelay", standardEventDelay)

	; Import done
	; Activate and refresh settings
	bmlUtility.RefreshFeatures()
	updateGlobals()

	if !abSilent
		if !IgnoredWarning
			ShowMessage("$LPO_ImportConfigMessage4", false)
		else
			ShowMessage("$LPO_ImportConfigMessage5", false)
		endIf
	endIf
	Return true
EndFunction

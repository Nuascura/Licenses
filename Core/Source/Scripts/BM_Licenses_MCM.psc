Scriptname BM_Licenses_MCM extends SKI_ConfigBase conditional

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
GlobalVariable Property GameDaysPassed auto

bool Property SessionModified auto

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

bool Property isBikiniLicenseFeatureEnabled = false auto conditional
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

; Page 5 - Integrations
; Devious Devices
bool Property equipDDOnViolation = false auto
int Property ddEquipChance = 50 auto
int Property ddFilter = 1 auto
string[] ddFilterList

; SlaveTats
bool Property ShowCurseTattoos = false auto
int Property Curse_Color = 8900331 auto
int Property Curse_Glow = 27028 auto
float Property Curse_Alpha = 1.0 auto
bool Property Curse_Neck = true auto
bool Property Curse_Torso = true auto
bool Property Curse_Arms = true auto
bool Property Curse_Legs = true auto
bool Property Curse_ReduceSlotUsage = false auto
bool Property Curse_FormatOverride = false auto ; true = CBBE 3BA, false = BHUNP (UUNP)

; Page 6 - Auxiliary
; Dependency Check
; Hard dependency - PapyrusExtender
string Property PapyrusExtender_Status = "$Missing" auto
; Hard dependency - PapyrusUtil
string Property PapyrusUtil_Status = "$Missing" auto
; Hard dependency - Pyramid Utils
string Property PyramidUtils_Status = "$Missing" auto
; Soft dependency - Devious Devices - Assets.esm
; Soft dependency - Devious Devices - Expansion.esm
; Soft dependency - Devious Devices - Integration.esm
; Soft dependency - Devious Devices - Contraptions.esm
bool Property DeviousDevices_State = false auto
string Property DeviousDevices_Status = "" auto
; Soft dependency - DeviousFollowers.esp
bool Property DeviousFollowers_State = false auto
string Property DeviousFollowers_Status = "" auto
; Soft dependency - xazPrisonOverhaulPatched.esp
bool Property PrisonOverhaulPatched_State = false auto
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
bool Property PrisonAlternative_State = false auto
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

Message Property MessageConfigWarn  Auto  

string config = "../../../Interface/Licenses/Settings.json"
string[] ModVersionCache

import JsonUtil

string Function GetModName(bool cache = true)
	if cache
		return modname
	else
		return "Licenses - Player Oppression"
	endIf
EndFunction

string Function GetModVersion()
	return "1.19.0"
EndFunction

int Function GetVersion()
	return 16
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
	sellerList[0] = "$SellerList0"
	sellerList[1] = "$SellerList1"
	sellerList[2] = "$SellerList2"

	ddFilterList = new string[4]
	ddFilterList[0] = "$ddFilterList0"
	ddFilterList[1] = "$ddFilterList1"
	ddFilterList[2] = "$ddFilterList2"
	ddFilterList[3] = "$ddFilterList3"

	NullifyMagickaSourceList = new string[3]
	NullifyMagickaSourceList[0] = "$NullifyMagickaSourceList0"
	NullifyMagickaSourceList[1] = "$NullifyMagickaSourceList1"
	NullifyMagickaSourceList[2] = "$NullifyMagickaSourceList2"

	ModVersionCache = PapyrusUtil.StringSplit(GetModVersion(), ".")
	if CurrentVersion == 0
		bmlUtility.LogNotification("Installed Licenses " + GetModVersion(), true)
		bmlUtility.LogTrace("Installed Licenses " + GetModVersion(), true)
	endIf
EndEvent

Event OnConfigOpen()
	SessionModified = false
	if !bmlUtility.Licenses_State
		Pages = new string[1]
		Pages[0] = "$Pages0"
	else
		Pages = new string[7]
		Pages[0] = "$Pages0"
		Pages[1] = "$Pages1"
		Pages[2] = "$Pages2"
		Pages[3] = "$Pages3"
		Pages[4] = "$Pages4"
		Pages[5] = "$Pages5"
		Pages[6] = "$Pages6"
	endIf
EndEvent

Event OnConfigClose()
	if SessionModified && bmlUtility.Licenses_State
		SessionModified = false
		bmlUtility.refreshLicenseFeatures()
		bmlUtility.refreshInventoryEventFilters()
		bmlUtility.bmlModeratorAlias.RefreshLicenseValidity()
	endIf
EndEvent

Event OnPageReset(string page)
	if !bmlUtility.Licenses_State || (page == "$Pages0")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetTitleText("$Pages0")
		AddHeaderOption("$Setup")
		if !bmlUtility.Licenses_State
			AddTextOptionST("Licenses_StateST", "$Licenses_State", "$Licenses_StateValue1")
		else
			AddTextOptionST("Licenses_StateST", "$Licenses_State", "$Licenses_StateValue3")
			AddEmptyOption()
			AddHeaderOption("$ConfigurationFile")
			AddTextOptionST("exportConfigST", "$exportConfig", "")
			AddTextOptionST("importConfigST", "$importConfig", "")
		endIf
		SetCursorPosition(1)
		AddHeaderOption("")
		AddTextOption("$ModVersion", GetModVersion(), OPTION_FLAG_DISABLED)
		AddTextOption("$Version", GetVersion(), OPTION_FLAG_DISABLED)
		AddTextOption("$CacheIndexDiff1Int2", (PapyrusUtil.StringSplit(GetModVersion(), ".")[1] as int - ModVersionCache[1] as int) + "," + ModVersionCache[2] as int, OPTION_FLAG_DISABLED)
		if checkHardDependencies()
			AddTextOption("$DependencyCheck", "$Safe", OPTION_FLAG_DISABLED)
		else
			AddTextOption("$DependencyCheck", "$Failed", OPTION_FLAG_DISABLED)
		endIf
		if bmlUtility.IsExceptionState()
			AddTextOption("$ExceptionState", "$Active", OPTION_FLAG_DISABLED)
		else
			AddTextOption("$ExceptionState", "$Inactive", OPTION_FLAG_DISABLED)
		endIf
	elseIf (page == "")
		SetCursorFillMode(LEFT_TO_RIGHT)
		SetTitleText("$Monitor")
		AddHeaderOption("$LicenseStatuses")
		AddEmptyOption()
		if (licenses.hasArmorLicense && isArmorLicenseFeatureEnabled)
			AddTextOption("$ArmorLicense", "$Valid")
		elseIf (!isArmorLicenseFeatureEnabled)
			AddTextOption("$ArmorLicense",  "$Unnecessary")
		else
			AddTextOption("$ArmorLicense",  "$Invalid")
		endIf
		if licenses.armorLicenseExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.armorLicenseExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.armorLicenseCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.armorLicenseCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf

		if (licenses.hasBikiniLicense && isBikiniLicenseFeatureEnabled)
			AddTextOption("$BikiniLicense",  "$Valid")
		elseIf (!isBikiniLicenseFeatureEnabled)
			AddTextOption("$BikiniLicense",  "$Unnecessary")
		else
			AddTextOption("$BikiniLicense",  "$Invalid")
		endIf
		if licenses.bikiniLicenseExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.bikiniLicenseExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.bikiniLicenseCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.bikiniLicenseCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf

		if (licenses.hasClothingLicense && isClothingLicenseFeatureEnabled)
			AddTextOption("$ClothingLicense",  "$Valid")
		elseIf (!isClothingLicenseFeatureEnabled)
			AddTextOption("$ClothingLicense",  "$Unnecessary")
		else
			AddTextOption("$ClothingLicense",  "$Invalid")
		endIf
		if licenses.clothingLicenseExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.clothingLicenseExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.clothingLicenseCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.clothingLicenseCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf

		if (licenses.hasMagicLicense && isMagicLicenseFeatureEnabled)
			AddTextOption("$MagicLicense",  "$Valid")
		elseIf (!isMagicLicenseFeatureEnabled)
			AddTextOption("$MagicLicense",  "$Unnecessary")
		else
			AddTextOption("$MagicLicense",  "$Invalid")
		endIf
		if licenses.magicLicenseExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.magicLicenseExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.magicLicenseCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.magicLicenseCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf

		if (licenses.hasWeaponLicense && isWeaponLicenseFeatureEnabled)
			AddTextOption("$WeaponLicense",  "$Valid")
		elseIf (!isWeaponLicenseFeatureEnabled)
			AddTextOption("$WeaponLicense",  "$Unnecessary")
		else
			AddTextOption("$WeaponLicense",  "$Invalid")
		endIf
		if licenses.weaponLicenseExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.weaponLicenseExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.weaponLicenseCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.weaponLicenseCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf

		if (licenses.hasCraftingLicense && isCraftingLicenseFeatureEnabled)
			AddTextOption("$CraftingLicense",  "$Valid")
		elseIf (!isCraftingLicenseFeatureEnabled)
			AddTextOption("$CraftingLicense",  "$Unnecessary")
		else
			AddTextOption("$CraftingLicense",  "$Invalid")
		endIf
		if licenses.craftingLicenseExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.craftingLicenseExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.craftingLicenseCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.craftingLicenseCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf

		if (licenses.hasTradingLicense && isTradingLicenseFeatureEnabled)
			AddTextOption("$TradingLicense",  "$Valid")
		elseIf (!isTradingLicenseFeatureEnabled)
			AddTextOption("$TradingLicense",  "$Unnecessary")
		else
			AddTextOption("$TradingLicense",  "$Invalid")
		endIf
		if licenses.tradingLicenseExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.tradingLicenseExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.tradingLicenseCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.tradingLicenseCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf

		if (licenses.hasCurfewExemption && isCurfewExemptionFeatureEnabled)
			AddTextOption("$CurfewExemption",  "$Valid")
		elseIf (!isCurfewExemptionFeatureEnabled)
			AddTextOption("$CurfewExemption",  "$Unnecessary")
		else
			AddTextOption("$CurfewExemption",  "$Invalid")
		endIf
		if licenses.curfewExemptionExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.curfewExemptionExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.curfewExemptionCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.curfewExemptionCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf

		if (licenses.hasTravelPermit && isTravelPermitFeatureEnabled)
			AddTextOption("$TravelPermit",  "$Valid")
		elseIf (!isTravelPermitFeatureEnabled)
			AddTextOption("$TravelPermit",  "$Unnecessary")
		else
			AddTextOption("$TravelPermit",  "$Invalid")
		endIf
		if licenses.travelPermitExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.travelPermitExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.travelPermitCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.travelPermitCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf
		
		if (licenses.hasInsurance && isInsuranceFeatureEnabled)
			AddTextOption("$Insurance",  "$Valid")
		elseIf (!isInsuranceFeatureEnabled)
			AddTextOption("$Insurance",  "$Unnecessary")
		else
			AddTextOption("$Insurance",  "$Invalid")
		endIf
		if licenses.insuranceExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.insuranceExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.insuranceCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.insuranceCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf

		if (licenses.hasWhoreLicense && isWhoreLicenseFeatureEnabled)
			AddTextOption("$WhoreLicense",  "$Valid")
		elseIf (!isWhoreLicenseFeatureEnabled)
			AddTextOption("$WhoreLicense",  "$Unnecessary")
		else
			AddTextOption("$WhoreLicense",  "$Invalid")
		endIf
		if licenses.whoreLicenseExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.whoreLicenseExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.whoreLicenseCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.whoreLicenseCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf

		if (licenses.hasCollarExemption && isCollarExemptionFeatureEnabled)
			AddTextOption("$CollarExemption",  "$Valid")
		elseIf (!isCollarExemptionFeatureEnabled)
			AddTextOption("$CollarExemption",  "$Unnecessary")
		else
			AddTextOption("$CollarExemption",  "$Invalid")
		endIf
		if licenses.collarExemptionExpirationTime != -1.0
			AddTextOption("$ExpirationTime{" + Math.ceiling(24.0 * (licenses.collarExemptionExpirationTime - GameDaysPassed.GetValue())) + "}", "")
		elseIf licenses.collarExemptionCooldownTime != -1.0
			AddTextOption("$CooldownTime{" + Math.ceiling(24.0 * (licenses.collarExemptionCooldownTime - GameDaysPassed.GetValue())) + "}", "")
		else
			AddEmptyOption()
		endIf
    elseIf (page == "$Pages1")
		SetCursorFillMode(TOP_TO_BOTTOM)
        AddHeaderOption("$BasicSettings")
        AddToggleOptionST("isKinkyDialogueFeatureEnabledST", "$isKinkyDialogueFeatureEnabled", isKinkyDialogueFeatureEnabled)
        AddToggleOptionST("isCheckIntervalFeatureEnabledST", "$isCheckIntervalFeatureEnabled", isCheckIntervalFeatureEnabled)
		AddSliderOptionST("checkIntervalST", "$checkInterval", checkInterval, "{0} second(s)", (!isCheckIntervalFeatureEnabled) as int)
		AddToggleOptionST("isCheckLOSFeatureEnabledST", "$isCheckLOSFeatureEnabled", isCheckLOSFeatureEnabled)
		AddEmptyOption()
		AddEmptyOption()
		AddHeaderOption("$AdditionalSettings")
		AddMenuOptionST("licenseSellerST", "$licenseSeller", sellerList[licenseSellerFaction])
		AddSliderOptionST("LicenseEnforcerCountST", "$LicenseEnforcerCount", LicenseEnforcerCount, "{0}")
		AddSliderOptionST("LicenseLimitST", "$LicenseLimit", LicenseLimit, "{0}")
		AddSliderOptionST("LicenseCooldownST", "$LicenseCooldown", LicenseCooldown, "{0} day(s)")
		AddToggleOptionST("LicenseRenewalST", "$LicenseRenewal", LicenseRenewal)
		AddToggleOptionST("isWaterDamageEnabledST", "$isWaterDamageEnabled", isWaterDamageEnabled)
		AddToggleOptionST("thaneImmunityUniversalST", "$thaneImmunityUniversal", thaneImmunityUniversal)
		AddToggleOptionST("ValidateEquipmentTradeST", "$ValidateEquipmentTrade", ValidateEquipmentTrade)

		SetCursorPosition(1)
		AddHeaderOption("$Filters")
		AddToggleOptionST("isLimitToCityEnabledST", "$isLimitToCityEnabled", isLimitToCityEnabled)
		AddToggleOptionST("isLimitToTownEnabledST", "$isLimitToTownEnabled", isLimitToTownEnabled)
		AddToggleOptionST("isLimitToCitySpaceEnabledST", "$isLimitToCitySpaceEnabled", isLimitToCitySpaceEnabled)
		AddToggleOptionST("BM_isMaleGuardEnabledST", "$BM_isMaleGuardEnabled", BM_isMaleGuardEnabled.GetValue() as bool)
        AddToggleOptionST("BM_isFemaleGuardEnabledST", "$BM_isFemaleGuardEnabled", BM_isFemaleGuardEnabled.GetValue() as bool)
		AddEmptyOption()
		AddHeaderOption("$Punishments")
        AddSliderOptionST("FineBaseST", "$FineBase", FineBase, "{0} gold")
		AddSliderOptionST("FinePercentageST", "$FinePercentage", FinePercentage, "{1}%")
        AddToggleOptionST("fineAddsToBountyST", "$fineAddsToBounty", fineAddsToBounty)
        AddToggleOptionST("isConfiscateFeatureEnabledST", "$isConfiscateFeatureEnabled", isConfiscateFeatureEnabled)
		AddToggleOptionST("isConfiscateInventoryFeatureEnabledST", "$isConfiscateInventoryFeatureEnabled", isConfiscateInventoryFeatureEnabled, (!isConfiscateFeatureEnabled) as int)
    elseIf (page == "$Pages2")
		SetCursorFillMode(LEFT_TO_RIGHT)
        AddHeaderOption("$ArmorLicense")
        AddToggleOptionST("isArmorLicenseFeatureEnabledST", "$Enabled", isArmorLicenseFeatureEnabled)
        AddSliderOptionST("BM_ALCostST", "$BM_ALCost", BM_ALCost.getValue(), "{0} gold")
        AddSliderOptionST("BM_ALDurationST", "$BM_ALDuration", BM_ALDuration.getValue(), "{0} day(s)")
        AddEmptyOption()
        AddEmptyOption()
        AddHeaderOption("$BikiniLicense")
        AddToggleOptionST("isBikiniLicenseFeatureEnabledST", "$Enabled", isBikiniLicenseFeatureEnabled)
        AddSliderOptionST("BM_BLCostST", "$BM_BLCost", BM_BLCost.getValue(), "{0} gold")
        AddSliderOptionST("BM_BLDurationST", "$BM_BLDuration", BM_BLDuration.getValue(), "{0} day(s)")
		AddToggleOptionST("isBikiniArmorFeatureEnabledST", "$isBikiniArmorFeatureEnabled", isBikiniArmorFeatureEnabled)
		AddToggleOptionST("isBikiniClothingFeatureEnabledST", "$isBikiniClothingFeatureEnabled", isBikiniClothingFeatureEnabled)
        AddInputOptionST("bikiniKeywordStringST", "$bikiniKeywordString", "$InputModify")
        AddEmptyOption()
        AddEmptyOption()
        AddEmptyOption()
        AddHeaderOption("$ClothingLicense")
        AddToggleOptionST("isClothingLicenseFeatureEnabledST", "$Enabled", isClothingLicenseFeatureEnabled)
        AddSliderOptionST("BM_CLCostST", "$BM_CLCost", BM_CLCost.getValue(), "{0} gold")
        AddSliderOptionST("BM_CLDurationST", "$BM_CLDuration", BM_CLDuration.getValue(), "{0} day(s)")
        AddEmptyOption()
        AddEmptyOption()
        AddHeaderOption("$MagicLicense")
        AddToggleOptionST("isMagicLicenseFeatureEnabledST", "$Enabled", isMagicLicenseFeatureEnabled)
        AddSliderOptionST("BM_MLCostST", "$BM_MLCost", BM_MLCost.getValue(), "{0} gold")
        AddSliderOptionST("BM_MLDurationST", "$BM_MLDuration", BM_MLDuration.getValue(), "{0} day(s)")
		AddToggleOptionST("isEnchantedArmorFeatureEnabledST", "$isEnchantedArmorFeatureEnabled", isEnchantedArmorFeatureEnabled)
        AddToggleOptionST("isEnchantedClothingFeatureEnabledST", "$isEnchantedClothingFeatureEnabled", isEnchantedClothingFeatureEnabled)
		AddToggleOptionST("isEnchantedJewelryFeatureEnabledST", "$isEnchantedJewelryFeatureEnabled", isEnchantedJewelryFeatureEnabled)
		AddToggleOptionST("isEnchantedWeaponryFeatureEnabledST", "$isEnchantedWeaponryFeatureEnabled", isEnchantedWeaponryFeatureEnabled)
        AddMenuOptionST("NullifyMagickaSourceST", "$NullifyMagickaSource", NullifyMagickaSourceList[NullifyMagickaSource])
        AddToggleOptionST("NullifyMagickaEnforceST", "$NullifyMagickaEnforce", NullifyMagickaEnforce, (!(NullifyMagickaSource as bool)) as int)
		AddEmptyOption()
		AddEmptyOption()
        AddHeaderOption("$WeaponLicense")
        AddToggleOptionST("isWeaponLicenseFeatureEnabledST", "$Enabled", isWeaponLicenseFeatureEnabled)
        AddSliderOptionST("BM_WLCostST", "$BM_WLCost", BM_WLCost.getValue(), "{0} gold")
        AddSliderOptionST("BM_WLDurationST", "$BM_WLDuration", BM_WLDuration.getValue(), "{0} day(s)")
		AddToggleOptionST("isWeaponAmmoFeatureEnabledST", "$isWeaponAmmoFeatureEnabled", isWeaponAmmoFeatureEnabled)
	elseIf (page == "$Pages3")
		SetCursorFillMode(LEFT_TO_RIGHT)
		AddHeaderOption("$CraftingLicense")
        AddToggleOptionST("isCraftingLicenseFeatureEnabledST", "$Enabled", isCraftingLicenseFeatureEnabled)
        AddSliderOptionST("BM_CrfLCostST", "$BM_CrfLCost", BM_CrfLCost.getValue(), "{0} gold")
        AddSliderOptionST("BM_CrfLDurationST", "$BM_CrfLDuration", BM_CrfLDuration.getValue(), "{0} day(s)")
		AddEmptyOption()
        AddEmptyOption()
		AddHeaderOption("$TradingLicense")
        AddToggleOptionST("isTradingLicenseFeatureEnabledST", "$Enabled", isTradingLicenseFeatureEnabled)
        AddSliderOptionST("BM_TLCostST", "$BM_TLCost", BM_TLCost.getValue(), "{0} gold")
        AddSliderOptionST("BM_TLDurationST", "$BM_TLDuration", BM_TLDuration.getValue(), "{0} day(s)")
		AddEmptyOption()
        AddEmptyOption()
		AddHeaderOption("$CurfewExemption")
        AddToggleOptionST("isCurfewExemptionFeatureEnabledST", "$Enabled", isCurfewExemptionFeatureEnabled)
        AddSliderOptionST("BM_CuECostST", "$BM_CuECost", BM_CuECost.getValue(), "{0} gold")
        AddSliderOptionST("BM_CuEDurationST", "$BM_CuEDuration", BM_CuEDuration.getValue(), "{0} day(s)")
		AddSliderOptionST("BM_CurfewStartST", "$BM_CurfewStart", BM_CurfewStart.getValue(), "{0}:00")
		AddSliderOptionST("BM_CurfewEndST", "$BM_CurfewEnd", BM_CurfewEnd.getValue(), "{0}:00")
		AddEmptyOption()
		AddEmptyOption()
		AddHeaderOption("$TravelPermit")
		AddToggleOptionST("isTravelPermitFeatureEnabledST", "$Enabled", isTravelPermitFeatureEnabled)
        AddSliderOptionST("BM_TPCostST", "$BM_TPCost", BM_TPCost.getValue(), "{0} gold")
        AddSliderOptionST("BM_TPDurationST", "$BM_TPDuration", BM_TPDuration.getValue(), "{0} day(s)")
		AddToggleOptionST("BM_FollowerMaleST", "$BM_FollowerMale", BM_FollowerMale.GetValue() as bool)
		AddEmptyOption()
        AddToggleOptionST("BM_FollowerFemaleST", "$BM_FollowerFemale", BM_FollowerFemale.GetValue() as bool)
		AddEmptyOption()
		AddEmptyOption()
        AddEmptyOption()
		AddHeaderOption("$Insurance")
		AddToggleOptionST("isInsuranceFeatureEnabledST", "$Enabled", isInsuranceFeatureEnabled)
        AddSliderOptionST("BM_InsurCostBaseST", "$BM_InsurCostBase", BM_InsurCostBase, "{0} gold")
        AddSliderOptionST("BM_InsurDurationST", "$BM_InsurDuration", BM_InsurDuration.getValue(), "{0} day(s)")
		AddTextOptionST("insuranceMisbehaviourMonitorST", "$MisbehaviourMultiplier", licenses.insuranceMisbehaviourMultiplier + "x")
		AddEmptyOption()
		AddTextOptionST("insurancePopularityMonitorST", "$PopularityMultiplier", licenses.insurancePopularityMultiplier + "x")
		AddEmptyOption()
		AddToggleOptionST("invertPopularityMultiplierST", "$invertPopularityMultiplier", invertPopularityMultiplier)
		AddEmptyOption()
		AddToggleOptionST("thaneImmunityInsuranceST", "$thaneImmunityInsurance", thaneImmunityInsurance)
	elseIf (page == "$Pages4")
		SetCursorFillMode(LEFT_TO_RIGHT)
		AddHeaderOption("$WhoreLicense")
        AddToggleOptionST("isWhoreLicenseFeatureEnabledST", "$Enabled", isWhoreLicenseFeatureEnabled)
        AddSliderOptionST("BM_WhLCostST", "$BM_WhLCost", BM_WhLCost.getValue(), "{0} gold")
        AddSliderOptionST("BM_WhLDurationST", "$BM_WhLDuration", BM_WhLDuration.getValue(), "{0} day(s)")
		AddEmptyOption()
        AddEmptyOption()
		AddHeaderOption("$CollarExemption")
		AddToggleOptionST("isCollarExemptionFeatureEnabledST", "$Enabled", isCollarExemptionFeatureEnabled, (!DeviousDevices_State) as int)
        AddSliderOptionST("BM_CECostST", "$BM_CECost", BM_CECost.getValue(), "{0} gold", (!DeviousDevices_State) as int)
        AddSliderOptionST("BM_CEDurationST", "$BM_CEDuration", BM_CEDuration.getValue(), "{0} day(s)", (!DeviousDevices_State) as int)
    elseIf (page == "$Pages5")
		SetCursorFillMode(TOP_TO_BOTTOM)
		if !DeviousDevices_State && !SlaveTats_State
			AddTextOption("$Integrations_Empty", "", OPTION_FLAG_DISABLED)
		endIf

		if DeviousDevices_State
			AddHeaderOption("$DeviousDevices")
			AddToggleOptionST("equipDDOnViolationST", "$equipDDOnViolation", equipDDOnViolation)
			AddSliderOptionST("ddEquipChanceST", "$ddEquipChance", ddEquipChance, "{0}%", (!equipDDOnViolation) as int)
			AddMenuOptionST("ddFilterST", "$ddFilter", ddFilterList[ddFilter])
		endIf

		SetCursorPosition(1)

		if SlaveTats_State
			AddHeaderOption("$SlaveTats")
			AddToggleOptionST("ShowCurseTattoosST", "$ShowCurseTattoos", ShowCurseTattoos)
			AddInputOptionST("Curse_ColorST", "$Curse_Color", "$InputModify", (!ShowCurseTattoos) as int)
			AddInputOptionST("Curse_GlowST", "$Curse_Glow", "$InputModify", (!ShowCurseTattoos) as int)
			AddSliderOptionST("Curse_AlphaST", "$Curse_Alpha", Curse_Alpha, "{1}", (!ShowCurseTattoos) as int)
			AddToggleOptionST("Curse_NeckST", "$Curse_Neck", Curse_Neck, (!ShowCurseTattoos) as int)
			AddToggleOptionST("Curse_TorsoST", "$Curse_Torso", Curse_Torso, (!ShowCurseTattoos) as int)
			AddToggleOptionST("Curse_ArmsST", "$Curse_Arms", Curse_Arms, (!ShowCurseTattoos) as int)
			AddToggleOptionST("Curse_LegsST", "$Curse_Legs", Curse_Legs, (!ShowCurseTattoos) as int)
			AddToggleOptionST("Curse_ReduceSlotUsageST", "$Curse_ReduceSlotUsage", Curse_ReduceSlotUsage, (!ShowCurseTattoos) as int)
			AddTextOptionST("Curse_FormatOverrideST", "$Curse_FormatOverride", Curse_FormatOverride, (!ShowCurseTattoos) as int)
		endIf
	elseIf (page == "$Pages6")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$DebugFunctions")
		AddTextOptionST("RefreshFeaturesST", "$RefreshFeatures", "")
		AddTextOptionST("RefreshStatusST", "$RefreshStatus", "")
		if SlaveTats_State
			AddTextOptionST("RefreshTattoosST", "$RefreshTattoos", "")
		endIf
		AddTextOptionST("ResetMenuST", "$ResetMenu", "")
		AddEmptyOption()
		AddHeaderOption("$AdvancedSettings")
		AddToggleOptionST("GameMessageST", "$GameMessage", GameMessage)
		AddToggleOptionST("LogNotificationST", "$LogNotification", LogNotification)
		AddToggleOptionST("LogTraceST", "$LogTrace", LogTrace)
		AddToggleOptionST("ConfigWarnST", "$ConfigWarn", ConfigWarn)
		AddToggleOptionST("allowJailQuestNodesST", "$allowJailQuestNodes", allowJailQuestNodes)
		AddSliderOptionST("standardEventDelayST", "$standardEventDelay", standardEventDelay, "{0} seconds")

		SetCursorPosition(1)
		AddHeaderOption("$HardDependencies")
		AddTextOption("$PapyrusExtender_State", PapyrusExtender_Status)
		AddTextOption("$PapyrusUtil_State", PapyrusUtil_Status)
		AddTextOption("$PyramidUtils_State", PyramidUtils_Status)
		AddEmptyOption()
		AddHeaderOption("$SoftDependencies")
		AddTextOption("$DeviousDevices_State", DeviousDevices_Status, (!DeviousDevices_State) as int)
		AddTextOption("$DeviousFollowers_State", DeviousFollowers_Status, (!DeviousFollowers_State) as int)
		AddTextOption("$PrisonOverhaulPatched_State", PrisonOverhaulPatched_Status, (!PrisonOverhaulPatched_State) as int)
		AddTextOption("$SexLabAroused_State", SexLabAroused_Status, (!SexLabAroused_State) as int)
		AddTextOption("$SlaveTats_State", SlaveTats_Status, (!SlaveTats_State) as int)
		if DeviousInterests_State || OStim_State || PrisonAlternative_State || SexLab_State || SimpleSlavery_State
			AddEmptyOption()
			AddHeaderOption("$Compatibility")
			if DeviousInterests_State
				AddTextOption("$DeviousInterests_State", DeviousInterests_Status)
			endIf
			if OStim_State
				AddTextOption("$OStim_State", OStim_Status)
			endIf
			if PrisonAlternative_State
				AddTextOption("$PrisonAlternative_State", PrisonAlternative_Status)
			endIf
			if SexLab_State
				AddTextOption("$SexLab_State", SexLab_Status)
			endIf
			if SimpleSlavery_State
				AddTextOption("$SimpleSlavery_State", SimpleSlavery_Status)
			endIf
		endIf
    endIf
EndEvent

state Licenses_StateST
    event OnSelectST()
        if !bmlUtility.Licenses_State
			SetTextOptionValueST("$Licenses_StateValue2")
			ShowMessage("$Licenses_StateMessageInitialize1", false)
			; startup
			bmlUtility.Startup()
        else
			if ShowMessage("$Licenses_StateMessageShutdown1")
				SetTextOptionValueST("$Licenses_StateValue4")
				; Remove currently held license book items
				Actor player = licenses.playerRef.GetActorRef()
				player.removeItem(bmlUtility.BM_ArmorLicense, player.getItemCount(bmlUtility.BM_ArmorLicense))
				player.removeItem(bmlUtility.BM_BikiniLicense, player.getItemCount(bmlUtility.BM_BikiniLicense))
				player.removeItem(bmlUtility.BM_ClothingLicense, player.getItemCount(bmlUtility.BM_ClothingLicense))
				player.removeItem(bmlUtility.BM_MagicLicense, player.getItemCount(bmlUtility.BM_MagicLicense))
				player.removeItem(bmlUtility.BM_WeaponLicense, player.getItemCount(bmlUtility.BM_WeaponLicense))
				player.removeItem(bmlUtility.BM_CraftingLicense, player.getItemCount(bmlUtility.BM_CraftingLicense))
				player.removeItem(bmlUtility.BM_TradingLicense, player.getItemCount(bmlUtility.BM_TradingLicense))
				player.removeItem(bmlUtility.BM_WhoreLicense, player.getItemCount(bmlUtility.BM_WhoreLicense))
				player.removeItem(bmlUtility.BM_TravelPermit, player.getItemCount(bmlUtility.BM_TravelPermit))
				player.removeItem(bmlUtility.BM_CollarExemption, player.getItemCount(bmlUtility.BM_CollarExemption))
				player.removeItem(bmlUtility.BM_Insurance, player.getItemCount(bmlUtility.BM_Insurance))
				player.removeItem(bmlUtility.BM_CurfewExemption, player.getItemCount(bmlUtility.BM_CurfewExemption))
				; Remove Nullify Magicka
				licenses.RemoveNullifyMagicka(true)
				; shutdown
				bmlUtility.Shutdown()
				SessionModified = false
				ForcePageReset()
			endIf
        endIf
	endEvent
	event OnHighlightST()
		if bmlUtility.Licenses_State
			SetInfoText("$Licenses_StateHighlight")
		endIf
	endEvent
endState

state isKinkyDialogueFeatureEnabledST
	event OnSelectST()
		isKinkyDialogueFeatureEnabled = !isKinkyDialogueFeatureEnabled
		SetToggleOptionValueST(isKinkyDialogueFeatureEnabled)
	endEvent
	event OnHighlightST()
		SetInfoText("$isKinkyDialogueFeatureEnabledHighlight")
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
		SetInfoText("$isCheckIntervalFeatureEnabledHighlight")
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
		SetInfoText("$checkIntervalHighlight")
	endEvent
endState

state isCheckLOSFeatureEnabledST
	event OnSelectST()
		isCheckLOSFeatureEnabled = !isCheckLOSFeatureEnabled
		SetToggleOptionValueST(isCheckLOSFeatureEnabled)
        bmlUtility.licenseDetectionQuest.stop()
	endEvent
	event OnHighlightST()
		SetInfoText("$isCheckLOSFeatureEnabledHighlight")
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
		SetInfoText("$LicenseEnforcerCountHighlight")
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
		SetInfoText("$licenseSellerHighlight")
	endEvent
endState

State exportConfigST
	Event OnSelectST()
		SetTextOptionValueST("$Processing")
		if exportConfig()
			SetTextOptionValueST("$Done")
		else
			SetTextOptionValueST("$Errored")
		endIf
	EndEvent
EndState

State importConfigST
	Event OnSelectST()
		SetTextOptionValueST("$Processing")
		if importConfig()
			SetTextOptionValueST("$Done")
		else
			SetTextOptionValueST("$Errored")
		endIf
	EndEvent
EndState

State ResetMenuST
	Event OnSelectST()
		if ShowMessage("$ResetMenuMessage1")
			SetTextOptionValueST("$Processing")
			ShowMessage("$ResetMenuMessage2", false)
			bmlUtility.ResetMCM()
		endIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("$ResetMenuHighlight")
	EndEvent
EndState

State RefreshFeaturesST
	Event OnSelectST()
		if ShowMessage("$RefreshFeaturesMessage1")
			SetTextOptionValueST("$Processing")
			bmlUtility.RefreshFeatures()
			ShowMessage("$RefreshFeaturesMessage2", false)
			SetTextOptionValueST("$Done")
		endIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("$RefreshFeaturesHighlight")
	EndEvent
EndState

State RefreshStatusST
	Event OnSelectST()
		if ShowMessage("$RefreshStatusMessage1")
			SetTextOptionValueST("$Processing")
			ShowMessage("$RefreshStatusMessage2", false)
			bmlUtility.RefreshStatus()
			bmlUtility.LogNotification("Refreshed Status.", true)
		endIf
	EndEvent
	Event OnHighlightST()
		SetInfoText("$RefreshStatusHighlight")
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
		SetInfoText("$standardEventDelayHighlight")
	endEvent
endState

state isLimitToCityEnabledST
	event OnSelectST()
		isLimitToCityEnabled = !isLimitToCityEnabled
		SetToggleOptionValueST(isLimitToCityEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isLimitToCityEnabledHighlight")
	endEvent
endState

state isLimitToCitySpaceEnabledST
	event OnSelectST()
		isLimitToCitySpaceEnabled = !isLimitToCitySpaceEnabled
		SetToggleOptionValueST(isLimitToCitySpaceEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isLimitToCitySpaceEnabledHighlight")
	endEvent
endState

state isLimitToTownEnabledST
	event OnSelectST()
		isLimitToTownEnabled = !isLimitToTownEnabled
		SetToggleOptionValueST(isLimitToTownEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isLimitToTownEnabledHighlight")
	endEvent
endState

state ValidateEquipmentTradeST
	event OnSelectST()
		ValidateEquipmentTrade = !ValidateEquipmentTrade
		SetToggleOptionValueST(ValidateEquipmentTrade)
	endEvent
	event OnHighlightST()
		SetInfoText("$ValidateEquipmentTradeHighlight")
	endEvent
endState

state BM_isMaleGuardEnabledST
	event OnSelectST()
		bool value = !(BM_isMaleGuardEnabled.GetValue() as bool)
		BM_isMaleGuardEnabled.SetValue(value as float)
		SetToggleOptionValueST(value)
	endEvent
	event OnHighlightST()
		SetInfoText("$BM_isXGuardEnabledHighlight")
	endEvent
endState

state BM_isFemaleGuardEnabledST
	event OnSelectST()
		bool value = !(BM_isFemaleGuardEnabled.GetValue() as bool)
		BM_isFemaleGuardEnabled.SetValue(value as float)
		SetToggleOptionValueST(value)
	endEvent
	event OnHighlightST()
		SetInfoText("$BM_isXGuardEnabledHighlight")
	endEvent
endState

state isWaterDamageEnabledST
	event OnSelectST()
		isWaterDamageEnabled = !isWaterDamageEnabled
		SetToggleOptionValueST(isWaterDamageEnabled)
	endEvent
	event OnHighlightST()
		SetInfoText("$isWaterDamageEnabledHighlight")
	endEvent
endState

state thaneImmunityUniversalST
	event OnSelectST()
		thaneImmunityUniversal = !thaneImmunityUniversal
		SetToggleOptionValueST(thaneImmunityUniversal)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$thaneImmunityUniversalHighlight")
	endEvent
endState

state LicenseLimitST
	event OnSliderOpenST()
		SetSliderDialogStartValue(LicenseLimit)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 12.0)
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
		SetInfoText("$LicenseLimitHighlight")
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
		SetInfoText("$LicenseCooldownHighlight")
	endEvent
endState

state LicenseRenewalST
	event OnSelectST()
		LicenseRenewal = !LicenseRenewal
		SetToggleOptionValueST(LicenseRenewal)
	endEvent
	event OnHighlightST()
		SetInfoText("$LicenseRenewalHighlight")
	endEvent
endState

state GameMessageST
	event OnSelectST()
		GameMessage = !GameMessage
		SetToggleOptionValueST(GameMessage)
	endEvent
	event OnHighlightST()
		SetInfoText("$GameMessageHighlight")
	endEvent
endState

state LogNotificationST
	event OnSelectST()
		LogNotification = !LogNotification
		SetToggleOptionValueST(LogNotification)
	endEvent
	event OnHighlightST()
		SetInfoText("$LogNotificationHighlight")
	endEvent
endState

state LogTraceST
	event OnSelectST()
		LogTrace = !LogTrace
		SetToggleOptionValueST(LogTrace)
	endEvent
	event OnHighlightST()
		SetInfoText("$LogTraceHighlight")
	endEvent
endState

state ConfigWarnST
	event OnSelectST()
		ConfigWarn = !ConfigWarn
		SetToggleOptionValueST(ConfigWarn)
	endEvent
	event OnHighlightST()
		SetInfoText("$ConfigWarnHighlight")
	endEvent
endState

state allowJailQuestNodesST
	event OnSelectST()
		allowJailQuestNodes = !allowJailQuestNodes
		SetToggleOptionValueST(allowJailQuestNodes)
	endEvent
	event OnHighlightST()
		SetInfoText("$allowJailQuestNodesHighlight")
	endEvent
endState

state isArmorLicenseFeatureEnabledST
	event OnSelectST()
		isArmorLicenseFeatureEnabled = !isArmorLicenseFeatureEnabled
		SetToggleOptionValueST(isArmorLicenseFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isArmorLicenseFeatureEnabledHighlight")
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

state isBikiniLicenseFeatureEnabledST
	event OnSelectST()
		isBikiniLicenseFeatureEnabled = !isBikiniLicenseFeatureEnabled
		SetToggleOptionValueST(isBikiniLicenseFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isBikiniLicenseFeatureEnabledHighlight")
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
		SetInfoText("$isBikiniArmorFeatureEnabledHighlight")
	endEvent
endState

state isBikiniClothingFeatureEnabledST
	event OnSelectST()
		isBikiniClothingFeatureEnabled = !isBikiniClothingFeatureEnabled
		SetToggleOptionValueST(isBikiniClothingFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isBikiniClothingFeatureEnabledHighlight")
	endEvent
endState

state bikiniKeywordStringST
	event OnInputOpenST()
        SetInputDialogStartText(bikiniKeywordString)
	endEvent
    event OnInputAcceptST(string value)
        bikiniKeywordString = value
		licenses.PopulateKeywordBikiniItemArray()
		SessionModified = true
    endEvent
	event OnHighlightST()
		SetInfoText("$bikiniKeywordStringHighlight")
	endEvent
endState

state isClothingLicenseFeatureEnabledST
	event OnSelectST()
		isClothingLicenseFeatureEnabled = !isClothingLicenseFeatureEnabled
		SetToggleOptionValueST(isClothingLicenseFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isClothingLicenseFeatureEnabledHighlight")
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
		SetToggleOptionValueST(isMagicLicenseFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isMagicLicenseFeatureEnabledHighlight")
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
		SetInfoText("$isEnchantedJewelryFeatureEnabledHighlight")
	endEvent
endState

state isEnchantedClothingFeatureEnabledST
	event OnSelectST()
		isEnchantedClothingFeatureEnabled = !isEnchantedClothingFeatureEnabled
		SetToggleOptionValueST(isEnchantedClothingFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isEnchantedClothingFeatureEnabledHighlight")
	endEvent
endState

state isEnchantedArmorFeatureEnabledST
	event OnSelectST()
		isEnchantedArmorFeatureEnabled = !isEnchantedArmorFeatureEnabled
		SetToggleOptionValueST(isEnchantedArmorFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isEnchantedArmorFeatureEnabledHighlight")
	endEvent
endState

state isEnchantedWeaponryFeatureEnabledST
	event OnSelectST()
		isEnchantedWeaponryFeatureEnabled = !isEnchantedWeaponryFeatureEnabled
		SetToggleOptionValueST(isEnchantedWeaponryFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isEnchantedWeaponryFeatureEnabledHighlight")
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
		SetInfoText("$NullifyMagickaSourceHighlight")
	endEvent
endState

state NullifyMagickaEnforceST
	event OnSelectST()
		NullifyMagickaEnforce = !NullifyMagickaEnforce
		SetToggleOptionValueST(NullifyMagickaEnforce)
	endEvent
	event OnHighlightST()
		SetInfoText("$NullifyMagickaEnforceHighlight")
	endEvent
endState

state isWeaponLicenseFeatureEnabledST
	event OnSelectST()
		isWeaponLicenseFeatureEnabled = !isWeaponLicenseFeatureEnabled
		SetToggleOptionValueST(isWeaponLicenseFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isWeaponLicenseFeatureEnabledHighlight")
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
		SetInfoText("$isWeaponAmmoFeatureEnabledHighlight")
	endEvent
endState

state isCraftingLicenseFeatureEnabledST
	event OnSelectST()
		isCraftingLicenseFeatureEnabled = !isCraftingLicenseFeatureEnabled
		SetToggleOptionValueST(isCraftingLicenseFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isCraftingLicenseFeatureEnabledHighlight")
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
		SetToggleOptionValueST(isTradingLicenseFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isTradingLicenseFeatureEnabledHighlight")
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
		SetToggleOptionValueST(isCurfewExemptionFeatureEnabled)
		if !isCurfewExemptionFeatureEnabled
			bmlUtility.BM_IsViolatingCurfew.SetValue(0.0)
			licenses.isCurfewViolation = false
		endIf
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isCurfewExemptionFeatureEnabledHighlight")
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
		SetInfoText("$BM_CurfewStartHighlight")
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
		SetInfoText("$BM_CurfewEndHighlight")
	endEvent
endState

state isWhoreLicenseFeatureEnabledST
	event OnSelectST()
		isWhoreLicenseFeatureEnabled = !isWhoreLicenseFeatureEnabled
		SetToggleOptionValueST(isWhoreLicenseFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isWhoreLicenseFeatureEnabledHighlight")
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
		SetToggleOptionValueST(isTravelPermitFeatureEnabled)
		if !isTravelPermitFeatureEnabled
			bmlUtility.savedLoc = None
			bmlUtility.savedSpace = None
			licenses.isTravelViolation = false
		endIf
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isTravelPermitFeatureEnabledHighlight")
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
		SetInfoText("$BM_FollowerMaleHighlight")
	endEvent
endState

state BM_FollowerFemaleST
	event OnSelectST()
		bool value = !(BM_FollowerFemale.GetValue() as bool)
		BM_FollowerFemale.SetValue(value as float)
		SetToggleOptionValueST(value)
	endEvent
	event OnHighlightST()
		SetInfoText("$BM_FollowerFemaleHighlight")
	endEvent
endState

state isCollarExemptionFeatureEnabledST
	event OnSelectST()
		isCollarExemptionFeatureEnabled = !isCollarExemptionFeatureEnabled
		SetToggleOptionValueST(isCollarExemptionFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isCollarExemptionFeatureEnabledHighlight")
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
		SetToggleOptionValueST(isInsuranceFeatureEnabled)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$isInsuranceFeatureEnabledHighlight")
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
		SetInfoText("$BM_InsurCostBaseHighlight")
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
		SetInfoText("$insuranceMisbehaviourMonitorHighlight")
	endEvent
endState

state insurancePopularityMonitorST
	event OnHighlightST()
		SetInfoText("$insurancePopularityMonitorHighlight")
	endEvent
endState

state invertPopularityMultiplierST
	event OnSelectST()
		invertPopularityMultiplier = !invertPopularityMultiplier
		SetToggleOptionValueST(invertPopularityMultiplier)
		bmlUtility.refreshPopularityModifier()
	endEvent
	event OnHighlightST()
		SetInfoText("$invertPopularityMultiplierHighlight")
	endEvent
endState

state thaneImmunityInsuranceST
	event OnSelectST()
		thaneImmunityInsurance = !thaneImmunityInsurance
		SetToggleOptionValueST(thaneImmunityInsurance)
		SessionModified = true
	endEvent
	event OnHighlightST()
		SetInfoText("$thaneImmunityInsuranceHighlight")
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
		SetInfoText("$FineBaseHighlight")
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
		SetInfoText("$FinePercentageHighlight")
	endEvent
endState

state fineAddsToBountyST
	event OnSelectST()
		fineAddsToBounty = !fineAddsToBounty
		SetToggleOptionValueST(fineAddsToBounty)
	endEvent
	event OnHighlightST()
		SetInfoText("$fineAddsToBountyHighlight")
	endEvent
endState

state isConfiscateFeatureEnabledST
	event OnSelectST()
		isConfiscateFeatureEnabled = !isConfiscateFeatureEnabled
		SetOptionFlagsST((!isConfiscateFeatureEnabled) as int, true, "isConfiscateInventoryFeatureEnabledST")
		SetToggleOptionValueST(isConfiscateFeatureEnabled)
	endEvent
	event OnHighlightST()
		SetInfoText("$isConfiscateFeatureEnabledHighlight")
	endEvent
endState

state isConfiscateInventoryFeatureEnabledST
	event OnSelectST()
		isConfiscateInventoryFeatureEnabled = !isConfiscateInventoryFeatureEnabled
		SetToggleOptionValueST(isConfiscateInventoryFeatureEnabled)
	endEvent
	event OnHighlightST()
		SetInfoText("$isConfiscateInventoryFeatureEnabledHighlight")
	endEvent
endState

state equipDDOnViolationST
	event OnSelectST()
		equipDDOnViolation = !equipDDOnViolation
		SetOptionFlagsST((!equipDDOnViolation) as int, true, "ddEquipChanceST")
		SetToggleOptionValueST(equipDDOnViolation)
	endEvent
	event OnHighlightST()
		SetInfoText("$equipDDOnViolationHighlight")
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
		SetInfoText("$ddEquipChanceHighlight")
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
		SetInfoText("$ddFilterHighlight")
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
		SetOptionFlagsST((!ShowCurseTattoos) as int, true, "Curse_ReduceSlotUsageST")
		SetOptionFlagsST((!ShowCurseTattoos) as int, false, "Curse_FormatOverrideST")
		SetToggleOptionValueST(ShowCurseTattoos)
	endEvent
endState

state Curse_ColorST
	event OnInputOpenST()
        SetInputDialogStartText(Curse_Color)
	endEvent
    event OnInputAcceptST(string value)
        Curse_Color = bmlUtility.AdjustStringToInt(value)
    endEvent
	event OnHighlightST()
		SetInfoText("$Curse_ColorHighlight")
	endEvent
endState

state Curse_GlowST
	event OnInputOpenST()
        SetInputDialogStartText(Curse_Glow)
	endEvent
    event OnInputAcceptST(string value)
        Curse_Glow = bmlUtility.AdjustStringToInt(value)
    endEvent
	event OnHighlightST()
		SetInfoText("$Curse_GlowHighlight")
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
		SetInfoText("$Curse_AlphaHighlight")
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
		SetInfoText("$Curse_ReduceSlotUsageHighlight")
	endEvent
endState

state Curse_FormatOverrideST
	event OnSelectST()
		Curse_FormatOverride = !Curse_FormatOverride
		licenses.PopulateCursedTattoosArray()
		SetTextOptionValueST(Curse_FormatOverride)
	endEvent
	event OnHighlightST()
		SetInfoText("$Curse_FormatOverrideHighlight")
	endEvent
endState

state RefreshTattoosST
	event OnSelectST()
		SetTextOptionValueST("$Processing")
		ShowMessage("$RefreshTattoosMessage1", false)
		bmlUtility.RefreshTattoos()
		bmlUtility.LogNotification("Refreshed tattoos.", true)
	endEvent
	event OnHighlightST()
		SetInfoText("$RefreshTattoosHighlight")
	endEvent
endState

Bool Function checkHardDependencies()
	if SKSE.GetPluginVersion("powerofthree's Papyrus Extender") != -1 && (PO3_SKSEFunctions.GetPapyrusExtenderVersion()[0] >= 5)
		PapyrusExtender_Status = "$Installed"
	else
		PapyrusExtender_Status = "$Invalid"
	endIf
	if (SKSE.GetPluginVersion("PapyrusUtil") != -1 || SKSE.GetPluginVersion("papyrusutil plugin") != -1) && (PapyrusUtil.GetVersion() >= 30)
		PapyrusUtil_Status = "$Installed"
	else
		PapyrusUtil_Status = "$Invalid"
	endIf
	if SKSE.GetPluginVersion("PyramidUtils") != -1 && (PyramidUtils.GetVersion() >= 0.002009)
		PyramidUtils_Status = "$Installed"
	else
		PyramidUtils_Status = "$Invalid"
	endIf

	if PapyrusExtender_Status == "$Installed" && PapyrusUtil_Status == "$Installed" && PyramidUtils_Status == "$Installed"
		return true
	else
		return false
	endIf
EndFunction

Function checkSoftDependencies()
    DeviousDevices_State = false
	DeviousDevices_Status = ""
    if(Game.GetModByName("Devious Devices - Assets.esm") != 255) && (Game.GetModByName("Devious Devices - Integration.esm") != 255) && (Game.GetModByName("Devious Devices - Expansion.esm") != 255) && (Game.GetModByName("Devious Devices - Contraptions.esm") != 255)
        DeviousDevices_State = true
		DeviousDevices_Status = "$Installed"
    endIf
	DeviousFollowers_State = false
	DeviousFollowers_Status = ""
    if(Game.GetModByName("DeviousFollowers.esp") != 255)
        DeviousFollowers_State = true
		DeviousFollowers_Status = "$Installed"
    endIf
	PrisonOverhaulPatched_State = false
	PrisonOverhaulPatched_Status = ""
    if(Game.GetModByName("xazPrisonOverhaulPatched.esp") != 255)
        PrisonOverhaulPatched_State = true
		PrisonOverhaulPatched_Status = "$Installed"
    endIf
	SexLabAroused_State = false
	SexLabAroused_Status = ""
	if(Game.GetModByName("SexLabAroused.esm") != 255)
        SexLabAroused_State = true
		SexLabAroused_Status = "$Installed"
    endIf
	SlaveTats_State = false
	SlaveTats_Status = ""
	if(Game.GetModByName("SlaveTats.esp") != 255)
        SlaveTats_State = true
		SlaveTats_Status = "$Installed"
    endIf
	DeviousInterests_State = false
	DeviousInterests_Status = ""
    if(Game.GetModByName("DeviousInterests.esp") != 255)
        DeviousInterests_State = true
		DeviousInterests_Status = "$Installed"
    endIf
	OStim_State = false
	OStim_Status = ""
    if(Game.GetModByName("OStim.esp") != 255)
        OStim_State = true
		OStim_Status = "$Installed"
    endIf
	PrisonAlternative_State = false
	PrisonAlternative_Status = ""
	if(Game.GetModByName("PamaPrisonAlternative.esm") != 255)
        PrisonAlternative_State = true
		PrisonAlternative_Status = "$Installed"
    endIf
	SexLab_State = false
	SexLab_Status = ""
	if(Game.GetModByName("SexLab.esm") != 255)
        SexLab_State = true
		SexLab_Status = "$Installed"
    endIf
	SimpleSlavery_State = false
	SimpleSlavery_Status = ""
	if(Game.GetModByName("SimpleSlavery.esp") != 255)
        SimpleSlavery_State = true
		SimpleSlavery_Status = "$Installed"
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
			if !ShowMessage("$ExportConfigMessage1")
				return false
			endIf
		else
			if !ShowMessage("$ExportConfigMessage2")
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
	SetIntValue(config, "Curse_FormatOverride", Curse_FormatOverride as int)

	; Auxiliary - Advanced Settings
	SetIntValue(config, "GameMessage", GameMessage as int)
	SetIntValue(config, "LogNotification", LogNotification as int)
	SetIntValue(config, "LogTrace", LogTrace as int)
	SetIntValue(config, "ConfigWarn", ConfigWarn as int)
	SetIntValue(config, "allowJailQuestNodes", allowJailQuestNodes as int)
	SetFloatValue(config, "standardEventDelay", standardEventDelay)

	Save(config)
	ShowMessage("$ExportConfigMessage3", false)
	return true
EndFunction

Bool Function importConfig()
	; Check config health
	bool IgnoredWarning = false
	if !(Load(config) && IsGood(config) && GetStringValue(config, "Mod Name") == GetModName() )
		ShowMessage("$ImportConfigMessageError1", false)
		return false
	endIf
	if GetVersion() != GetIntValue(config, "Mod Config Version") && GetModVersion() == GetStringValue(config, "Mod Version")
		ShowMessage("$ImportConfigMessageError2_{" + GetModVersion() + "_" + GetVersion() + "}_{" + GetStringValue(config, "Mod Version") + "_" + GetIntValue(config, "Mod Config Version") + "}", false)
		return false
	endIf
	if GetModVersion() != GetStringValue(config, "Mod Version")
		if ShowMessage("$ImportConfigMessage1")
			ShowMessage("$ImportConfigMessageError3_{" + GetModVersion() + "}_{" + GetStringValue(config, "Mod Version") + "}", false)
			return false
		endIf
		IgnoredWarning = true
	endIf
	if GetVersion() > GetIntValue(config, "Mod Config Version")
		if ShowMessage("$ImportConfigMessage2")
			ShowMessage("$ImportConfigMessageError4_{" + GetVersion() + "}_{" + GetIntValue(config, "Mod Config Version") + "}", false)
			return false
		endIf
		IgnoredWarning = true
	elseIf GetVersion() < GetIntValue(config, "Mod Config Version")
		if ShowMessage("$ImportConfigMessage3")
			ShowMessage("$ImportConfigMessageError5_{" + GetVersion() + "}_{" + GetIntValue(config, "Mod Config Version") + "}", false)
			return false
		endIf
		IgnoredWarning = true
	endIf

	; General - Basic Settings
	isKinkyDialogueFeatureEnabled = GetIntValue(config, "isKinkyDialogueFeatureEnabled", isKinkyDialogueFeatureEnabled as int) as Bool
	isCheckIntervalFeatureEnabled = GetIntValue(config, "isCheckIntervalFeatureEnabled", isCheckIntervalFeatureEnabled as int) as Bool
	checkInterval = GetFloatValue(config, "checkInterval", checkInterval)
	isCheckLOSFeatureEnabled = GetIntValue(config, "isCheckLOSFeatureEnabled", isCheckLOSFeatureEnabled as int) as Bool

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
	isBikiniLicenseFeatureEnabled = GetIntValue(config, "isBikiniLicenseFeatureEnabled", isBikiniLicenseFeatureEnabled as int) as Bool
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
	Curse_FormatOverride = GetIntValue(config, "Curse_FormatOverride", Curse_FormatOverride as int) as Bool

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

	if !IgnoredWarning
		ShowMessage("$ImportConfigMessage4", false)
	else
		ShowMessage("$ImportConfigMessage5", false)
	endIf
	Return true
EndFunction
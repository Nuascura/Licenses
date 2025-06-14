Scriptname BM_Licenses_Init extends Quest Hidden 

; Mod Quests
Quest Property kzadAPI auto hidden
Quest Property kzadxAPI auto hidden

Bool Function CheckHardDependencies(BM_Licenses_MCM bmlmcm)
	if SKSE.GetPluginVersion("powerofthree's Papyrus Extender") != -1 && (PO3_SKSEFunctions.GetPapyrusExtenderVersion()[0] >= 5)
		bmlmcm.PapyrusExtender_Status = "$LPO_Installed"
	else
		bmlmcm.PapyrusExtender_Status = "$LPO_Null"
	endIf
	if (SKSE.GetPluginVersion("PapyrusUtil") != -1 || SKSE.GetPluginVersion("papyrusutil plugin") != -1) && (PapyrusUtil.GetVersion() >= 30)
		bmlmcm.PapyrusUtil_Status = "$LPO_Installed"
	else
		bmlmcm.PapyrusUtil_Status = "$LPO_Null"
	endIf
	if SKSE.GetPluginVersion("ScrabsPapyrusExtender") >= 0x01020000
		bmlmcm.ScrabsPapyrusExtender_Status = "$LPO_Installed"
	else
		bmlmcm.ScrabsPapyrusExtender_Status = "$LPO_Null"
	endIf

	if bmlmcm.PapyrusExtender_Status == "$LPO_Installed" && bmlmcm.PapyrusUtil_Status == "$LPO_Installed" && bmlmcm.ScrabsPapyrusExtender_Status == "$LPO_Installed"
		return true
	else
		return false
	endIf
EndFunction

Function CheckSoftDependencies(BM_Licenses_MCM bmlmcm)
    bmlmcm.DeviousDevices_State = false
	bmlmcm.DeviousDevices_Status = ""
    if (Game.GetModByName("Devious Devices - Assets.esm") != 255) \ 
	&& (Game.GetModByName("Devious Devices - Integration.esm") != 255) \ 
	&& (Game.GetModByName("Devious Devices - Expansion.esm") != 255) \
	&& (Game.GetModByName("Devious Devices - Contraptions.esm") != 255)
        bmlmcm.DeviousDevices_State = true
		bmlmcm.DeviousDevices_Status = "$LPO_Installed"
    endIf
	bmlmcm.DeviousFollowers_State = false
	bmlmcm.DeviousFollowers_Status = ""
    if (Game.GetModByName("DeviousFollowers.esp") != 255)
        bmlmcm.DeviousFollowers_State = true
		bmlmcm.DeviousFollowers_Status = "$LPO_Installed"
    endIf
	bmlmcm.PrisonOverhaulPatched_State = false
	bmlmcm.PrisonOverhaulPatched_Status = ""
    if (Game.GetModByName("xazPrisonOverhaulPatched.esp") != 255)
        bmlmcm.PrisonOverhaulPatched_State = true
		bmlmcm.PrisonOverhaulPatched_Status = "$LPO_Installed"
    endIf
	bmlmcm.SexLabAroused_State = false
	bmlmcm.SexLabAroused_Status = ""
	if (Game.GetModByName("SexLabAroused.esm") != 255)
        bmlmcm.SexLabAroused_State = true
		bmlmcm.SexLabAroused_Status = "$LPO_Installed"
    endIf
	bmlmcm.SlaveTats_State = false
	bmlmcm.SlaveTats_Status = ""
	if (Game.GetModByName("SlaveTats.esp") != 255)
        bmlmcm.SlaveTats_State = true
		bmlmcm.SlaveTats_Status = "$LPO_Installed"
    endIf
	bmlmcm.DeviousInterests_State = false
	bmlmcm.DeviousInterests_Status = ""
    if (Game.GetModByName("DeviousInterests.esp") != 255)
        bmlmcm.DeviousInterests_State = true
		bmlmcm.DeviousInterests_Status = "$LPO_Installed"
    endIf
	bmlmcm.OStim_State = false
	bmlmcm.OStim_Status = ""
    if (Game.GetModByName("OStim.esp") != 255)
        bmlmcm.OStim_State = true
		bmlmcm.OStim_Status = "$LPO_Installed"
    endIf
	bmlmcm.PrisonAlternative_State = false
	bmlmcm.PrisonAlternative_Status = ""
	if (Game.GetModByName("PamaPrisonAlternative.esm") != 255)
        bmlmcm.PrisonAlternative_State = true
		bmlmcm.PrisonAlternative_Status = "$LPO_Installed"
    endIf
	bmlmcm.SexLab_State = false
	bmlmcm.SexLab_Status = ""
	if (Game.GetModByName("SexLab.esm") != 255)
        bmlmcm.SexLab_State = true
		bmlmcm.SexLab_Status = "$LPO_Installed"
    endIf
	bmlmcm.SimpleSlavery_State = false
	bmlmcm.SimpleSlavery_Status = ""
	if (Game.GetModByName("SimpleSlavery.esp") != 255)
        bmlmcm.SimpleSlavery_State = true
		bmlmcm.SimpleSlavery_Status = "$LPO_Installed"
    endIf

	SetInternalVariables(bmlmcm)
EndFunction

Function SetInternalVariables(BM_Licenses_MCM bmlmcm)
	if bmlmcm.DeviousDevices_State
		kzadAPI = Quest.GetQuest("zadQuest") ; 0x00F624
        kzadxAPI = Quest.GetQuest("zadxQuest") ; 0x00CA01
	endIf
EndFunction
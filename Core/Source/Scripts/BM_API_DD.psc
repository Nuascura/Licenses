Scriptname BM_API_DD

Function equipRestraint(actor player, int ddEquipChance, int ddFilter) global
    zadLibs libs = (Game.GetFormFromFile(0x00F624, "Devious Devices - Integration.esm") as Quest) as zadLibs
    zadDeviceLists DeviceLists = (Game.GetFormFromFile(0x00CA01, "Devious Devices - Expansion.esm") as Quest) as zadDeviceLists
    BM_Licenses_Utility bmlUtility = Quest.GetQuest("BM_Licenses_Utility") as BM_Licenses_Utility
    int random = 0
    int randomDeviceList = 0
    armor randomDevice = None
    LeveledItem selectedDeviceList = None

    ; ddFilter: 0 = Disabled, 1 = Limited, 2 = Standard, 3 = Standard + Restrictive

    random = Utility.RandomInt(1,100)
    if (random <= ddEquipChance)
        if ddFilter <= 0
            randomDevice = DeviceLists.GetRandomDevice(DeviceLists.zad_dev_all)
        elseIf ddFilter == 1
            Armor[] devices = new Armor[8]
            devices[0] = libs.cuffsPaddedArms
            devices[1] = libs.cuffsPaddedLegs
            devices[2] = libs.gagball
            devices[3] = libs.corset
            devices[4] = libs.gagring
            devices[5] = libs.plugSoulgemVag
            devices[6] = libs.plugInflatableAn
            devices[7] = libs.cuffsPaddedCollar
            randomDevice = devices[Utility.RandomInt(0, devices.Length - 1)]
        else ; Get random device type
            random = Utility.RandomInt(1,2)
            if random == 2 && ddFilter == 3
                LeveledItem[] restrictive = new LeveledItem[11]
                restrictive[0] = DeviceLists.zad_dev_ankleshackles
                restrictive[1] = DeviceLists.zad_dev_armbinders
                restrictive[2] = DeviceLists.zad_dev_bb_yokes
                restrictive[3] = DeviceLists.zad_dev_blindfolds
                restrictive[4] = DeviceLists.zad_dev_boxbinders
                restrictive[5] = DeviceLists.zad_dev_elbowbinders
                restrictive[6] = DeviceLists.zad_dev_elbowshackles
                restrictive[7] = DeviceLists.zad_dev_gags
                restrictive[8] = DeviceLists.zad_dev_legrestraints
                restrictive[9] = DeviceLists.zad_dev_wristshackles
                restrictive[10] = DeviceLists.zad_dev_yokes
                randomDeviceList = Utility.RandomInt(0, restrictive.Length - 1)
                selectedDeviceList = restrictive[randomDeviceList]
            else
                LeveledItem[] standard = new LeveledItem[9]
                standard[0] = DeviceLists.zad_dev_armcuffs
                standard[1] = DeviceLists.zad_dev_boots
                standard[2] = DeviceLists.zad_dev_collars
                standard[3] = DeviceLists.zad_dev_corsets
                standard[4] = DeviceLists.zad_dev_gloves
                standard[5] = DeviceLists.zad_dev_harnesses
                standard[6] = DeviceLists.zad_dev_legcuffs
                standard[7] = DeviceLists.zad_dev_piercings
                standard[8] = DeviceLists.zad_dev_plugs
                randomDeviceList = Utility.RandomInt(0, standard.Length - 1)
                selectedDeviceList = standard[randomDeviceList]
            endIf
            randomDevice = DeviceLists.GetRandomDevice(selectedDeviceList)
        endIf

        if (deviceValidator(libs, player, randomDevice))
            bmlUtility.LogTrace("Device Validated: " + randomDevice.GetName() + ", " + randomDevice.GetFormID())
            LockDeviceAndWait(libs, player, randomDevice, libs.GetDeviceKeyword(randomDevice))
            bmlUtility.LogTrace("devicekeyword: " + libs.GetDeviceKeyword(randomDevice))
        else
            bmlUtility.LogTrace("Device Failed to Validate: " + randomDevice.GetName() + ", " + randomDevice.GetFormID())
        endIf
    endIf
EndFunction

Function RefreshCollar(actor player, enchantment effect = none) global
    ; this equips a new collar of the same kind
    zadLibs libs = (Game.GetFormFromFile(0x00F624, "Devious Devices - Integration.esm") as Quest) as zadLibs
    armor WornDevice = none
    if player.WornHasKeyword(libs.zad_DeviousCollar)
        WornDevice = libs.GetWornDevice(player, libs.zad_DeviousCollar)
        UnlockDeviceAndWait(libs, player, WornDevice, none, libs.zad_DeviousCollar, true)
    endIf
    if (deviceValidator(libs, player, WornDevice))
        ObjectReference WornDeviceRef = player.PlaceAtMe(WornDevice, abInitiallyDisabled = true)
        if WornDeviceRef
            if effect
                WornDeviceRef.SetEnchantment(effect, 0)
                WornDeviceRef.SetDisplayName("Cursed " + WornDevice.GetName())
            endIf
            player.AddItem(WornDeviceRef)
            LockDeviceAndWait(libs, player, WornDevice, libs.zad_DeviousCollar, true)
            WornDeviceRef.delete()
        endIf
    endIf
EndFunction

Function RenewCollar(actor player, enchantment effect = none, int ddFilter) global
    ; this equips a totally new collar
    zadLibs libs = (Game.GetFormFromFile(0x00F624, "Devious Devices - Integration.esm") as Quest) as zadLibs
    zadDeviceLists DeviceLists = (Game.GetFormFromFile(0x00CA01, "Devious Devices - Expansion.esm") as Quest) as zadDeviceLists
    armor randomDevice = None
    if player.WornHasKeyword(libs.zad_DeviousCollar)
        UnlockDeviceAndWait(libs, player, libs.GetWornDevice(player, libs.zad_DeviousCollar), zad_DeviousDevice = libs.zad_DeviousCollar, destroyDevice = true)
    endIf
    if ddFilter == 1
        randomDevice = libs.cuffsPaddedCollar
    else
        randomDevice = DeviceLists.GetRandomDevice(DeviceLists.zad_dev_collars)
    endIf
    if (deviceValidator(libs, player, randomDevice))
        ObjectReference randomDeviceRef = player.PlaceAtMe(randomDevice, abInitiallyDisabled = true)
        if randomDeviceRef
            if effect
                randomDeviceRef.SetEnchantment(effect, 0)
                randomDeviceRef.SetDisplayName("Cursed " + randomDevice.GetName())
            endIf
            player.AddItem(randomDeviceRef)
            LockDeviceAndWait(libs, player, randomDevice, libs.zad_DeviousCollar, true)
            randomDeviceRef.delete()
        endIf
    endIf
EndFunction

Function RemoveCollar(actor player) global
    zadLibs libs = (Game.GetFormFromFile(0x00F624, "Devious Devices - Integration.esm") as Quest) as zadLibs
    if player.WornHasKeyword(libs.zad_DeviousCollar)
        libs.UnlockDeviceByKeyword(player, libs.zad_DeviousCollar, true)
    endIf
EndFunction

Function equipCollar(actor player, int ddFilter) global
    zadLibs libs = (Game.GetFormFromFile(0x00F624, "Devious Devices - Integration.esm") as Quest) as zadLibs
    zadDeviceLists DeviceLists = (Game.GetFormFromFile(0x00CA01, "Devious Devices - Expansion.esm") as Quest) as zadDeviceLists
    armor randomDevice = None
    if ddFilter == 1
        randomDevice = libs.cuffsPaddedCollar
    else
        randomDevice = DeviceLists.GetRandomDevice(DeviceLists.zad_dev_collars)
    endIf
    if (deviceValidator(libs, player, randomDevice))
        LockDeviceAndWait(libs, player, randomDevice, libs.GetDeviceKeyword(randomDevice))
    endIf
EndFunction

Bool Function hasCollarEquipped(actor player) global
    zadLibs libs = (Game.GetFormFromFile(0x00F624, "Devious Devices - Integration.esm") as Quest) as zadLibs
    if player.WornHasKeyword(libs.zad_deviousCollar)
        return true
    endIf
    return false
EndFunction

Bool Function deviceValidator(zadLibs libs, actor player, armor device) global
    
    if (device == none) 
        return false
    endIf

    ; first pass. Based on @Taki17's din_Utility.ValidateRestraint(). Exceptions validator
    If device.HasKeyword( libs.zad_DeviousCuffsFront )
		If player.WornHasKeyword( libs.zad_DeviousHeavyBondage )
            return false
        elseIf device.HasKeyword( libs.zad_DeviousCollar ) ;account for prisoner chains
			Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousArmCuffs ) && !player.WornHasKeyword( libs.zad_DeviousLegCuffs )
		ElseIf !device.HasKeyword( libs.zad_DeviousCollar )
			Return !player.WornHasKeyword(libs.GetDeviceKeyword(device))
		EndIf
	ElseIf device.HasKeyword( libs.zad_DeviousPetSuit )
		Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousHeavyBondage )
	ElseIf device.HasKeyword( libs.zad_DeviousBra )
		Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousYokeBB )
	ElseIf device.HasKeyword( libs.zad_DeviousElbowTie )
		Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousHobbleSkirt )
	ElseIf device.HasKeyword( libs.zad_DeviousHobbleSkirt )
		Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousElbowTie )
	ElseIf device.HasKeyword( libs.zad_DeviousHarness )
        if device.HasKeyword( libs.zad_DeviousCollar ) && player.WornHasKeyword( libs.zad_DeviousCollar )
            Return false
        elseIf device.HasKeyword( libs.zad_DeviousBelt ) && player.WornHasKeyword( libs.zad_DeviousBelt )
            Return false
        else
		    Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousCorset )
        endIf
	ElseIf device.HasKeyword( libs.zad_DeviousBondageMittens )
		Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousGloves )
	ElseIf device.HasKeyword( libs.zad_DeviousCorset ) 
		Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousHarness )
	ElseIf device.HasKeyword( libs.zad_DeviousPiercingsNipple )
		Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousBra )
	ElseIf device.HasKeyword( libs.zad_DeviousPiercingsVaginal )
		Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousBelt )
	ElseIf device.HasKeyword( libs.zad_DeviousPlugVaginal )
		Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousBelt )
	ElseIf device.HasKeyword( libs.zad_DeviousPlugAnal )
		Return !player.WornHasKeyword(libs.GetDeviceKeyword(device)) && !player.WornHasKeyword( libs.zad_DeviousBelt )
    else
        Return !player.WornHasKeyword(libs.GetDeviceKeyword(device))
	EndIf

    return false
EndFunction

Function LockDeviceAndWait(zadLibs libs, actor akActor, armor deviceInventory, keyword zad_DeviousDevice, bool force = false) global
	if libs.LockDevice(akActor, deviceInventory, force)
        int counter = 5
        while !akActor.WornHasKeyword(zad_DeviousDevice) && counter > 0
            Utility.Wait(0.1)
            counter -= 1
        endWhile
    endIf
EndFunction

Function UnlockDeviceAndWait(zadLibs libs, actor akActor, armor deviceInventory, armor deviceRendered = none, keyword zad_DeviousDevice = none, bool destroyDevice = false, bool genericonly = false) global
    if libs.UnlockDevice(akActor, deviceInventory, deviceRendered, zad_DeviousDevice, destroyDevice, genericonly)
        int counter = 5
        while akActor.WornHasKeyword(zad_DeviousDevice) && counter > 0
            Utility.Wait(0.1)
            counter -= 1
        endWhile
    endIf
EndFunction
Scriptname BM_ME_HostLicenseTemplateBridge extends activemagiceffect  

BM_Licenses Property licenses Auto
BM_Licenses_Utility Property bmlUtility Auto

Function InventoryStateChange(Bool heldState)
    bmlUtility.LogTrace("Failed to process new license inventory state. Host MGEF is associated with an unsigned license.")
EndFunction

Bool Function IsLicenseActive()
    bmlUtility.LogTrace("Failed to get license activation state. Host MGEF is associated with an unsigned license.")
    return FALSE
EndFunction

Function PushStatusUpdate(Bool abHeldState, Int ID)
    InventoryStateChange(abHeldState)
    if abHeldState
        bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseAdded", ID)
    else
        bmlUtility.SendCustomEvent_SingleInt("BM-LPO_LicenseRemoved", ID)
    endIf
    bmlUtility.bmlModeratorAlias.RefreshLicenseValidity()
EndFunction

; ------------------------------

State LicenseBridge_1
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasArmorLicense
            licenses.ArmorLicense = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.armorLicenseExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_2
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasBikiniLicense
            licenses.BikiniLicense = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.bikiniLicenseExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_3
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasBikiniExemption
            licenses.BikiniExemption = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.bikiniExemptionExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_4
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasClothingLicense
            licenses.ClothingLicense = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.clothingLicenseExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_5
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasMagicLicense
            licenses.MagicLicense = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.magicLicenseExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_6
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasWeaponLicense
            licenses.WeaponLicense = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.weaponLicenseExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_7
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasCraftingLicense
            licenses.CraftingLicense = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.craftingLicenseExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_8
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasTravelPermit
            licenses.TravelPermit = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.travelPermitExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_9
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasCollarExemption
            licenses.CollarExemption = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.collarExemptionExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_10
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasInsurance
            licenses.Insurance = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.insuranceExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_11
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasCurfewExemption
            licenses.CurfewExemption = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.curfewExemptionExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_12
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasTradingLicense
            licenses.TradingLicense = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.tradingLicenseExpirationTime != -1.0)
    EndFunction
EndState
State LicenseBridge_13
    Function InventoryStateChange(Bool heldState)
        If heldState != licenses.hasWhoreLicense
            licenses.WhoreLicense = heldState
        EndIf
    EndFunction
    Bool Function IsLicenseActive()
        return (licenses.whoreLicenseExpirationTime != -1.0)
    EndFunction
EndState
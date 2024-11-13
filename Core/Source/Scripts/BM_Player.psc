Scriptname BM_Player extends ReferenceAlias

BM_Licenses Property licenses auto
BM_Licenses_Utility Property bmlUtility Auto
BM_Licenses_MCM Property bmlmcm auto

Event OnPlayerLoadGame()
    RegisterForAnimationEvent(self.GetActorRef(), "MRh_SpellFire_Event")
    RegisterForAnimationEvent(self.GetActorRef(), "MLh_SpellFire_Event")
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
    Actor playerActor = self.GetActorRef()
    if !licenses.isMagicViolation && (licenses.hasMagicLicense == false || licenses.isInsured == false)
        if bmlUtility.ValidateSpellForms(playerActor, playerActor.GetEquippedSpell(0), playerActor.GetEquippedSpell(1))
            if (licenses.hasMagicLicense == true && licenses.isInsured == false)
                licenses.isUninsuredViolation = true
            endIf
            licenses.isMagicViolation = true
            bmlUtility.LogTrace("Detected Magic Violation (Spell): " + playerActor.GetEquippedSpell(0) + ", " + playerActor.GetEquippedSpell(1))
            bmlUtility.AggregateViolations()
        endIf
    endIf
EndEvent

Event OnSpellCast(Form akSpell)
    Spell SpellCast = akSpell as Spell
    if SpellCast && PO3_SKSEFunctions.GetSpellType(SpellCast) == 11
        if !licenses.isMagicViolation && (licenses.hasMagicLicense == false || licenses.isInsured == false)
            if (licenses.hasMagicLicense == true && licenses.isInsured == false)
                licenses.isUninsuredViolation = true
            endIf
            licenses.isMagicViolation = true
            bmlUtility.LogTrace("Detected Magic Violation (Shout): " + akSpell)
            bmlUtility.AggregateViolations()
        endIf
    endIf
EndEvent

Event OnObjectEquipped(Form item, ObjectReference akReference)
    if (item as Armor || item as Spell || item as Weapon || item as Ammo)
        CheckViolations()
    endIf
endEvent

Event OnObjectUnEquipped(Form item, ObjectReference akReference)
    if (item as Armor || item as Spell || item as Weapon || item as Ammo)
        CheckViolations()
    endIf
endEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    if akOldLoc || akNewLoc
        CheckViolations()
    endIf
EndEvent

Function CheckViolations()
    RegisterForSingleUpdate(bmlmcm.standardEventDelay)
EndFunction

Event OnUpdate()
    bmlUtility.ConsiderViolationCheck()
    if (bmlmcm.isCheckIntervalFeatureEnabled)
        RegisterForSingleUpdate(bmlmcm.checkInterval)
    endIf
EndEvent

Event OnPlayerFastTravelEnd(float afTravelGameTimeHours)
    if afTravelGameTimeHours > 0.1
        bmlUtility.licenseBountyQuest.stop()
        licenses.ResetViolations(-1)
    endIf
EndEvent
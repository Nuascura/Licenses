Scriptname BM_API_ST

String[] Function LockCursedTattoos(Actor target, String[] CursedTattoos) global
    BM_Licenses_MCM bmlmcm = Quest.GetQuest("BM_Licenses_MCM") as BM_Licenses_MCM

    int template = 0
    int matches = 0
    int tattoo = 0

    int i = 0
    while i < CursedTattoos.Length
        if CursedTattoos[i]
            template = JValue.addToPool(JMap.object(), "SlaveTats_Licenses")
            matches = JValue.addToPool(JArray.object(), "SlaveTats_Licenses")
            JMap.setStr(template, "section", "Licenses")
            JMap.setStr(template, "name", CursedTattoos[i])

            if !SlaveTats.query_available_tattoos(template, matches)
                tattoo = JValue.addToPool(JArray.getObj(matches, 0), "SlaveTats_Licenses")
                JMap.setInt(tattoo, "color", bmlmcm.Curse_Color)
                JMap.setInt(tattoo, "glow", bmlmcm.Curse_Glow)
                JMap.setFlt(tattoo, "invertedAlpha", 1.0 - bmlmcm.Curse_Alpha)
                JMap.setInt(tattoo, "locked", 1)
                JArray.clear(matches)
                if !SlaveTats.query_applied_tattoos(target, template, matches) && !(JArray.count(matches) > 0)
                    SlaveTats.add_tattoo(target, tattoo, -1, true, true)
                endIf
            endIf
        endIf
        i += 1
    endWhile
    SlaveTats.synchronize_tattoos(target, true)
    JValue.cleanPool("SlaveTats_Licenses")

    return CursedTattoos
EndFunction

String[] Function UnlockCursedTattoos(Actor target, String[] CursedTattoosActive) global
    
    int template = 0
    int matches = 0
    int tattoo = 0

    int i = 0
    while i < CursedTattoosActive.Length
        if CursedTattoosActive[i]
            template = JValue.addToPool(JMap.object(), "SlaveTats_Licenses")
            matches = JValue.addToPool(JArray.object(), "SlaveTats_Licenses")
            JMap.setStr(template, "section", "Licenses")
            JMap.setStr(template, "name", CursedTattoosActive[i])
            if !SlaveTats.query_applied_tattoos(target, template, matches) && !(JArray.count(matches) == 0)
                tattoo = JValue.addToPool(JArray.getObj(matches, 0), "SlaveTats_Licenses")
                SlaveTats.remove_tattoos(target, tattoo, true, true)
            endIf
        endIf
        i += 1
    endWhile

    SlaveTats.synchronize_tattoos(target, true)
    JValue.cleanPool("SlaveTats_Licenses")

    return new String[7]
EndFunction
Scriptname BM_Licenses_WorldspaceCheck extends Quest  

ReferenceAlias Property Door_0 auto
ReferenceAlias Property Door_1 auto
ReferenceAlias Property Door_2 auto
ReferenceAlias Property Door_3 auto
ReferenceAlias Property Door_4 auto

WorldSpace Function Run()
    ObjectReference[] DoorList = new ObjectReference[5]
    DoorList[0] = Door_0.GetReference()
    DoorList[1] = Door_1.GetReference()
    DoorList[2] = Door_2.GetReference()
    DoorList[3] = Door_3.GetReference()
    DoorList[4] = Door_4.GetReference()

    int i = 0
    Worldspace CurrExteriorSpace
    while i < DoorList.Length
        if DoorList[i] && PO3_SKSEFunctions.IsLoadDoor(DoorList[i])
            CurrExteriorSpace = PO3_SKSEFunctions.GetDoorDestination(DoorList[i]).GetWorldSpace()
            if CurrExteriorSpace
                return CurrExteriorSpace
            endIf
        endIf
        i += 1
    EndWhile
    return none
EndFunction
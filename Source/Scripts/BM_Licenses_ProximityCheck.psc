Scriptname BM_Licenses_ProximityCheck extends Quest  

ReferenceAlias Property followerRef auto

Bool Function Run()
    if followerRef.GetActorRef()
        return true
    endIf
    return false
EndFunction
Scriptname BM_Licenses_ThaneshipCheck extends Quest  

BM_Licenses Property licenses auto

ReferenceAlias Property WhiterunGuardImperial auto
ReferenceAlias Property WhiterunGuardSons auto
ReferenceAlias Property WinterholdGuardImperial auto
ReferenceAlias Property WinterholdGuardSons auto
ReferenceAlias Property RiftGuardImperial auto
ReferenceAlias Property RiftGuardSons auto
ReferenceAlias Property ReachGuardImperial auto
ReferenceAlias Property ReachGuardSons auto
ReferenceAlias Property PaleGuardImperial auto
ReferenceAlias Property PaleGuardSons auto
ReferenceAlias Property HjaalmarchGuardImperial auto
ReferenceAlias Property HjaalmarchGuardSons auto
ReferenceAlias Property HaafingarGuardImperial auto
ReferenceAlias Property HaafingarGuardSons auto
ReferenceAlias Property FalkreathGuardImperial auto
ReferenceAlias Property FalkreathGuardSons auto
ReferenceAlias Property EastmarchGuardImperial auto
ReferenceAlias Property EastmarchGuardSons auto

Bool Function Run()
    if WhiterunGuardImperial.GetActorRef() || WhiterunGuardSons.GetActorRef()
        licenses.isWhiterunThane = true
        return true
    elseIf WinterholdGuardImperial.GetActorRef() || WinterholdGuardSons.GetActorRef()
        licenses.isWinterholdThane = true
        return true
    elseIf RiftGuardImperial.GetActorRef() || RiftGuardSons.GetActorRef()
        licenses.isRiftThane = true
        return true
    elseIf ReachGuardImperial.GetActorRef() || ReachGuardSons.GetActorRef()
        licenses.isReachThane = true
        return true
    elseIf PaleGuardImperial.GetActorRef() || PaleGuardSons.GetActorRef()
        licenses.isPaleThane = true
        return true
    elseIf HjaalmarchGuardImperial.GetActorRef() ||  HjaalmarchGuardSons.GetActorRef()
        licenses.isHjaalmarchThane = true
        return true
    elseIf HaafingarGuardImperial.GetActorRef() || HaafingarGuardSons.GetActorRef()
        licenses.isHaafingarThane = true
        return true
    elseIf FalkreathGuardImperial.GetActorRef() || FalkreathGuardSons.GetActorRef()
        licenses.isFalkreathThane = true
        return true
    elseIf EastmarchGuardImperial.GetActorRef() || EastmarchGuardSons.GetActorRef()
        licenses.isEastmarchThane = true
        return true
    endIf
    return false
EndFunction
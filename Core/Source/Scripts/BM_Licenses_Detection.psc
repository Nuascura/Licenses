Scriptname BM_Licenses_Detection extends Quest  

BM_Licenses Property licenses auto
ReferenceAlias Property playerRef auto
ReferenceAlias Property enforcerRef_1 auto
ReferenceAlias Property enforcerRef_2 auto
ReferenceAlias Property enforcerRef_3 auto
ReferenceAlias Property enforcerRef_4 auto
ReferenceAlias Property enforcerRef_5 auto

Actor[] EnforcerActors
ReferenceAlias[] EnforcerAliases

bool Property isDetected = false auto

Function Setup()
    Actor playerActor = playerRef.GetActorRef()
    SetActorArray()
    int i = 0
    while i < EnforcerActors.Length
        if EnforcerActors[i]
            RegisterForSingleLOSGain(EnforcerActors[i], playerActor)
        endIf
        i += 1
    endWhile
    RegisterForSingleUpdate(15) ; time out after 15 seconds
    licenses.bmlUtility.LogTrace("Alias setup valid. Running periodic detection update event.")
EndFunction

Event OnGainLOS(Actor akViewer, ObjectReference akTarget)
    isDetected = true
    licenses.bmlUtility.LogTrace("LOS Detection: Player was detected by enforcer " + akViewer)
    RegisterForSingleUpdate(1.0)
EndEvent

Event OnUpdate()
    if isDetected
        SendModEvent("BM-LPO_ReporterLOSGain")
        licenses.bmlUtility.startViolationCheckQuest()
    else
        licenses.bmlUtility.LogTrace("Stopping detection quest due to time out.")
    endIf
    self.stop()
EndEvent

Function SetActorArray()
    EnforcerActors = new Actor[5]
    EnforcerActors[0] = enforcerRef_1.GetActorRef()
    EnforcerActors[1] = enforcerRef_2.GetActorRef()
    EnforcerActors[2] = enforcerRef_3.GetActorRef()
    EnforcerActors[3] = enforcerRef_4.GetActorRef()
    EnforcerActors[4] = enforcerRef_5.GetActorRef()
EndFunction
;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname BM_D_ItemRetrieval_Kinky Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
ItemRetrievalActor.ShowGiftMenu(false, none, true, false)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
licenses.BM_ItemConfiscationChest.RemoveAllItems(ItemRetrievalActor, false, true)
Form[] ValidatedForms = PapyrusUtil.MergeFormArray(licenses.bmlUtility.ScanInventory_Base(ItemRetrievalActor), licenses.bmlUtility.ScanInventory_Ench(ItemRetrievalActor), true)
PyramidUtils.RemoveForms(ItemRetrievalActor, ValidatedForms, licenses.BM_ItemConfiscationChest)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

BM_Licenses Property licenses Auto
Actor Property ItemRetrievalActor Auto
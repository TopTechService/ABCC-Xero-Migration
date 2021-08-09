trigger trg_attachment on Attachment (After insert,After update,before delete) {
	List<Event_Sponsor__c> lstSponsorToBeUpdated = new List<Event_Sponsor__c>();
    
    Map<Id,Attachment> allParentIdToAttachments = new Map<Id,Attachment>();
    
    if(Trigger.IsDelete)
    {
       for(Attachment att : Trigger.old){
            if((att.ParentId != null || att.ParentId != '')){
                String sObjName = att.ParentId.getSObjectType().getDescribe().getName();
                If('Event_Sponsor__c' == sObjName){
                    allParentIdToAttachments.put(att.ParentId, att);
                }
            }
    	}
    }
    else {
       for(Attachment att : Trigger.new){
            if((att.ParentId != null || att.ParentId != '')){
                String sObjName = att.ParentId.getSObjectType().getDescribe().getName();
                If('Event_Sponsor__c' == sObjName){
                    allParentIdToAttachments.put(att.ParentId, att);
                }
            }
    	}        
    }
    
    If(!allParentIdToAttachments.isEmpty()){
        List<Event_Sponsor__c> lstSponsor = [SELECT Id,Logo_Image_Link__c FROM Event_Sponsor__c WHERE Id IN :allParentIdToAttachments.keySet()];
        if(!lstSponsor.isEmpty()){
            for(Event_Sponsor__c sponser : lstSponsor)
            {
                If(Trigger.IsDelete){
                    sponser.Logo_Image_Link__c = '';
                    lstSponsorToBeUpdated.add(sponser);
                }else{
                    sponser.Logo_Image_Link__c = allParentIdToAttachments.get(sponser.Id).Id;
                    lstSponsorToBeUpdated.add(sponser);
                }
            }
        }
    }
    
    if(!lstSponsorToBeUpdated.isEmpty()){
        update lstSponsorToBeUpdated;
    }
}
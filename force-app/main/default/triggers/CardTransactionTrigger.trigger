trigger CardTransactionTrigger on Card_Transaction__c (after insert) {

    List<Card_Transaction__c> transactionList = new List<Card_Transaction__c>();
    Set<Id> oppIdForSuccess = new Set<Id>();
    Set<Id> oppIdForFailed = new Set<Id>();
    Set<Id> oppIdForRefund = new Set<Id>();
    List<Opportunity> paymentSuccessOpps = new List<Opportunity>();
    List<Event_Registration__c> successEventRegistration = new List<Event_Registration__c>();
    List<Event_Registration__c> failedEventRegistration = new List<Event_Registration__c>();
    List<Event_Registration__c> updatedEventRegistration = new List<Event_Registration__c>();
    Messaging.SingleEmailMessage[] mails = new List<Messaging.SingleEmailMessage>();
    List<CampaignMember> campaignMembersToUpsert = new list<CampaignMember>();
    List<string> SuccessContactIds = new List<string>();
    Public String campMemberStatusReg = 'Registered';
    List<Id> SuccessCampaignIds = new List<Id>();
    
    //getting applicable opportunity IDs
    for(Card_Transaction__c obj : Trigger.new){
        if(!String.isBlank(obj.Opportunity__c) && obj.Transaction_Status__c == 'SUCCESSFUL' && obj.Transaction_Type__c == 'SALE'){
            oppIdForSuccess.add(obj.Opportunity__c);
        } else if(!String.isBlank(obj.Opportunity__c) && obj.Transaction_Status__c == 'SUCCESSFUL' && obj.Transaction_Type__c == 'REFUND'){
            oppIdForRefund.add(obj.Opportunity__c);
        } else if(!String.isBlank(obj.Opportunity__c) && obj.Transaction_Status__c == 'FAILED' && obj.Transaction_Type__c == 'SALE'){
            oppIdForFailed.add(obj.Opportunity__c);
        }
        transactionList.add(obj);
    }
    
    //Success Opportunities
    if(!oppIdForSuccess.isEmpty()){
        // instantiate a new instance of the Queueable class
        //GenericEmailHandler sendEmailJob = new GenericEmailHandler(oppIdForSuccess);
        
        // enqueue the job for processing
        //ID jobID = System.enqueueJob(sendEmailJob);
      	
        //GenericEmailHandler.generateEmailFormat(oppIdForSuccess);
    }
    
    if(!oppIdForRefund.isEmpty()){
        GenericEmailHandler.generateEmailFormatForRefund(oppIdForRefund);
    }
    
    //getting Success Event Regestration Records
    if(!oppIdForSuccess.isEmpty()){
        successEventRegistration = [SELECT Id,Registration_Status__c, Contact__c, Quantity__c, Contact__r.FirstName, Contact__r.Email, Event_Package__r.Name, Event__r.Campaign__c From Event_Registration__c WHERE Opportunity__c In :oppIdForSuccess];    	
    }   
    
    System.debug('Anuj '+successEventRegistration);
    //updating Registration_Status__c= 'Successful'
    if(!successEventRegistration.isEmpty()){
        for(Event_Registration__c obj : successEventRegistration){
            if(obj.Contact__c != null){
                SuccessContactIds.add(obj.Contact__c);
            }
            if(obj.Event__r.Campaign__c != null){
                SuccessCampaignIds.add(obj.Event__r.Campaign__c);
            }
        }   
    }
    
    if(!successEventRegistration.isEmpty() && SuccessContactIds != null && SuccessCampaignIds != null){
        /*List<CampaignMember> cmpMembers = [Select Id, CampaignId, ContactId, Status from CampaignMember where ContactId IN: SuccessContactIds AND CampaignId IN: SuccessCampaignIds];
        System.debug('cmpMembers ' + cmpMembers + 'SuccessContactIds ' + SuccessContactIds);
        
        Map<Id, Map<Id, CampaignMember>> campaignToCampaignMem = new Map<Id, Map<Id, CampaignMember>>();
        for(CampaignMember cmpMem : cmpMembers){
            if(!campaignToCampaignMem.containsKey(cmpMem.CampaignId)){
                Map<Id, CampaignMember> temp = new Map<Id, CampaignMember>();
                temp.put(cmpMem.ContactId, cmpMem);
                campaignToCampaignMem.put(cmpMem.CampaignId, temp);
            } else {
                campaignToCampaignMem.get(cmpMem.CampaignId).put(cmpMem.ContactId, cmpMem);
            }
        }
        
        for(Event_Registration__c er : successEventRegistration){
            if(er.Contact__c != null && er.Event__r.Campaign__c != null){
                CampaignMember cm = campaignToCampaignMem != null && campaignToCampaignMem.size() > 0 ? campaignToCampaignMem.get(er.Event__r.Campaign__c).get(er.Contact__c) : null;
                if(cm != null){
                    cm.Status = campMemberStatusReg;
                    campaignMembersToUpsert.add(cm);
                }
                else{
                    CampaignMember newCmp = new  CampaignMember();
                    newCmp.CampaignId = er.Event__r.Campaign__c;
                    newCmp.ContactId = er.Contact__c;
                    newCmp.Status = campMemberStatusReg;
                    campaignMembersToUpsert.add(newCmp);
                }
            }
        }
        
        try{
            upsert campaignMembersToUpsert;
        } catch(Exception e) {
            System.debug('Campaign Member Status is not Updated to Registered.' + e);
        }*/
    }    
}
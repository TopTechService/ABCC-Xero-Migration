trigger EventRegistrationTrigger on Event_Registration__c (after insert, after update) {
	if((trigger.isInsert || trigger.isUpdate) && trigger.isAfter ){
		List<CampaignMember> campaignMembersToUpsert = new list<CampaignMember>();
	    List<string> SuccessEmails = new List<string>();
	    String campMemberStatusReg = 'Registered';
	    List<Id> SuccessCampaignIds = new List<Id>();
	    List<Event_Registration__c> successEventRegistration = new List<Event_Registration__c>();
	    Map<Id, Event_Registration__c> ers = new Map<Id, Event_Registration__c>([Select id, Event__r.Campaign__c, Email__c from Event_Registration__c where Id in : trigger.newMap.keyset()]);
		for(Event_Registration__c er : trigger.new){
			if(er.Registration_Status__c == 'Outstanding' || er.Registration_Status__c == 'Successful'){
				if(er.Email__c != null && !String.isBlank(er.Email__c)){
	                SuccessEmails.add(er.Email__c);
	            }
	            if(ers != null && ers.containsKey(er.Id) && ers.get(er.Id).Event__r.Campaign__c != null){
	                SuccessCampaignIds.add(ers.get(er.Id).Event__r.Campaign__c);
	            }
	            successEventRegistration.add(er);
			}
		}

		if(SuccessEmails != null && SuccessCampaignIds != null){
	        List<CampaignMember> cmpMembers = [Select Id, CampaignId, ContactId, Contact.Email, Status from CampaignMember where Contact.Email IN: SuccessEmails AND CampaignId IN: SuccessCampaignIds];
	        System.debug('cmpMembers ' + cmpMembers + 'SuccessEmails ' + SuccessEmails);
	        
	        Map<Id, Map<String, CampaignMember>> campaignToCampaignMem = new Map<Id, Map<String, CampaignMember>>();
	        Map<String, Id> emailToCampaignMemberContactMap = new Map<String, Id>();
	        for(CampaignMember cmpMem : cmpMembers){
	        	emailToCampaignMemberContactMap.put(cmpMem.Contact.Email, cmpMem.ContactId);
	            if(!campaignToCampaignMem.containsKey(cmpMem.CampaignId)){
	                Map<String, CampaignMember> temp = new Map<String, CampaignMember>();
	                temp.put(cmpMem.Contact.Email.toUpperCase(), cmpMem);
	                campaignToCampaignMem.put(cmpMem.CampaignId, temp);
	            } else {
	                campaignToCampaignMem.get(cmpMem.CampaignId).put(cmpMem.Contact.Email.toUpperCase(), cmpMem);
	            }
	        }
	        
	        for(Event_Registration__c er : successEventRegistration){
	            if(ers != null && ers.containsKey(er.Id) && ers.get(er.Id).Event__r.Campaign__c != null){
	                CampaignMember cm = campaignToCampaignMem != null && campaignToCampaignMem.size() > 0 && !String.isBlank(er.Email__c) ? campaignToCampaignMem.get(ers.get(er.Id).Event__r.Campaign__c).get(er.Email__c.toUpperCase()) : null;
	                if(cm != null){
	                    cm.Status = campMemberStatusReg;
	                    campaignMembersToUpsert.add(cm);
	                }
	                else{
	                	if(emailToCampaignMemberContactMap.get(er.Email__c) != null){
	                		CampaignMember newCmp = new  CampaignMember();
		                    newCmp.CampaignId = ers.get(er.Id).Event__r.Campaign__c;
		                    newCmp.ContactId = emailToCampaignMemberContactMap.get(er.Email__c);
		                    newCmp.Status = campMemberStatusReg;
		                    campaignMembersToUpsert.add(newCmp);
	                	}
	                }
	            }
	        }
	        
	        try{
	            upsert campaignMembersToUpsert;
	        } catch(Exception e) {
	            System.debug('Campaign Member Status is not Updated to Registered.' + e);
	        }
	    } 
	}
}
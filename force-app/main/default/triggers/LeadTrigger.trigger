trigger LeadTrigger on Lead (after insert, before insert, before update) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        ContactDuplicateMarker marker = new ContactDuplicateMarker();
        marker.markLeadsAsExistingContacts(trigger.new);
    }
     
    if(Trigger.isBefore && Trigger.isUpdate){
        list <Lead> leadsWithChangedEmailAddress = new list <Lead>();
        for(Lead leadRecord : Trigger.new) {
            if(leadRecord.Email != Trigger.oldMap.get(leadRecord.Id).Email && leadRecord.Email != null) {
                leadsWithChangedEmailAddress.add(leadRecord);
            }
        }
        
        ContactDuplicateMarker marker = new ContactDuplicateMarker();
        marker.markLeadsAsExistingContacts(leadsWithChangedEmailAddress);
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        list <Database.LeadConvertResult> leadConvertResultList = new list <Database.LeadConvertResult>();
        LeadConversionHelper helper = new LeadConversionHelper(trigger.new);
        leadConvertResultList.addAll(LeadConverter.convert(helper.filterLeadsToBeConvertedToExistingAccounts(), helper.getLeadIdVsExistingAccount()));
        leadConvertResultList.addAll(LeadConverter.convert(helper.filterLeadsToBeConverted()));
        set<Id> convertedContactIdSet = new set<Id>();
        system.debug('=====leadConvertResultList=====' + leadConvertResultList);
        for(Database.LeadConvertResult result : leadConvertResultList){
            convertedContactIdSet.add(result.getContactId());  
        }
        System.debug('====convertedContactIdSet======' + convertedContactIdSet);
        helper.updateConvertedContacts(convertedContactIdSet);
    }
}
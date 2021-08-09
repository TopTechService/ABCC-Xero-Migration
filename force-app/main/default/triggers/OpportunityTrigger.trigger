trigger OpportunityTrigger on Opportunity (before update) {
    if(Trigger.isUpdate && Trigger.isBefore){
        List<Event_Registration__c> erToUpdate = new List<Event_Registration__c>();
        Map<Id, Opportunity> OppsWithErs = new Map<Id, Opportunity>([Select Id, (Select Id, Registration_Status__c from Event_Registrations__r) from Opportunity Where Id IN : Trigger.newMap.keyset()]);
        for(Opportunity opp : Trigger.new){
            if(opp.StageName == 'Closed Lost'){
                for(Event_Registration__c er : OppsWithErs.get(opp.Id).Event_Registrations__r){
                    er.Registration_Status__c = 'Cancelled';
                    erToUpdate.add(er);
                }
            } else if(opp.StageName == 'Closed Won'){
                for(Event_Registration__c er : OppsWithErs.get(opp.Id).Event_Registrations__r){
                    er.Registration_Status__c = 'Successful';
                    erToUpdate.add(er);
                }
            }
        }
        System.debug('erToUpdate'+erToUpdate);
        update erToUpdate;
    }
}
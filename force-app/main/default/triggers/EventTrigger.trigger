trigger EventTrigger on Event__c (after insert, before insert, before update) {
    if((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)) {
        for(Event__c event : Trigger.New){
            if(event.Event_Start_Time__c != null){
                event.Event_Start_Date__c = event.Event_Start_Time__c.Date();
            }
        }
    }    
    if(Trigger.isAfter && Trigger.isInsert) {
        EventTriggerHandler.createPackages(Trigger.new);
        EventTriggerHandler.createTables(Trigger.new);
    }
}
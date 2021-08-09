trigger ChangeEventNameTrigger on Event__c (before insert,before update) {
     if(Trigger.isBefore && Trigger.isInsert ) {
          for(Event__c event : Trigger.New){
                 Event__c events = new Event__c();
                 event.Event_Name__c = event.Name ;
        }
    }    
    if(Trigger.isbefore && Trigger.isUpdate){
       
            for(Event__c updateevent : Trigger.new){
                Event__c oldevent = Trigger.oldMap.get(updateevent.Id);
                System.debug(oldevent);
                    if(updateevent.Name !=  oldevent.Event_Name__c ){
                       updateevent.Event_Name__c= updateevent.Name;
                   
                }
            }
        }
}
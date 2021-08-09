/**
* @Author : Arxxus Advantage 
* @Description : Contact Trigger 
*/
trigger ContactTrigger on Contact (before insert, before update) {
    if(Trigger.isBefore ) {
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.updateNonMemberSubscriptionFields(Trigger.new, Trigger.oldMap);
    } 
}
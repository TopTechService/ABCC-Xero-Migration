/*
 * @author: Arxxus 
 * @desc: Helper class to handle trigger operations.
 */
public with sharing class ContactTriggerHandler {

    /*
     *@author: Arxxus 
     *@desc: This method is responsible for updating all the Non Member state fields based on the state value.
     */
    public void updateNonMemberSubscriptionFields(list < contact > contacts, map < Id, Contact > oldContacts) {
        map <String, State_synonyms__c> stateMap = State_synonyms__c.getAll();
        map <String, String> stateVsNMStateField = new map < String, String > ();

        for (State_synonyms__c state: State_synonyms__c.getAll().values()) {
            stateVsNMStateField.put(state.name.toLowercase(), state.FieldAPIName__c);
        }

        for (Contact contactRecord: contacts) {
            if ((oldContacts == NULL || oldContacts.get(contactRecord.id).MailingState != contactRecord.MailingState 
                                     || (oldContacts.get(contactRecord.id).Nominated_Contact__c != contactRecord.Nominated_Contact__c) && contactRecord.Nominated_Contact__c == false) ) {
                system.debug('--Contact State---' + contactRecord.MailingState);
                //Reset all the checkboxes to false
                contactRecord.NSW_NonMember__c = false;
                contactRecord.VIC_NonMember__c = false;
                contactRecord.QLD_NonMember__c = false;
                contactRecord.WA_NonMember__c = false;
                contactRecord.SA_NonMember__c = false;
                contactRecord.ACT_NM__c = false;
                
                if (String.isBlank(contactRecord.MailingState))
                    continue;
                system.debug('---State Custom Settings---' + stateVsNMStateField); 
                if (stateVsNMStateField.containsKey(contactRecord.MailingState.toLowercase()) 
                    && stateVsNMStateField.get(contactRecord.MailingState.toLowercase()) != null
                    && contactRecord.Nominated_Contact__c	== false) {
                    contactRecord.put((String) stateVsNMStateField.get(contactRecord.MailingState.toLowercase()), true);
                    system.debug('---State Flag---');    
                } 
            }
            
        }
    }
}
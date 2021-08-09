/*
* @author: Arxxus
* @desc: This class is responsible for identifying the duplicate contacts
*/
public with sharing class ContactDuplicateMarker { 
	
	/*
	* @author: Arxxus
	* @desc: This method checks the existing contacts for potential duplicates.
	*		 duplicate contacts are identified based on FirstName and LastName combination.
	* 		 This method will typically update the Duplicate Contact checkbox and related duplicate
	*		 contact lookup field.
	*		 The oldest contact will be populated in the duplicate contact lookup field.
	*/
	public void markDuplicates(list <Contact> contactRecords) {
		System.debug(LoggingLevel.INFO, '@ContactDuplicateMarker No Of Contacts :- ' + contactRecords.size());
		list <Contact> contactsToBeUpdated = new list <Contact>();
		map <String, list <Contact>> uniqueNameVsContacts = new map <String, list <Contact>>();
		set <String> uniqueNames = new set <String>();
		
		//Find out the unique combinations from newly created contacts (TODAY)
		for(Contact contactRecord : contactRecords){
			if(!String.isBlank(contactRecord.Contact_Unique_Name__c)){
				uniqueNames.add(contactRecord.Contact_Unique_Name__c.toLowerCase());
				//make it case insensitive. All the keys are lowercase.
			}
		}
		
		for(Contact contactRecord : [SELECT Id, Contact_Unique_Name__c, Duplicate_Contact_Record__c, 
		       								Duplicate_Contact__c, CreatedDate
									 FROM Contact
									 WHERE Contact_Unique_Name__c IN: uniqueNames 
									 ORDER BY CreatedDate ASC]) {
									 	
			if(!String.isBlank(contactRecord.Contact_Unique_Name__c) && 
				uniqueNameVsContacts.containsKey(contactRecord.Contact_Unique_Name__c)) {
				uniqueNameVsContacts.get(contactRecord.Contact_Unique_Name__c).add(contactRecord);
			} else { 
				uniqueNameVsContacts.put(contactRecord.Contact_Unique_Name__c, new list <Contact> {contactRecord});
			}
		}
		
		for(Contact contactRecord : contactRecords){
			if(!String.isBlank(contactRecord.Contact_Unique_Name__c) && 
				uniqueNameVsContacts.containsKey(contactRecord.Contact_Unique_Name__c)) {
				//In order to avoid the loop of the same contact having self lookup.
				if(uniqueNameVsContacts.get(contactRecord.Contact_Unique_Name__c)[0].id == contactRecord.Id)
					continue;
					
				contactRecord.Duplicate_Contact__c = true;
                contactRecord.Duplicate_Contact_Record__c = uniqueNameVsContacts.get(contactRecord.Contact_Unique_Name__c)[0].id;
            	contactsToBeUpdated.add(contactRecord);
			}
		}
		
		if(!contactsToBeUpdated.isEmpty()){
        	update contactsToBeUpdated;    
        }
	}
	
	/*
	* @author: Arxxus
	* @desc: This method will check if the contact with same email already exists in the system or not.
	* 		 If contact exists then the flag on the lead called existing contact is set to true.
	*/
	public void markLeadsAsExistingContacts(list <lead> leadRecords) {
		system.debug('==== markLeadsAsExistingContacts leadRecords====' + leadRecords);
		set <String> emails = new set <String>();
		set <String> existingContactEmails = new set <String>();
		 
		for(Lead leadRecord : leadRecords){
			if(!String.isBlank(leadRecord.Email)) {
				emails.add(leadRecord.Email);
			}
		}
		
		system.debug('==== markLeadsAsExistingContacts emails====' + emails);
		for(Contact contactRecord : [SELECT Id, Email 
									 FROM Contact
									 WHERE Email IN: emails limit 50000]){
			existingContactEmails.add(contactRecord.Email);
		}
		system.debug('==== markLeadsAsExistingContacts existingContactEmails====' + existingContactEmails);
		for(Lead leadRecord : leadRecords){
			if(!String.isBlank(leadRecord.Email) && existingContactEmails.contains(leadRecord.Email)) {
				leadRecord.Existing_Contact__c = true;
			}
		}
		
		system.debug('==== markLeadsAsExistingContacts leadRecord====' + leadRecords);
	}
}
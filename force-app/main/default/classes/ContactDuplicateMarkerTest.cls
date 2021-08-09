/*
* Test class for ContactDuplicateMarker 
**/
@isTest
public class ContactDuplicateMarkerTest { 
	
	public static testmethod void testMarkDuplicates(){
		List<Contact> contacts = DataFactory.getInsertedContacts(10);
		System.debug('==Contacts===' + Contacts);
		Set<Id> contactIdSet = new Set<Id>();
		for (contact con : contacts){
			contactIdSet.add(con.id);    
		}
		System.debug('==contactIdSet===' + contactIdSet);
		Test.startTest();
			ContactDuplicateMarker marker = new ContactDuplicateMarker();
			marker.markDuplicates(contacts);
		Test.stopTest();
		
		List<contact> contatcList = DataFactory.getExistingContacts(contactIdSet);
		System.debug('==contatcList=' + contatcList);
		List<Contact> duplicateContactList = new List<Contact>();
		for (Contact con : contatcList){
			System.debug('=con==' + con.Duplicate_Contact__c + '==con uniqueName==' +con.Contact_Unique_Name__c);
			if (con.Duplicate_Contact__c == true ){
				duplicateContactList.add(con);
			}
		}
		System.assertEquals( duplicateContactList.size(), 9);
	}		

	// Test if Lead with same email id is present on the contact then that lead should be marked is existing contact  
	public static testmethod void testMarkLeadsAsExistingContacts(){
		List<Contact> contacts = DataFactory.getCreatedContacts(10);
		Integer counter = 0;
		for (contact con : contacts){
			con.email = 'abc'+String.valueOf(counter)+'@gmail.com';
			counter++;
		}
		insert contacts;
		counter = 0;
		List<Lead> leads = DataFactory.getCreatedLeads(20);
		for (Lead led : leads){
			led.email = 'abc'+String.valueOf(counter)+'@gmail.com';
			counter ++ ;
		}
		list<Database.SaveResult> results = Database.insert(leads);
		Set<Id> leadIdSet = new Set<Id>();
		for (Database.SaveResult result : results){
			leadIdSet.add(result.getId());
		}

		Test.startTest();
			ContactDuplicateMarker marker = new ContactDuplicateMarker();
			marker.markDuplicates(contacts);
			List<Lead> existingContactLeadList = new List<Lead>();

			for (Lead led : DataFactory.getExistingLeads(leadIdSet)){
				if (led.Existing_Contact__c == true){
					existingContactLeadList.add(led);
				}
			}

			System.assertEquals(existingContactLeadList.size(),10);
		Test.stopTest();
	}
}
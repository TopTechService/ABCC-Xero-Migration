@isTest
public class BatchDuplicateContactMarkerTest {
    
	// Test for no duplicate contact 
	public static testMethod void testBatchForNoDuplicateContacts(){
        List<Contact> contacts = DataFactory.getCreatedContacts(10);
		System.debug('==Contacts===' + Contacts);
		Set<Id> contactIdSet = new Set<Id>();
		Integer count = 0;
		for (Contact con : contacts){
			con.firstName = 'Contact First Name' + String.valueOf(count);
			con.Contact_Unique_Name__c = con.firstName + '-' + con.LastName;
            count++;
		}
		
		List<Database.SaveResult> redults =  Database.insert(contacts);
		for (Database.SaveResult result : redults){
			contactIdSet.add(result.getId());
		}

		Test.startTest();
			String query = 'SELECT Id, email, Duplicate_Contact_Record__c, Duplicate_Contact__c,' + 
					   'Name, FirstName, LastName, Contact_Unique_Name__c, CreatedDate ' +
					   'FROM Contact WHERE CreatedDate = Today';
	        BatchDuplicateContactMarker dupeMarker = new BatchDuplicateContactMarker(query);
	        Database.executeBatch(dupeMarker);
		Test.stopTest();
		
		for (Contact con : DataFactory.getExistingContacts(contactIdSet)){
			System.assertEquals(con.Duplicate_Contact__c , false);
		}
    }

	//Test for duplicate contact
	public static testMethod void testBatchForDuplicateContacts(){
        List<Contact> contacts = DataFactory.getInsertedContacts(10);
		System.debug('==Contacts===' + Contacts);
		Set<Id> contactIdSet = new Set<Id>();
		for (contact con : contacts){
			contactIdSet.add(con.id);    
		}
		System.debug('==contactIdSet===' + contactIdSet);
		Test.startTest();
			String query = 'SELECT Id, email, Duplicate_Contact_Record__c, Duplicate_Contact__c,' + 
					   'Name, FirstName, LastName, Contact_Unique_Name__c, CreatedDate ' +
					   'FROM Contact WHERE CreatedDate = Today';
	        BatchDuplicateContactMarker dupeMarker = new BatchDuplicateContactMarker(query);
	        Database.executeBatch(dupeMarker);
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
}
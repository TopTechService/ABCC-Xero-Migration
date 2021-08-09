/**
 * @ Desc - Test class to test ContactListController class 
 */
@isTest
private class ContactListControllerTest {

    // Test GetDuplicateContacts
    static testMethod void testGetDuplicateContacts() {
        // get contacts from data factory 
        list<Contact> contacts = DataFactory.getCreatedContacts(10);
        for(contact cont : contacts ){
        	cont.Duplicate_Contact__c = true;
        }
        
        insert contacts;
        Test.startTest();
        	ContactListController conListController = new ContactListController();
        	system.assertEquals(conListController.getDuplicateContacts().size(),10);
        Test.stopTest();
        
    }
    
    // Test getConvertedContacts
    static testMethod void testGetConvertedContacts() {
        // get contacts from data factory 
        list<Contact> contacts = DataFactory.getCreatedContacts(10);
        for(contact cont : contacts ){
        	cont.isConvertedToday__c = true;
        }
        
        insert contacts;
        Test.startTest();
        	ContactListController conListController = new ContactListController();
        	system.assertEquals(conListController.getConvertedContacts().size(),10);
        Test.stopTest();
    }
}
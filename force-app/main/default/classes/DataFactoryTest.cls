@isTest
private class DataFactoryTest {

    static testMethod void testGetCreatedleads() {
        test.startTest();
            system.assertEquals(2, DataFactory.getCreatedleads(2).size());
        test.stopTest();
    }
    
    static testMethod void testGetCreatedContacts() {
        test.startTest();
            system.assertEquals(2, DataFactory.getCreatedContacts(2).size());
        test.stopTest();
    }
    
    static testMethod void testGetCreatedAccounts() {
        test.startTest();
            system.assertEquals(2, DataFactory.getCreatedAccounts(2).size());
        test.stopTest();
    }
    
    // Test for inserted records 2
    static testMethod void testGetInsertedleads() {
        test.startTest();
            system.assertEquals(2, DataFactory.getInsertedleads(2).size());
        test.stopTest();
    }
    
    static testMethod void testGetInsertedContacts() {
        test.startTest();
            system.assertEquals(2, DataFactory.getInsertedContacts(2).size());
        test.stopTest();
    }
    
    static testMethod void testGetInsertedAccounts() {
        test.startTest();
            system.assertEquals(2, DataFactory.getInsertedAccounts(2).size());
        test.stopTest();
    }
    
    
    // Test for inserted records 0 
    static testMethod void testGetInsertedleadsZero() {
        test.startTest();
            system.assertEquals(0, DataFactory.getInsertedleads(0).size());
        test.stopTest();
    }
    
    static testMethod void testGetInsertedContactsZero() {
        test.startTest();
            system.assertEquals(0, DataFactory.getInsertedContacts(0).size());
        test.stopTest();
    }
    
    static testMethod void testGetInsertedAccountsZero() {
        test.startTest();
            system.assertEquals(0, DataFactory.getInsertedAccounts(0).size());
        test.stopTest();
    }
    
    
    static testMethod void testGetStateSynonymsCustomSetting() { 
        test.startTest();
            DataFactory.createStateSynanymsCustomSettings();
        test.stopTest();
    }
    
    
}
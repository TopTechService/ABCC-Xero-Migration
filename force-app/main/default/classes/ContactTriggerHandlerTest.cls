/**
 * 
 */
@isTest
private class ContactTriggerHandlerTest {
    
    @testsetup
    static void setUpData() {
        DataFactory.createStateSynanymsCustomSettings();
        Account acc = new Account(Name = 'ABC');
        insert acc;
    }
    
    //Single instance of contact record is being inserted
    @isTest
    static void checkBoxTestWhenContactCreated() {
        Account accountRecord = [Select Id From Account limit 1];
    	Contact contactRecord = new Contact(FirstName = 'John', 
                                            LastName = 'Cena', 
                                            MailingState = 'VIC',
                                            Email = 'abc@test.com',
                                            AccountId = accountRecord.Id);
        
        insert contactRecord;
        Test.startTest();
        Contact updatedRecord = [Select Id, VIC_NonMember__c, WA_NonMember__c   From Contact Where Id =: contactRecord.Id];
        system.assertEquals(true, updatedRecord.VIC_NonMember__c);
        system.assertEquals(false, updatedRecord.WA_NonMember__c);
        Test.stopTest();
    }

    @isTest
    static void checkBoxTestWhenContactCreatedWihoutState() {
        Account accountRecord = [Select Id From Account limit 1];
    	Contact contactRecord = new Contact(FirstName = 'John', 
                                            LastName = 'Cena', 
                                            MailingState = NULL,
                                            Email = 'abc@test.com',
                                            AccountId = accountRecord.Id);
        
        insert contactRecord;
        Test.startTest();
        Contact updatedRecord = [Select Id, VIC_NonMember__c, WA_NonMember__c   From Contact Where Id =: contactRecord.Id];
        system.assertEquals(false, updatedRecord.VIC_NonMember__c);
        system.assertEquals(false, updatedRecord.WA_NonMember__c);
        Test.stopTest();
    }
    
    @isTest
    static void checkBoxTestWhenContactStateChanged() {
        Account accountRecord = [Select Id From Account limit 1];
    	Contact contactRecord = new Contact(FirstName = 'John', 
                                            LastName = 'Cena', 
                                            MailingState = 'VIC',
                                            Email = 'abc@test.com',
                                            AccountId = accountRecord.Id);
        
        insert contactRecord;
        Test.startTest();
        Contact updatedRecord = [Select Id, MailingState, VIC_NonMember__c, ACT_NM__c   From Contact Where Id =: contactRecord.Id];
        system.assertEquals(true, updatedRecord.VIC_NonMember__c);
        system.assertEquals(false, updatedRecord.ACT_NM__c);
        updatedRecord.MailingState = 'ACT';
        update updatedRecord;
        Test.stopTest();
        
        Contact updatedRecord1 = [Select Id, MailingState, VIC_NonMember__c, ACT_NM__c   From Contact Where Id =: contactRecord.Id];
        system.assertEquals(false, updatedRecord1.VIC_NonMember__c);
        system.assertEquals(true, updatedRecord1.ACT_NM__c);
    }
    
    @isTest
    static void checkBoxTestWhenSubscriptionCheckBoxIsChanged() {
        Account accountRecord = [Select Id From Account limit 1];
    	Contact contactRecord = new Contact(FirstName = 'John', 
                                            LastName = 'Cena', 
                                            MailingState = 'VIC',
                                            Email = 'abc@test.com',
                                            AccountId = accountRecord.Id);
        
        insert contactRecord;
        Test.startTest();
        Contact updatedRecord = [Select Id, MailingState, VIC_NonMember__c, ACT_NM__c   From Contact Where Id =: contactRecord.Id];
        system.assertEquals(true, updatedRecord.VIC_NonMember__c);
        system.assertEquals(false, updatedRecord.ACT_NM__c);
        updatedRecord.VIC_NonMember__c = false;
        update updatedRecord;
        Test.stopTest();
        
        Contact updatedRecord1 = [Select Id, MailingState, VIC_NonMember__c, ACT_NM__c   From Contact Where Id =: contactRecord.Id];
        system.assertEquals(false, updatedRecord1.VIC_NonMember__c);
        system.assertEquals(false, updatedRecord1.ACT_NM__c);
    }
}
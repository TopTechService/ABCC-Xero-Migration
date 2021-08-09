@isTest
public class trg_attachment_Test {
    
    @testSetup public static void SetUpData() {
        Venue__c ve = new Venue__c();
        ve.Name = 'Ahmedabad';
        ve.Street_Address_1__c ='test' ;
        ve.Street_Address_2__c = 'test';
        ve.City__c='test';
        ve.State__c='test';
        ve.Country__c='test';
        ve.Postal_Code_Zip__c = '382350';
        insert ve;
        
        Payment_Gateway__c obj_PaymentGateway = new Payment_Gateway__c();
        obj_PaymentGateway.Active__c = false;
        obj_PaymentGateway.eWay_API_Key__c = '12345678965';
        obj_PaymentGateway.eWay_API_Password__c = 'butter@fly123';
        obj_PaymentGateway.Merchant_ID__c = '987363277';
        obj_PaymentGateway.Merchant_Reference__c = 'zxcvbnsj123';
        obj_PaymentGateway.Merchant_Security_Key__c = 'h37sje38skw02es';
        obj_PaymentGateway.Test_Endpoint__c = true;
        obj_PaymentGateway.User_Name__c = 'Test User';
        insert obj_PaymentGateway;
        
        Event__c event = new Event__c();
        event.Event_Name__c = 'Test Event';
        event.Event_Start_Time__c = System.today();
        event.Venue__c = ve.Id;
        // Removing Payment_Gateway__c from Event__c by Yugandhara on 19th sept 2017
        //event.Payment_Gateway__c = obj_PaymentGateway.Id;
        insert event; 
        
        Event_Sponsor__c sponser = new Event_Sponsor__c();
        sponser.Name  ='Test sponsor';
        sponser.Event__c = event.Id;
        insert sponser;
    }
    
    @isTest
    public static void addingAttachmentTest()
    {
        Event_Sponsor__c sponser = [Select id from Event_Sponsor__c limit 1];
        
        Attachment  attach = new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=sponser.id;
        Test.startTest();
        insert attach;
        Test.stopTest();
        
        Event_Sponsor__c result = [SELECT Id,Logo_Image_Link__c FROM Event_Sponsor__c];
        System.assertEquals(result.Logo_Image_Link__c, attach.Id);
    }
    
    @isTest
    public static void deleteAttachmentTest()
    {
		Event_Sponsor__c sponser = [Select id from Event_Sponsor__c limit 1];
        
        Attachment attach = new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=sponser.id;
        insert attach;
        
        Test.startTest();
        delete  attach;
        Test.stopTest();
        
        Event_Sponsor__c result = [SELECT Id,Logo_Image_Link__c FROM Event_Sponsor__c];
        System.assertEquals(result.Logo_Image_Link__c, null);
    }
}
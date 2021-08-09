@isTest
private class RefundHandlerPageController_Test{

    static testMethod  void setup() {    
    
      Account obj_Account = new Account();
        obj_Account.Name = 'Test Account';
        obj_Account.Industry='Accounting';
        insert obj_Account;
        
        
        Contact obj_Contact = new Contact();
        obj_Contact.LastName ='Test Lastname';
        obj_Contact.AccountID=obj_Account.id;
        obj_Contact.Business_Function__c = 'Accounts';
        insert obj_Contact;
        
          Attachment attach = new Attachment();     
      attach.Name='Unit Test Attachment';
      Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
      attach.body=bodyBlob;
        attach.parentId = obj_Contact.id;
        insert attach;
        
        Venue__c obj_Venue = new Venue__c();
        obj_Venue.Name='Test Venue';
        obj_Venue.Street_Address_1__c='Test Street Address';
        obj_Venue.City__c='Test City';
        obj_Venue.State__c='Test State';
        obj_Venue.Postal_Code_Zip__c='Test Zip Code';
        obj_Venue.Country__c='Test Country';
        obj_Venue.Venue_Type__c='Hotel';
        insert obj_Venue;
        
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
        
        
        Event__c obj_Event = new Event__c();
       // obj_Event.Name='Test Event';
        obj_Event.Event_Type__C ='Evening Networking';
        obj_Event.Event_Name__c ='Test Event';
        obj_Event.Event_Start_Date__c = date.newInstance(2017, 11, 21);
        obj_Event.Event_Start_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        obj_Event.Event_Finish_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        obj_Event.Event_Description_HTML__c='Hello this is the Test Event';
        obj_Event.venue__c=obj_Venue.id;
        obj_Event.Rego_Deadline_Date_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        //Removing Payment_Gateway__c from Event__c by Yugandhara on 19th sept 2017
        //obj_Event.Payment_Gateway__c = obj_PaymentGateway.id;
        insert obj_Event;
        
        
         Event_Package__c newEventPackage1 = new Event_Package__c();
         newEventPackage1.Description__c='Test Event Package';
        newEventPackage1.Name='Test Event Package';
        newEventPackage1.IsStandardPackage__c=true;
        newEventPackage1.Stadard_Price__c=1999;
        newEventPackage1.Event__c=obj_Event.Id;
        newEventPackage1.Standard_Price__c = 2000;
        newEventPackage1.Member_Price__c = 2000;
        newEventPackage1.Type__c = 'Single Ticket';
        //newEventPackage.CurrencyIsoCode='AUD';  
        insert newEventPackage1;
        
         Opportunity opps = new Opportunity();
        opps.Name = 'testopp';
        opps.Amount = 1000;
        opps.Account = obj_Account;
        opps.StageName = 'Closed Won';
        opps.Event_Package__c = newEventPackage1.Id;
        opps.Event__c = obj_Event.Id;
        opps.CloseDate = System.today().addMonths(1);
        opps.Ticket_Qty__c = 0;
        insert opps;
        Test.StartTest();
             Test.setCurrentPage(Page.RefundHandlerPage);
             RefundHandlerPageController controller = new RefundHandlerPageController (new ApexPages.StandardController(opps));
                 RefundHandlerPageController.trxStatus = 'SUCCESSFUL';
             RefundHandlerPageController.trxType  = 'SALE';
             controller.returnToOpportunity();
         
        Test.StopTest();
     }
     
     static testMethod  void setup2() {    
    
      Account obj_Account = new Account();
        obj_Account.Name = 'Test Account';
        obj_Account.Industry='Accounting';
        insert obj_Account;
        
        
        Contact obj_Contact = new Contact();
        obj_Contact.LastName ='Test Lastname';
        obj_Contact.AccountID=obj_Account.id;
        obj_Contact.Business_Function__c = 'Accounts';
        insert obj_Contact;
        
        
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
        
        Opportunity opps = new Opportunity();
        opps.Name = 'testopp';
        opps.Amount = 1000;
        opps.Account = obj_Account;
        opps.StageName = 'Closed Won';
        opps.CloseDate = System.today().addMonths(1);
        opps.Ticket_Qty__c = 0;
        insert opps;
        
         Card_Transaction__c cardtrans = new Card_Transaction__c();
        cardtrans.Payment_Gateway__c = obj_PaymentGateway.Id; 
        cardtrans.Opportunity__c= opps.Id;
        insert cardtrans;       
       
        Test.StartTest();
             Test.setCurrentPage(Page.RefundHandlerPage);
             RefundHandlerPageController controller = new RefundHandlerPageController (new ApexPages.StandardController(opps));
               RefundHandlerPageController.trxStatus = '';
             RefundHandlerPageController.trxType  = '';
         
             controller.refundAmount();
        Test.StopTest();
     }
}
@IsTest public class EventDetailTabExtention_Test
{
   
    public testmethod static void EventDetailTabExtention_TestMethod1()
    {
    
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
        
        Table__c testtable = new Table__c();
        testtable.Event__c = obj_Event.Id;
        insert testtable;
        
        Event_Registration__c evereg = new Event_Registration__c();
        evereg.Event__c = obj_Event.Name;
        evereg.Event__c = obj_Event.Id;
        evereg.Event_Package__c = newEventPackage1.Id;
        evereg.Opportunity__c = opps.Id;
        evereg.Contact__c = obj_Contact.Id;
        evereg.First_Name__c = 'testfirst';
        evereg.Last_Name__c = 'testlast';
        evereg.Job_Title__c = 'testjob';
        evereg.Telphone__c = '11222333';
        evereg.Email__c = 'abc@test.com';
        evereg.Dietary_Requirements__c = 'testdietary';
        evereg.Contact__c = obj_Contact.Name;
        evereg.Opportunity__c = opps.Id;
        evereg.Table__c=testtable.Id;
        evereg.Registration_Type__c = 'Guest';
        insert evereg;

        test.starttest();
        Test.setCurrentPage(Page.EventDetailTabs);
        EventDetailTabExtention controller = new EventDetailTabExtention(new ApexPages.StandardController(obj_Event));
        controller.filterString = 'Attendees';
         controller.updateNoShow();
        controller.filterErList();
        controller.changeListToShow();
  
        test.stoptest();
        
        
        }
       
   
    public testmethod static void EventDetailTabExtention_TestMethod2()
    {
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
        
        Table__c testtable = new Table__c();
        testtable.Event__c = obj_Event.Id;
        insert testtable;
        
        Event_Registration__c evereg = new Event_Registration__c();
        evereg.Event__c = obj_Event.Name;
        evereg.Event__c = obj_Event.Id;
        evereg.Event_Package__c = newEventPackage1.Id;
        evereg.Opportunity__c = opps.Id;
        evereg.Contact__c = obj_Contact.Id;
        evereg.First_Name__c = 'testfirst';
        evereg.Last_Name__c = 'testlast';
        evereg.Job_Title__c = 'testjob';
        evereg.Telphone__c = '11222333';
        evereg.Email__c = 'abc@test.com';
        evereg.Dietary_Requirements__c = 'testdietary';
        evereg.Contact__c = obj_Contact.Name;
        evereg.Opportunity__c = opps.Id;
        evereg.Table__c=testtable.Id;
        evereg.Registration_Type__c = 'Guest';
        insert evereg;
    
           test.starttest();
            Test.setCurrentPage(Page.EventDetailTabs);
            EventDetailTabExtention controller1 = new EventDetailTabExtention(new ApexPages.StandardController(obj_Event));
            controller1.filterString = 'Wait List';
             controller1.updateNoShow();
            controller1.filterErList();
            controller1.changeListToShow();
        test.stoptest();
     
    }
    public testmethod static void EventDetailTabExtention_TestMethod3()
    {
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
        
        Table__c testtable = new Table__c();
        testtable.Event__c = obj_Event.Id;
        insert testtable;
        
        Event_Registration__c evereg = new Event_Registration__c();
        evereg.Event__c = obj_Event.Name;
        evereg.Event__c = obj_Event.Id;
        evereg.Event_Package__c = newEventPackage1.Id;
        evereg.Opportunity__c = opps.Id;
        evereg.Contact__c = obj_Contact.Id;
        evereg.First_Name__c = 'testfirst';
        evereg.Last_Name__c = 'testlast';
        evereg.Job_Title__c = 'testjob';
        evereg.Telphone__c = '11222333';
        evereg.Email__c = 'abc@test.com';
        evereg.Dietary_Requirements__c = 'testdietary';
        evereg.Contact__c = obj_Contact.Name;
        evereg.Opportunity__c = opps.Id;
        evereg.Table__c=testtable.Id;
        evereg.Registration_Status__c = 'Cancelled';
        insert evereg;

          test.starttest();
            Test.setCurrentPage(Page.EventDetailTabs);
            EventDetailTabExtention controller2 = new EventDetailTabExtention(new ApexPages.StandardController(obj_Event));
            controller2.filterString = 'All';
            controller2.updateNoShow();
            controller2.filterErList();
            controller2.changeListToShow();
        
        test.stoptest();
       
    }
    public testmethod static void EventDetailTabExtention_TestMethod4()
    {
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
        
        Table__c testtable = new Table__c();
        testtable.Event__c = obj_Event.Id;
        insert testtable;
        
        Event_Registration__c evereg = new Event_Registration__c();
        evereg.Event__c = obj_Event.Name;
        evereg.Event__c = obj_Event.Id;
        evereg.Event_Package__c = newEventPackage1.Id;
        evereg.Opportunity__c = opps.Id;
        evereg.Contact__c = obj_Contact.Id;
        evereg.First_Name__c = 'testfirst';
        evereg.Last_Name__c = 'testlast';
        evereg.Job_Title__c = 'testjob';
        evereg.Telphone__c = '11222333';
        evereg.Email__c = 'abc@test.com';
        evereg.Dietary_Requirements__c = 'testdietary';
        evereg.Contact__c = obj_Contact.Name;
        evereg.Opportunity__c = opps.Id;
        evereg.Table__c=testtable.Id;
        evereg.Registration_Status__c = 'Wait List';
        insert evereg;
        
             test.starttest();
            Test.setCurrentPage(Page.EventDetailTabs);
            EventDetailTabExtention controller3 = new EventDetailTabExtention(new ApexPages.StandardController(obj_Event));
             controller3.filterString = 'Cancelled';
            controller3.updateNoShow();
            controller3.filterErList();
            controller3.changeListToShow();
        test.stoptest();
   

    
        
    }
}
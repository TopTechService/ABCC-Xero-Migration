@isTest
public class InvoiceButtonController_Test {
    @isTest
    static void testcreateInvoices(){
    	//added by YP
		Tracking__c tracYp = new Tracking__c();
         tracYp.Name = 'TestYpTracking';
        insert tracYp;
        
        TrackingOption__c trackOptions = new TrackingOption__c();
        trackOptions.Name = 'TestOptionYp';
        trackOptions.Tracking__c = tracYp.id;
        trackOptions.TrackingOptionID__c = '123456';
        insert trackOptions;
        
        Venue__c testVenue = new Venue__c();
        testVenue.State__c = 'TestState';
        testVenue.Postal_Code_Zip__c = '12345';
        testVenue.Country__c = 'India';
        insert testVenue;
        
        Event__c testEvent = new Event__c();
        testEvent.Name = 'TestEvent';
        testEvent.Event_Start_Time__c = system.today();
        testEvent.Our_Reference__c = 'TestOptionYp';
        testEvent.Venue__c = testVenue.Id;
        insert testEvent;
        //************
        
        Account acc = new Account();
         acc.name = 'test';
         insert acc;
         
         Contact con = new Contact();
         con.FirstName = 'test';
         con.LastName = 'test';
         con.AccountId = acc.Id;
         con.Email = 'Dhrudipshah@gmail.com';
         con.MailingCountry = 'Australia';
         insert con;
         
    
         Opportunity opp = new Opportunity();
         opp.AccountId = acc.Id;
         opp.Primary_Contact__c = con.Id;
         opp.Name = 'Test1';
         opp.CloseDate = System.Today();
         opp.StageName = 'Prospecting';
         opp.Xero_Invoice_Status__c = 'Pending';
         opp.Xero_Invoice_Number__c = '1234';
		 opp.Add_GST_on_Invoice__c = true;
        opp.Event__c = testEvent.id;
         insert opp;

    	Product2 prod = new Product2(Name = 'Laptop X200', 
        Family = 'Hardware');
    	insert prod;
    
        Id pricebookId = Test.getStandardPricebookId();
    
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = prod.Id,
        UnitPrice = 10000, IsActive = true);
        insert standardPrice;

    	OpportunityLineItem oli = new OpportunityLineItem();
    	oli.Quantity = 1;
    	oli.OpportunityId = opp.Id;
    	oli.TotalPrice = 100;
    	oli.Product2Id = standardPrice.Id;

    	insert oli;
    	
        csXero_Setting__c xeroSetting = New csXero_Setting__c(Name = 'Xero',
        Xero_Tenant_Id__c = '7febd1ae-5213-4189-a4a5-adc7f39551a5');
        insert xeroSetting;        

        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        PageReference pageRef = Page.InvoiceButton;
        pageRef.getParameters().put('id', opp.Id);
        Test.setCurrentPage(pageRef);
       	InvoiceButtonController ibc = new InvoiceButtonController();
       	ibc.createInvoice();
        Test.StopTest();
    }

    @isTest
    static void testAttachIncoices(){
    	Account acc = new Account();
         acc.name = 'test';
         insert acc;
         
         Contact con = new Contact();
         con.FirstName = 'test';
         con.LastName = 'test';
         con.AccountId = acc.Id;
         con.Email = 'Dhrudipshah@gmail.com';
         con.MailingCountry = 'Australia';
         insert con;
         
    
         Opportunity opp = new Opportunity();
         opp.AccountId = acc.Id;
         opp.Primary_Contact__c = con.Id;
         opp.Name = 'Test1';
         opp.CloseDate = System.Today();
         opp.StageName = 'Prospecting';
         opp.CloseDate = System.Today();
         opp.Xero_Invoice_Status__c = 'Pending';

         insert opp;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
       	InvoiceButtonController ibc = new InvoiceButtonController();
       	ibc.attachInvoice('Link', 'XeroId', opp.Id, 'INV-0000',acc.name);
        Test.StopTest();
    }
}
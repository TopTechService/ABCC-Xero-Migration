@isTest
public with sharing class Invoices_Test {
	@testsetup
    Public Static void testData(){
        List<Opportunity> oppList = new List<Opportunity>();
        
        csXero_Setting__c xeroSetting = New csXero_Setting__c(Name = 'Xero',
                                                             Xero_Tenant_Id__c = '7febd1ae-5213-4189-a4a5-adc7f39551a5');
        insert xeroSetting;
       
        //added by YP
		Tracking__c tracYp = new Tracking__c();
         tracYp.Name = 'TestYpTracking';
        insert tracYp;
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
             opp.CloseDate = System.Today();
             oppList.add(opp);

             Opportunity opp1 = new Opportunity();
             opp1.AccountId = acc.Id;
             opp1.Primary_Contact__c = con.Id;
             opp1.Name = 'Test1';
             opp1.StageName = 'Prospecting';
             opp1.CloseDate = System.Today();
             oppList.add(opp1);
        
        if(oppList != Null && oppList.size() > 0){
            Insert oppList;
        }

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

        
    }
    @isTest
    static void testcreateInvoices(){
        List<Opportunity> newOpp = [Select Id, Name, Description, Surchrge__c, Xero_Invoice_Status__c, Xero_Invoice_Id__c,
									Event__r.Event_Start_Time__c, (select Id,Quantity,UnitPrice,ListPrice,Product2.Name,Product2.Description, Product2.Xero_Account_Code__c, Description,Product2.ProductCode,Discount,Opportunity.Type, Opportunity.Product__c from OpportunityLineItems),
									Xero_Invoice_Number__c, Type, Product__c, AccountId, Amount, CloseDate,
									Account.Id, Account.Xero_Account_Id__c,Account.Name,Account.BillingPostalCode,Account.BillingStreet,
									Account.BillingCity, Account.BillingState, Account.Phone, Event__r.Our_Reference__c,
									Primary_Contact__r.Id,
									Primary_Contact__r.Xero_Contact_Id__c,
									Primary_Contact__r.Name,
									Primary_Contact__r.MailingPostalCode,
									Primary_Contact__r.MailingStreet,
									Primary_Contact__r.MailingCity,
									Primary_Contact__r.MailingState,
									Primary_Contact__r.Phone
									from Opportunity];
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Invoices inv = new Invoices();
        Test.startTest();
       	XeroCreateInvoiceResponse a =inv.createInvoices(newOpp);
        Test.StopTest();        
    }

    @isTest
    static void testgetInvoices(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        Invoices inv = new Invoices();
        inv.getInvoices();
        Test.StopTest();
    }
    @isTest
    static void testgetOnlineInvoice(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         Test.startTest();
        Invoices inv = new Invoices();
        inv.getOnlineInvoice('abcd');
        Test.StopTest();
    }
}
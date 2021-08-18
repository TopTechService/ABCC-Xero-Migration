@isTest
public class CreatePaymentButtonController_Test {
	@isTest
    Public Static void createBankTransactionsTest(){
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
		opp.Amount = 100;
		opp.Liability_Bank_Transaction__c = 'Pending';
    	opp.Type = 'Introduction';
//    	opp.Product__c = 'Guest';
		
		insert opp;

        Opportunity opp2 = new Opportunity();
        opp2.AccountId = acc.Id;
        opp2.Primary_Contact__c = con.Id;
        opp2.Name = 'Test1';
        opp2.CloseDate = System.Today();
        opp2.StageName = 'Prospecting';
        opp2.Amount = 100;
        opp2.Liability_Bank_Transaction__c = 'Pending';
        opp2.Type = 'Introduction';
//        opp2.Product__c = 'Guest';
        
        insert opp2;

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

        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.Quantity = 1;
        oli2.OpportunityId = opp2.Id;
        oli2.TotalPrice = 100;
        oli2.Product2Id = standardPrice.Id;

        insert oli2;
    	
        csXero_Setting__c xeroSetting = New csXero_Setting__c(Name = 'Xero',
        Xero_Tenant_Id__c = '7febd1ae-5213-4189-a4a5-adc7f39551a5');
        insert xeroSetting;        

        Test.setMock(HttpCalloutMock.class, new BankTransactionsMock());
    	Test.startTest();
    	PageReference pageRef = Page.CreatePaymentButton;
        pageRef.getParameters().put('id', opp.Id);
        Test.setCurrentPage(pageRef);
        CreatePaymentButtonController cpbc = new CreatePaymentButtonController();
        cpbc.createPayment();
        Test.stopTest();
    }

    @isTest
    Public Static void createBankTransactionsTestOthers(){
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

        Opportunity opp2 = new Opportunity();
        opp2.AccountId = acc.Id;
        opp2.Primary_Contact__c = con.Id;
        opp2.Name = 'Test1';
        opp2.CloseDate = System.Today();
        opp2.StageName = 'Prospecting';
        opp2.CloseDate = System.Today();
        opp2.Amount = 100;
        opp2.Liability_Bank_Transaction__c = 'Not Required';
        opp2.Type = 'Event';
        opp2.Product__c = 'Event Sponser';
        
        insert opp2;

        Product2 prod = new Product2(Name = 'Laptop X200', 
        Family = 'Hardware');
        insert prod;
    
        Id pricebookId = Test.getStandardPricebookId();
    
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = prod.Id,
        UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.Quantity = 1;
        oli2.OpportunityId = opp2.Id;
        oli2.TotalPrice = 100;
        oli2.Product2Id = standardPrice.Id;

        insert oli2;

        csXero_Setting__c xeroSetting = New csXero_Setting__c(Name = 'Xero',
        Xero_Tenant_Id__c = '7febd1ae-5213-4189-a4a5-adc7f39551a5');
        insert xeroSetting;        

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PaymentMock());
        PageReference pageRef2 = Page.CreatePaymentButton;
        pageRef2.getParameters().put('id', opp2.Id);
        Test.setCurrentPage(pageRef2);
        CreatePaymentButtonController cpbc1 = new CreatePaymentButtonController();
        cpbc1.createPayment();
        Test.stopTest();
    }
}
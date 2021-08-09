@isTest
public class GetAwaitingOpportunities_Test {
	@isTest
    static void testcreateInvoices(){
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
         opp.Status_of_payment__c = 'Awaiting For Payment';
         opp.CloseDate = System.Today();
         opp.Xero_Invoice_Status__c = 'Pending';
         opp.Xero_Invoice_Id__c = '1234';
         opp.Surchrge__c = 4;

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

    	Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
       	GetAwaitingOpportunities.getProspectingAwaitingOpportunities();
        Test.StopTest();
    }
}
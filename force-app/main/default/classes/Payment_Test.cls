@isTest
public class Payment_Test {
	@testsetup
    Public Static void testData(){
        List<Opportunity> oppList = new List<Opportunity>();
       

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
    Public Static void createPaymentTest(){
    	List<Id> oppID = new List<ID>();
        List<Opportunity> newOpp = [Select id from Opportunity];
        for(Opportunity o : newOpp)
        {
            oppID.add(o.id);
        }
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Payment payment = new Payment();
        Test.startTest();
        payment.createPayment(oppID);
        Test.StopTest(); 
    }
}
@isTest
public class BankTransactions_Test {
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
             opp.Amount = 100;
             oppList.add(opp);

             Opportunity opp1 = new Opportunity();
             opp1.AccountId = acc.Id;
             opp1.Primary_Contact__c = con.Id;
             opp1.Name = 'Test1';
             opp1.StageName = 'Prospecting';
             opp1.CloseDate = System.Today();
             opp1.Surchrge__c = 4;
             opp1.Amount = 100;
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
    Public Static void createBankTransactionsTest(){
    	List<Id> oppID = new List<ID>();
        List<Opportunity> newOpp = [Select Id, Liability_Bank_Transaction__c,Name,Description, Surchrge__c, Xero_Invoice_Number__c,
                                 (select Id,Quantity,UnitPrice,ListPrice,Product2.Name,Product2.Description, Description,Product2.ProductCode,Discount,Product2.Xero_Liability_Account_Code__c from OpportunityLineItems),
                                 AccountId,Amount,CloseDate,Account.Name,
                                 Type, Product__c, Xero_Bank_Transaction_Id__c, 
                                 Xero_Prepayment_Id__c,
                                 Primary_Contact__r.Id,
                                 Primary_Contact__r.Xero_Contact_Id__c,
                                 Primary_Contact__r.Name,
                                 Primary_Contact__r.MailingPostalCode,
                                 Primary_Contact__r.MailingStreet,
                                 Primary_Contact__r.MailingCity,
                                 Primary_Contact__r.MailingState,
                                 Primary_Contact__r.Phone,
                                 Primary_Contact__r.FirstName,
                                 Primary_Contact__r.LastName,
                                 Primary_Contact__r.Company_Name__c,
                                 Primary_Contact__r.Account.Name
                                 from Opportunity];
        for(Opportunity o : newOpp)
        {
            oppID.add(o.id);
        }
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        BankTransactions bt = new BankTransactions();
        Test.startTest();
        bt.createBankTransactions(newOpp);
        Test.StopTest(); 
    }
}
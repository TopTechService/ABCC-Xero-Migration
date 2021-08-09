@isTest
public class QuoteTriggerTest {
	@isTest
	public static void quoteNumberUpdateOnOppTest(){
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
		insert opp;

		Quote qt = new Quote();
		qt.OpportunityId = opp.id;
		qt.Name = 'test';
        qt.Use_an_Amex__c = true;
		insert qt;
        
        Quote qt2 = new Quote();
		qt2.OpportunityId = opp.id;
		qt2.Name = 'test';
		insert qt2;
        
        qt2.Use_an_Amex__c = true;
        update qt2;
	}
}
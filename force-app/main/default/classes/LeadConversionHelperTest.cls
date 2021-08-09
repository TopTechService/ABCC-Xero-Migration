@isTest
public class LeadConversionHelperTest { 
	
	public static testMethod void testGetLeadIdVsExistingAccount(){
		List<Account> acctounts = DataFactory.getInsertedAccounts(1);
		List<Lead> leads = DataFactory.getCreatedleads(4);
		for (Lead led : leads){
			led.company = 'Arxxus';
		}

		List<Database.SaveResult> results = Database.insert(leads);
		Set<id> leadIdSet = new Set<id>();
		
		for (Database.SaveResult result : results){
			leadIdSet.add(result.getId());
		}

		leads.clear();
		leads.addAll(DataFactory.getExistingLeads(leadIdSet));
		Test.startTest();
			LeadConversionHelper helper = new LeadConversionHelper(leads);
			helper.getLeadIdVsExistingAccount();
		Test.stopTest();

	}
}
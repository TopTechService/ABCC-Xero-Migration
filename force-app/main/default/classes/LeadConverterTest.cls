/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class LeadConverterTest {

    static testMethod void testConvertForExistingAccount() {
        Account acct = DataFactory.getCreatedAccounts(1)[0];
        acct.Name = 'ABC1';
        insert acct;
        list<Lead> leads = DataFactory.getCreatedleads(1);
        map<Id,Id> leadVsAccountId = new map<Id,Id>();
        list<database.Saveresult> results = Database.insert( leads);
        set<Id> leadIdSet = new set<Id>();
        for(database.Saveresult result : results){
        	leadIdSet.add(result.getId());
        	leadVsAccountId.put(result.getId(),acct.id);
        }
        
        set<Id> convertedLeadIdSet = new set<Id>();
        list<Lead> convertedLeadList = new list<Lead>();
        leads.clear();
        leads.addAll(DataFactory.getExistingLeads(leadIdSet));
        test.startTest();
        	system.debug('====leads====' + leads);
        	
        	for(Database.LeadConvertResult result : LeadConverter.convert(leads , leadVsAccountId)){
        		convertedLeadIdSet.add(result.getLeadId());
        	}
        	convertedLeadList.addAll(DataFactory.getExistingLeads(convertedLeadIdSet));
        	for(Lead led : convertedLeadList){
        		system.assertEquals(led.isConverted , true);
        		system.assertEquals(led.ConvertedAccountId ,acct.id );
        	}
        	
        test.stopTest();
        
    }
}
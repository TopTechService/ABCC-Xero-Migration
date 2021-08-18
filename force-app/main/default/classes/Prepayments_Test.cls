@isTest
public class Prepayments_Test {
	@isTest
    Public Static void allocateBankTransactionsTest(){

        csXero_Setting__c xeroSetting = New csXero_Setting__c(Name = 'Xero',
        Xero_Tenant_Id__c = '7febd1ae-5213-4189-a4a5-adc7f39551a5');
        insert xeroSetting;        
        
    	Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Prepayments prepayment = new Prepayments();
        Test.startTest();
        prepayment.allocateBankTransactions('f5832195-5cd3-4660-ad3f-b73d9c64f263', 'aea95d78-ea48-456b-9b08-6bc012600072', 100);
        Test.StopTest(); 
    }
}
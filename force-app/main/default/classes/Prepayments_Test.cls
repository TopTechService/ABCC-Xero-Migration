@isTest
public class Prepayments_Test {
	@isTest
    Public Static void allocateBankTransactionsTest(){
    	Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Prepayments prepayment = new Prepayments();
        Test.startTest();
        prepayment.allocateBankTransactions('f5832195-5cd3-4660-ad3f-b73d9c64f263', 'aea95d78-ea48-456b-9b08-6bc012600072', 100);
        Test.StopTest(); 
    }
}
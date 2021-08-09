@isTest
private with sharing class ConnectXeroTest {
    @isTest static void ConnectXeroTest() {

        Account accountObj = New Account();
        Pagereference pageRef = Page.ConnectToXero;
        test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(AccountObj);
        connectXero testConn = new connectXero(sc);

        Test.startTest();
        ConnectXero.authorizeNamedCredential();
        Test.stopTest();

    }
}
@isTest
public class XeroClient_test {
     @testsetup
    Public Static void testData(){
        csXero_Setting__c xeroSetting = New csXero_Setting__c(Name = 'Xero',
                                                             Xero_Tenant_Id__c = '7febd1ae-5213-4189-a4a5-adc7f39551a5');
        insert xeroSetting;
    }
    @isTest
    static void testdoGet(){
        csXero_Setting__c xsc = [Select Id, Name, Xero_Tenant_Id__c  from csXero_Setting__c limit 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        XeroClient XC = new XeroClient();
        Test.startTest();
       	XC.doGet('www.anything,com','query');
        Test.StopTest();
    }
     @isTest
    static void testdoPost(){
        csXero_Setting__c xsc = [Select Id, Name, Xero_Tenant_Id__c  from csXero_Setting__c limit 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        XeroClient XC = new XeroClient();
        Test.startTest();
       	XC.doPost('www.anything,com','{"example":"test"}');
        Test.StopTest();
    }
     @isTest
    static void testdoPut(){
        csXero_Setting__c xsc = [Select Id, Name, Xero_Tenant_Id__c  from csXero_Setting__c limit 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        XeroClient XC = new XeroClient();
        Test.startTest();
       	XC.doPut('www.anything,com','{"example":"test"}');
        Test.StopTest();
    }
}
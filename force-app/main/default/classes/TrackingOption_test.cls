@isTest
public class TrackingOption_test {
    @istest
    static void testcreateContacts(){

        csXero_Setting__c xeroSetting = New csXero_Setting__c(Name = 'Xero',
        Xero_Tenant_Id__c = '7febd1ae-5213-4189-a4a5-adc7f39551a5');
        insert xeroSetting;        

        TrackingOption ObjTrackOption = new TrackingOption();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForTrackingOption());
        Test.startTest();
        ObjTrackOption.createTrackingOption('res1YP','ff7edbb4-a53a-48d7-8c1b-ff58a10fcaa8');
        Test.StopTest();
    }
}
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
        ObjTrackOption.createTrackingOption('South','6159bdd4-b634-4338-a664-e929aa73f70f');
        Test.StopTest();
    }
}
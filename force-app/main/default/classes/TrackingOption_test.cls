@isTest
public class TrackingOption_test {
    @istest
    static void testcreateContacts(){
        TrackingOption ObjTrackOption = new TrackingOption();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForTrackingOption());
        Test.startTest();
        ObjTrackOption.createTrackingOption('res1YP','ff7edbb4-a53a-48d7-8c1b-ff58a10fcaa8');
        Test.StopTest();
    }
}
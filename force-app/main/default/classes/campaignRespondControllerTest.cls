@isTest
public class campaignRespondControllerTest {
    
    public static testmethod void testRedirection()
    {
        PageReference pg = Page.campaignRespondPage;
        Test.setCurrentPageReference(pg); 
		System.currentPageReference().getParameters().put('id','a0jN0000008Gxxj');
        
        Test.StartTest();
        
        campaignRespondController obj = new campaignRespondController();
        obj.callRedirect();
        Test.StopTest();
        
        System.assert(obj.eventId == 'a0jN0000008Gxxj');
        
    }
}
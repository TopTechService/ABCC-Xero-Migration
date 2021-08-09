/**
* @Desc - This class is to test EmailNotificationManager class
*/
@isTest
private class EmailNotificationManagerTest {

    static testMethod void testSendAnEmail() {
        Id defaultLeadOwnerId = Userinfo.getUserId();
        Test.startTest();
	        if(!String.isBlank(defaultLeadOwnerId)) {
	        	EmailNotificationManager mgr =  new EmailNotificationManager();
	        	mgr.sendAnEmail(GlobalConstants.DUPLICATE_CONTACT_EMAIL_TEMPLATE_NAME, defaultLeadOwnerId);
	        }
	    Test.stopTest();
    }
}
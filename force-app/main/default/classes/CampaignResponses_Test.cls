@isTest
public class CampaignResponses_Test {
      
    public testmethod static void CampaignResponses_Testmethod(){

       PageReference pageRef = Page.PaymentTestPage;
        Test.setCurrentPage(pageRef);
        
        Account acct = new Account();
        acct.name = 'avvv';
        insert acct;
        
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'testl';
        con.MailingStreet  = 'testmails';
        con.MailingPostalCode = '9000';
        con.AccountId = acct.Id;
        con.Business_Function__c = 'Accounts';
        con.monthly_newsletter__c = True ;
        con.Monthly__c = True;
        con.No_Update_Notification__c = True;
        con.Weekly__c = True;
        con.Fortnightly__c = True;
        con.Business_Lunches__c = True;
        con.Business_Breakfasts__c = True;
        con.Evening_Networking__c = True;
        con.Sports_Events__c = True;
        con.Cultural_Events__c = True;
        con.Infrastructure__c = True;
        con.Financial_Services__c = True;
        con.Gov_Affairs_Policy__c = True;
        con.Resources__c = True;
        con.Education__c = True;
        con.Others__c = True;
        con.Member_Offers__c = True;
        con.Fintech__c = True;
        con.Defence__c = True;
        con.Health__c = True;
        con.Tourism__c = True;
        con.Retail__c = True;
        con.Seminars__c= True;
        con.Brexit__c = True;
        con.Energy_Resources__c = True;
        con.Digital_Cyber__c = True;
        con.Trade__c = True;
        con.Infrastructure__c = True;
        con.Fintech__c = True;
        con.Defence__c = True;
        con.Health__c= True;
        con.Retail__c = True;
        con.Tourism__c = True;

        insert con;

        apexpages.currentpage().getparameters().put('id' ,con.Id);
        string conId_param = apexPages.currentPage().getParameters().get('id');   
        System.debug(conId_param);
         test.starttest();
        CampaignResponses controller = new CampaignResponses();
        controller.getIndustryType();
        controller.getTypeOfEvents();
        controller.prePopulateTypeOfEvents();
        controller.prePopulateIndustryType();
        controller.submitResponses();
        test.stoptest();
    }
    
}
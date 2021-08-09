@IsTest public class UserPreferencePageController_Test
{
    public testmethod static void UserPreferencePageController_Test_Method1()
    {
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
        con.FTA_Brexit_Updates__c = true;
        con.Fortnightly_Upcoming_Events_weekly_duri__c = true;
        con.Member_Offers_DNS__c = true;
        con.Monthly_Newsletters_weekly_during_COVID__c = true;
        con.Event_Webinar_Invites__c = true;
        con.Business_Breakfasts__c = true;
        con.Business_Lunches__c = true;
        con.Seminars__c = true;
        con.Private_Boardroom_Events__c = true;
        con.Cocktail_Evenings__c = true;
        con.Sports_Events__c = true;
        con.Evening_Networking__c = true;
        con.Wine_Tastings__c = true;
        con.Whisky_Tastings__c = true;
        con.Gin_Tastings__c = true;
        con.Online_Sessions_business_hours__c = true;
        con.Online_Sessions_evening__c = true;
        con.International_Delegations__c = true;
        con.Agriculture__c = true;
        con.Brexit__c = true;
        con.Digital_Cyber__c = true;
        con.Defence__c = true;
        con.Education__c = true;
        con.Energy_Resources__c = true;
        con.Fintech__c = true;
        con.Financial_Services__c = true;
        con.Gov_Affairs_Policy__c = true;
        con.Health__c = true;
        con.Human_Resources__c = true;
        con.Infrastructure__c = true;
        con.Resources__c = true;
        con.Retail__c = true;
        con.Technology__c = true;
        con.Tourism__c = true;
        con.Trade__c = true;
        con.ACT__c = true;
        con.NSW_Member__c = true;
        con.QLD_Member__c = true;
        con.SA_Member__c = true;
        con.VIC_Member__c = true;
        con.WA_Member__c = true;
        con.TAS__c = true;
        con.NT__c = true;
        insert con;

        apexpages.currentpage().getparameters().put('id' ,con.Id);
        string conId_param = apexPages.currentPage().getParameters().get('id');   
        System.debug(conId_param);
        
        List<Contact> conlist = new List<Contact>([select Id,Fortnightly_Upcoming_Events_weekly_duri__c,monthly_newsletter__c, Update_Following_Industries_as_well__c, International_Travel_Destinations__c, No_Update_Notification__c,Weekly__c,Fortnightly__c,Monthly__c,Evening_Networking__c,Sports_Events__c,Cultural_Events__c,Infrastructure__c,Fintech__c,Financial_Services__c,Gov_Affairs_Policy__c,Defence__c,Resources__c,Health__c,Retail__c,Tourism__c,Education__c,Other__c from Contact where Id = :conId_param  limit 1]);
        System.debug(conlist);
    
        test.StartTest();
        UserPreferencePageController userpref = new UserPreferencePageController();
        userpref.getTypeOfEvents();
        userpref.getMontlyNews();
        userpref.getIndustryType();
        userpref.getEventFormats();
        userpref.submitResponses();
        userpref.prePopulateDontSendMe();
        test.StopTest();
    }
    
}
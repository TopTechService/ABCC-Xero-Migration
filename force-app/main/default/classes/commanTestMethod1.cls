@isTest
public class commanTestMethod1 {  
    @Testsetup Public static void Data(){
        List<RecordType> rtypes = [Select Name, Id From RecordType
                  where sObjectType='Discount__c' and isActive=true];
        Account obj_Account = new Account();
        obj_Account.Name = 'Test Account';
        obj_Account.Industry='Accounting';
        insert obj_Account;
        
       Contact obj_Contact = new Contact();
        obj_Contact.LastName ='Test Lastname';
        obj_Contact.Business_Function__c = 'Accounts';
        obj_Contact.AccountID=obj_Account.id;
        insert obj_Contact;
        
       Venue__c obj_Venue = new Venue__c();
        obj_Venue.Name='Test Venue';
        obj_Venue.Street_Address_1__c='Test Street Address';
        obj_Venue.City__c='Test City';
        obj_Venue.State__c='Test State';
        obj_Venue.Postal_Code_Zip__c='Test Zip Code';
        obj_Venue.Country__c='Test Country';
        obj_Venue.Venue_Type__c='Hotel';
        insert obj_Venue;
        
        Payment_Gateway__c obj_PaymentGateway = new Payment_Gateway__c();
        obj_PaymentGateway.Active__c = false;
        obj_PaymentGateway.eWay_API_Key__c = '12345678965';
        obj_PaymentGateway.eWay_API_Password__c = 'butter@fly123';
        obj_PaymentGateway.Merchant_ID__c = '987363277';
        obj_PaymentGateway.Merchant_Reference__c = 'zxcvbnsj123';
        obj_PaymentGateway.Merchant_Security_Key__c = 'h37sje38skw02es';
        obj_PaymentGateway.Test_Endpoint__c = true;
        obj_PaymentGateway.User_Name__c = 'Test User';
        insert obj_PaymentGateway;
        
       Event__c obj_Event = new Event__c();
       // obj_Event.Name='Test Event';
        obj_Event.Event_Type__C ='Evening Networking';
        obj_Event.Event_Name__c ='Test Event';
        obj_Event.Event_Start_Date__c = date.newInstance(2017, 11, 21);
        obj_Event.Event_Start_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        obj_Event.Event_Finish_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        obj_Event.Event_Description_HTML__c='Hello this is the Test Event';
        obj_Event.venue__c=obj_Venue.id;
        // Removing payment gateway from event by Yugandhara on 19th sept 2017
        //obj_Event.Payment_Gateway__c = obj_PaymentGateway.id;
        insert obj_Event;
    }
    
    @isTest
    public static void test_GenericEmail()
    {
        //GenericEmailHandler.generateEmailFormat('123','Ahmedabad','Anuj','Single ticket','10');
          Account a = new Account();
      a.name='test';
      insert a;
      Opportunity op = new Opportunity();
      op.Name ='tsetop';
      op.StageName = 'close won';
      op.closeDate = System.Today();
      op.AccountId = a.Id;
      insert op;
     Set<id> i = new Set<id>();
      i.add(op.id);
        GenericEmailHandler.generateEmailFormatForRefund(i);
       
    }
    
    @isTest
    public static void test_EventHandler()
    {
        Event__c obj_Event = [Select id, Seats_Per_Table__c from Event__c limit 1];
        List<Event__c> lst = new List<Event__c>();
        lst.add(obj_Event);
        EventTriggerHandler.createPackages(lst);
    }
    @isTest
    public static void test_PageControllerBase()
    {
        PageControllerBase obj = new PageControllerBase();
        obj.setMyComponentController(new ComponentControllerBase());
        obj.setComponentController(new ComponentControllerBase());
        obj.getMyComponentController();
        obj.getThis();
    }
}
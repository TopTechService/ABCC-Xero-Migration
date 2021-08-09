@IsTest public class commanTestMethod2 
{
    
    public testmethod static void commanTestMethod2_PageControllerBase()
    {

        PageControllerBase obj_PageControllerBase = new PageControllerBase();
        
        ComponentControllerBase obj_ComponentControllerBase = new ComponentControllerBase();
        obj_ComponentControllerBase.pageController =obj_PageControllerBase;
       // obj_ComponentControllerBase.myComponentController=obj_PageControllerBase;
        obj_ComponentControllerBase = obj_PageControllerBase.getMyComponentController();
        obj_PageControllerBase.setMyComponentController(obj_ComponentControllerBase);
        obj_PageControllerBase = obj_PageControllerBase.getThis();
    }
   /* public testmethod static void commanTestMethod2_EventRegistrationEditController()
    {
        List<RecordType> rtypes = [Select Name, Id From RecordType 
                  where sObjectType='Discount__c' and isActive=true];
        Account obj_Account = new Account();
        obj_Account.Name = 'Test Account';
        obj_Account.Industry='Accounting';
        insert obj_Account;
        
        Contact obj_Contact = new Contact();
        obj_Contact.LastName ='Test Lastname';
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
        
        Event__c obj_Event = new Event__c();
       // obj_Event.Name='Test Event';
        obj_Event.Event_Type__C ='Evening Networking';
        obj_Event.Event_Name__c ='Test Event';
        obj_Event.Event_Start_Date__c = date.newInstance(2017, 11, 21);
        obj_Event.Event_Start_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        obj_Event.Event_Finish_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        obj_Event.Event_Description_HTML__c='Hello this is the Test Event';
        obj_Event.venue__c=obj_Venue.id;
        insert obj_Event;
        Discount__c obj_Discount = new Discount__c();
        obj_Discount.Event__c =obj_Event.id;
        obj_Discount.RecordTypeId=rtypes[0].id;
        insert obj_Discount;
        EventRegistrationEditController obj_EventRegistrationEditController = new EventRegistrationEditController();
      PaymentTestPageController obj_PaymentTestPageController = new PaymentTestPageController();
      
    }*/
}
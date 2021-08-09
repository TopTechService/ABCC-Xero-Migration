@isTest
public class trg_updatePaymentStatus_Test {

    @isTest
    public static void test1()
    {
        
    Venue__c newVenue = new Venue__c();
    newVenue.Name = 'Test Venue';
    newVenue.State__c = 'NSW';
    newVenue.Postal_Code_Zip__c = '2000';
    newVenue.Country__c = 'AU';
    insert newVenue;
        
        
Event__c newEvent = new Event__c(); 
        newEvent.Active__c=true;
        
        newEvent.Event_End_Date__c=System.today().addMonths(1);
        //newEvent.CurrencyIsoCode='AUD';
        newEvent.Event_Name__c='Test Event Trigger Pipeline Forecast';
        newEvent.Event_Type__c='Conference';
        newEvent.Event_Start_Time__c=System.now();
        newEvent.Event_Start_Date__c=newEvent.Event_Start_Time__c.Date();
        newEvent.Marketing_Coordinator__c = UserInfo.getUserId();
        newEvent.Colour_Scheme__C ='Red'; 
        newEvent.Brand__c ='Aventedge';
        newEvent.Venue__c = newVenue.Id;
        insert newEvent;
        System.debug(newEvent);
        
        Account acct = new Account();
        acct.name = 'avvv';
        insert acct;
        
         Opportunity opp = new Opportunity(Name='Opportunity '+'Test testRegistrationsTrigger',
                                           StageName='KIV',
                                           
                                           CloseDate=System.today().addMonths(1),
                                           Event__c=newEvent.Id,                   
                                          AccountId=acct.Id);
       
          insert opp;            
        
         
        
        Event_Package__c newEventPackage = new Event_Package__c();
        newEventPackage.Description__c='Test Event Package';
        newEventPackage.Name='Test Event Package';
        newEventPackage.IsStandardPackage__c=true;
        newEventPackage.Stadard_Price__c=1999;
        newEventPackage.Event__c=newEvent.Id;
        newEventPackage.Standard_Price__c = 1000;
        newEventPackage.Member_Price__c = 100;
        //newEventPackage.CurrencyIsoCode='AUD';        
        insert newEventPackage;   
        System.debug(newEventPackage);
         
        Event_Registration__c evereg = new  Event_Registration__c();
        evereg.Event__c = newEvent.Id;
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Registration_Type__c = 'Guest';
        evereg.Email__c = 'test@test.com';
        evereg.Opportunity__c = opp.Id;
        insert evereg;
            
        ChargentSFA__Transaction__c obj = new ChargentSFA__Transaction__c();
        obj.ChargentSFA__Opportunity__c = opp.id;
        obj.ChargentSFA__Response_Status__c = 'Approved';
        
	obj.ChargentSFA__Gateway_Date__C = System.today();
    obj.ChargentSFA__Amount__c = 100;
    obj.ChargentSFA__Type__c = 'Charge';
    obj.ChargentSFA__Response__c = '';
    obj.ChargentSFA__Response_Message__c = 'TEsting';
    obj.ChargentSFA__Card_Last_4__c ='1234';
    obj.ChargentSFA__Credit_Card_Name__c ='Anuj';
    obj.ChargentSFA__Credit_Card_Type__c = 'MasterCard';
        Test.startTest();
        insert obj;
        Test.stopTest();
    }
    
     @isTest
    public static void test2()
    {
        
    Venue__c newVenue = new Venue__c();
    newVenue.Name = 'Test Venue';
    newVenue.State__c = 'NSW';
    newVenue.Postal_Code_Zip__c = '2000';
    newVenue.Country__c = 'AU';
    insert newVenue;
             
		Event__c newEvent = new Event__c(); 
        newEvent.Active__c=true;
        
        newEvent.Event_End_Date__c=System.today().addMonths(1);
        //newEvent.CurrencyIsoCode='AUD';
        newEvent.Event_Name__c='Test Event Trigger Pipeline Forecast';
        newEvent.Event_Type__c='Conference';
        newEvent.Event_Start_Time__c=System.now();
        newEvent.Event_Start_Date__c=newEvent.Event_Start_Time__c.Date();
        newEvent.Marketing_Coordinator__c = UserInfo.getUserId();
        newEvent.Colour_Scheme__C ='Red'; 
        newEvent.Brand__c ='Aventedge';
        newEvent.Venue__c = newVenue.Id;
        insert newEvent;
        System.debug(newEvent);
        
        Account acct = new Account();
        acct.name = 'avvv';
        insert acct;
        
         Opportunity opp = new Opportunity(Name='Opportunity '+'Test testRegistrationsTrigger',
                                           StageName='KIV',
                                           
                                           CloseDate=System.today().addMonths(1),
                                           Event__c=newEvent.Id,                   
                                          AccountId=acct.Id);
       
          insert opp;            
        
         
        
        Event_Package__c newEventPackage = new Event_Package__c();
        newEventPackage.Description__c='Test Event Package';
        newEventPackage.Name='Test Event Package';
        newEventPackage.IsStandardPackage__c=true;
        newEventPackage.Stadard_Price__c=1999;
        newEventPackage.Event__c=newEvent.Id;
        newEventPackage.Standard_Price__c = 1000;
        newEventPackage.Member_Price__c = 100;
        //newEventPackage.CurrencyIsoCode='AUD';        
        insert newEventPackage;   
        System.debug(newEventPackage);
         
        Event_Registration__c evereg = new  Event_Registration__c();
        evereg.Event__c = newEvent.Id;
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Registration_Type__c = 'Guest';
        evereg.Email__c = 'test@test.com';
        evereg.Opportunity__c = opp.Id;
        insert evereg;
            
        ChargentSFA__Transaction__c obj = new ChargentSFA__Transaction__c();
        obj.ChargentSFA__Opportunity__c = opp.id;
        obj.ChargentSFA__Response_Status__c = 'Failed';
        
	obj.ChargentSFA__Gateway_Date__C = System.today();
    obj.ChargentSFA__Amount__c = 100;
    obj.ChargentSFA__Type__c = 'Charge';
    obj.ChargentSFA__Response__c = '';
    obj.ChargentSFA__Response_Message__c = 'TEsting';
    obj.ChargentSFA__Card_Last_4__c ='1234';
    obj.ChargentSFA__Credit_Card_Name__c ='Anuj';
    obj.ChargentSFA__Credit_Card_Type__c = 'MasterCard';
        Test.startTest();
        insert obj;
        Test.stopTest();
    }
}
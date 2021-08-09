@isTest
private class TestEventHandle{

public static List<Event__c> EventPackCheck ; 
static testmethod void myTestMetho() {

 EventPackCheck = new List<Event__c>();
 List<Event_Package__c> packagesToInsert = new List<Event_Package__c>();
    
    Venue__c newVenue = new Venue__c();
    newVenue.Name = 'Test Venue';
    newVenue.State__c = 'NSW';
    newVenue.Postal_Code_Zip__c = '2000';
    newVenue.Country__c = 'AU';
    insert newVenue;
    
    
     Event__c newEvent = new Event__c(); 
        newEvent.Active__c=true;
        newEvent.Event_Start_Date__c=System.today();
        newEvent.Event_End_Date__c=System.today().addMonths(1);
        //newEvent.CurrencyIsoCode='AUD';
        newEvent.Event_Name__c='Test Event Trigger Pipeline Forecast';
        newEvent.Event_Type__c='Conference';
        newEvent.Marketing_Coordinator__c = UserInfo.getUserId();
        newEvent.Colour_Scheme__C ='Red'; 
        newEvent.Brand__c ='Aventedge';
    	newEvent.Venue__c = newVenue.Id;
        insert newEvent;        
        
        EventTriggerHandler etc = new EventTriggerHandler();
        EventTriggerHandler.createPackages(EventPackCheck);
        
        List<Event__c> EventPackCheck = [select Name,(select Name from Event_Package__r) from Event__c where Id =: newEvent.Id ];
        
        for(Event__c e : EventPackCheck ){
        
            e.Event_Package__r.size();
            System.assertEquals(2,e.Event_Package__r.size());
        }

      
}

}
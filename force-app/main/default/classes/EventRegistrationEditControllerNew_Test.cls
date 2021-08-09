@isTest
public class EventRegistrationEditControllerNew_Test {

    static testMethod void EventRegistrationEditControllertest() {
        
        PageReference pageRef = Page.EventRegistrationEditPage;
        Test.setCurrentPage(pageRef); 
        
        Venue__c ve = new Venue__c();
        ve.Name = 'Ahmedabad';
        ve.Street_Address_1__c ='test' ;
        ve.Street_Address_2__c = 'test';
        ve.City__c='test';
        ve.State__c='test';
        ve.Country__c='test';
        ve.Postal_Code_Zip__c = '382350';
        insert ve;
        
        String eventlocation = ve.Name;
        
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
        newEvent.Venue__c = ve.Id;
        insert newEvent;
        System.debug(newEvent);
        
        Account acct = new Account();
        acct.name = 'avvv';
        insert acct;
        system.debug('Account: '+acct);
/*        
        system.debug('Argument: '+apexPages.currentPage().getParameters().get('eventRegId'));
        
          Blob eventRegIdBlob = EncodingUtil.base64decode(apexPages.currentPage().getParameters().get('eventRegId'));
          Blob key = EncodingUtil.base64decode(Label.cryptoKey);
        
         Blob decryptedData = Crypto.decryptWithManagedIV('AES256', key, eventRegIdBlob);

        // Decode the decrypted data for subsequent use
        String decryptedDataString = decryptedData.toString();
        
         Opportunity opp = new Opportunity(Name='Opportunity '+'Test testRegistrationsTrigger',
                                           StageName='KIV',
                                           
                                           CloseDate=System.today().addMonths(1),
                                           Event__c=newEvent.Id,                   
                                           AccountId=acct.Id,
                                           Id =decryptedDataString );
       
          insert opp;            
*/        
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
        evereg.Email__c = 'NotKnown@test.com';
        evereg.Opportunity__c = opp.Id;
        insert evereg;
        System.debug(evereg);
        
        Blob cryptoKey = EncodingUtil.base64decode(Label.cryptoKey);
        // Generate the data to be encrypted.
        Blob data = Blob.valueOf(evereg.Id);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
        String encryptedString = EncodingUtil.base64encode(encryptedData);
        System.debug('UB: urlEncode'+ encryptedString);
        apexpages.currentpage().getparameters().put('eventRegId' ,encryptedString);
        
        Event_Registration_Attendee__c erAttendee = new Event_Registration_Attendee__c();
         erAttendee.FirstName__c = 'Umang';
         erAttendee.LastName__c = 'Barot';
         erAttendee.Attendee_Email__c = 'umang@resonantcloud.info';
         erAttendee.Position__c = 'software engineer';
         erAttendee.Company__c = 'Resonant Cloud';
         erAttendee.Dietary_Requirements__c = 'veg';
         erAttendee.Event__c = newEvent.id;
         erAttendee.Event_Registration__c = evereg.id;
        insert erAttendee;
        
        EventRegistrationEditController er = new EventRegistrationEditController();
        ComponentControllerBase objbaseClass = er.MyComponentController;
        er.setComponentController(objbaseClass );
        Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper> mapData = new Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper>();
        
        RelatedAttendeeListCotroller.AttendeeWrapper objWrapper = new RelatedAttendeeListCotroller.AttendeeWrapper(); 
        objWrapper.firstName ='test';
        objWrapper.lastName ='test';
        objWrapper.email ='dsfsdfsdfsdf@sdfsdf.com';
        objWrapper.phone ='23232';
        objWrapper.undefined =false;
        objWrapper.key =1;
        objWrapper.memberInvitee =true;
        objWrapper.company ='REsonant';
        objWrapper.positionTitle ='Hello';
        objWrapper.Dietary_Req ='Veg';
        
        mapData.put(1,objWrapper);
        
        //Added by Umang--Start
        RelatedAttendeeListCotroller.AttendeeWrapper objWrapper1 = new RelatedAttendeeListCotroller.AttendeeWrapper();
        
        objWrapper1.firstName =null;
        objWrapper1.lastName =null;
        objWrapper1.email =null;
        objWrapper1.phone =null;
        objWrapper1.undefined =true;
        objWrapper1.key =2;
        objWrapper1.memberInvitee = null;
        objWrapper1.company = null;
        objWrapper1.positionTitle = null;
        objWrapper1.Dietary_Req = null;
        
        mapData.put(2,objWrapper1);
        //Added by Umang--End
        
        er.AttendeeList = mapData;
        
        er.myComponentController = new RelatedAttendeeListCotroller();
        test.startTest();           
//            er.initializeAttendees();
//            er.updateRecords();
        
        test.stopTest();
        
        
    }
}
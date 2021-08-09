@isTest(SeeAllData=true)
public class EventRegistrationEditController_Test {
    
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
        //Removing Payment_Gateway__c from Event__c by Yugandhara on 19th Sept 2017
        //newEvent.Payment_Gateway__c = obj_PaymentGateway.Id;
        insert newEvent;
        System.debug(newEvent);
        
        
          Event__c newEvent1 = new Event__c(); 
        newEvent1.Active__c=true;
        newEvent1.Event_End_Date__c=System.today().addMonths(1);
        //newEvent.CurrencyIsoCode='AUD';
        newEvent1.Event_Name__c='Test Event Trigger Pipeline Forecast';
        newEvent1.Event_Type__c='Conference';
        newEvent1.Event_Start_Time__c=System.now();
        newEvent1.Event_Start_Date__c=newEvent1.Event_Start_Time__c.Date();
        newEvent1.Event_Finish_Time__c =System.now();
        newEvent1.Marketing_Coordinator__c = UserInfo.getUserId();
        newEvent1.Colour_Scheme__C ='Red'; 
        newEvent1.Brand__c ='Aventedge';
        newEvent1.Venue__c = ve.Id;
        newEvent1.Timezone__c = 'British Summer Time';
        //Removing Payment_Gateway__c from Event__c by Yugandhara on 19th Sept 2017
        //newEvent1.Payment_Gateway__c = obj_PaymentGateway.Id;
        insert newEvent1;
 
        Account acct = new Account();
        acct.name = 'avvv';
        insert acct;
        
         Opportunity opp = new Opportunity();
            opp.Name='Opportunity '+'Test testRegistrationsTrigger';
            opp.StageName='KIV';
            
            opp.CloseDate=System.today().addMonths(1);
            opp.Event__c=newEvent.Id;                  
            opp.AccountId=acct.Id;
            opp.Event__c =newEvent1.Id;
            
          insert opp;    
          System.debug(opp);        
         
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
        evereg.First_Name__c = 'Not Known';
        evereg.Last_Name__c = 'Not Known';
        evereg.Email__c = 'NotKnown@test.com';
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Registration_Type__c = 'Guest';
        evereg.Opportunity__c = opp.Id;
        insert evereg;
        System.debug(evereg);
        
        Event_Registration__c evereg1 = new  Event_Registration__c();
        evereg1.Event__c = newEvent.Id;
        evereg1.First_Name__c = 'abc';
        evereg1.Last_Name__c = 'abc';
        evereg1.Email__c = 'abc@test.com';
        evereg1.Event_Package__c = newEventPackage.Id;
        evereg1.Registration_Type__c = 'Guest';
        evereg1.Opportunity__c = opp.Id;
        insert evereg1;
        System.debug(evereg);
        
        Blob cryptoKey = EncodingUtil.base64decode(Label.cryptoKey);
        // Generate the data to be encrypted.
        Blob data = Blob.valueOf(opp.Id);
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
        
         Event_Registration_Attendee__c erAttendee1 = new Event_Registration_Attendee__c();
         erAttendee1.FirstName__c = null ;
         erAttendee1.LastName__c = null;
         erAttendee1.Attendee_Email__c = 'umang@resonantcloud.info';
         erAttendee1.Position__c = 'software engineer';
         erAttendee1.Company__c = 'Resonant Cloud';
         erAttendee1.Dietary_Requirements__c = 'veg';
         erAttendee1.Event__c = newEvent.id;
         erAttendee1.Event_Registration__c = evereg.id;
        insert erAttendee1;
        
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
        objWrapper1.key =1;
        objWrapper1.memberInvitee = null;
        objWrapper1.company = null;
        objWrapper1.positionTitle = null;
        objWrapper1.Dietary_Req = null;
        
         mapData.put(1,objWrapper);
       
        
      
        //Added by Umang--End
        
        Contact c = new Contact();
        c.FirstName = 'a';
        c.Lastname = 'b';
        c.Email = objWrapper.email;
        c.AccountId = acct.Id;
        c.Business_Function__c = 'Accounts';
        insert c;
        
        Contact c1 = new Contact();
        c1.FirstName = 'a';
        c1.Lastname = 'b';
        c1.AccountId = acct.Id;
        c1.Business_Function__c = 'Accounts';
        insert c1;
        
        Blob eventRegId = EncodingUtil.base64decode(apexPages.currentPage().getParameters().get('eventRegId'));
        er.AttendeeList = mapData;
        
        er.myComponentController = new RelatedAttendeeListCotroller();
        test.startTest();           
        er.initializeAttendees();
        er.updateRecords();
        
        test.stopTest();
        
        
        
    }
      static testMethod void EventRegistrationEditControllertest1() {
      
        Venue__c ve = new Venue__c();
        ve.Name = 'Ahmedabad';
        ve.Street_Address_1__c ='test' ;
        ve.Street_Address_2__c = 'test';
        ve.City__c='test';
        ve.State__c='test';
        ve.Country__c='test';
        ve.Postal_Code_Zip__c = '382350';
        insert ve;
        
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
        //Removing Payment_Gateway__c from Event__c by Yugandhara on 19th Sept 2017
        //newEvent.Payment_Gateway__c = obj_PaymentGateway.Id;
        insert newEvent;
        System.debug(newEvent);
        
        
        Event__c newEvent1 = new Event__c(); 
        newEvent1.Active__c=true;
        newEvent1.Event_End_Date__c=System.today().addMonths(1);
        //newEvent.CurrencyIsoCode='AUD';
        newEvent1.Event_Name__c='Test Event Trigger Pipeline Forecast';
        newEvent1.Event_Type__c='Conference';
        newEvent1.Event_Start_Time__c=System.now();
        newEvent1.Event_Start_Date__c=newEvent1.Event_Start_Time__c.Date();
        newEvent1.Event_Finish_Time__c =System.now();
        newEvent1.Marketing_Coordinator__c = UserInfo.getUserId();
        newEvent1.Colour_Scheme__C ='Red'; 
        newEvent1.Brand__c ='Aventedge';
        newEvent1.Venue__c = ve.Id;
        newEvent1.Timezone__c = 'British Summer Time';
        //Removing Payment_Gateway__c from Event__c by Yugandhara on 19th Sept 2017
        //newEvent1.Payment_Gateway__c = obj_PaymentGateway.Id;
        insert newEvent1;
 
        Account acct = new Account();
        acct.name = 'avvv';
        insert acct;
        
         Opportunity opp = new Opportunity();
            opp.Name='Opportunity '+'Test testRegistrationsTrigger';
            opp.StageName='KIV';
            
            opp.CloseDate=System.today().addMonths(1);
            opp.Event__c=newEvent.Id;                  
            opp.AccountId=acct.Id;
            opp.Event__c =newEvent1.Id;
            
          insert opp;    
          System.debug(opp);        
         
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
        evereg.First_Name__c = 'Not Known';
        evereg.Last_Name__c = 'Not Known';
        evereg.Email__c = 'NotKnown@test.com';
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Registration_Type__c = 'Guest';
        evereg.Opportunity__c = opp.Id;
        insert evereg;
        System.debug(evereg);
        
        Event_Registration__c evereg1 = new  Event_Registration__c();
        evereg1.Event__c = newEvent.Id;
        evereg1.First_Name__c = 'abc';
        evereg1.Last_Name__c = 'abc';
        evereg1.Email__c = 'abc@test.com';
        evereg1.Event_Package__c = newEventPackage.Id;
        evereg1.Registration_Type__c = 'Guest';
        evereg1.Opportunity__c = opp.Id;
        insert evereg1;
        System.debug(evereg);
        
        Blob cryptoKey = EncodingUtil.base64decode(Label.cryptoKey);
        // Generate the data to be encrypted.
        Blob data = Blob.valueOf(opp.Id);
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
        
         Event_Registration_Attendee__c erAttendee1 = new Event_Registration_Attendee__c();
         erAttendee1.FirstName__c = null ;
         erAttendee1.LastName__c = null;
         erAttendee1.Attendee_Email__c = 'umang@resonantcloud.info';
         erAttendee1.Position__c = 'software engineer';
         erAttendee1.Company__c = 'Resonant Cloud';
         erAttendee1.Dietary_Requirements__c = 'veg';
         erAttendee1.Event__c = newEvent.id;
         erAttendee1.Event_Registration__c = evereg.id;
        insert erAttendee1;
        
        EventRegistrationEditController er = new EventRegistrationEditController();
        ComponentControllerBase objbaseClass = er.MyComponentController;
        er.setComponentController(objbaseClass );
        Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper> mapData = new Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper>();
        
        //Added by Umang--Start
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
        
        mapData.put(2,objWrapper);
       
        
      
        //Added by Umang--End
        
        Contact c = new Contact();
        c.FirstName = 'a';
        c.Lastname = 'b';
        c.AccountId = acct.Id;
        c.Business_Function__c = 'Accounts';
        insert c;
   
        Blob eventRegId = EncodingUtil.base64decode(apexPages.currentPage().getParameters().get('eventRegId'));
        er.AttendeeList = mapData;
        
        er.myComponentController = new RelatedAttendeeListCotroller();
        test.startTest();           
        er.updateRecords();
        
        test.stopTest();
      
  }
}
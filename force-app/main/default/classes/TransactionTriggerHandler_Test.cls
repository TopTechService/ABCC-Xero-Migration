@isTest
public class TransactionTriggerHandler_Test {    
  
   static testMethod void myTesttables() {
        Id ids;
        Account acc = new Account();
        acc.Name = 'testacc';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'testcon';
        con.Account = acc;
        con.LastName = 'testLast';
        con.Business_function__C = 'Events';
        insert con;
        
        Venue__c newvenue = new Venue__c();
        newvenue.Name= 'Ahmedabad';
        newvenue.Street_Address_1__c = 'paldi';
        newvenue.Street_Address_2__c = 'road';
        newvenue.City__c = 'Ahmedabad';
        newvenue.State__c = 'Gujarat';
        newvenue.Country__c = 'India';
        newvenue.Postal_Code_Zip__c = '123';
        insert newvenue;
        
        Event__c newEvent = new Event__c();
        newEvent.Active__c=true;
        newEvent.Event_Start_Date__c = system.today();
        newEvent.Event_Start_Time__c=System.today();
        newEvent.Event_End_Date__c=System.today().addMonths(1);
        newEvent.Event_Finish_Time__c = system.today().addMonths(1);
        newEvent.Venue__c = newvenue.Id;
        newEvent.Timezone__c = 'British Summer Time';
        //newEvent.CurrencyIsoCode='AUD';
        newEvent.Event_Name__c='Test Event Trigger Pipeline Forecast'; 
        newEvent.Event_Type__c='Conference';
        newEvent.Marketing_Coordinator__c = UserInfo.getUserId();
        newEvent.Colour_Scheme__c ='Red'; 
        newEvent.Brand__c ='Aventedge';
        newEvent.Seats_Per_Table__c =20;
        insert newEvent;
        
        Event_Package__c newEventPackage = new Event_Package__c();
         newEventPackage.Description__c='Test Event Package';
        newEventPackage.Name='Test Event Package';
        newEventPackage.IsStandardPackage__c=true;
        newEventPackage.Stadard_Price__c=1999;
        newEventPackage.Event__c=newEvent.Id;
        newEventPackage.Standard_Price__c = 2000;
        newEventPackage.Member_Price__c = 2000;
        newEventPackage.Type__c = 'Table';
        //newEventPackage.CurrencyIsoCode='AUD';  
        insert newEventPackage;
        
         Event_Package__c newEventPackage1 = new Event_Package__c();
         newEventPackage1.Description__c='Test Event Package';
        newEventPackage1.Name='Test Event Package';
        newEventPackage1.IsStandardPackage__c=true;
        newEventPackage1.Stadard_Price__c=1999;
        newEventPackage1.Event__c=newEvent.Id;
        newEventPackage1.Standard_Price__c = 2000;
        newEventPackage1.Member_Price__c = 2000;
        newEventPackage1.Type__c = 'Single Ticket';
        //newEventPackage.CurrencyIsoCode='AUD';  
        insert newEventPackage1;
        system.debug(newEventPackage.id);
        System.debug([Select Id,Type__c from Event_Package__c where Id =:newEventPackage1.Id ]);
        
        Opportunity opps = new Opportunity();
        opps.Name = 'testopp';
        opps.Amount = 1000;
        opps.Account = acc;
        opps.StageName = 'Closed Won';
        opps.Event_Package__c = newEventPackage.Id;
        opps.Event__c = newEvent.Id;
        opps.CloseDate = System.today().addMonths(1);
        opps.Ticket_Qty__c = 0;
        insert opps;
        
              
        ids = opps.Id;
        Opportunity opportunitytables = [Select Id,Name,Event__c,Event_Package__r.Type__c,Primary_Contact__r.Email,Primary_Contact__r.FirstName,Event_Package__r.Name,Ticket_Qty__c,(Select Id from Event_Registrations__r) from Opportunity where Id =:opps.Id];
         
        System.debug( opportunitytables.Event_Package__r.Type__c);
        Table__c testtable = new Table__c();
        testtable.Event__c = newevent.Id;
        insert testtable;
        
        Event_Registration__c evereg = new Event_Registration__c();
        evereg.Event__c = newEvent.Name;
        evereg.Event__c = newEvent.Id;
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Opportunity__c = opps.Id;
        evereg.Contact__c = con.Id;
        evereg.First_Name__c = 'testfirst';
        evereg.Last_Name__c = 'testlast';
        evereg.Job_Title__c = 'testjob';
        evereg.Telphone__c = '11222333';
        evereg.Email__c = 'abc@test.com';
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Dietary_Requirements__c = 'testdietary';
        evereg.Contact__c = con.Name;
        evereg.Opportunity__c = opps.Id;
        evereg.Table__c=testtable.Id;
        insert evereg;
        
        Table__c testtable2 = new Table__c();
        testtable2.Occupied_Seats__c=10;
        testtable2.Event__c = newevent.Id;
        insert testtable2;
        
        Table__c testtable3 = new Table__c();
        testtable3.Occupied_Seats__c=20;
        testtable3.Event__c = newevent.Id;
        insert testtable3;
        
        List<Table__c> tabl = new List<Table__c>([select Name,Id,Vacant_Seats__c,Occupied_Seats__c,Capacity__c from Table__c where Id =: testtable2.Id]);
        List<Table__c> tabl2 = new List<Table__c>([select Name,Id,Vacant_Seats__c,Occupied_Seats__c,Capacity__c from Table__c where Id =: testtable3.Id]);
        List<Table__c> tabl3 = new List<Table__c>([select Name,Id,Vacant_Seats__c,Occupied_Seats__c,Capacity__c from Table__c where Id =: testtable.Id]);
       
        List<Event_Registration__c> er = new List<Event_Registration__c>([select Id,Table__c,Table__r.Capacity__c from Event_Registration__c where Table__c =:testtable.Id]);
        System.debug(er[0].Table__r.Capacity__c);
        
        List<Event_Registration__c> remainingER = new List<Event_Registration__c>();
    
        Table__c minVacantSufficient = tabl[0] ;
        Table__c maxVacantNotSufficient = null;
        test.startTest();
 
        TransactionTriggerHandler a = new TransactionTriggerHandler();
        a.allocateTables(new List<Opportunity> {opportunitytables });
       
        a.findTable(tabl3,0,er,opps);
        a.findTable(tabl,6,er,opps);
        a.findTable(tabl,30,er,opps);
        System.assertEquals('Table',newEventPackage.Type__c);
        System.assertEquals(1,er.size());
        System.assertnotEquals(null,minVacantSufficient );
        a.findTable(tabl, opps.Event_Registrations__r.size(), opps.Event_Registrations__r, opps);
        System.assertEquals(null,maxVacantNotSufficient);
        test.stopTest();
    }
    
     static testMethod void myTesttable2() {
        Id ids;
        Account acc = new Account();
        acc.Name = 'testacc';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'testcon';
        con.Account = acc;
        con.LastName = 'testLast';
        con.Business_function__C = 'Events';
        insert con;
        
        Venue__c newvenue = new Venue__c();
        newvenue.Name= 'Ahmedabad';
        newvenue.Street_Address_1__c = 'paldi';
        newvenue.Street_Address_2__c = 'road';
        newvenue.City__c = 'Ahmedabad';
        newvenue.State__c = 'Gujarat';
        newvenue.Country__c = 'India';
        newvenue.Postal_Code_Zip__c = '123';
        insert newvenue;
        
        Event__c newEvent = new Event__c();
        newEvent.Active__c=true;
        newEvent.Event_Start_Date__c = system.today();
        newEvent.Event_Start_Time__c=System.today();
        newEvent.Event_End_Date__c=System.today().addMonths(1);
        newEvent.Event_Finish_Time__c = system.today().addMonths(1);
        newEvent.Venue__c = newvenue.Id;
        newEvent.Timezone__c = 'British Summer Time';
        //newEvent.CurrencyIsoCode='AUD';
        newEvent.Event_Name__c='Test Event Trigger Pipeline Forecast'; 
        newEvent.Event_Type__c='Conference';
        newEvent.Marketing_Coordinator__c = UserInfo.getUserId();
        newEvent.Colour_Scheme__c ='Red'; 
        newEvent.Brand__c ='Aventedge';
        newEvent.Seats_Per_Table__c =20;
        insert newEvent;
        
        Event_Package__c newEventPackage = new Event_Package__c();
         newEventPackage.Description__c='Test Event Package';
        newEventPackage.Name='Test Event Package';
        newEventPackage.IsStandardPackage__c=true;
        newEventPackage.Stadard_Price__c=1999;
        newEventPackage.Event__c=newEvent.Id;
        newEventPackage.Standard_Price__c = 2000;
        newEventPackage.Member_Price__c = 2000;
        newEventPackage.Type__c = 'Single Ticket';
        //newEventPackage.CurrencyIsoCode='AUD';  
        insert newEventPackage;
        
        
        Opportunity opps = new Opportunity();
        opps.Name = 'testopp';
        opps.Amount = 1000;
        opps.Account = acc;
        opps.StageName = 'Closed Won';
        opps.Event_Package__c = newEventPackage.Id;
        opps.Event__c = newEvent.Id;
        opps.CloseDate = System.today().addMonths(1);
        opps.Ticket_Qty__c = null;
        insert opps;
        
        ids = opps.Id;
        Opportunity o = [Select Id,Name,Event__c,Event_Package__r.Type__c,Primary_Contact__r.Email,Primary_Contact__r.FirstName,Event_Package__r.Name,Ticket_Qty__c,(Select Id from Event_Registrations__r) from Opportunity where Id =:opps.Id];
          
          Table__c testtable9 = new Table__c();
        testtable9.Event__c = newevent.Id;
        insert testtable9;
          
          
        Event_Registration__c evereg = new Event_Registration__c();
        evereg.Event__c = newEvent.Name;
        evereg.Event__c = newEvent.Id;
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Opportunity__c = opps.Id;
        evereg.Contact__c = con.Id;
        evereg.First_Name__c = 'testfirst';
        evereg.Last_Name__c = 'testlast';
        evereg.Job_Title__c = 'testjob';
        evereg.Telphone__c = '11222333';
        evereg.Email__c = 'abc@test.com';
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Dietary_Requirements__c = 'testdietary';
        evereg.Contact__c = con.Name;
        evereg.Opportunity__c = opps.Id;
        evereg.Table__c = testtable9.Id;
        insert evereg;
        
        Table__c testtable = new Table__c();
        testtable.Event__c = newevent.Id;
        insert testtable;
        
       Table__c testtable2 = new Table__c();
        testtable2.Occupied_Seats__c=10;
        testtable2.Event__c = newevent.Id;
        insert testtable2;
        
        Table__c testtable3 = new Table__c();
        testtable3.Occupied_Seats__c=20;
        testtable3.Event__c = newevent.Id;
        insert testtable3;
        
        List<Table__c> tabl = new List<Table__c>([select Name,Id,Vacant_Seats__c,Occupied_Seats__c,Capacity__c from Table__c where Id =: testtable2.Id]);
        List<Table__c> tabl2 = new List<Table__c>([select Name,Id,Vacant_Seats__c,Occupied_Seats__c,Capacity__c from Table__c where Id =: testtable3.Id]);
        List<Table__c> tabl3 = new List<Table__c>([select Name,Id,Vacant_Seats__c,Occupied_Seats__c,Capacity__c from Table__c where Id =: testtable.Id]);
       List<Event_Registration__c> er = new List<Event_Registration__c>([select Id,Table__c from Event_Registration__c where Id =: evereg.Id]);
           
        Table__c minVacantSufficient = tabl[0] ;
        Integer count = 1;
        Integer i =0;
         Table__c maxVacantNotSufficient = tabl[0];
        
        test.startTest();
 
        TransactionTriggerHandler a = new TransactionTriggerHandler();
        a.allocateTables(new List<Opportunity> {o});
        
        System.assertEquals(10, maxVacantNotSufficient.Occupied_Seats__c); 
        System.assertEquals('Single Ticket',newEventPackage.Type__c);
        System.assertnotEquals(0,er.size());
        a.findTable(tabl, opps.Event_Registrations__r.size(), opps.Event_Registrations__r, opps);
        test.stopTest();
    }
    
  
  
    static testMethod void myTesttable3() {
   
     Id ids;
        Account acc = new Account();
        acc.Name = 'testacc';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'testcon';
        con.Account = acc;
        con.LastName = 'testLast';
        con.Business_function__C = 'Events';
        insert con;
        
        Venue__c newvenue = new Venue__c();
        newvenue.Name= 'Ahmedabad';
        newvenue.Street_Address_1__c = 'paldi';
        newvenue.Street_Address_2__c = 'road';
        newvenue.City__c = 'Ahmedabad';
        newvenue.State__c = 'Gujarat';
        newvenue.Country__c = 'India';
        newvenue.Postal_Code_Zip__c = '123';
        insert newvenue;
        
        Event__c newEvent = new Event__c();
        newEvent.Active__c=true;
        newEvent.Event_Start_Date__c = system.today();
        newEvent.Event_Start_Time__c=System.today();
        newEvent.Event_End_Date__c=System.today().addMonths(1);
        newEvent.Event_Finish_Time__c = system.today().addMonths(1);
        newEvent.Venue__c = newvenue.Id;
        newEvent.Timezone__c = 'British Summer Time';
        //newEvent.CurrencyIsoCode='AUD';
        newEvent.Event_Name__c='Test Event Trigger Pipeline Forecast'; 
        newEvent.Event_Type__c='Conference';
        newEvent.Marketing_Coordinator__c = UserInfo.getUserId();
        newEvent.Colour_Scheme__c ='Red'; 
        newEvent.Brand__c ='Aventedge';
        newEvent.Seats_Per_Table__c = 2;
        insert newEvent;
            
        Event_Package__c newEventPackage = new Event_Package__c();
         newEventPackage.Description__c='Test Event Package';
        newEventPackage.Name='Test Event Package';
        newEventPackage.IsStandardPackage__c=true;
        newEventPackage.Stadard_Price__c=1999;
        newEventPackage.Event__c=newEvent.Id;
        newEventPackage.Standard_Price__c = 2000;
        newEventPackage.Member_Price__c = 2000;
        newEventPackage.Type__c = 'Table';
        //newEventPackage.CurrencyIsoCode='AUD';  
        insert newEventPackage;
  
        Opportunity opps = new Opportunity();
        opps.Name = 'testopp';
        opps.Amount = 1000;
        opps.Account = acc;
        opps.StageName = 'Closed Won';
        opps.Event_Package__c = newEventPackage.Id;
        opps.Event__c = newEvent.Id;
        opps.CloseDate = System.today().addMonths(1);
        opps.Ticket_Qty__c = 2;
        insert opps;
              
        ids = opps.Id;
         
        Event_Registration__c evereg = new Event_Registration__c();
        evereg.Event__c = newEvent.Name;
        evereg.Event__c = newEvent.Id;
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Opportunity__c = opps.Id;
        evereg.Contact__c = con.Id;
        evereg.First_Name__c = 'testfirst';
        evereg.Last_Name__c = 'testlast';
        evereg.Job_Title__c = 'testjob';
        evereg.Telphone__c = '11222333';
        evereg.Email__c = 'abc@test.com';
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Dietary_Requirements__c = 'testdietary';
        evereg.Contact__c = con.Name;
        evereg.Opportunity__c = opps.Id;
        insert evereg;
        
             Event_Registration__c evereg1 = new Event_Registration__c();
        evereg1.Event__c = newEvent.Name;
        evereg1.Event__c = newEvent.Id;
        evereg1.Event_Package__c = newEventPackage.Id;
        evereg1.Opportunity__c = opps.Id;
        evereg1.Contact__c = con.Id;
        evereg1.First_Name__c = 'testfirst';
        evereg1.Last_Name__c = 'testlast';
        evereg1.Job_Title__c = 'testjob';
        evereg1.Telphone__c = '11222333';
        evereg1.Email__c = 'abc@test.com';
        evereg1.Event_Package__c = newEventPackage.Id;
        evereg1.Dietary_Requirements__c = 'testdietary';
        evereg1.Contact__c = con.Name;
        evereg1.Opportunity__c = opps.Id;
        insert evereg1;
   
        Event_Registration__c evereg2 = new Event_Registration__c();
        evereg2.Event__c = newEvent.Name;
        evereg2.Event__c = newEvent.Id;
        evereg2.Event_Package__c = newEventPackage.Id;
        evereg2.Opportunity__c = opps.Id;
        evereg2.Contact__c = con.Id;
        evereg2.First_Name__c = 'testfirst';
        evereg2.Last_Name__c = 'testlast';
        evereg2.Job_Title__c = 'testjob';
        evereg2.Telphone__c = '11222333';
        evereg2.Email__c = 'abc@test.com';
        evereg2.Event_Package__c = newEventPackage.Id;
        evereg2.Dietary_Requirements__c = 'testdietary';
        evereg2.Contact__c = con.Name;
        evereg2.Opportunity__c = opps.Id;
        insert evereg2;
   
        Event_Registration__c evereg3 = new Event_Registration__c();
        evereg3.Event__c = newEvent.Name;
        evereg3.Event__c = newEvent.Id;
        evereg3.Event_Package__c = newEventPackage.Id;
        evereg3.Opportunity__c = opps.Id;
        evereg3.Contact__c = con.Id;
        evereg3.First_Name__c = 'testfirst';
        evereg3.Last_Name__c = 'testlast';
        evereg3.Job_Title__c = 'testjob';
        evereg3.Telphone__c = '11222333';
        evereg3.Email__c = 'abc@test.com';
        evereg3.Event_Package__c = newEventPackage.Id;
        evereg3.Dietary_Requirements__c = 'testdietary';
        evereg3.Contact__c = con.Name;
        evereg3.Opportunity__c = opps.Id;
        insert evereg3;
        
       Table__c testtable2 = new Table__c();
        testtable2.Event__c = newevent.Id;
        insert testtable2;
        
        Table__c testtable3 = new Table__c();
        testtable3.Event__c = newevent.Id;
        insert testtable3;
        
        Table__c testtable4 = new Table__c();
        testtable4.Event__c = newevent.Id;
        insert testtable4;
        
        Opportunity opportunitytable = [Select Id,Name,Event__c,Event_Package__r.Type__c,Primary_Contact__r.Email,Primary_Contact__r.FirstName,Event_Package__r.Name,Ticket_Qty__c,(Select Id from Event_Registrations__r) from Opportunity where Id =:opps.Id];
        System.debug(opportunitytable .Event_Registrations__r);
        Integer count = 2;
       
        test.startTest();
 
        TransactionTriggerHandler a = new TransactionTriggerHandler();
        a.allocateTables(new List<Opportunity> {opportunitytable });
        
        test.stopTest();
        }

        static testMethod void myTesttable4() {
   
     Id ids;
       Account acc = new Account();
        acc.Name = 'testacc';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'testcon';
        con.Account = acc;
        con.LastName = 'testLast';
        con.Business_function__C = 'Events';
        insert con;
        
        Venue__c newvenue = new Venue__c();
        newvenue.Name= 'Ahmedabad';
        newvenue.Street_Address_1__c = 'paldi';
        newvenue.Street_Address_2__c = 'road';
        newvenue.City__c = 'Ahmedabad';
        newvenue.State__c = 'Gujarat';
        newvenue.Country__c = 'India';
        newvenue.Postal_Code_Zip__c = '123';
        insert newvenue;
        
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
        newEvent.Event_Start_Date__c = system.today();
        newEvent.Event_Start_Time__c=System.today();
        newEvent.Event_End_Date__c=System.today().addMonths(1);
        newEvent.Event_Finish_Time__c = system.today().addMonths(1);
        newEvent.Venue__c = newvenue.Id;
        newEvent.Timezone__c = 'British Summer Time';
        //newEvent.CurrencyIsoCode='AUD';
        newEvent.Event_Name__c='Test Event Trigger Pipeline Forecast'; 
        newEvent.Event_Type__c='Conference';
        newEvent.Marketing_Coordinator__c = UserInfo.getUserId();
        newEvent.Colour_Scheme__c ='Red'; 
        newEvent.Brand__c ='Aventedge';
        newEvent.Seats_Per_Table__c =0;
        //Removing Payment_Gateway__c from Event__c by Yugandhara on 19th sept 2017
        //newEvent.Payment_Gateway__c = obj_PaymentGateway.id;
        insert newEvent;
        
        Event_Package__c newEventPackage = new Event_Package__c();
         newEventPackage.Description__c='Test Event Package';
        newEventPackage.Name='Test Event Package';
        newEventPackage.IsStandardPackage__c=true;
        newEventPackage.Stadard_Price__c=1999;
        newEventPackage.Event__c=newEvent.Id;
        newEventPackage.Standard_Price__c = 2000;
        newEventPackage.Member_Price__c = 2000;
        newEventPackage.Type__c = 'Table';
        //newEventPackage.CurrencyIsoCode='AUD';  
        insert newEventPackage;
        
         Event_Package__c newEventPackage1 = new Event_Package__c();
         newEventPackage1.Description__c='Test Event Package';
        newEventPackage1.Name='Test Event Package';
        newEventPackage1.IsStandardPackage__c=true;
        newEventPackage1.Stadard_Price__c=1999;
        newEventPackage1.Event__c=newEvent.Id;
        newEventPackage1.Standard_Price__c = 2000;
        newEventPackage1.Member_Price__c = 2000;
        newEventPackage1.Type__c = 'Single Ticket';
        //newEventPackage.CurrencyIsoCode='AUD';  
        insert newEventPackage1;
        system.debug(newEventPackage.id);
        System.debug([Select Id,Type__c from Event_Package__c where Id =:newEventPackage1.Id ]);
        
        Opportunity opps = new Opportunity();
        opps.Name = 'testopp';
        opps.Amount = 1000;
        opps.Account = acc;
        opps.StageName = 'Closed Won';
        opps.Event_Package__c = newEventPackage.Id;
        opps.Event__c = newEvent.Id;
        opps.CloseDate = System.today().addMonths(1);
        opps.Ticket_Qty__c = 0;
        insert opps;
              
        ids = opps.Id;
         
        Event_Registration__c evereg = new Event_Registration__c();
        evereg.Event__c = newEvent.Name;
        evereg.Event__c = newEvent.Id;
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Opportunity__c = opps.Id;
        evereg.Contact__c = con.Id;
        evereg.First_Name__c = 'testfirst';
        evereg.Last_Name__c = 'testlast';
        evereg.Job_Title__c = 'testjob';
        evereg.Telphone__c = '11222333';
        evereg.Email__c = 'abc@test.com';
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Dietary_Requirements__c = 'testdietary';
        evereg.Contact__c = con.Name;
        evereg.Opportunity__c = opps.Id;
        insert evereg;
        
        Event_Registration__c evereg1 = new Event_Registration__c();
        evereg1.Event__c = newEvent.Name;
        evereg1.Event__c = newEvent.Id;
        evereg1.Event_Package__c = newEventPackage.Id;
        evereg1.Opportunity__c = opps.Id;
        evereg1.Contact__c = con.Id;
        evereg1.First_Name__c = 'testfirst';
        evereg1.Last_Name__c = 'testlast';
        evereg1.Job_Title__c = 'testjob';
        evereg1.Telphone__c = '11222333';
        evereg1.Email__c = 'abc@test.com';
        evereg1.Event_Package__c = newEventPackage.Id;
        evereg1.Dietary_Requirements__c = 'testdietary';
        evereg1.Contact__c = con.Name;
        evereg1.Opportunity__c = opps.Id;
        insert evereg1;
   
        Event_Registration__c evereg2 = new Event_Registration__c();
        evereg2.Event__c = newEvent.Name;
        evereg2.Event__c = newEvent.Id;
        evereg2.Event_Package__c = newEventPackage.Id;
        evereg2.Opportunity__c = opps.Id;
        evereg2.Contact__c = con.Id;
        evereg2.First_Name__c = 'testfirst';
        evereg2.Last_Name__c = 'testlast';
        evereg2.Job_Title__c = 'testjob';
        evereg2.Telphone__c = '11222333';
        evereg2.Email__c = 'abc@test.com';
        evereg2.Event_Package__c = newEventPackage.Id;
        evereg2.Dietary_Requirements__c = 'testdietary';
        evereg2.Contact__c = con.Name;
        evereg2.Opportunity__c = opps.Id;
        insert evereg2;
       
       Table__c testtable2 = new Table__c();
        testtable2.Event__c = newevent.Id;
        testtable2.Occupied_Seats__c = 0;
        insert testtable2;
        
        Event_Registration__c evereg3 = new Event_Registration__c();
        evereg3.Event__c = newEvent.Name;
        evereg3.Event__c = newEvent.Id;
        evereg3.Event_Package__c = newEventPackage.Id;
        evereg3.Opportunity__c = opps.Id;
        evereg3.Contact__c = con.Id;
        evereg3.First_Name__c = 'testfirst';
        evereg3.Last_Name__c = 'testlast';
        evereg3.Job_Title__c = 'testjob';
        evereg3.Telphone__c = '11222333';
        evereg3.Email__c = 'abc@test.com';
        evereg3.Event_Package__c = newEventPackage.Id;
        evereg3.Dietary_Requirements__c = 'testdietary';
        evereg3.Contact__c = con.Name;
        evereg3.Opportunity__c = opps.Id;
        evereg3.Table__r = testtable2;
        insert evereg3;
        
        Opportunity opportunitytable = [Select Id,Name,Event__c,Event_Package__r.Type__c,Primary_Contact__r.Email,Primary_Contact__r.FirstName,Event_Package__r.Name,Ticket_Qty__c,(Select Id from Event_Registrations__r) from Opportunity where Id =:opps.Id];
        System.debug(opportunitytable .Event_Registrations__r);
       
        test.startTest();
 
        TransactionTriggerHandler a = new TransactionTriggerHandler();
        a.allocateTables(new List<Opportunity> {opportunitytable });
        
        test.stopTest();
        }
        


}
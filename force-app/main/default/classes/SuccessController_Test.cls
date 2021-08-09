@isTest
public class SuccessController_Test {
    
public List<Venue__c> newVanues;
    
    @Testsetup Public Static Void SetUpData(){
       
     
    }
    
Public Static testmethod void testsuccess(){
    
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
    newEvent.Event_Timezone__c = 'Australia/Sydney';
    //newEvent.CurrencyIsoCode='AUD';
    newEvent.Event_Name__c='Test Event Trigger Pipeline Forecast'; 
    newEvent.Event_Type__c='Conference';
    newEvent.Marketing_Coordinator__c = UserInfo.getUserId();
    newEvent.Colour_Scheme__c ='Red'; 
    newEvent.Brand__c ='Aventedge';
    //Removing Payment_Gateway__c from Event__c by Yugandhara on 19th sept 2017
    //newEvent.Payment_Gateway__c = obj_PaymentGateway.Id;
    insert newEvent;
 
    Event_Package__c newEventPackage = new Event_Package__c();
    newEventPackage.Description__c='Test Event Package';
    newEventPackage.Name='Test Event Package';
    newEventPackage.IsStandardPackage__c=true;
    newEventPackage.Stadard_Price__c=1999;
    newEventPackage.Event__c=newEvent.Id;
    newEventPackage.Standard_Price__c = 2000;
    newEventPackage.Member_Price__c = 2000;
    //newEventPackage.CurrencyIsoCode='AUD';  
    insert newEventPackage;
    
    Opportunity opp = new Opportunity();
    opp.Name = 'testopp';
    opp.Amount = 1000;
    opp.Account = acc;
    opp.StageName = 'Closed Won';
    opp.Event__c =newEvent.Id;
    opp.CloseDate = System.today().addMonths(1);
    insert opp;
    ids = opp.Id;
    
    Card_Transaction__c ccTrans = new Card_Transaction__c();
    ccTrans.Transaction_ID__c = '336527619';
    ccTrans.Opportunity__c = opp.Id;
    ccTrans.Transaction_Type__c = 'SALE';
    ccTrans.Transaction_Status__c = 'SUCCESSFUL';
    insert ccTrans;
   
     
    Event_Registration__c evereg = new Event_Registration__c();
    evereg.Event__c = newEvent.Name;
    evereg.Event__c = newEvent.Id;
    evereg.Event_Package__c = newEventPackage.Id;
    evereg.Opportunity__c = opp.Id;
    evereg.Contact__c = con.Id;
    evereg.First_Name__c = 'testfirst';
    evereg.Last_Name__c = 'testlast';
    evereg.Job_Title__c = 'testjob';
    evereg.Telphone__c = '11222333';
    evereg.Email__c = 'abc@test.com';
    evereg.Event_Package__c = newEventPackage.Id;
    evereg.Dietary_Requirements__c = 'testdietary';
    evereg.Contact__c = con.Name;
    evereg.Opportunity__c = opp.Id;
    insert evereg;      
    
    Event_Registration_Attendee__c era = new Event_Registration_Attendee__c();
    era.FirstName__c = 'testfirst';
    era.LastName__c = 'testlast';
    era.Attendee_email__c = 'test@test.com';
    era.position__c = 'testposition';
    era.Company__c = 'testcompany';
    era.Dietary_Requirements__c = 'testreq';
    era.Event_Registration__c = evereg.Id;
    era.Contact__c = con.Id;
    insert era;
    
    System.debug(era);
       
    String eventname;
    Date enddate;
    
    enddate = opp.Event__r.Event_End_Date__c;
    eventname = opp.Event__r.Event_Name__c;
    String eventlocation = opp.Event__r.Venue__c;
    
    Test.startTest();
    Test.setCurrentPage(page.Success);
    apexpages.currentpage().getparameters().put('oppId' ,opp.Id);
    
    SuccessController Success = new SuccessController();
    
    Success.populatedata();

    Test.stopTest();

             
    }

}
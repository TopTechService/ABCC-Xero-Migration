@IsTest
public class CardTransactionTrigger_Test 
{
    
    static testMethod void testmethod1() 
    {
        Campaign cmp = new Campaign();
        cmp.Name = 'Test Campaign';
        insert cmp;
        
        Account obj_Account = new Account();
        obj_Account.Name = 'Test Account';
        obj_Account.Industry='Accounting';
        insert obj_Account;
        
        opportunity obj_opportunity = new opportunity();
        obj_opportunity.Name='test';
        obj_opportunity.Accountid =obj_Account.id;
        obj_opportunity.CloseDate = date.newInstance(2017, 11, 21);
        obj_opportunity.StageName='Prospecting';
        /* obj_opportunity.pricebook2Id  = prbook.Id;
obj_opportunity.Event_Package__c = obj_Event_Package.Id;*/
        
        insert obj_opportunity;
        
        Venue__c ve = new Venue__c();
        ve.Name = 'Ahmedabad';
        ve.Street_Address_1__c ='test' ;
        ve.Street_Address_2__c = 'test';
        ve.City__c='test';
        ve.State__c='test';
        ve.Country__c='test';
        ve.Postal_Code_Zip__c = '382350';
        insert ve;
        
        Event__c newEvent1 = new Event__c();
        newEvent1.Campaign__c = cmp.Id;
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
        
        
        Event_Package__c newEventPackage = new Event_Package__c();
        newEventPackage.Description__c='Test Event Package';
        newEventPackage.Name='Test Event Package';
        newEventPackage.IsStandardPackage__c=true;
        newEventPackage.Stadard_Price__c=1999;
        newEventPackage.Event__c=newEvent1.Id;
        newEventPackage.Standard_Price__c = 1000;
        newEventPackage.Member_Price__c = 100;
        //newEventPackage.CurrencyIsoCode='AUD';        
        insert newEventPackage; 
        
        Contact con = new Contact();
        con.LastName = 'barot';
        con.Business_Function__c = 'Events';
        con.email = 'test@test.com';
        insert con;
        
        Event_Registration__c evereg = new  Event_Registration__c();
        evereg.Event__c = newEvent1.Id;
        evereg.First_Name__c = 'Not Known';
        evereg.Last_Name__c = 'Not Known';
        evereg.Email__c = 'NotKnown@test.com';
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Registration_Type__c = 'Guest';
        evereg.Opportunity__c = obj_opportunity.Id;
        evereg.Contact__c = con.Id;
            insert evereg;
        
        Card_Transaction__c obj_Card_Transaction1 = new Card_Transaction__c();
        obj_Card_Transaction1.Opportunity__c = obj_opportunity.id;
        obj_Card_Transaction1.Transaction_Status__c ='SUCCESSFUL';
        obj_Card_Transaction1.Transaction_Type__c ='SALE';
        insert obj_Card_Transaction1;
        
        Card_Transaction__c obj_Card_Transaction2 = new Card_Transaction__c();
        obj_Card_Transaction2.Opportunity__c = obj_opportunity.id;
        obj_Card_Transaction2.Transaction_Status__c ='SUCCESSFUL';
        obj_Card_Transaction2.Transaction_Type__c ='REFUND';
        insert obj_Card_Transaction2;
        
        Card_Transaction__c obj_Card_Transaction3 = new Card_Transaction__c();
        obj_Card_Transaction3.Opportunity__c = obj_opportunity.id;
        obj_Card_Transaction3.Transaction_Status__c ='FAILED';
        obj_Card_Transaction3.Transaction_Type__c ='SALE';
        insert obj_Card_Transaction3;
        
        
    }
    
}
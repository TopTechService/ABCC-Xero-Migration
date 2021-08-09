@isTest
private class EventRegistrationTrigger_Test {
	
	@isTest static void EventRegistrationSuccessful() {
		Account obj_Account = new Account();
        obj_Account.Name = 'Test Account';
        obj_Account.Industry='Accounting';
        insert obj_Account;
        
        opportunity obj_opportunity = new opportunity();
        obj_opportunity.Name='test';
        obj_opportunity.Accountid =obj_Account.id;
        obj_opportunity.CloseDate = date.newInstance(2017, 11, 21);
        obj_opportunity.StageName='Prospecting';
        obj_opportunity.Amount = 15;
        obj_opportunity.Amount_Paid__c = 10;
        insert obj_opportunity;
        
       
        
        List<Payment_Gateway__c> obj_list_Payment_Gateway = new List<Payment_Gateway__c>();
        
        obj_list_Payment_Gateway = PaymentUtility.getPaymentGatewayDetails();      
        
         Venue__c ve = new Venue__c();
        ve.Name = 'Ahmedabad';
        ve.Street_Address_1__c ='test' ;
        ve.Street_Address_2__c = 'test';
        ve.City__c='test';
        ve.State__c='test';
        ve.Country__c='test';
        ve.Postal_Code_Zip__c = '382350';
        insert ve;

        Campaign cmp = new Campaign();
        cmp.Name = 'New Cmp';
        insert cmp;
        
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
        newEvent1.Campaign__c = cmp.Id;
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
        evereg.Registration_Status__c = 'Successful';
        evereg.Contact__c = con.Id;
        insert evereg;

        CampaignMember cmpMem = new CampaignMember();
        cmpMem.ContactId = con.Id;
        cmpMem.CampaignId = cmp.Id;
        cmpMem.Status = 'Registered';
        insert cmpMem;

        Event_Registration__c evereg1 = new  Event_Registration__c();
        evereg1.Event__c = newEvent1.Id;
        evereg1.First_Name__c = 'Test';
        evereg1.Last_Name__c = 'Test';
        evereg1.Email__c = 'test@test.com';
        evereg1.Event_Package__c = newEventPackage.Id;
        evereg1.Registration_Type__c = 'Guest';
        evereg1.Opportunity__c = obj_opportunity.Id;
        evereg1.Registration_Status__c = 'Successful';
        evereg1.Contact__c = con.Id;
        insert evereg1;
	}
	
}
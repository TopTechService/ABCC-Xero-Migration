@isTest
public class PaymentTestPageController_Test {
     static testMethod void myTest() {
     
        string failURL;
        string successURL;
        string cancelURL;
        string abccLogoURL;
        test.startTest();
        
        
         Venue__c ve = new Venue__c();
        ve.Name = 'Ahmedabad';
        ve.Street_Address_1__c ='test' ;
        ve.Street_Address_2__c = 'test';
        ve.City__c='test';
        ve.State__c='test';
        ve.Country__c='test';
        ve.Postal_Code_Zip__c = '382350';
        insert ve;
          
          
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
        newEvent.venue__c = ve.Id;
        insert newEvent;
        System.debug(newEvent);
        
        Account acct = new Account();
        acct.name = 'avvv';
        insert acct;
        
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'testl';
        con.MailingStreet  = 'testmails';
        con.MailingPostalCode = '9000';
        con.AccountId = acct.Id;
        con.Business_Function__c = 'Accounts';
        insert con;
        
        Opportunity opp = new Opportunity();
        opp.Name='Opportunity '+'Test testRegistrationsTrigger';
        opp.StageName='KIV';
        //opp.Primary_Contact__r.FirstName ='testprimary';
        opp.CloseDate=System.today().addMonths(1);
        opp.Event__c=newEvent.Id;                  
        opp.AccountId=acct.Id;
         opp.Amount = 100;
        opp.Primary_Contact__c =  con.Id;
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
        evereg.Opportunity__c = opp.Id;
        insert evereg;
        System.debug(evereg);
        
        PageReference pageRef = Page.PaymentTestPage;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('oppId', Opp.Id);
        String id = ApexPages.currentPage().getParameters().get('oppId');
        System.debug(id);
    	system.assertEquals(true,id!=null);
         
        Account a = new Account();
        a.Name = 'testacc';
        insert a;
        
        
   /*     failURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Fail?oppId=' +oppId_param;
        successURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Success?oppId=' + oppId_param;
        cancelURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/EventDetail?id=' + evereg.Event__c;*/
        Payment_Gateway__c pg = new Payment_Gateway__c();
         pg.Name = 'test';
         pg.Active__c = True;
         insert pg;


System.assertnotEquals (null,pageRef);
         
        String s = 'American Express';
        PaymentTestPageController paytest = new PaymentTestPageController();
        paytest.cardNumber = '12233';
        paytest.cardExpiry = String.valueof(System.today());
         paytest.cardName= 'test';
        paytest.cardCVC = '212';
         paytest.cancelURL ='www.test.com';
        EwayPaymentProcessing eway = new EwayPaymentProcessing(id,s);
        PayflowPaymentProcessing pfp = new PayflowPaymentProcessing();
         
        
         PaymentProcessing handlePayment;
	   	PaymentUtility pu = new PaymentUtility();
         
         PaymentUtility.getPaymentGatewayDetails();
         
         
         paytest.getItems();
         paytest.setcardType1(s);
         paytest.getcardType1();
        paytest.chargeAmount();
        paytest.returnToOpportunity();
         paytest.updateOpportunity();
        test.stopTest();
         
     }
}
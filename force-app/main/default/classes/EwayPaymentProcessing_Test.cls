@isTest
public class EwayPaymentProcessing_Test{
     static testMethod void myTest() {
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
        
        Opportunity opp = new Opportunity();
        opp.Name='Opportunity '+'Test testRegistrationsTrigger';
        opp.StageName='KIV';
        //opp.Primary_Contact__r.FirstName ='testprimary';
        opp.CloseDate=System.today().addMonths(1);
        opp.AccountId=acct.Id;
         opp.Amount = 100;
        opp.Primary_Contact__c =  con.Id;
        insert opp;            
        
          Card_Transaction__c cardtrans = new Card_Transaction__c();
        cardtrans.Payment_Gateway__c = obj_PaymentGateway.Id; 
        cardtrans.Opportunity__c= opp.Id;
        insert cardtrans;       
        
         Payment_Gateway__c pg = new Payment_Gateway__c();
         pg.Name = 'test';
         pg.Active__c = True;
         insert pg;
     
         test.starttest();
         String s = String.valueof(cardtrans.Id);
         String accid = String.valueof(acct.Id);
         String exdate = String.valueof(System.today()+8);
         String cvv = '390';
         String cardname ='visa';
         EwayPaymentProcessing ep = new EwayPaymentProcessing(opp.Id,s);
    //     EwayPaymentProcessing ep1 = new EwayPaymentProcessing(opp.Id,accid,exdate,cvv,cardname);
       
         
         test.stoptest();
         
     }
     
      static testMethod void myTest1() {
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
        
        Opportunity opp = new Opportunity();
        opp.Name='Opportunity '+'Test testRegistrationsTrigger';
        opp.StageName='KIV';
        //opp.Primary_Contact__r.FirstName ='testprimary';
        opp.CloseDate=System.today().addMonths(1);
        opp.AccountId=acct.Id;
         opp.Amount = 100;
        opp.Primary_Contact__c =  con.Id;
        insert opp;            
        
          Card_Transaction__c cardtrans = new Card_Transaction__c();
        cardtrans.Payment_Gateway__c = obj_PaymentGateway.Id; 
        cardtrans.Opportunity__c= opp.Id;
        insert cardtrans;       
        
         Payment_Gateway__c pg = new Payment_Gateway__c();
         pg.Name = 'test';
         pg.Active__c = True;
         insert pg;
     
         test.starttest();
         String s = String.valueof(cardtrans.Id);
         String accid = String.valueof(acct.Id);
         String exdate = String.valueof(System.today()+8);
         String cvv = '390';
         String cardname ='visa';
        // EwayPaymentProcessing ep = new EwayPaymentProcessing(opp.Id,s);
         EwayPaymentProcessing ep1 = new EwayPaymentProcessing(opp.Id,accid,exdate,cvv,cardname);
         ep1.pay();
         ep1.processRefund();
         
         test.stoptest();
         
     }
 }
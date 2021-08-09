@isTest(SeeAllData=true)
public class PaymentUtility_Test {

    public static testMethod void testBatchForNoDuplicateContacts()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        PaymentUtility obj_PaymentUtility = new PaymentUtility();
        
        Account obj_Account = new Account();
        obj_Account.Name = 'Test Account';
        obj_Account.Industry='Accounting';
        insert obj_Account;
        
        Contact con = new Contact();
        con.LastName = 'Barot';
        con.AccountId = obj_Account.Id;
 		insert con;
        
        opportunity obj_opportunity = new opportunity();
        obj_opportunity.Name='test';
        obj_opportunity.Accountid =obj_Account.id;
        obj_opportunity.CloseDate = date.newInstance(2017, 11, 21);
        obj_opportunity.StageName='Prospecting';
        obj_opportunity.Amount = 15;
        obj_opportunity.Add_GST_on_Invoice__c = false;
        obj_opportunity.Amount_Paid__c = 10;
        obj_opportunity.Type = 'Event';
        obj_opportunity.Product__c = 'Event Attendee';
        obj_opportunity.Primary_Contact__c = con.Id;
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
        
        Event_Registration__c evereg = new  Event_Registration__c();
        evereg.Event__c = newEvent1.Id;
        evereg.First_Name__c = 'Not Known';
        evereg.Last_Name__c = 'Not Known';
        evereg.Event_Package__c = newEventPackage.Id;
        evereg.Registration_Type__c = 'Guest';
        evereg.Opportunity__c = obj_opportunity.Id;
        insert evereg;
        
        List<Event_Registration__c> obj_list_Event_Registration = new List<Event_Registration__c>();
        obj_list_Event_Registration.add(evereg);
        
        PaymentUtility.generateCardTransactionRecord(String.valueOf(obj_opportunity.id),String.valueOf(obj_list_Payment_Gateway[0].id),'201','zvcx','SALE','SUCCESSFUL');
        PaymentUtility.updateOppAmt(obj_opportunity,'20');
        PaymentUtility.getKeyValuePairFromURL('https://cs6.salesforce.com/setup/build/viewApexClass.apexp?id=01pN0000000OTmy');
        PaymentUtility.calculateRefundAmount(15.0,2.0,3.0);
        PaymentUtility.updateEventRegistrations(obj_list_Event_Registration,'Successful','12');
        String quoteId = PaymentUtility.createQuoteRecord(obj_opportunity);
        PaymentUtility.createQuoteLineItemRecord(obj_opportunity, quoteId);
//      PaymentUtility.createXeroBankTransaction(obj_opportunity.id);
    }


}
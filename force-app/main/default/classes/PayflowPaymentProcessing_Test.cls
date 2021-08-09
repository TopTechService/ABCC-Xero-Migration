@isTest(SeeAllData=true)
public class PayflowPaymentProcessing_Test 
{
     static testMethod void testmethod1() 
     {
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
       /* obj_opportunity.pricebook2Id  = prbook.Id;
        obj_opportunity.Event_Package__c = obj_Event_Package.Id;*/
        
        insert obj_opportunity;
        
         PayflowPaymentProcessing obj_PayflowPaymentProcessing1 = new PayflowPaymentProcessing();
         PayflowPaymentProcessing obj_PayflowPaymentProcessing2 = new PayflowPaymentProcessing(obj_opportunity.id,'cxvb');
          PayflowPaymentProcessing obj_PayflowPaymentProcessing3 = new PayflowPaymentProcessing(obj_opportunity.id,'cxvb','12/12/2017');
         obj_PayflowPaymentProcessing2.oppId = obj_opportunity.id;
         obj_PayflowPaymentProcessing2.pay();
         obj_PayflowPaymentProcessing2.processRefund();
         
     }
}
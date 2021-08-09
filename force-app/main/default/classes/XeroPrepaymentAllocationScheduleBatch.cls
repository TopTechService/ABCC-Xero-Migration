global class XeroPrepaymentAllocationScheduleBatch implements Database.Batchable<sObject>, Database.AllowsCallouts  {
       
   private String query;
 
   global XeroPrepaymentAllocationScheduleBatch (String soql){
       query = soql;
   }

   global Database.Querylocator start(Database.BatchableContext bc){
       System.debug('>>>> start ' + query);
       return Database.getQuerylocator(query);
   }

   // Code added by Yugandhara Patil
   // Date - 5th Jan 2018
   global void execute(Database.BatchableContext bc, List<sObject> scope){
       List<opportunity> opps = new List<Opportunity> ();
       for(sObject obj : scope){
           System.debug('obj' + obj);
           Opportunity opp = (Opportunity) obj;
           Decimal surcharge = opp.Surchrge__c != null ? opp.Surchrge__c : 0;
           Decimal amount = ((opp.Amount + (opp.Amount * surcharge /100)));
           System.debug('opp' + opp);
           Prepayments pp = new Prepayments();
           XeroPrepaymentAllocationResponse resposne = pp.allocateBankTransactions(opp.Xero_Invoice_Id__c, opp.Xero_Prepayment_Id__c, amount);
           System.debug('resposne' + resposne);
           if(resposne.Allocations != null && resposne.Allocations.size() > 0 &&
              		resposne.Allocations[0].ValidationErrors.size() == 0){
               opp.Xero_Invoice_Status__c = 'PAID';
               opp.Liability_Bank_Transaction__c = 'ALLOCATED';
               opps.add(opp);
           }
       }
       
       update opps;
   }
   
   global void finish(Database.BatchableContext bc){
       AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()];
       System.debug('>>>> finish ' + job.Status);
   }

}
trigger ActivateSinglePaymentGateway on Payment_Gateway__c (before insert, before update) {
	
     if(trigger.isInsert || trigger.isUpdate){
        
        if(trigger.isbefore){
            List<Payment_Gateway__c> activeGateway = [Select Id from Payment_Gateway__c where Active__c=true];
            for(Payment_Gateway__c pg : Trigger.new){
                if(activeGateway.size() > 0 && pg.Active__c==true){
                    //addError;
                    pg.addError('First deactivate previously activated Gateway.');
                }
            }
      }
    }
}
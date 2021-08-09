trigger QuoteTrigger on Quote (after insert, before update) {
    if(trigger.isInsert && Trigger.isAfter){
        Map<Id, Opportunity> oppstoupdate = new Map<Id, Opportunity>();
        
        Map<Id, Quote> invList = new Map<Id, Quote>([Select OpportunityId, Opportunity.Xero_Invoice_Number__c from Quote where Id IN : Trigger.newMap.keyset()]);
        for(Id invId : invList.keyset()){
            invList.get(invId).Opportunity.Xero_Invoice_Number__c = Trigger.newMap.get(invId).QuoteNumber;
            if(Trigger.newMap.get(invId).Use_an_Amex__c == true)
            {
                invList.get(invId).Opportunity.Surchrge__c = Decimal.valueOf(Label.amexSurcharge);
            }
            oppstoupdate.put(invId, invList.get(invId).Opportunity);
        }
        
        update oppstoupdate.Values();
    }
    
     if(trigger.isUpdate && Trigger.isBefore){
        Map<Id, Opportunity> oppstoupdate = new Map<Id, Opportunity>();
        
        Map<Id, Quote> invList = new Map<Id, Quote>([Select OpportunityId, Opportunity.Surchrge__c from Quote where Id IN : Trigger.newMap.keyset()]);
        for(Id invId : invList.keyset()){
            if(Trigger.newMap.get(invId).Use_an_Amex__c == true)
            {
                invList.get(invId).Opportunity.Surchrge__c = Decimal.valueOf(Label.amexSurcharge);
                oppstoupdate.put(invId, invList.get(invId).Opportunity);
            }
            
        }
        
        update oppstoupdate.Values();
    }
}
public class XeroPrepaymentAllocationSchedule implements XeroPrepaymentAllocationScheduleBase.IXeroPrepaymentAllocationScheduleBase {
    public void Execute(SchedulableContext sc)
    {
        String soql = 'SELECT Id, Amount, Surchrge__c, Xero_Invoice_Status__c, Xero_Invoice_Id__c, Xero_Prepayment_Id__c, Event__r.Event_Finish_Time__c, Liability_Bank_Transaction__c ';
        soql += 'FROM Opportunity WHERE (Xero_Invoice_Status__c = \'AUTHORISED\' AND Event__r.Event_Finish_Time__c = YESTERDAY)';
        
        XeroPrepaymentAllocationScheduleBatch batch = new XeroPrepaymentAllocationScheduleBatch(soql);
        Database.executebatch(batch, 1);
    }
}
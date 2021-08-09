public class RefundHandlerPageController {
    private Opportunity opp;
   @testvisible private static String trxStatus = 'SUCCESSFUL';
   @testvisible private static String trxType = 'SALE';
    
    public RefundHandlerPageController(Apexpages.StandardController controller)
    {
        this.Opp = (Opportunity)controller.getRecord(); 
        System.debug('Test Id '+this.Opp.id);
    }
    
    public void refundAmount() { 
    	List<Card_Transaction__c> cardtransaction = [Select Name, Opportunity__c, Transaction_Status__c, Transaction_Type__c, Payment_Gateway__r.RecordType.Name,Transaction_ID__c From Card_Transaction__c 
                                                     Where Opportunity__c =: Opp.Id And Transaction_Status__c =: trxStatus And Transaction_Type__c =: trxType];
        System.debug(cardtransaction);
        if(cardtransaction.isEmpty() || cardtransaction.size() > 1){
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There is no successful Sale transaction or there are more than one successful sale transaction for the opportunity');
    		ApexPages.addMessage(errorMsg);
        } else
        {
            //call for refund
            boolean result = false;
            PaymentProcessing handleRefundPayment;
            System.debug('Test GatewayType '+cardtransaction[0].Payment_Gateway__r.RecordType.NAme);
            if(cardtransaction[0].Payment_Gateway__r.RecordType.NAme == 'eWay')
            {
                handleRefundPayment = new EwayPaymentProcessing(this.opp.Id,cardtransaction[0].Transaction_ID__c);
            }
            else if(cardtransaction[0].Payment_Gateway__r.RecordType.NAme == 'Payflow')
            {
               handleRefundPayment = new PayflowPaymentProcessing(this.opp.Id,cardtransaction[0].Transaction_ID__c);
            }
            result = handleRefundPayment.processRefund();
            
            if(result)
            {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Refund Processed Successfully!!');
    			ApexPages.addMessage(errorMsg);
            }
            else
            {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Refund Processing Failed!! Please find Transaction Record for more details');
    			ApexPages.addMessage(errorMsg);
            }
        }
    }
    
    public PageReference returnToOpportunity(){
        return new PageReference('/'+opp.id);
     }
}
public without sharing class PaymentTestPageController {

    public string failURL {get;set;}
    public string successURL {get;set;}
    public string cancelURL {get;set;}
    public string cardNumber {get;set;}
    public string cardCVC {get;set;}
    public string cardExpiry {get;set;}
    public string oppId_param {get;set;}
    public string cardType1{get;set;}
    Public string cardName{get;set;}
    public List<SelectOption> availableCardType {get; set;}
    public List<SelectOption> cardExpiryYear{get;set;}
    public List<SelectOption> cardExpiryMonth{get;set;}
    public string selectedCardExpiryYear{get;set;}
    public string selectedCardExpiryMonth{get;set;}
    public string redirectionLink{get;set;}
    public string amountDue{get;set;}
    public boolean isOpportunityPaid {get; set;}
    
    Opportunity opp;
    
    
    public PaymentTestPageController(){
        oppId_param = apexPages.currentPage().getParameters().get('oppId');
        System.debug(oppId_param);
        failURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Fail?oppId=' + oppId_param;
        successURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Success?oppId=' + oppId_param;
        Event_Registration__c er = [Select Event__c from Event_Registration__c where Opportunity__c =:oppId_param limit 1]; 
        System.debug(er);
        cancelURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/EventDetail?id=' + er.Event__c;
        
        
        opp = [Select Id, Amount, Primary_Contact__r.FirstName,Primary_Contact__r.LastName, Primary_Contact__r.MailingStreet,
               Primary_Contact__r.MailingPostalCode,Surchrge__c, (Select Id, Use_an_Amex__c from Quotes) from Opportunity where Id=:oppId_param];
        System.debug(opp);
        
        
        
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        amountDue = '$' + String.format(opp.Amount.format(), args);
        getcardExpiryYear();
        getcardExpiryMonth();
        availableCardType = new List<SelectOption> ();
        availableCardType.add(new SelectOption('Visa','Visa'));
        isOpportunityPaid = false;
    }
   
    
    public Pagereference chargeAmount(){
        List<Card_Transaction__c> successfulTrx = [Select Id from Card_Transaction__c where Opportunity__c =: oppId_param and Transaction_Status__c = 'SUCCESSFUL'];
        if(successfulTrx != null && successfulTrx.size() > 0){
            isOpportunityPaid = true;
            return null;
        } else{
            PaymentProcessing handlePayment;
            List<Payment_Gateway__c> listPaymentGateway = PaymentUtility.getPaymentGatewayDetails();    //Added by Yugandhara on 19th sept 2017
            System.debug('listPaymentGateway' + listPaymentGateway);
            if(listPaymentGateway != null && listPaymentGateway.size() == 1){
                    if(listPaymentGateway[0].RecordType.NAme == 'eWay')
                    {
                        system.debug('oppId_param'+oppId_param+'cardNumber'+cardNumber);
                        handlePayment = new EwayPaymentProcessing(oppId_param,cardNumber,cardExpiry,cardCVC, cardName);
                    }
                    else if(listPaymentGateway[0].RecordType.NAme == 'Payflow')
                    {
                       handlePayment = new PayflowPaymentProcessing(oppId_param, cardNumber, cardExpiry);
                        
                    }
            }
             if(Test.isRunningTest()){
                 return null;
             }else{
                return handlePayment.pay();
             }
        }
    }
    
    public void updateOpportunity() {
        system.debug('cardType' + cardType1);
       if(opp.Amount != null){
            if(cardType1 == 'American Express'){
                opp.surchrge__c = Decimal.valueOf(Label.amexSurcharge);
                if(opp.Quotes != null && opp.Quotes.size() > 0){
                    opp.Quotes[0].Use_an_Amex__c = true;
                    update opp.Quotes[0];
                }
                update opp;
            }
        }
    }
    
    public void getcardExpiryYear(){
        cardExpiryYear = new List<SelectOption>();
        Integer cYear = System.Today().Year();
        for(Integer i=1; i<=10; i++){
            cardExpiryYear.add(new SelectOption(String.ValueOf(cYear),String.ValueOf(cYear)));
            cYear++;
        }
    }
    
    public void getcardExpiryMonth(){
        cardExpiryMonth = new List<SelectOption>();
        for(Integer i=1; i<12; i++){
            cardExpiryMonth.add(new SelectOption(String.ValueOf(i),String.ValueOf(i)));
        }
    }
    String country = null;
         
  	public PageReference test() {
        return null;
    }
                
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Visa','Visa')); 
        options.add(new SelectOption('Mastercard','Mastercard')); 
        options.add(new SelectOption('American Express','American Express')); return options; 
    }
                   
    public String getcardType1() {
        return cardType1;
    }
                    
    public void setcardType1(String cardType) { this.cardType1 = cardType; } 
        public PageReference returnToOpportunity(){
        return new PageReference('/'+opp.id);
    } 
}
public class PayflowPaymentProcessing implements PaymentProcessing {
    @TestVisible private string partner; //The Payflow partner
    @TestVisible private string pwd; //Payflow merchent Password
    @TestVisible private string vendor;  //Payflow Merchent Id
    @TestVisible private string user;    //Payflow user
    @TestVisible private string tender;  //The payment method, e.g. C for credit card.
    @TestVisible private string acct;    //The buyer's credit card number.
    @TestVisible private string trxtype; //The type of the transaction, e.g. S for sale.
    @TestVisible private string expdate; //The expiration date of the credit card.
    @TestVisible private string amt; //The amount of the sale.
    
    @TestVisible private static string transactionTypeSale = 'S';
    @TestVisible private static string transactionTypeCredit = 'C';
    @TestVisible private static string paymentMethod = 'C';
    @TestVisible private static string successStatus = 'RESPMSG=APPROVED';
    @TestVisible private static string returnURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Fail?oppId=';
    @TestVisible private static string successURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Success?oppId=';
    @TestVisible private static string eventRegStatusSuccess = 'Successful';
    @TestVisible private string oppId;
    @TestVisible private string gatewayId;
    @TestVisible private Opportunity Opp;
    
    @TestVisible private boolean isTestEndPoint;
    @TestVisible private static string testEndPointURL = 'https://pilot-payflowpro.paypal.com';
    @TestVisible private static string liveEndPointURL = 'https://payflowpro.paypal.com';
    
    @TestVisible private string orgid;    
    
    
    public PayflowPaymentProcessing(){}
    
    public PayflowPaymentProcessing(Id oppId, String trxId){
       //Removing Payment_Gateway__c from Event__c by Yugandhara on 19th sept 2017
       //list<Opportunity> opp = [Select Id, Amount_Paid__c, Surchrge__c, Event__r.Payment_Gateway__c, Event__r.Payment_Gateway__r.Merchant_ID__c, Event__r.Payment_Gateway__r.Merchant_Reference__c, Event__r.Payment_Gateway__r.Merchant_Security_Key__c,Event__r.Payment_Gateway__r.Test_Endpoint__c,Event__r.Payment_Gateway__r.User_Name__c,(Select Id, Registration_Status__c from Event_Registrations__r) from Opportunity where Id =:oppId];
       list<Opportunity> opp = [Select Id, Amount_Paid__c, Surchrge__c, StageName, Probability, (Select Id, Registration_Status__c from Event_Registrations__r) from Opportunity where Id =:oppId];
       list<Payment_Gateway__c> listPaymentGateway = PaymentUtility.getPaymentGatewayDetails(); //Added by Yugandhara on 19th sept 2017
        if(opp != null && opp.size() == 1 && listPaymentGateway != null && listPaymentGateway.size() == 1){
            this.oppId = opp[0].Id;
            this.opp = opp[0];
            //this.partner = opp[0].Event__r.Payment_Gateway__r.Merchant_Reference__c;
            //this.vendor = opp[0].Event__r.Payment_Gateway__r.Merchant_ID__c;
            //this.user = opp[0].Event__r.Payment_Gateway__r.User_Name__c == null ? opp[0].Event__r.Payment_Gateway__r.Merchant_ID__c : opp[0].Event__r.Payment_Gateway__r.User_Name__c;
            //this.pwd = opp[0].Event__r.Payment_Gateway__r.Merchant_Security_Key__c;
           
            this.partner = listPaymentGateway[0].Merchant_Reference__c;
            this.vendor = listPaymentGateway[0].Merchant_ID__c;
            this.user = listPaymentGateway[0].User_Name__c == null ? listPaymentGateway[0].Merchant_ID__c :listPaymentGateway[0].User_Name__c;
            this.pwd = listPaymentGateway[0].Merchant_Security_Key__c;
            this.trxtype = transactionTypeCredit;
            this.tender = paymentMethod;
            
            //this.isTestEndPoint = opp[0].Event__r.Payment_Gateway__r.Test_Endpoint__c;
            this.isTestEndPoint = listPaymentGateway[0].Test_Endpoint__c;
            this.orgid = trxId;
       }    
    }    
    
    public PayflowPaymentProcessing(Id oppId, String acct, String expdate){
        System.debug('oppId'+oppId);
        
        //Removing Payment_Gateway__c from Event__c by Yugandhara on 19th sept 2017
        //list<Opportunity> opp = [Select Id, Amount, Amount_Due__c, Amount_Paid__c, Surchrge__c, Event__r.Payment_Gateway__r.Id, Event__r.Payment_Gateway__r.Name, Event__r.Payment_Gateway__r.Merchant_ID__c, Event__r.Payment_Gateway__r.Merchant_Reference__c, Event__r.Payment_Gateway__r.Merchant_Security_Key__c,Event__r.Payment_Gateway__r.Test_Endpoint__c,Event__r.Payment_Gateway__r.User_Name__c,(Select Id, Registration_Status__c from Event_Registrations__r) from Opportunity where Id =:oppId];
        
        list<Opportunity> opp = [Select Id, Amount, Amount_Due__c, Amount_Paid__c, StageName, Probability, Surchrge__c, Event__r.Event_Start_time__c, Event__r.Name, 
                                 Ticket_Qty__c, (Select Id, Registration_Status__c from Event_Registrations__r), 
                                 (Select Product2.Name from OpportunityLineItems) from Opportunity where Id =:oppId];
        list<Payment_Gateway__c> listPaymentGateway = PaymentUtility.getPaymentGatewayDetails();    //Added by Yugandhara on 19th sept 2017
        
        if(opp != null && opp.size() == 1 && listPaymentGateway != null && listPaymentGateway.size() == 1){
            this.oppId = opp[0].Id;
            //this.gatewayId = opp[0].Event__r.Payment_Gateway__r.Id;
            this.gatewayId = listPaymentGateway[0].id;
            this.opp = opp[0];
            Decimal surcharge = opp[0].Surchrge__c != null ? opp[0].Surchrge__c : 0;
            System.debug('surcharge' + surcharge);
            this.amt = String.valueOf((opp[0].Amount + (opp[0].Amount * surcharge /100)).setscale(2));
            System.debug('amt'+amt);
            
            //this.partner = opp[0].Event__r.Payment_Gateway__r.Merchant_Reference__c;
            //this.vendor = opp[0].Event__r.Payment_Gateway__r.Merchant_ID__c;
            //this.user = opp[0].Event__r.Payment_Gateway__r.User_Name__c == null ? opp[0].Event__r.Payment_Gateway__r.Merchant_ID__c : opp[0].Event__r.Payment_Gateway__r.User_Name__c;
            //this.pwd = opp[0].Event__r.Payment_Gateway__r.Merchant_Security_Key__c;
            
            this.partner = listPaymentGateway[0].Merchant_Reference__c;
            this.vendor = listPaymentGateway[0].Merchant_ID__c;
            this.user = listPaymentGateway[0].User_Name__c ==null ? listPaymentGateway[0].Merchant_ID__c : listPaymentGateway[0].User_Name__c;
            this.pwd = listPaymentGateway[0].Merchant_Security_Key__c;
            this.trxtype = transactionTypeSale;
            this.tender = paymentMethod;
            
            //this.isTestEndPoint = opp[0].Event__r.Payment_Gateway__r.Test_Endpoint__c;
             if(!Test.isRunningTest())
             {
                 this.isTestEndPoint = listPaymentGateway[0].Test_Endpoint__c;
             } else {
                 this.isTestEndPoint = true;
             }
            
            
            this.acct = acct;
            this.expdate = expdate.replace('/', '');
        }
    }
    public Pagereference pay(){
        System.debug('oppId'+oppId);
        if(oppId != null){
            // Instantiate a new http object
            Http httpObj = new Http();
        
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest httpReq = new HttpRequest();
            if(this.isTestEndPoint){
                httpReq.setEndpoint(testEndPointURL);
            } else{
                httpReq.setEndpoint(liveEndPointURL);
            }
            httpReq.setMethod('POST');
            String reqString = 'partner='+partner+'&pwd='+pwd+'&vendor='+vendor+'&user='+user+'&tender='+tender+'&acct='+acct
                                +'&trxtype='+trxtype+'&expdate='+expdate+'&amt='+amt+'&currency=AUD';
            System.debug('reqString'+reqString);
            httpreq.setheader('Content-Type','application/x-www-form-urlencoded');
            httpReq.setBody(reqString);
        
            // Send the request, and return a response
            HttpResponse res;
            if(!Test.isRunningTest())
              {
                  res = httpObj.send(httpReq);  
                  System.debug('res.getBody' + res.getBody());
              }        
            
         
            Boolean isTrxSucessful = false;
            Map<string, string> paramValueMap;
            if(!Test.isRunningTest())
              {
                 paramValueMap= PaymentUtility.getKeyValuePairFromURL(res.getBody());
              } 
              else
              {
                  paramValueMap = new Map<string, string>();
                  paramValueMap.put('id','test');
              }  
            
            if(paramValueMap != null && paramValueMap.containsKey('RESPMSG') && paramValueMap.get('RESPMSG') == ('APPROVED')){
                returnURL = successURL+oppId;
                PaymentUtility.updateOppAmt(opp, amt);
                PaymentUtility.updateEventRegistrations(opp.Event_Registrations__r, 'Successful', amt);
                String quoteId = PaymentUtility.createQuoteRecord(this.Opp);
                PaymentUtility.createQuoteLineItemRecord(this.Opp, quoteId);
                isTrxSucessful = true;
            }else{
                returnURL = returnURL + oppId;
            }
            
            string trxId, trxType, trxStatus;
            if(isTrxSucessful){
                trxId = paramValueMap.get('PNREF');
                trxStatus = 'SUCCESSFUL';
            } else {
                PaymentUtility.updateEventRegistrations(Opp.Event_Registrations__r, 'Failed', amt);
                trxStatus = 'FAILED';
            }
            trxType = 'SALE';
                
            //Insert transaction Record
            if(!Test.isRunningTest())
              {
                 PaymentUtility.generateCardTransactionRecord(oppId, gatewayId, String.ValueOf(res.getBody()), trxId, trxType, trxStatus);
              } 
              else
              {
                 PaymentUtility.generateCardTransactionRecord(oppId, gatewayId, String.ValueOf('test'), trxId, trxType, trxStatus);
              }  
            
        }
        System.debug('returnURL'+returnURL);
        return new Pagereference(returnURL);
    }
    
    public boolean processRefund(){
        Boolean isTrxSucessful = false;
        if(oppId != null){
            // Instantiate a new http object
            Http httpObj = new Http();
        
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest httpReq = new HttpRequest();
            if(this.isTestEndPoint){
                httpReq.setEndpoint(testEndPointURL);
            } else{
                httpReq.setEndpoint(liveEndPointURL);
            }
            httpReq.setMethod('POST');
            String reqString = 'partner='+partner+'&pwd='+pwd+'&vendor='+vendor+'&user='+user+'&tender='+tender+'&trxtype='+trxtype+'&origid='+orgid;
            System.debug('reqString'+reqString);
            httpreq.setheader('Content-Type','application/x-www-form-urlencoded');
            httpReq.setBody(reqString);
        
            // Send the request, and return a response
            HttpResponse res;
            if(!Test.isRunningTest())
              {
                   res= httpObj.send(httpReq); 
                   System.debug('res.getBody' + res.getBody());
              }
             
            
         
            Map<string, string> paramValueMap;
            
             if(!Test.isRunningTest())
              {
                 paramValueMap= PaymentUtility.getKeyValuePairFromURL(res.getBody());
              } 
              else
              {
                  paramValueMap = new Map<string, string>();
                  paramValueMap.put('id','test');
              } 
            if(paramValueMap != null && paramValueMap.containsKey('RESPMSG') && paramValueMap.get('RESPMSG') == ('APPROVED')){
                isTrxSucessful = true;
                PaymentUtility.updateEventRegistrations(opp.Event_Registrations__r, 'Cancelled', amt);
            }
            
            string trxId, trxType, trxStatus;
            if(isTrxSucessful){
                trxId = paramValueMap.get('PNREF');
                trxStatus = 'SUCCESSFUL';
            } else {
                PaymentUtility.updateEventRegistrations(Opp.Event_Registrations__r, 'Failed', amt);
                trxStatus = 'FAILED';
            }
            trxType = 'REFUND';
                
            //Insert transaction Record
            if(!Test.isRunningTest())
              {
                 PaymentUtility.generateCardTransactionRecord(oppId, gatewayId, String.ValueOf(res.getBody()), trxId, trxType, trxStatus);
              } 
              else
              {
                 PaymentUtility.generateCardTransactionRecord(oppId, gatewayId, String.ValueOf('test'), trxId, trxType, trxStatus);
              }  
            
        }
        return isTrxSucessful;
    }
}
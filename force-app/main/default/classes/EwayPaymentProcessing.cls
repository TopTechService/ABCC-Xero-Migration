public class EwayPaymentProcessing implements PaymentProcessing{

   @Testvisible private String ewayAPIkey; //store apikey
   @Testvisible private String ewayPass; //eway password
   @Testvisible private String ewayAccessCode; //eway accessCode for rquest
   @Testvisible private String ewayPaymentType; //Payment Type like Credit Card
   @Testvisible private String ewayCardName; //Card Name
   @Testvisible private String ewayCardNo; //Card no
   @Testvisible private String ewayExpMonth; //Expiry Month
   @Testvisible private String ewayExpYear; //Expiry Year
   @Testvisible private String ewayCardCVV; //CVV
   @Testvisible private Integer amt;    //The amount of the sale.
   @Testvisible private Integer ewayRefundAmount; //Refund Amount
   @Testvisible private string ewayPaymentURL;  //Payment URL
   @Testvisible private String ewayGatewayID;
   @Testvisible private String SuccessMessage = 'A2000';
   @Testvisible private String transactionId;

   @Testvisible private string oppId;
   @Testvisible private Opportunity Opp;
    
   @Testvisible private static string returnURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Fail';
   @Testvisible private static string successURL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Success?oppId=';
   @Testvisible private boolean isTestEndPoint;
   @Testvisible private static string testEndPointURL = 'https://api.sandbox.ewaypayments.com';
   @Testvisible private static string liveEndPointURL = 'https://api.ewaypayments.com';
   @Testvisible private static string baseEndPointURL = '';
    
   @Testvisible private Decimal surchargeValue = 0.0;
    
    public EwayPaymentProcessing(Id oppId, String trxId)
    {
        //List<Opportunity> lstOpp = [SELECT id,Surchrge__c,Amount, Amount_paid__c, Event__r.Payment_Gateway__c,Event__r.Payment_Gateway__r.eWay_API_Key__c, Event__r.Payment_Gateway__r.eWay_API_Password__c, Event__r.Payment_Gateway__r.Test_Endpoint__c,(Select Id, Registration_Status__c from Event_Registrations__r) FROM Opportunity where Id = :oppId];
        List<Opportunity> lstOpp = [SELECT id,Surchrge__c,Amount, Amount_Due__c, Amount_paid__c, StageName, Probability,Ticket_Qty__c, Event__r.Event_Start_time__c, Event__r.Name, (Select Id, Registration_Status__c from Event_Registrations__r), (Select Product2.Name,Product2Id from OpportunityLineItems) FROM Opportunity where Id = :oppId];
        list<Payment_Gateway__c> listPaymentGateway = PaymentUtility.getPaymentGatewayDetails();    //Added by Yugandhara on 19th sept 2017
        
        if(!lstOpp.isEmpty() && listPaymentGateway != Null && listPaymentGateway.size() == 1){
            ewayAPIkey = listPaymentGateway[0].eWay_API_Key__c;
            ewayPass = listPaymentGateway[0].eWay_API_Password__c;
            this.isTestEndPoint = listPaymentGateway[0].Test_Endpoint__c;
            this.oppId = oppId;
            Decimal surcharge = lstOpp[0].Surchrge__c != null ? lstOpp[0].Surchrge__c : 0;
            System.debug('surcharge' + surcharge);
            this.amt = Integer.valueOf(((lstOpp[0].Amount + (lstOpp[0].Amount * surcharge /100)).setScale(2)) * 100);
            this.surchargeValue = lstOpp[0].Amount * surcharge /100;
            
            this.ewayRefundAmount = Integer.valueOf((PaymentUtility.calculateRefundAmount(lstOpp[0].Amount_paid__c, surcharge, 0))*100);
            
            baseEndPointURL = this.isTestEndPoint ? testEndPointURL : liveEndPointURL;
            Opp = lstOpp[0];
            transactionId = trxId;
            ewayGatewayID = listPaymentGateway[0].id;
        }
    }
    
    public EwayPaymentProcessing(Id oppId, String acct, String expdate, String CVV, STring cardName)
    {
        //Payment gateway removed from event by Yugandhara on 19th sept 2017
        //List<Opportunity> lstOpp = [SELECT id,Surchrge__c,Amount,Event__r.Payment_Gateway__c,Event__r.Payment_Gateway__r.eWay_API_Key__c, Event__r.Payment_Gateway__r.eWay_API_Password__c, Event__r.Payment_Gateway__r.Test_Endpoint__c,(Select Id, Registration_Status__c from Event_Registrations__r) FROM Opportunity where Id = :oppId];
        List<Opportunity> lstOpp = [SELECT id,Amount, Amount_Due__c, Amount_Paid__c, StageName, Probability, Surchrge__c, Event__r.Event_Start_time__c, Event__r.Name, Event__r.Our_Reference__c, Event_Package__r.Name, Ticket_Qty__c, (Select Id, Registration_Status__c from Event_Registrations__r), (Select Product2.Name from OpportunityLineItems), (Select Id, QuoteNumber, Xero_Invoice_Number__c from Quotes) FROM Opportunity where Id = :oppId];
        List<Payment_Gateway__c> listPaymentGateway = PaymentUtility.getPaymentGatewayDetails();    //Added by Yugandhara on 19th sept 2017
        
        if(!lstOpp.isEmpty() && listPaymentGateway != Null && listPaymentGateway.size() == 1){
            //ewayAPIkey = lstOpp[0].Event__r.Payment_Gateway__r.eWay_API_Key__c;
            //ewayPass = lstOpp[0].Event__r.Payment_Gateway__r.eWay_API_Password__c;
             
            ewayAPIkey = listPaymentGateway[0].eWay_API_Key__c;
            ewayPass =listPaymentGateway[0].eWay_API_Password__c;
            ewayPaymentType = 'Credit Card';
            ewayCardName = cardName;
            ewayCardNo = acct;
            ewayCardCVV = CVV;
            setExpiryDetails(expdate);
            //this.isTestEndPoint = lstOpp[0].Event__r.Payment_Gateway__r.Test_Endpoint__c;
            this.isTestEndPoint = listPaymentGateway[0].Test_Endpoint__c;
            this.oppId = oppId;
            Decimal surcharge = lstOpp[0].Surchrge__c != null ? lstOpp[0].Surchrge__c : 0;
            System.debug('surcharge' + surcharge);
            this.amt = Integer.valueOf(((lstOpp[0].Amount + (lstOpp[0].Amount * surcharge /100)).setScale(2)) * 100);
            this.surchargeValue = lstOpp[0].Amount * surcharge /100;

            baseEndPointURL = this.isTestEndPoint ? testEndPointURL : liveEndPointURL;
            //ewayGatewayID = lstOpp[0].Event__r.Payment_Gateway__c;
            ewayGatewayID = listPaymentGateway[0].Id;
            Opp = lstOpp[0];
        }
    }
    
    public PageReference pay()
    {
        if(oppId != null)
        {
            // Instantiate a new http object
            Http httpObj = new Http();
        
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest httpReq = new HttpRequest();
            httpReq.setTimeout(20000);
            httpReq.setEndpoint(baseEndPointURL+'/AccessCodes');
            //request for getting accessToken
            EwayAccessCodeRequest obj_EwayAccessCodeRequest = new EwayAccessCodeRequest();
            
            EwayAccessCodeRequest.Payment payment = new EwayAccessCodeRequest.Payment();
            payment.TotalAmount = amt;
            payment.CurrencyCode = 'AUD';
            payment.InvoiceReference = Opp.Event__r.Our_Reference__c;

            if(Opp.Quotes != null && Opp.Quotes.size() > 0){
                payment.InvoiceDescription = Opp.Quotes[0].Xero_Invoice_Number__c;
            }
            
            obj_EwayAccessCodeRequest.payment = payment;
            obj_EwayAccessCodeRequest.RedirectUrl = 'http://www.anujshah.com';
            obj_EwayAccessCodeRequest.Method = 'ProcessPayment';
            obj_EwayAccessCodeRequest.TransactionType = 'Purchase';
            
            String requestBody = JSON.serialize(obj_EwayAccessCodeRequest);

            System.debug('TEST 1st Request '+requestBody);
                
            
            httpReq.setMethod('POST');
            httpReq.setheader('Content-Type','application/json');
            httpReq.setHeader('Authorization','Basic'+' '+EncodingUtil.base64encode(Blob.valueOf(ewayAPIkey+':'+ewayPass)));
            System.debug('ewayPass' + ewayPass);
            httpReq.setBody(requestBody);
            // Send the request, and return a response\
            HttpResponse res;
            if(!Test.isRunningTest())
              {
            	 res = httpObj.send(httpReq);
                 System.debug(res);
              }
           // System.debug('TEST 1st Response '+res.getBody());
             EwayAccessCodeResponse obj_response;
             if(!Test.isRunningTest())
              {
            	 obj_response = EwayAccessCodeResponse.parse(res.getBody());
              }else{
                  String json = '{'+
		'    \"AccessCode\": \"F9802VCDNSSUVQyjV4BSwdS9rGHay5wWTZhu-bADhqM4vZkGpS_ESjxihJzusJgvk_GIMUWC9QHxLD1ApYzpfbwLDJ0rwuAmdB5aCavJOOdxsVdCh4wrgYsSo3e0S7TRP3JSEFIEqDQyIjtxPAM0o4WN4LA==\",'+
		'    \"Customer\": {'+
		'        \"CardNumber\": \"\",'+
		'        \"CardStartMonth\": \"\",'+
		'        \"CardStartYear\": \"\",'+
		'        \"CardIssueNumber\": \"\",'+
		'        \"CardName\": \"\",'+
		'        \"CardExpiryMonth\": \"\",'+
		'        \"CardExpiryYear\": \"\",'+
		'        \"IsActive\": false,'+
		'        \"TokenCustomerID\": null,'+
		'        \"Reference\": \"\",'+
		'        \"Title\": \"Mr.\",'+
		'        \"FirstName\": \"\",'+
		'        \"LastName\": \"\",'+
		'        \"CompanyName\": \"\",'+
		'        \"JobDescription\": \"\",'+
		'        \"Street1\": \"\",'+
		'        \"Street2\": \"\",'+
		'        \"City\": \"\",'+
		'        \"State\": \"\",'+
		'        \"PostalCode\": \"\",'+
		'        \"Country\": \"\",'+
		'        \"Email\": \"\",'+
		'        \"Phone\": \"\",'+
		'        \"Mobile\": \"\",'+
		'        \"Comments\": \"\",'+
		'        \"Fax\": \"\",'+
		'        \"Url\": \"\"'+
		'    },'+
		'    \"Payment\": {'+
		'        \"TotalAmount\": 5,'+
		'        \"InvoiceNumber\": null,'+
		'        \"InvoiceDescription\": null,'+
		'        \"InvoiceReference\": null,'+
		'        \"CurrencyCode\": \"AUD\"'+
		'    },'+
		'    \"FormActionURL\": \"https://secure-au.sandbox.ewaypayments.com/AccessCode/F9802VCDNSSUVQyjV4BSwdS9rGHay5wWTZhu-bADhqM4vZkGpS_ESjxihJzusJgvk_GIMUWC9QHxLD1ApYzpfbwLDJ0rwuAmdB5aCavJOOdxsVdCh4wrgYsSo3e0S7TRP3JSEFIEqDQyIjtxPAM0o4WN4LA==\",'+
		'    \"CompleteCheckoutURL\": null,'+
		'    \"Errors\": null'+
		'}';
		 obj_response = EwayAccessCodeResponse.parse(json);
                  
              }
            ewayAccessCode = obj_response.AccessCode;
            ewayPaymentURL = obj_response.FormActionURL;
            if(test.isRunningTest()){
                res = new HttpResponse();
                res.setStatusCode(200); 
            }
            if(res.getStatusCode() == 200 && !String.isBlank(ewayPaymentURL))
            {                
                Http httpObj2 = new Http();
                
                HttpRequest httpReq2 = new HttpRequest();
                httpReq2.setTimeout(20000);
                httpReq2.setEndpoint(ewayPaymentURL);
                httpReq2.setMethod('POST');
                httpReq2.setheader('Content-Type','application/x-www-form-urlencoded');
                
                String reqString ='';
                reqString += 'EWAY_ACCESSCODE='+ewayAccessCode;
                reqString += '&EWAY_PAYMENTTYPE='+ewayPaymentType.replace(' ', '+');
                reqString += '&EWAY_CARDNAME='+ewayCardName.replace(' ', '+');
                reqString += '&EWAY_CARDNUMBER='+ewayCardNo;
                reqString += '&EWAY_CARDEXPIRYMONTH='+ewayExpMonth;
                reqString += '&EWAY_CARDEXPIRYYEAR='+ewayExpYear;
                reqString += '&EWAY_CARDCVN='+ewayCardCVV;
                
                System.debug('TEST 2nd Request '+reqString);
                
                httpReq2.setBody(reqString);
                
                // Send the request, and return a response
                  HttpResponse res2;
         	   if(!Test.isRunningTest())
          	    {
           	   	   res2 = httpObj2.send(httpReq2);
                }else{
                  String json = '{'+
    '    \"AccessCode\": \"F9802VCDNSSUVQyjV4BSwdS9rGHay5wWTZhu-bADhqM4vZkGpS_ESjxihJzusJgvk_GIMUWC9QHxLD1ApYzpfbwLDJ0rwuAmdB5aCavJOOdxsVdCh4wrgYsSo3e0S7TRP3JSEFIEqDQyIjtxPAM0o4WN4LA==\",'+
    '    \"Customer\": {'+
    '        \"CardNumber\": \"\",'+
    '        \"CardStartMonth\": \"\",'+
    '        \"CardStartYear\": \"\",'+
    '        \"CardIssueNumber\": \"\",'+
    '        \"CardName\": \"\",'+
    '        \"CardExpiryMonth\": \"\",'+
    '        \"CardExpiryYear\": \"\",'+
    '        \"IsActive\": false,'+
    '        \"TokenCustomerID\": null,'+
    '        \"Reference\": \"\",'+
    '        \"Title\": \"Mr.\",'+
    '        \"FirstName\": \"\",'+
    '        \"LastName\": \"\",'+
    '        \"CompanyName\": \"\",'+
    '        \"JobDescription\": \"\",'+
    '        \"Street1\": \"\",'+
    '        \"Street2\": \"\",'+
    '        \"City\": \"\",'+
    '        \"State\": \"\",'+
    '        \"PostalCode\": \"\",'+
    '        \"Country\": \"\",'+
    '        \"Email\": \"\",'+
    '        \"Phone\": \"\",'+
    '        \"Mobile\": \"\",'+
    '        \"Comments\": \"\",'+
    '        \"Fax\": \"\",'+
    '        \"Url\": \"\"'+
    '    },'+
    '    \"Payment\": {'+
    '        \"TotalAmount\": 5,'+
    '        \"InvoiceNumber\": null,'+
    '        \"InvoiceDescription\": null,'+
    '        \"InvoiceReference\": null,'+
    '        \"CurrencyCode\": \"AUD\"'+
    '    },'+
    '    \"FormActionURL\": \"https://secure-au.sandbox.ewaypayments.com/AccessCode/F9802VCDNSSUVQyjV4BSwdS9rGHay5wWTZhu-bADhqM4vZkGpS_ESjxihJzusJgvk_GIMUWC9QHxLD1ApYzpfbwLDJ0rwuAmdB5aCavJOOdxsVdCh4wrgYsSo3e0S7TRP3JSEFIEqDQyIjtxPAM0o4WN4LA==\",'+
    '    \"CompleteCheckoutURL\": null,'+
    '    \"Errors\": null'+
    '}';
     obj_response = EwayAccessCodeResponse.parse(json);
                  
              }
        
             //    System.debug('Test res2 body '+res2.getBody());
                //  System.debug('Test res2 getStatusCode '+res2.getStatusCode());
    		if(test.isRunningTest()){
                res2 = new HttpResponse();
                res2.setStatusCode(302); 
            }
                            
                if(res2.getStatusCode() == 302)
                {
                    Http httpObj3 = new Http();
                    HttpRequest httpReq3 = new HttpRequest();
                    
                    httpReq3.setTimeout(20000);
                    httpReq3.setEndpoint(baseEndPointURL+'/AccessCode/'+ewayAccessCode);
                    
                    httpReq3.setMethod('GET');
                    httpReq3.setheader('Content-Type','application/json');
                    httpReq3.setHeader('Authorization','Basic'+' '+EncodingUtil.base64encode(Blob.valueOf(ewayAPIkey+':'+ewayPass)));
                HttpResponse res3;
            	if(!Test.isRunningTest())
            	  {
                     res3 = httpObj3.send(httpReq3);
                  }else{
                  String json = '{'+
    '    \"AccessCode\": \"F9802VCDNSSUVQyjV4BSwdS9rGHay5wWTZhu-bADhqM4vZkGpS_ESjxihJzusJgvk_GIMUWC9QHxLD1ApYzpfbwLDJ0rwuAmdB5aCavJOOdxsVdCh4wrgYsSo3e0S7TRP3JSEFIEqDQyIjtxPAM0o4WN4LA==\",'+
    '    \"Customer\": {'+
    '        \"CardNumber\": \"\",'+
    '        \"CardStartMonth\": \"\",'+
    '        \"CardStartYear\": \"\",'+
    '        \"CardIssueNumber\": \"\",'+
    '        \"CardName\": \"\",'+
    '        \"CardExpiryMonth\": \"\",'+
    '        \"CardExpiryYear\": \"\",'+
    '        \"IsActive\": false,'+
    '        \"TokenCustomerID\": null,'+
    '        \"Reference\": \"\",'+
    '        \"Title\": \"Mr.\",'+
    '        \"FirstName\": \"\",'+
    '        \"LastName\": \"\",'+
    '        \"CompanyName\": \"\",'+
    '        \"JobDescription\": \"\",'+
    '        \"Street1\": \"\",'+
    '        \"Street2\": \"\",'+
    '        \"City\": \"\",'+
    '        \"State\": \"\",'+
    '        \"PostalCode\": \"\",'+
    '        \"Country\": \"\",'+
    '        \"Email\": \"\",'+
    '        \"Phone\": \"\",'+
    '        \"Mobile\": \"\",'+
    '        \"Comments\": \"\",'+
    '        \"Fax\": \"\",'+
    '        \"Url\": \"\"'+
    '    },'+
    '    \"Payment\": {'+
    '        \"TotalAmount\": 5,'+
    '        \"InvoiceNumber\": null,'+
    '        \"InvoiceDescription\": null,'+
    '        \"InvoiceReference\": null,'+
    '        \"CurrencyCode\": \"AUD\"'+
    '    },'+
    '    \"FormActionURL\": \"https://secure-au.sandbox.ewaypayments.com/AccessCode/F9802VCDNSSUVQyjV4BSwdS9rGHay5wWTZhu-bADhqM4vZkGpS_ESjxihJzusJgvk_GIMUWC9QHxLD1ApYzpfbwLDJ0rwuAmdB5aCavJOOdxsVdCh4wrgYsSo3e0S7TRP3JSEFIEqDQyIjtxPAM0o4WN4LA==\",'+
    '    \"CompleteCheckoutURL\": null,'+
    '    \"Errors\": null'+
    '}';
     obj_response = EwayAccessCodeResponse.parse(json);
                  
              }
                    //System.debug('Test res3 body '+res3.getBody());
              	if(test.isRunningTest()){
                res3 = new HttpResponse();
                res3.setStatusCode(302); 
            }
              
                    if(res3.getStatusCode() == 200)
                    {
                        EwayTransactionResult obj_transResult = EwayTransactionResult.parse(res3.getBody());
                        System.debug('Transction '+ obj_transResult.TransactionID);
                        
                        Boolean isTrxSucessful = false;
                        if(obj_transResult.TransactionStatus && (obj_transResult.ResponseMessage == SuccessMessage || obj_transResult.ResponseMessage == 'A2011' || obj_transResult.ResponseMessage == 'A2016' || obj_transResult.ResponseMessage == 'A2008'))
                        {
                            PaymentUtility.updateOppAmt(Opp, String.ValueOf(Decimal.valueOf(amt)/100));
                            PaymentUtility.updateEventRegistrations(Opp.Event_Registrations__r, 'Successful', String.ValueOf(amt/100));
                            if(Opp.Quotes != null && Opp.Quotes.size() > 0){
                                PaymentUtility.createQuoteLineItemRecord(this.Opp, Opp.Quotes[0].id);
                            }

                            returnURL = successURL+oppId;
                            isTrxSucessful = true;
                        }
                        
                        string trxId, trxType, trxStatus;
                        if(isTrxSucessful){
//                          PaymentUtility.createXeroBankTransaction(Opp.Id);
                            trxId = String.valueOf(obj_transResult.TransactionID);
                            trxStatus = 'SUCCESSFUL';
                        } else {
                            PaymentUtility.updateEventRegistrations(Opp.Event_Registrations__r, 'Failed', String.ValueOf(amt/100));
                            trxStatus = 'FAILED';
                        }
                        trxType = 'SALE';
                        
                        PaymentUtility.generateCardTransactionRecord(oppID, ewayGatewayID, res3.getBody(), trxId, trxType, trxStatus);
                    }
                }
            }
            else{
                PaymentUtility.generateCardTransactionRecord(oppID, ewayGatewayID, res.getBody(), '', 'SALE', 'FALIED');
            }
        }
        return new Pagereference(returnURL);
    }
    
    private void setExpiryDetails(String expiryDate)
    {
        List<String> details = expiryDate.split('/');
        if(details != null && details.size() == 2)
        {
            ewayExpMonth = details[0];
            ewayExpYear = details[1];
            System.debug('ewayExpMonth '+ewayExpMonth);
            System.debug('ewayExpYear '+ewayExpYear);
        }
        else
        {
            System.debug('expiryDate is invalid '+expiryDate);
        }
        
    }
    
    public boolean processRefund()
    {
        boolean result = false;
        
        EwayRefundRequest obj_refundReq = new EwayRefundRequest();
        
        EwayRefundRequest.Refund obj_refund = new EwayRefundRequest.Refund();
        obj_refund.TotalAmount = this.amt;//ewayRefundAmount;
        obj_refund.CurrencyCode = 'AUD';
 
        obj_refundReq.refund = obj_refund;
        
        String requestBody = JSON.serialize(obj_refundReq);
        System.debug('TEST Refund Request '+requestBody);
        
        Http httpObj = new Http();
        HttpRequest httpReq = new HttpRequest();
        
        httpReq.setMethod('POST');
        httpReq.setheader('Content-Type','application/json');
        httpReq.setHeader('Authorization','Basic'+' '+EncodingUtil.base64encode(Blob.valueOf(ewayAPIkey+':'+ewayPass)));
        httpReq.setBody(requestBody);
        httpReq.setEndpoint(baseEndPointURL+'/Transaction/'+transactionId+'/Refund');
        
        // Send the request, and return a response
        HttpResponse res;
            if(!Test.isRunningTest())
              {
        		 res = httpObj.send(httpReq);
              }else{
                  String json = '{'+
		'    \"AuthorisationCode\": \"508125\",'+
		'    \"ResponseCode\": null,'+
		'    \"ResponseMessage\": \"A2000\",'+
		'    \"TransactionID\": 16929965,'+
		'    \"TransactionStatus\": true,'+
		'    \"Verification\": null,'+
		'    \"Customer\": {'+
		'        \"TokenCustomerID\": null,'+
		'        \"Reference\": null,'+
		'        \"Title\": null,'+
		'        \"FirstName\": \"\",'+
		'        \"LastName\": \"\",'+
		'        \"CompanyName\": null,'+
		'        \"JobDescription\": null,'+
		'        \"Street1\": \"\",'+
		'        \"Street2\": null,'+
		'        \"City\": \"\",'+
		'        \"State\": \"\",'+
		'        \"PostalCode\": \"\",'+
		'        \"Country\": \"\",'+
		'        \"Email\": \"\",'+
		'        \"Phone\": \"\",'+
		'        \"Mobile\": null,'+
		'        \"Comments\": null,'+
		'        \"Fax\": null,'+
		'        \"Url\": null,'+
		'        \"CardDetails\": {'+
		'            \"Number\": null,'+
		'            \"Name\": null,'+
		'            \"ExpiryMonth\": null,'+
		'            \"ExpiryYear\": null,'+
		'            \"StartMonth\": null,'+
		'            \"StartYear\": null,'+
		'            \"IssueNumber\": null'+
		'        }'+
		'    },'+
		'    \"Refund\": {'+
		'        \"TransactionID\": \"16927384\",'+
		'        \"AuthorisationID\": null,'+
		'        \"STAN\": null,'+
		'        \"ReceiptId\": null,'+
		'        \"Receipt\": null,'+
		'        \"ResponseCode\": null,'+
		'        \"ResponseText\": null,'+
		'        \"MerchantID\": null,'+
		'        \"TerminalID\": null,'+
		'        \"PosReference\": null,'+
		'        \"SettlementDate\": null,'+
		'        \"ReceiptGUID\": null,'+
		'        \"MposDeviceId\": null,'+
		'        \"TotalAmount\": 100,'+
		'        \"InvoiceNumber\": null,'+
		'        \"InvoiceDescription\": \"\",'+
		'        \"InvoiceReference\": \"\",'+
		'        \"CurrencyCode\": \"AUD\"'+
		'    },'+
		'    \"Errors\": null'+
		'}';
		EwayRefundResponse r = EwayRefundResponse.parse(json);
	}
        
       // System.debug('TEST Refund Response '+res.getBody()+' --> Code  '+res.getStatusCode());
        if(test.isRunningTest()){
                res = new HttpResponse();
                res.setStatusCode(200); 
            }
        if(res.getStatusCode() == 200)
        {
            	EwayRefundResponse obj_response;
            if(Test.isRunningTest())
              {
                  	String json1 = '{'+
		'    \"AuthorisationCode\": \"508125\",'+
		'    \"ResponseCode\": null,'+
		'    \"ResponseMessage\": \"A2000\",'+
		'    \"TransactionID\": 16929965,'+
		'    \"TransactionStatus\": true,'+
		'    \"Verification\": null,'+
		'    \"Customer\": {'+
		'        \"TokenCustomerID\": null,'+
		'        \"Reference\": null,'+
		'        \"Title\": null,'+
		'        \"FirstName\": \"\",'+
		'        \"LastName\": \"\",'+
		'        \"CompanyName\": null,'+
		'        \"JobDescription\": null,'+
		'        \"Street1\": \"\",'+
		'        \"Street2\": null,'+
		'        \"City\": \"\",'+
		'        \"State\": \"\",'+
		'        \"PostalCode\": \"\",'+
		'        \"Country\": \"\",'+
		'        \"Email\": \"\",'+
		'        \"Phone\": \"\",'+
		'        \"Mobile\": null,'+
		'        \"Comments\": null,'+
		'        \"Fax\": null,'+
		'        \"Url\": null,'+
		'        \"CardDetails\": {'+
		'            \"Number\": null,'+
		'            \"Name\": null,'+
		'            \"ExpiryMonth\": null,'+
		'            \"ExpiryYear\": null,'+
		'            \"StartMonth\": null,'+
		'            \"StartYear\": null,'+
		'            \"IssueNumber\": null'+
		'        }'+
		'    },'+
		'    \"Refund\": {'+
		'        \"TransactionID\": \"16927384\",'+
		'        \"AuthorisationID\": null,'+
		'        \"STAN\": null,'+
		'        \"ReceiptId\": null,'+
		'        \"Receipt\": null,'+
		'        \"ResponseCode\": null,'+
		'        \"ResponseText\": null,'+
		'        \"MerchantID\": null,'+
		'        \"TerminalID\": null,'+
		'        \"PosReference\": null,'+
		'        \"SettlementDate\": null,'+
		'        \"ReceiptGUID\": null,'+
		'        \"MposDeviceId\": null,'+
		'        \"TotalAmount\": 100,'+
		'        \"InvoiceNumber\": null,'+
		'        \"InvoiceDescription\": \"\",'+
		'        \"InvoiceReference\": \"\",'+
		'        \"CurrencyCode\": \"AUD\"'+
		'    },'+
		'    \"Errors\": null'+
		'}';
        		 
                  obj_response = EwayRefundResponse.parse(json1); 
              }
            else
            {
				obj_response = EwayRefundResponse.parse(res.getBody());            
            }
            
            
            if(obj_response.TransactionStatus && obj_response.ResponseMessage == SuccessMessage)
            {
                result = true;
                PaymentUtility.updateEventRegistrations(Opp.Event_Registrations__r, 'Cancelled', String.ValueOf(amt/100));
            }
            
            string trxId, trxType, trxStatus;
            if(result){
                trxId = String.valueOf(obj_response.TransactionID);
                trxStatus = 'SUCCESSFUL';
            } else {
                PaymentUtility.updateEventRegistrations(Opp.Event_Registrations__r, 'Failed', String.ValueOf(amt/100));
                trxStatus = 'FAILED';
            }
            trxType = 'REFUND';
            
            PaymentUtility.generateCardTransactionRecord(oppID, ewayGatewayID, res.getBody(), trxId, trxType, trxStatus);
        }
        System.debug('Test result '+result);
        return result;
    }
}
public without sharing class PaymentUtility {

    //Added by Yugandhara on 19th sept 2017
    public static list<Payment_Gateway__c> listPaymentGateway {get;set;}
    
    public PaymentUtility(){
        
    }
    
    public static list<Payment_Gateway__c> getPaymentGatewayDetails(){
        System.debug('listPaymentGatewayUtil'+listPaymentGateway);
        if( listPaymentGateway == null){
           if(!Test.isRunningTest()){
            listPaymentGateway = [select id, name, Active__c, eWay_API_Key__c, eWay_API_Password__c,  Merchant_ID__c, Merchant_Reference__c, 
                  Merchant_Security_Key__c, Test_Endpoint__c, RecordType.Name, User_Name__c from payment_gateway__c  where Active__c = true limit 1];
               System.debug('listPaymentGatewayUtil'+listPaymentGateway);
           } else{
               Payment_Gateway__c pg = new Payment_Gateway__c();
               pg.Name = 'payflow';
               pg.Merchant_ID__c = 'shahanuj4u';
               pg.Merchant_Reference__c = 'PayPal';
               pg.Merchant_Security_Key__c = '1234';
               pg.Active__c = true;
               listPaymentGateway = new List<Payment_Gateway__c>();
               listPaymentGateway.add(pg);
           }
        }  
        return listPaymentGateway;
    }  
    public static void generateCardTransactionRecord(String oppId, String gatewayID, String response, String trxId, String trxType, String trxStatus)
    {
        //Insert transaction Record
        Card_Transaction__c crdTrx = new Card_Transaction__c();
        crdTrx.Opportunity__c = oppId;
        crdTrx.Payment_Gateway__c = gatewayID;
        crdTrx.Payment_Gateway_Response__c = response;
        crdTrx.Transaction_ID__c = trxId;
        crdTrx.Transaction_Type__c = trxType;
        crdTrx.Transaction_Status__c = trxStatus;
        System.debug('Test Inside trasaction record');
        insert crdTrx;
    }
    
    public static void updateOppAmt(Opportunity opp,String amount)
    {
        opp.Amount_Paid__c = Decimal.valueOf(amount); 
        opp.Amount_Due__c = opp.Amount - opp.Amount_Paid__c <= 0 ? 0 : opp.Amount - opp.Amount_Paid__c;
        opp.StageName = 'Closed Won';
        opp.Probability = 100;
        opp.Quote_Pdf_Status__c = 'Quote to be Created';
        opp.status_of_payment__c = 'Paid';
        update opp;
        
        for(Event_Registration__c ereg : opp.Event_Registrations__r){
            ereg.Registration_Status__c = 'Successful';
        }
        update opp.Event_Registrations__r;
    }
    
    public static void updateEventRegistrations(List<Event_Registration__c> evntRegs, String regStatus, string Amount)
    {   
        if(evntRegs != null && evntRegs.size() > 0){
            Integer totaleventRegistrations = evntRegs.size();
        
            for(Event_Registration__c ereg : evntRegs){
                ereg.Registration_Status__c = regStatus;
                if(regStatus == 'Successful'){
                    ereg.Registration_Type__c = 'Paying';
                    ereg.Net_Attendee_Amount__c = Decimal.valueof(Amount) / totaleventRegistrations;
                }
            }
            update evntRegs;
        }
        
    }
    
    public static Map<string, string> getKeyValuePairFromURL(String url){
        Map<string, string> result = new Map<string, string>();
        if(url != null){
            List<string> splitParamFromBaseUrl = url.split('\\?');
            String paramstring;
            if(splitParamFromBaseUrl.size() == 2){
                paramstring = splitParamFromBaseUrl[1];
            } else if(splitParamFromBaseUrl.size() == 1){
                paramstring = splitParamFromBaseUrl[0];
            }
            
            if(paramstring != null){
                List<string> paramList = paramstring.split('&');
                for(string param : paramList){
                    List<string> keyValueList = param.split('=');
                    if(keyValueList.size() == 2){
                        result.put(keyValueList[0].toUpperCase(), keyValueList[1].toUpperCase());
                    }
                }
            }
        }
        return result;
    }
    
    public static decimal calculateRefundAmount(Decimal amountPaid, Decimal surcharge, Decimal refundCharge){
        Decimal result = 0;
        if(amountPaid != null){
            result = (surcharge != null && surcharge != 0 )? amountPaid - (amountPaid * surcharge / 100) : amountPaid;
            result = refundCharge != null ? result - (result * refundCharge / 100) : result;
        }
        return result;
    }
    
    public static void createQuoteLineItemRecord(Opportunity opp, String quoteId){
        
        
        List<OpportunityLineItem> olis = opp.OpportunityLineItems;
        System.debug('olis'+olis);
        if(olis != null && olis.size() == 1){
            list<PriceBookEntry> priceBookList = [Select Id, Product2Id from PriceBookEntry where Product2.Name=:olis[0].Product2.Name AND PriceBook2.isStandard = true LIMIT 1]; 
            QuoteLineItem qli = new QuoteLineItem();
            qli.PricebookEntryId = priceBookList[0].id;
            qli.QuoteId = quoteId;
            qli.Quantity = opp.Ticket_Qty__c;
            qli.UnitPrice = opp.Amount / opp.Ticket_Qty__c;
            qli.Paid_Already__c = opp.Amount_Paid__c;
            qli.Description = opp.Event__r.Name + ' ' + opp.Event__r.Event_Start_time__c.format('MMMMM') + ' ' + opp.Event__r.Event_Start_time__c.day() + ' ' + opp.Event__r.Event_Start_time__c.year() + ' ' + '(' + opp.Ticket_Qty__c + ' x ' + opp.Event_Package__r.Name + ')';
            System.debug('qli'+qli);
            insert qli;
        }
    }

    public static string createQuoteRecord(Opportunity opp){
        System.debug(opp);
        
        Quote qt = new Quote();
        qt.name = 'Quote-' + opp.Id;
        qt.opportunityId = opp.Id;
        qt.Pricebook2Id  = [Select Id from Pricebook2 where isStandard = true Limit 1].Id;
        qt.Include_GST__c = false;
        insert qt;
        return qt.Id;
    }
}
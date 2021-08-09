public with sharing class Payment {
	public Payment() {
		
	}

	public XeroCreatePaymentResponse createPayment(List<Id> lstOpps){
		XeroClient xc = new XeroClient();
        XeroCreatePaymentRequest req = PreparePaymentDetailsFromOpportunity(lstOpps);
        String jsonreq;
        if(req != null)
        	jsonreq = JSON.serialize(req);
        system.debug('Req ::' + jsonreq);
        JSONParser parser = JSON.createParser(jsonreq);      
        while (parser.nextToken() != null)
            {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Date_z'))
                {
                    jsonreq=jsonreq.replace(parser.getText(),'Date');
                }
            }
		HttpResponse res = xc.doPost(XeroConfig.API_ENDPOINT_URL+'Payments', jsonreq);
        system.debug('Urvish ::' + res.getBody());
        XeroCreatePaymentResponse resposne = XeroCreatePaymentResponse.parse(res.getBody());
        return resposne;
	}

	public XeroCreatePaymentRequest PreparePaymentDetailsFromOpportunity(List<Id> lstOpps){
		XeroCreatePaymentRequest createPaymentRequest = new XeroCreatePaymentRequest();        
        if(lstOpps != null && lstOpps.size() > 0){
			List<Opportunity> Opps = [Select Id,Name,Description, Surchrge__c, Xero_Invoice_Id__c, Amount_paid__c, Event__r.Event_Start_Time__c, 
			(select Id,Quantity,UnitPrice,ListPrice,Product2.Name,Product2.Description, Product2.Xero_Account_Code__c, Description,Product2.ProductCode,Discount from OpportunityLineItems),AccountId,Amount,CloseDate,Account.Name,Account.Xero_Account_Id__c
											from Opportunity where id IN :lstOpps];
			if(Opps != null && Opps.size() > 0){
				XeroCreatePaymentRequest.Invoice invoice = new XeroCreatePaymentRequest.Invoice();
				invoice.InvoiceID = Opps[0].Xero_Invoice_Id__c;
				createPaymentRequest.Invoice = invoice;
				XeroCreatePaymentRequest.Account account = new XeroCreatePaymentRequest.Account();
				account.Code = '200';
				createPaymentRequest.Account = account;
				createPaymentRequest.Amount = Opps[0].Surchrge__c != null ? Opps[0].Amount + (Opps[0].Amount * Opps[0].Surchrge__c / 100) : Opps[0].Amount;
				Date today = System.today();
				createPaymentRequest.Date_z = today.year() + '-' + today.month() + '-' + today.day();
			}
            return createPaymentRequest;
		}
        return null;
	}
}
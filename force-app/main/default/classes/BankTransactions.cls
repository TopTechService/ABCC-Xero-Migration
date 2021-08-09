public class BankTransactions {

    public BankTransactions(){
        
    }
    
    public void getBankTransactions(){
		XeroClient xc = new XeroClient();
        
		HttpResponse res = xc.doGet(XeroConfig.API_ENDPOINT_URL+'BankTransactions', null);
	}
    
    public XeroCreateBankTransactionRes createBankTransactions(List<Opportunity> lstOpps){
    	XeroClient xc = new XeroClient();
        XeroCreateBankTransactionRequest req = PrepareTransactionDetailsFromOpportunity(lstOpps);
        String jsonreq;
        if(req != null)
        	jsonreq = JSON.serialize(req);
        system.debug('Req ::' + jsonreq);
        JSONParser parser = JSON.createParser(jsonreq);      
        while (parser.nextToken() != null)
            {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Type_z'))
                {
                    jsonreq=jsonreq.replace(parser.getText(),'Type');
                }
            }
		HttpResponse res = xc.doPost(XeroConfig.API_ENDPOINT_URL+'BankTransactions', jsonreq);
        system.debug('Urvish :' + res.getBody());
        XeroCreateBankTransactionRes resposne = XeroCreateBankTransactionRes.parse(res.getBody());
        return resposne;
	}
    
    public XeroCreateBankTransactionRequest PrepareTransactionDetailsFromOpportunity(List<Opportunity> lstOpps){
        XeroCreateBankTransactionRequest createBankTransactions = new XeroCreateBankTransactionRequest();
        if(lstOpps != null && lstOpps.size() > 0){
			/*List<Opportunity> Opps = [Select Id,Name,Description, Surchrge__c, Xero_Invoice_Number__c, (select Id,Quantity,UnitPrice,ListPrice,Product2.Name,Product2.Description, Description,Product2.ProductCode,Discount,Product2.Xero_Liability_Account_Code__c from OpportunityLineItems),AccountId,Amount,CloseDate,Account.Name,Primary_Contact__r.Xero_Contact_Id__c
											from Opportunity where id IN :lstOpps];*/
            List<Opportunity> Opps = lstOpps;
			if(Opps != null && Opps.size() > 0){
				XeroCreateBankTransactionRequest.BankAccount bankAccount = new XeroCreateBankTransactionRequest.BankAccount();                
                XeroCreateBankTransactionRequest.Contact contact = new XeroCreateBankTransactionRequest.Contact();                 
                
                for(Opportunity objOpp : Opps)
                {
                    contact.ContactID = objOpp.Primary_Contact__r.Xero_Contact_Id__c;
                    createBankTransactions.Type_Z = 'RECEIVE-PREPAYMENT';
                    bankAccount.Code = '100';
                    createBankTransactions.contact = contact;
                    createBankTransactions.bankAccount = bankAccount;
                    createBankTransactions.Reference = objOpp.Xero_Invoice_Number__c;
                    createBankTransactions.lineitems = new List<XeroCreateBankTransactionRequest.LineItems>();
                    for(OpportunityLineItem objOpi : objOpp.OpportunityLineItems)
                    {
                        XeroCreateBankTransactionRequest.LineItems lineitems = new XeroCreateBankTransactionRequest.LineItems();
                        lineitems.Description = objOpi.Description != null ? objOpi.Description :  objOpi.Product2.Name;
                        lineitems.Quantity = String.valueOf(objOpi.Quantity);
                        lineitems.UnitAmount = String.valueOf(objOpi.UnitPrice);
                        lineitems.AccountCode = objOpi.Product2.Xero_Liability_Account_Code__c;
                        //lineitems.AccountCode = '200';
                        createBankTransactions.lineitems.add(lineitems);
                    }
                    
                    if(objOpp.Surchrge__c != null && objOpp.Surchrge__c > 0){
                        XeroCreateBankTransactionRequest.LineItems lineitems = new XeroCreateBankTransactionRequest.LineItems();
                        lineitems.Description = 'Amex Surcharge';
                        lineitems.Quantity = '1';
                        lineitems.AccountCode = '0520';
                        //lineitems.AccountCode = '200';
                        lineitems.UnitAmount = String.ValueOf(objOpp.Amount * objOpp.Surchrge__c / 100);
                        createBankTransactions.lineitems.add(lineitems);
                    }
                }
            }
        	return createBankTransactions;
        }
        return null;
    }
}
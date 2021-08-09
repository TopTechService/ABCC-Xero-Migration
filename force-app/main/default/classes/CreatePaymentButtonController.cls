public class CreatePaymentButtonController {
	public pagereference createPayment(){
		Id oppId = ApexPages.currentPage().getParameters().get('id');
		System.debug('oppId' + oppId);
		List<Opportunity> opp = [Select Id, Liability_Bank_Transaction__c,Name,Description, Surchrge__c, Xero_Invoice_Number__c,Amount_Paid__c, Amount_Due__c,
                                 (select Id,Quantity,UnitPrice,ListPrice,Product2.Name,Product2.Description, Description,Product2.ProductCode,Discount,Product2.Xero_Liability_Account_Code__c from OpportunityLineItems),
                                 AccountId,Amount,CloseDate,Account.Name,
                                 Type, Product__c, Xero_Bank_Transaction_Id__c, 
                                 Xero_Prepayment_Id__c,
                                 Primary_Contact__r.Id,
                                 Primary_Contact__r.Xero_Contact_Id__c,
                                 Primary_Contact__r.Name,
                                 Primary_Contact__r.MailingPostalCode,
                                 Primary_Contact__r.MailingStreet,
                                 Primary_Contact__r.MailingCity,
                                 Primary_Contact__r.MailingState,
                                 Primary_Contact__r.Phone,
                                 Primary_Contact__r.FirstName,
                                 Primary_Contact__r.LastName,
                                 Primary_Contact__r.Company_Name__c,
                                 Primary_Contact__r.Account.Name
                                 from Opportunity Where Id =:oppId];
		if(opp != null && opp.size() == 1 && opp[0].Liability_Bank_Transaction__c == 'Pending'){
			
			if(opp[0].Type == 'Event' && opp[0].Product__c == 'Event Attendee'){
                Contacts con = new Contacts();
                List<Contact> updatedCon = new List<Contact> ();
                XeroCreateContactResponse cResponse = con.createContacts(new List<Contact> {opp[0].Primary_Contact__r});
                if(cResponse.Contacts != null && cResponse.Contacts.size() == 1){
                    opp[0].Primary_Contact__r.Xero_Contact_Id__c = cResponse.Contacts[0].ContactID;
                    updatedCon.add(opp[0].Primary_Contact__r);
                }
                
				BankTransactions bt = new BankTransactions();
				XeroCreateBankTransactionRes btResponse = bt.createBankTransactions(new List<Opportunity> {opp[0]});
				System.debug(btResponse);
				if(btResponse.BankTransactions != null && btResponse.BankTransactions.size() > 0 &&
					btResponse.BankTransactions[0].PrepaymentID != null && btResponse.BankTransactions[0].BankTransactionID != null){
					opp[0].Xero_Bank_Transaction_Id__c = btResponse.BankTransactions[0].BankTransactionID;
					opp[0].Xero_Prepayment_Id__c = btResponse.BankTransactions[0].PrepaymentID;
					System.debug(btResponse.BankTransactions[0].Status);
					if(btResponse.BankTransactions[0].Status == 'AUTHORISED'){
						opp[0].Liability_Bank_Transaction__c = 'Paid';
                        System.debug(opp[0].Amount_Paid__c);
                        System.debug(opp[0].Amount_Due__c);
                        opp[0].Amount_Paid__c = opp[0].Amount_Due__c == null ? opp[0].Amount : opp[0].Amount_Paid__c + opp[0].Amount_Due__c;
                        opp[0].Amount_Due__c = 0;
					}
				}
                
                update updatedCon;
			}
		} else if(opp != null && opp.size() == 1 && opp[0].Liability_Bank_Transaction__c == 'Not Required'){
			Payment pay = new Payment();
			XeroCreatePaymentResponse response = pay.createPayment(new List<Id> {oppId});
			System.debug(response);
			if(response.Payments != null && response.Payments.size() > 0 && response.Payments[0].Invoice != null && response.Payments[0].Invoice.Status != null){
				opp[0].Xero_Invoice_Status__c = response.Payments[0].Invoice.Status;
				attachInvoice(opp[0].Online_Invoice_URL__c, opp[0].Xero_Invoice_Id__c, opp[0].Id, opp[0].Xero_Invoice_Number__c);
			}
		}

		update opp;
		
		return new pagereference('/'+oppId);
	}

	public void attachInvoice(String OnineInvoiceLink, String XeroId, String OppId, String InvoiceNmber){
		String url = OnineInvoiceLink + '/Invoice/DownloadPdf/'+XeroId;
        Http h = new Http();           
        HttpRequest req = new HttpRequest();
        url = url.replace(' ', '%20');
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/pdf');
        // To download Pdf 'application/pdf'
        // To download Document 'application/doc'
        // To download img 'image/jpeg'
        req.setCompressed(true);
        req.setTimeout(120000);
        HttpResponse res = null;
        res = h.send(req);
        blob file = res.getBodyAsBlob();
        Attachment n = new Attachment();
        n.ParentId = OppId;                              //set where you want to Save/Attach file
        n.Name = InvoiceNmber + '-paid.pdf';
        n.Body = file;
        n.contentType = 'application/pdf';
        // To download Pdf 'application/pdf'
        // To download Document 'application/doc'
        // To download img 'image/jpeg'
        insert n;
	}
}
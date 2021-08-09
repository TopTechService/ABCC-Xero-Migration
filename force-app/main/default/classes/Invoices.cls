public without sharing class Invoices {
	public Invoices() {
			
	}

	public XeroCreateInvoiceResponse createInvoices(List<Opportunity> lstOpps){
		XeroClient xc = new XeroClient();
        XeroCreateInvoiceRequest req = PrepareInvoiceDetailsFromOpportunity(lstOpps);
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
		HttpResponse res = xc.doPost(XeroConfig.API_ENDPOINT_URL+'invoices', jsonreq);
        system.debug('Urvish ::' + res.getBody());
        XeroCreateInvoiceResponse resposne = XeroCreateInvoiceResponse.parse(res.getBody());
        return resposne;
	}

	public void getInvoices(){
		XeroClient xc = new XeroClient();
		HttpResponse res = xc.doGet(XeroConfig.API_ENDPOINT_URL+'invoices', null);
	}

    public OnlineInvoiceResponse getOnlineInvoice(String invId){
        XeroClient xc = new XeroClient();
        HttpResponse res = xc.doGet(XeroConfig.API_ENDPOINT_URL+'Invoices/'+invId+'/OnlineInvoice', null);
        OnlineInvoiceResponse resposne = OnlineInvoiceResponse.parse(res.getBody());
        return resposne;
    }

	public XeroCreateInvoiceRequest PrepareInvoiceDetailsFromOpportunity(List<Opportunity> lstOpps){
        
        //Added by Yp
        //Map<String,String> MapTrackingOption = new Map<String,String>();
        //Map<String,String> MapTrackingOptionCategory = new Map<String,String>();
        //list<TrackingOption__c> TrackingOption = [select id,name,Tracking__r.Name,TrackingOptionID__c  from TrackingOption__c];
        //for(TrackingOption__c ToMy : TrackingOption)
        //{
        // MapTrackingOptionCategory.put(ToMy.name,ToMy.Tracking__r.Name);
        // MapTrackingOption.put(ToMy.name,ToMy.name);
        //}
        //**************
        Tracking__c trackCategory = [Select id,name from Tracking__c limit 1];
        
		XeroCreateInvoiceRequest createInvoiceRequest = new XeroCreateInvoiceRequest();
        Date invoiceDate = Date.Today();        
        String strInvoiceDate =  invoiceDate.year() +'-' +invoiceDate.Month()+'-' + invoiceDate.day();
        
        if(lstOpps != null && lstOpps.size() > 0){
			XeroCreateInvoiceRequest.Contact contact = new XeroCreateInvoiceRequest.Contact();
            for(Opportunity objOpp : lstOpps)
            {
                Date dueDate = objOpp.Event__r != null ? objOpp.Event__r.Event_Start_Time__c.Date() : invoiceDate.AddDays(14) ;
                String strDueDate =  dueDate.year() +'-' +dueDate.Month()+'-' + dueDate.day();

                system.debug('Urvish :' + objOpp.Primary_Contact__r.Xero_Contact_Id__c);
                contact.ContactID = objOpp.Primary_Contact__r.Xero_Contact_Id__c;
				system.debug('Urvish :' + contact.ContactID);
                createInvoiceRequest.Type_Z = 'ACCREC';
                createInvoiceRequest.InvoiceNumber = objOpp.Xero_Invoice_Number__c;
                createInvoiceRequest.Date_z = strInvoiceDate;
                createInvoiceRequest.Status = 'AUTHORISED';
                createInvoiceRequest.LineAmountTypes = 'Inclusive';
                createInvoiceRequest.DueDate = strDueDate;
                if(objOpp.Event__c != null && !String.isBlank(objOpp.Event__r.Our_Reference__c)){
                    createInvoiceRequest.Reference = objOpp.Event__r.Our_Reference__c;
                    //createInvoiceRequest.arrayOfTracking(p);
                }
                
                if(objOpp.Xero_Invoice_Id__c != null){
                    createInvoiceRequest.InvoiceId = objOpp.Xero_Invoice_Id__c;
                } 
                
                createInvoiceRequest.contact = new XeroCreateInvoiceRequest.Contact();
                createInvoiceRequest.contact = contact;
                createInvoiceRequest.lineitems = new List<XeroCreateInvoiceRequest.LineItems>();
                
                for(OpportunityLineItem objOpi : objOpp.OpportunityLineItems)
                {
                    XeroCreateInvoiceRequest.LineItems lineitems = new XeroCreateInvoiceRequest.LineItems();
                    
                    //Added by Yp
                    XeroCreateInvoiceRequest.Tracking temp = new XeroCreateInvoiceRequest.Tracking(); 
                    temp.Name = trackCategory.Name;
                    temp.Option = objOpp.Event__r.Our_Reference__c; //'res2';//
                    lineitems.Tracking = new List<XeroCreateInvoiceRequest.Tracking>();
                    lineitems.Tracking.add(temp);
                    
                    System.debug('temp ++' + temp);
                    //*************
                    
                    lineitems.Description = objOpi.Description != null ? objOpi.Description :  objOpi.Product2.Name;
                    lineitems.Quantity = String.valueOf(objOpi.Quantity);
                    lineitems.AccountCode = objOpi.Product2.Xero_Account_Code__c;
                    
                    
                    //lineitems.AccountCode = '200';
                    /*if(objOpi.Opportunity.Type == 'Event' && objOpi.Opportunity.Product__c == 'Event Attendee' && objOpp.Add_GST_on_Invoice__c == false){
                        lineitems.Taxtype = 'EXEMPTOUTPUT';
                    }*/
                    lineitems.UnitAmount = String.valueOf(objOpi.UnitPrice);
                    lineitems.DiscountRate = String.valueOf(objOpi.Discount);
                    createInvoiceRequest.lineitems.add(lineitems);
                }

                if(objOpp.Surchrge__c != null && objOpp.Surchrge__c > 0){
                    XeroCreateInvoiceRequest.LineItems lineitems = new XeroCreateInvoiceRequest.LineItems();
                    lineitems.Description = 'Amex Surcharge';
                    lineitems.Quantity = '1';
                    lineitems.AccountCode = '0520';
                    //lineitems.AccountCode = '200';
                    if(objOpp.Add_GST_on_Invoice__c == false){
                        lineitems.Taxtype = 'EXEMPTOUTPUT';
                    }
                    lineitems.UnitAmount = String.ValueOf(objOpp.Amount * objOpp.Surchrge__c / 100);
                    createInvoiceRequest.lineitems.add(lineitems);
                }
                /*for()
                {
                    
                }*/
                
            }
            return createInvoiceRequest;
		}
        return null;
	}
}
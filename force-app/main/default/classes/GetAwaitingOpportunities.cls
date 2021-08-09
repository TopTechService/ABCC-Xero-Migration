global class GetAwaitingOpportunities Implements Schedulable{
    global void execute (SchedulableContext sc)
    {
        getProspectingAwaitingOpportunities();
    }
    @future(callout=true)
    public static void getProspectingAwaitingOpportunities()
    {   
        List<Opportunity> oppList = [Select ID,Name,Status_of_payment__c,Event__r.Name,Ticket_Qty__c,Primary_Contact__r.Email,CreatedDate,LastModifiedDate, 
                                    Description, Surchrge__c, Xero_Invoice_Status__c, Xero_Invoice_Id__c,
                                    Event__r.Event_Start_Time__c, (select Id,Quantity,UnitPrice,ListPrice,Product2.Name,Product2.Description, Product2.Xero_Account_Code__c, Description,Product2.ProductCode,Discount from OpportunityLineItems),
                                    Xero_Invoice_Number__c, Type, Product__c, AccountId, Amount, CloseDate,
                                    Account.Id, Account.Xero_Account_Id__c,Account.Name,Account.BillingPostalCode,Account.BillingStreet,
                                    Account.BillingCity, Account.BillingState, Account.Phone, Event__r.Our_Reference__c,
                                    Primary_Contact__r.Id,
                                    Primary_Contact__r.Xero_Contact_Id__c,
                                    Primary_Contact__r.Name,
                                    Primary_Contact__r.MailingPostalCode,
                                    Primary_Contact__r.MailingStreet,
                                    Primary_Contact__r.MailingCity,
                                    Primary_Contact__r.MailingState,
                                    Primary_Contact__r.Phone
                                    from Opportunity where Status_of_payment__c='Awaiting For Payment' limit 50000];
        System.debug(oppList);
        List<Opportunity> opplistToUpdate = new List<Opportunity>();
        //string header = 'Record Id, Name ,Status of Payment,Event,Ticket Quantity,Email,Created Date, Modified Date \n';
        //string finalstr = header ;
        if((oppList!=null)&&(oppList.size()>0))
        {
            XeroClient xc = new XeroClient();
            XeroCreateMultipleInvoiceRequest req = PrepareVoidInvoiceDetailsFromOpportunity(oppList);
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
            system.debug('Urvish ::' + res.getStatusCode());
            system.debug('Urvish ::' + res.getBody());
            XeroCreateInvoiceResponse resposne = XeroCreateInvoiceResponse.parse(res.getBody());
            if(res.getStatusCode() == 200){
                for(Opportunity opp: oppList)
                {
                    opp.stagename='Online Failed';
                    opp.status_of_payment__c = 'Online Failed';
                    opp.Xero_Invoice_Status__c = 'VOIDED';
                    opplistToUpdate.add(opp);
                }
                System.debug('opplistToUpdate :- '+opplistToUpdate);
                update opplistToUpdate;
            }
            /*for(Opportunity a: oppList)
            {
               string recordString = a.id+','+a.Name+','+a.status_of_payment__c+','+a.Event__r.Name+','+a.Ticket_Qty__c+','+a.Primary_Contact__r.Email+','+a.CreatedDate+','+a.LastModifiedDate +'\n';
               finalstr = finalstr +recordString;
            }
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalstr);
            string csvname= 'Opportunity.csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String[] toAddresses = new list<string> {'natavar@resonantcloud.info'};
            String subject ='Opportunities Failed in last half hour.';
            email.setSubject(subject);
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Please Find the Attached file.');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});*/
        }
    }

    public static XeroCreateMultipleInvoiceRequest PrepareVoidInvoiceDetailsFromOpportunity(List<Opportunity> lstOpps){
        
        Date invoiceDate = Date.Today();        
        String strInvoiceDate =  invoiceDate.year() +'-' +invoiceDate.Month()+'-' + invoiceDate.day();
        
        if(lstOpps != null && lstOpps.size() > 0){
            DateTime dt = System.now();
            DateTime earlier = dt.addMinutes(-30);
            XeroCreateMultipleInvoiceRequest multipleReq = new XeroCreateMultipleInvoiceRequest();
            multipleReq.Invoices = new List<XeroCreateInvoiceRequest>();
            for(Opportunity objOpp : lstOpps)
            {
                if((objOpp.LastModifiedDate < earlier || Test.isRunningTest()) && objOpp.Xero_Invoice_Id__c != null){
                    XeroCreateInvoiceRequest createInvoiceRequest = new XeroCreateInvoiceRequest();
                    XeroCreateInvoiceRequest.Contact contact = new XeroCreateInvoiceRequest.Contact();
                    Date dueDate = objOpp.Event__r != null ? objOpp.Event__r.Event_Start_Time__c.Date() : invoiceDate.AddDays(14) ;
                    String strDueDate =  dueDate.year() +'-' +dueDate.Month()+'-' + dueDate.day();

                    system.debug('Urvish :' + objOpp.Primary_Contact__r.Xero_Contact_Id__c);
                    contact.ContactID = objOpp.Primary_Contact__r.Xero_Contact_Id__c;
                    system.debug('Urvish :' + contact.ContactID);
                    createInvoiceRequest.Type_Z = 'ACCREC';
                    createInvoiceRequest.Date_z = strInvoiceDate;
                    createInvoiceRequest.Status = 'VOIDED';
                    createInvoiceRequest.DueDate = strDueDate;
                    if(objOpp.Event__c != null && !String.isBlank(objOpp.Event__r.Our_Reference__c)){
                        createInvoiceRequest.Reference = objOpp.Event__r.Our_Reference__c;
                    }
                    
                    createInvoiceRequest.InvoiceId = objOpp.Xero_Invoice_Id__c;

                    createInvoiceRequest.contact = new XeroCreateInvoiceRequest.Contact();
                    createInvoiceRequest.contact = contact;
                    createInvoiceRequest.lineitems = new List<XeroCreateInvoiceRequest.LineItems>();
                    for(OpportunityLineItem objOpi : objOpp.OpportunityLineItems)
                    {
                        XeroCreateInvoiceRequest.LineItems lineitems = new XeroCreateInvoiceRequest.LineItems();
                        lineitems.Description = objOpi.Description != null ? objOpi.Description :  objOpi.Product2.Name;
                        lineitems.Quantity = String.valueOf(objOpi.Quantity);
                        lineitems.AccountCode = objOpi.Product2.Xero_Account_Code__c;
                        //lineitems.AccountCode = '200';
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
                        lineitems.UnitAmount = String.ValueOf(objOpp.Amount * objOpp.Surchrge__c / 100);
                        createInvoiceRequest.lineitems.add(lineitems);
                    }
                    multipleReq.Invoices.add(createInvoiceRequest);
                }
            }
            return multipleReq;
        }
        return null;
    }
}
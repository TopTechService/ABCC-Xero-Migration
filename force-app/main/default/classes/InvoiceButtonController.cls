public class InvoiceButtonController {
    
    public pagereference createInvoice(){
        Id oppId = ApexPages.currentPage().getParameters().get('id');
        
        System.debug('oppId====' + oppId);
        List<Opportunity> opp = [Select Id, Name, Description, Surchrge__c, Xero_Invoice_Status__c, Xero_Invoice_Id__c,Add_GST_on_Invoice__c,
                                 Event__r.Event_Start_Time__c, (select Id,Quantity,UnitPrice,ListPrice,Product2.Name,Product2.Description, Product2.Xero_Account_Code__c, Description,Product2.ProductCode,Discount, Opportunity.Type, Opportunity.Product__c from OpportunityLineItems),
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
                                 Primary_Contact__r.Phone,
                                 Primary_Contact__r.FirstName,
                                 Primary_Contact__r.LastName,
                                 Primary_Contact__r.Company_Name__c,
                                 Primary_Contact__r.Account.Name
                                 from Opportunity Where Id =:oppId];
        System.debug(opp);
        
        //Added by Yp
        Map<String,String> TrackOptionAndId = new Map<String,String>();
        Tracking__c TrackingCategory = [select id,name,TrackingCategoryID__c,(select id,name,Tracking__c,TrackingOptionID__c from TrackingOptions__r) from Tracking__c limit 1];
        if(TrackingCategory!= null)
        {
            for(TrackingOption__c Tomy : TrackingCategory.TrackingOptions__r)
            {
                //System.debug('Tomy--->'+Tomy);
                TrackOptionAndId.put(Tomy.Name,Tomy.TrackingOptionID__c);
            }
        }
        //System.debug('TrackingCategory--->'+TrackingCategory);
        //***************
        System.debug('opp--->'+opp);
        if(opp != null && opp.size() == 1 && opp[0].Xero_Invoice_Number__c != null){
            Contacts con = new Contacts();
            List<Contact> updatedCon = new List<Contact> ();
            XeroCreateContactResponse cResponse = con.createContacts(new List<Contact> {opp[0].Primary_Contact__r});
            System.debug('cResponse--->'+cResponse);
            if(cResponse.Contacts != null && cResponse.Contacts.size() == 1){
                opp[0].Primary_Contact__r.Xero_Contact_Id__c = cResponse.Contacts[0].ContactID;
                updatedCon.add(opp[0].Primary_Contact__r);
            }
            
            //Added by Yp
            System.debug('---True Or False---'+TrackOptionAndId.containsKey(opp[0].Event__r.Our_Reference__c));
            System.debug('------check null----'+TrackOptionAndId.get(opp[0].Event__r.Our_Reference__c));
            List<TrackingOption__c> newTrackingOptions = New List<TrackingOption__c>();
            if(!TrackOptionAndId.containsKey(opp[0].Event__r.Our_Reference__c) && TrackOptionAndId.get(opp[0].Event__r.Our_Reference__c)==null && opp[0].Event__r.Our_Reference__c != null) {
                System.debug('----create Tracking Options------');
                TrackingOption TrackOpt = new TrackingOption();
                //TrackingCategoryResponse tResponse = TrackOpt.createTrackingOption(test);
                String trackingOptionID = TrackOpt.createTrackingOption(opp[0].Event__r.Our_Reference__c,TrackingCategory.TrackingCategoryID__c,TrackingCategory.Id);
                System.debug('Dan - TrackingOptionID=' + trackingOptionID);
                if(trackingOptionID != null) {
                    TrackingOption__c newOption = New TrackingOption__c(Name = opp[0].Event__r.Our_Reference__c,
                                                                        Tracking__c = TrackingCategory.Id,
                                                                        TrackingOptionID__c = trackingOptionID
                    );
                    newTrackingOptions.add(newOption);
                }
            }
            
            //*****
            
            
            Invoices inv = new Invoices();
            XeroCreateInvoiceResponse response = inv.createInvoices(new List<Opportunity> {opp[0]});
            System.debug('-----response----'+response);
            if(response.Invoices != null && response.Invoices.size() > 0 &&
               response.Invoices[0].InvoiceID != null && response.Invoices[0].Status != null){
                   opp[0].Xero_Invoice_Status__c = response.Invoices[0].Status;
                   opp[0].Xero_Invoice_Id__c = response.Invoices[0].InvoiceID;
                   //opp[0].Xero_Invoice_Number__c = response.Invoices[0].InvoiceNumber;
                   
                   if(response.Invoices[0].InvoiceID != null) {
                       OnlineInvoiceResponse oiRes = inv.getOnlineInvoice(response.Invoices[0].InvoiceID);
                       if(oiRes.OnlineInvoices != null && oiRes.OnlineInvoices.size() > 0){
                           opp[0].Online_Invoice_URL__c = oiRes.OnlineInvoices[0].OnlineInvoiceUrl;
                           attachInvoice(oiRes.OnlineInvoices[0].OnlineInvoiceUrl, response.Invoices[0].InvoiceID, opp[0].Id, response.Invoices[0].InvoiceNumber,opp[0].Account.Name);
                           system.debug('---->opp'+opp[0].Online_Invoice_URL__c);
                           
                       }
                   }
                   
                   update opp;
               }
            System.debug(updatedCon);
            update updatedCon;
            if(newTrackingOptions.size() != 0){
                insert newTrackingOptions;
            }
        }
        
        return new pagereference('/'+oppId);
    }
    
    public void attachInvoice(String OnineInvoiceLink, String XeroId, String OppId, String InvoiceNmber, String accName){
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
        n.Name = accName != null ? InvoiceNmber + '-' + accName +'.pdf' : InvoiceNmber+'.pdf';
        n.Body = file;
        n.contentType = 'application/pdf';
        // To download Pdf 'application/pdf'
        // To download Document 'application/doc'
        // To download img 'image/jpeg'
        insert n;
    }
}
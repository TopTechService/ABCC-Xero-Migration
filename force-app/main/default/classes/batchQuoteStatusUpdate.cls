global class batchQuoteStatusUpdate implements Database.Batchable<sObject>
{
    Public List<Opportunity> opp;
    List<Opportunity> updateQuoteStatus {get;set;}
    private Set<Id> oppIds;
    public blob b;
    
    public static List<OrgWideEmailAddress> lstOrgWideEmailAddress{ get{
        if(lstOrgWideEmailAddress == null)
            lstOrgWideEmailAddress = [select id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName='Australian British Chamber of Commerce'];
        return lstOrgWideEmailAddress;
    } set;}
    
    public static List<EmailTemplate> lstET{ get{
        if(lstET == null)
            lstET = [SELECT HtmlValue FROM EmailTemplate where Name = :Label.TempId];
        return lstET;
    } set;}
    
    global List<sObject> start(Database.BatchableContext BC)
    {
        //updateQuoteStatus = new List<Opportunity>();
        //String query = 'SELECT Id, Name ,Quote_Pdf_Status__c , Primary_Contact__c ,(select Name,Id from Quotes ) FROM Opportunity where Quote_Pdf_Status__c= \'Quote to be Created\'';
        return [SELECT Name ,Quote_Pdf_Status__c ,Primary_Contact__c , Primary_Contact__r.IsEmailBounced, Primary_Contact__r.Email , Primary_Contact__r.FirstName,
               Event__c, Event__r.Our_Reference__c, Event_Package__r.Type__c, Event__r.Event_Manager__r.Email,
               (Select Id, Registration_Status__c, Table__c, Table__r.Capacity__c From Event_Registrations__r),
               (SELECT Name, QuoteNumber, Xero_Invoice_Number__c, Id FROM Quotes ) FROM Opportunity WHERE Quote_Pdf_Status__c =: 'Quote to be Created'];
    }
 
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        opp = (List<Opportunity>)scope;
           List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
           List<Attachment> invoicePdfsToInsert = new List<Attachment>();
 
   		System.debug('opp ' + opp.size());
        if(!opp.isEmpty() && opp.size()>0)
        {
            updateQuoteStatus = new List<Opportunity>();
            for(Opportunity oppstatuschange : opp)
            {
                if(oppstatuschange.Quote_Pdf_Status__c == 'Quote to be Created' && oppstatuschange.Quotes != NULL && oppstatuschange.Quotes.size()>0)
                {
                     Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                     Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                     List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                   
                    oppstatuschange.Quote_Pdf_Status__c= 'Quote Created';
                    updateQuoteStatus.add(oppstatuschange );
        
                    String QuoteID = oppstatuschange.Quotes[0].Id;
                    String QuoteNumberString = oppstatuschange.Quotes[0].Xero_Invoice_Number__c;
                    String OurRef = oppstatuschange.Event__r.Our_Reference__c;
                    String conFname = oppstatuschange.Primary_Contact__r.FirstName;
                    //Create Quote and attach invoice with email
                    //Id of Quote record.
                    //This Url create the pdf for quote
                    String quoteUrl = Label.SalesforceBaseURL+'/quote/quoteTemplateDataViewer.apexp?id=';
                    quoteUrl +=QuoteID.substring(0, 15);
                    quoteUrl +='&&headerHeight=155&footerHeight=394&summlid=';
                    quoteUrl +=Label.summlid ;
                    quoteUrl +='#toolbar=1&navpanes=0&zoom=90';
                    System.debug('quoteUrl' + quoteUrl);
                    String result = '';
                    //Create pdf content
                    PageReference pg = new PageReference(quoteUrl) ;
                    //Get the content of Pdf.
                     if (Test.IsRunningTest())
                    {
                         blob content=Blob.valueOf('UNIT.TEST');
                    }else{
                        b = pg.getContentAsPDF() ;
                        System.debug('getContentAsPDF' + b);
                   }
                   
                    //oppRef.Description = '3' + EncodingUtil.base64encode(b);
                    
                    //Document object of quote which hold the quote pdf
                    Attachment invoicedoc = new Attachment();
                    //set where you want to Save/Attach file
                    invoicedoc.ParentId = oppstatuschange.Id;         
                    invoicedoc.Name = QuoteNumberString + '-paid.pdf';
                    invoicedoc.Body = b;
                    invoicedoc.contentType = 'application/pdf';
                    
                    //insert the quotdoc
                    if(!lstET.isEmpty())
                    {
                        message.setTemplateId(lstET[0].id);
                    }
                    //getting Org wide email
                    if(lstOrgWideEmailAddress.size()>0){
                        message.setOrgWideEmailAddressId(lstOrgWideEmailAddress[0].id);
                    }
                    
                    message.setTargetObjectId(oppstatuschange.Primary_Contact__c);
                    message.setSaveAsActivity(false);
                    message.setReplyTo(oppstatuschange.Event__r.Event_Manager__r.Email);
                    message.setWhatId(oppstatuschange.Id);
                    message.setBccAddresses(new String []{'accounts@britishchamber.com'});
                   if (!Test.IsRunningTest())
                   {
                    invoicePdfsToInsert.add(invoicedoc);
                    String fileName = QuoteNumberString + '_' + OurRef + '_'+ conFname+'.pdf';
                    efa.setFileName(fileName);
                    efa.setBody(b);
                    fileAttachments.add(efa);
                    message.setFileAttachments(fileAttachments);
                    if(!oppstatuschange.Primary_Contact__r.IsEmailBounced){
                        mails.add(message);
                    }
                    }
                         
                }
            }
        }      
        if(invoicePdfsToInsert != null && invoicePdfsToInsert.size() > 0)
        {
            system.debug('invoicePdfsToInsert' + invoicePdfsToInsert);
            insert invoicePdfsToInsert;
        }
        if(updateQuoteStatus != NULL && updateQuoteStatus.size() > 0 )
        {
            system.debug('updateQuoteStatus' + updateQuoteStatus);
            update updateQuoteStatus ;
        }
        if(!mails.isEmpty() && mails.size()>0)
        {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);   
        }           
                          
        TransactionTriggerHandler ttHandler = new TransactionTriggerHandler();
        ttHandler.allocateTables(opp);
        System.debug(updateQuoteStatus );
    
     }
 
    global void finish(Database.BatchableContext BC)
    {
    
    }
}
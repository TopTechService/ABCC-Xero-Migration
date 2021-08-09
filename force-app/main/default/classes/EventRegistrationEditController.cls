public without sharing class EventRegistrationEditController extends PageControllerBase {
    public Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper> oldAttendeeList {get;set;}
    public Map<RelatedAttendeeListCotroller.AttendeeWrapper, Event_Registration__c> eventRegAttendeeMap {get;set;}
    public Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper> AttendeeList {get;set;}
    public RelatedAttendeeListCotroller myComponentController { get; set; }
    public Integer maxAttendees { get; set; }
    public Id eventRegId { get; set; }
    //public String abccLogoURL { get; set; }
    //public Event_Registration__c er { get; set; }
    public Opportunity opp {get;set;}
    public String eventlocation {get;set;}
    public String eventWhen {get;set;}
    public String eventWhentime {get;set;}
    public String eventManager {get;set;}
    
    public EventRegistrationEditController() {
        maxAttendees = 0;
        AttendeeList = new Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper>();
        //id abccLogoId = [SELECT Id FROM Document where DeveloperName='ABCC'].Id;
        //abccLogoURL = '/servlet/servlet.FileDownload?file=' + abccLogoId;
        eventRegAttendeeMap = new Map<RelatedAttendeeListCotroller.AttendeeWrapper, Event_Registration__c>();
        
    }

    public override void setComponentController(ComponentControllerBase compController) {
       myComponentController = (RelatedAttendeeListCotroller)compController;
    }
    
    public override ComponentControllerBase getMyComponentController() {
        return myComponentController;
    }
    
    public void initializeAttendees() {
        //Blob exampleIv = Blob.valueOf('Example of IV123');
        System.debug('UB: decrypt'+apexPages.currentPage().getParameters().get('eventRegId'));
        //String decodedurl = EncodingUtil.urlDecode(apexPages.currentPage().getParameters().get('eventRegId'), 'UTF-8');
        //System.debug('UB: decodedurl'+decodedurl);
        Blob eventRegIdBlob = EncodingUtil.base64decode(apexPages.currentPage().getParameters().get('eventRegId'));
        Blob key = EncodingUtil.base64decode(Label.cryptoKey);
        // Decrypt the data - the first 16 bytes contain the initialization vector
        //Blob decryptedData = Crypto.decrypt('AES256', key, exampleIv, eventRegIdBlob);
        Blob decryptedData = Crypto.decryptWithManagedIV('AES256', key, eventRegIdBlob);
        System.debug(decryptedData);

        // Decode the decrypted data for subsequent use
        String decryptedDataString = decryptedData.toString();
        System.debug(decryptedDataString);
        
       list<Opportunity> opps = [Select Id, Event__r.Event_Manager__r.FirstName,Event__r.Event_Manager__r.Email, Event__r.Name, Event__r.Event_Manager__c, Event__r.Event_Manager__r.Name, Event__r.Event_Name__c, Event__r.Event_Start_Date__c, Event__r.Event_Start_Time__c, Event__r.Event_Finish_Time__c,Event__r.Timezone__c,  Event__r.Event_End_Date__c,Event__r.Venue__c,
               Event_Package__r.Name,Amount,Primary_Contact__r.MailingStreet, Primary_Contact__r.MailingCity, Primary_Contact__r.MailingState, Primary_Contact__r.MailingPostalCode, Primary_Contact__r.MailingCountry, Ticket_Qty__c,
               Primary_Contact__r.firstName,Primary_Contact__r.lastName,Primary_Contact__r.email,Primary_Contact__r.title,Primary_Contact__r.Company_Name__c,Primary_Contact__r.MobilePhone,Primary_Contact__r.Phone,
               (Select Id,First_Name__c,Last_Name__c,Email__c,Job_Title__c,Telphone__c,Company__c,Dietary_Requirements__c from Event_Registrations__r) from Opportunity where Id =:decryptedDataString LIMIT 1];
               System.debug('good');
        opp = opps[0];
        eventManager = opp.Event__r.Event_Manager__r.FirstName;
        System.debug('hiii');
        System.debug(opp.Event_Registrations__r);
        Integer count = 0;
      
            for(Event_Registration__c era :opp.Event_Registrations__r){
                System.debug('in for loop');
                If(era.First_Name__c == 'Not Known' && era.Last_Name__c == 'Not Known'){
                      System.debug('in if loop');
              
                    RelatedAttendeeListCotroller.AttendeeWrapper atd = new RelatedAttendeeListCotroller.AttendeeWrapper();
                    atd.firstName = null;
                    atd.lastName = null;
                    atd.email = null;
                    atd.positionTitle = null;
                    atd.Company = null;
                    atd.Dietary_Req = null;
                    atd.undefined = false;               
                    AttendeeList.put(count++, atd);
                    System.debug('UB: atd' + atd);
                    System.debug('UB: era' + era);
                    eventRegAttendeeMap.put(atd, era);
                } else {
                    RelatedAttendeeListCotroller.AttendeeWrapper atd = new RelatedAttendeeListCotroller.AttendeeWrapper();
                    atd.firstName = era.First_Name__c;
                    atd.lastName = era.Last_Name__c;
                    atd.email = era.Email__c;
                    atd.positionTitle = era.Job_Title__c;
                    atd.Company = era.Company__c;
                    atd.Dietary_Req = era.Dietary_Requirements__c;
                    atd.undefined = false;               
                    AttendeeList.put(count++, atd);
                    System.debug('UB: atd' + atd);
                    System.debug('UB: era' + era);
                    eventRegAttendeeMap.put(atd, era);
                }
            }     
        System.debug(AttendeeList);
        maxAttendees = count;
        oldAttendeeList = AttendeeList;
        myComponentController.populateAttenddes(AttendeeList);
        System.debug(myComponentController);      
        
        List<Venue__c> ve = [select Name, Street_Address_1__c, Street_Address_2__c, City__c, State__c, Country__c  from Venue__c where Id =: opp.Event__r.Venue__c ]; 
        System.debug('UB:ve'+ve);
        
        if(ve != null && ve.size() > 0){
            eventlocation = ve[0].Name;
            if(!String.isBlank(ve[0].Street_Address_1__c))
                eventlocation = eventlocation + ', ' + ve[0].Street_Address_1__c;
            if(!String.isBlank(ve[0].Street_Address_2__c))
                eventlocation = eventlocation + ', ' + ve[0].Street_Address_2__c;
            if(!String.isBlank(ve[0].City__c))
                eventlocation = eventlocation + ', ' + ve[0].City__c;
            if(!String.isBlank(ve[0].State__c))
                eventlocation = eventlocation + ', ' + ve[0].State__c;
            if(!String.isBlank(ve[0].Country__c))
                eventlocation = eventlocation + ', ' + ve[0].Country__c;
            System.debug('this is start date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+eventlocation);
        }
        
        //populating When to do : multiple dates 
        if(opp.Event__r.Event_Start_Date__c != null && opp.Event__r.Event_Start_Time__c != null && opp.Event__r.Event_Finish_Time__c != null) 
        {
            System.debug('kkkk');
            DateTime dt=DateTime.newInstance(opp.Event__r.Event_Start_date__c, Time.newInstance(0, 0, 0, 0));
            String monthString = eventdetailController.getMonthNameFromNumber(dt.Month());
            
            this.eventWhen = dt.format('EEEE') +' '+ dt.Day()+ ' ' +monthString + ' ' + dt.Year();
            this.eventWhentime = String.valueOf(opp.Event__r.Event_Start_Time__c.format('h:mm a')) + ' - ' +
                String.valueOf(opp.Event__r.Event_Finish_Time__c.format('h:mm a')) ;
                System.debug(opp.Event__r.Timezone__c);
            if(opp.Event__r.Timezone__c != null){
                this.eventWhentime = this.eventWhentime + ' ' + opp.Event__r.Timezone__c;
            }
            
            if(opp.Event__r.Event_Start_Time__c.date() != opp.Event__r.Event_Finish_Time__c.date()){
                DateTime enddt=DateTime.newInstance(opp.Event__r.Event_Finish_Time__c.date(), Time.newInstance(0, 0, 0, 0));
                String endMonthString = eventdetailController.getMonthNameFromNumber(enddt.Month());
                this.eventWhen = this.eventWhen + ' - '+ enddt.format('EEEE') +' '+enddt.Day()+' ' + endMonthString +' '+ enddt.Year();
            }
        }
    }
    
    public void updateRecords(){
        try{
            //delete opp.Event_Registrations__r;
            Set<String> allAttendeeEmail = new Set<String>();
            List<Contact> contactsToInsert = new List<Contact>();
            List<Event_Registration__c> erAttendeesToInsert = new List<Event_Registration__c>();
            
            for(RelatedAttendeeListCotroller.AttendeeWrapper atd : AttendeeList.values()){
                System.debug(atd);
                if(atd.email != null){
                    System.debug(atd);
                    allAttendeeEmail.add(atd.email);
                }
            }
            
            Map<string, Id> emailToContactMap = new Map<string, Id>();
            System.debug(allAttendeeEmail);
            List<Contact> AttendeeContacts = [Select Id,email from Contact where email IN :allAttendeeEmail];
            System.debug(AttendeeContacts );
            for(Contact con : AttendeeContacts){
                if(!emailToContactMap.containsKey(con.email)){
                    emailToContactMap.put(con.email, con.Id);
                }
            }
              System.debug('hi on 161');
                  
            for(RelatedAttendeeListCotroller.AttendeeWrapper atd : AttendeeList.values()){
                System.debug(atd);
                System.debug(emailToContactMap.containsKey(atd.email));
                if(atd.email != null && !emailToContactMap.containsKey(atd.email)){
                    System.debug('hi on 164');
                    Contact newContact = new Contact();
                    newContact.FirstName = atd.firstName;
                    newContact.LastName = atd.LastName;
                    newContact.Email = atd.Email;
                    newContact.Title = atd.positionTitle;
                    newContact.Source__c = 'Event Registration';
                    newContact.Business_Function__c = 'Events';
                    contactsToInsert.add(newContact);
                }
            }
            
            //insert contactsToInsert;
            
            for(Contact insertedcontact : contactsToInsert){
                emailToContactMap.put(insertedcontact.email, insertedcontact.Id);
            }
            
            Integer count = 0;
            List<Event_Registration__c> erv = new List<Event_Registration__c >();
            //Contact notKnownContact  = [Select Id, FirstName, LastName, Company_Name__c, Title From Contact where FirstName = 'NotKnown' And LastName = 'NotKnown' Limit 1];
            for(RelatedAttendeeListCotroller.AttendeeWrapper atdwrap : AttendeeList.values()){
                if(atdwrap.undefined != true){
                    
                    opp.Event_Registrations__r[count].First_Name__c = atdwrap.firstName;
                    opp.Event_Registrations__r[count].Last_Name__c = atdwrap.LastName ;
                    opp.Event_Registrations__r[count].Email__c = atdwrap.email ;
                    opp.Event_Registrations__r[count].Job_title__c = atdwrap.positionTitle;
                    opp.Event_Registrations__r[count].Company__c= atdwrap.company;
                    opp.Event_Registrations__r[count].Dietary_Requirements__c = atdwrap.Dietary_Req ;
                   
                    System.debug('id ='+opp.Event_Registrations__r[count].Id);
                    System.debug(opp.Event_Registrations__r[count]);
                    count++;
                    //erAttendeesToInsert.Add(erAttendee);
                } else{
                    System.debug('hiiiii');
                    opp.Event_Registrations__r[count].First_Name__c = 'Not Known';
                    opp.Event_Registrations__r[count].Last_Name__c = 'Not Known' ;
                    opp.Event_Registrations__r[count].Email__c = null ;
                    opp.Event_Registrations__r[count].Job_title__c =null ;
                    opp.Event_Registrations__r[count].Company__c= null;
                    opp.Event_Registrations__r[count].Dietary_Requirements__c = null ;
                   
                    count++;
                    //erAttendeesToInsert.Add(erAttendee);
                }
            }
            System.debug('erAttendeesToInsert'+ erAttendeesToInsert);
            update opp.Event_Registrations__r;
            System.debug(opp.Event_Registrations__r);
        
        
            //Send Email for confirmation to Invitee
            string templateId = Label.TempId;
            System.debug('templateId'+templateId);
            List<EmailTemplate> lstET = [SELECT Id, Name, DeveloperName, HtmlValue FROM EmailTemplate where DeveloperName = 'EventManagerEventRegUpdateEmail'];
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            List<OrgWideEmailAddress>lstOrgWideEmailAddress =[select id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName='Australian British Chamber of Commerce'];
            if(lstOrgWideEmailAddress.size()>0){
                message.setOrgWideEmailAddressId(lstOrgWideEmailAddress[0].id);
            }
            if(lstET != null && lstET.size() > 0)
            {
                message.setTemplateId(lstET[0].id);
            }
            
            //Create Contact to set what Id for Email.
            Contact con = new Contact();
            con.LastName = 'EmailHelper';
            con.Email = opp.Event__r.Event_Manager__r.Email;
            //con.Business_Function__c = 'Events';
            insert con;
            
            try{
                message.setTargetObjectId(con.Id);
                message.setSaveAsActivity(false);
                message.setWhatId(opp.Id);
                
                if(!Test.isRunningTest()){
                    Messaging.SingleEmailMessage[] mails = new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
                }
            } catch(Exception e) {
                System.debug('Exception1!!' + e);
            } finally{
                delete con;
            }
            
        } catch(Exception e) {
            System.debug('Exception!!' + e);
        }
        
    }
}
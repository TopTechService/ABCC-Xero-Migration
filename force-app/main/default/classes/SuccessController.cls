public class SuccessController {
    public Opportunity opp {get;set;}
    public Id oppId {get;set;}
    public Datetime startdate {get;set;}
    public Datetime enddate {get;set;}
    public String startDateStr {get;set;}
    public String endDateStr {get;set;}
    public String timeZoneStr {get;set;}
    public String eventname {get;set;}
    public String eventlocation {get;set;}
    public Id eventId{get;set;}
    public String transactionId {get;set;}
    public String approvedResponse = 'Approved';
    public String eventWhen {get;set;}
    public String eventWhentime {get;set;}
    public String amounts{get;set;}
    Public final string currencySymbol ='$';
       
    
    public SuccessController(){
        //id abccLogoId = [SELECT Id FROM Document where DeveloperName='ABCC'].Id;
        //abccLogoURL = '/servlet/servlet.FileDownload?file=' + abccLogoId;
        oppId = Id.valueOf(apexPages.currentPage().getParameters().get('oppId'));
        populatedata();
        
    }
    
    public void populatedata(){
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        opp = [Select Id, Event__c, Event__r.Event_Name__c, Event__r.Event_Start_Date__c, Event__r.Event_Start_Time__c, Event__r.Event_Finish_Time__c,Event__r.Timezone__c,  Event__r.Event_End_Date__c,Event__r.Venue__c,
               Event_Package__r.Name,Amount,Primary_Contact__r.MailingStreet, Primary_Contact__r.MailingCity, Primary_Contact__r.MailingState, Primary_Contact__r.MailingPostalCode, Primary_Contact__r.MailingCountry, Ticket_Qty__c,
               Primary_Contact__r.firstName,Primary_Contact__r.lastName,Primary_Contact__r.email,Primary_Contact__r.title,Primary_Contact__r.Company_Name__c,Primary_Contact__r.MobilePhone,Primary_Contact__r.Phone,
               Event__r.Event_Timezone__c,
               (Select Id,First_Name__c,Last_Name__c,Email__c,Job_Title__c,Telphone__c,Company__c,Dietary_Requirements__c from Event_Registrations__r) from Opportunity where Id =:oppId LIMIT 1];
        
        amounts =currencySymbol + String.format(opp.Amount.format(), args);
        System.debug(opp.Amount);
        System.debug(amounts);
        
        List<Card_Transaction__c> transctionList = [SELECT Id, Transaction_ID__c, Transaction_Type__c, Transaction_Status__c  FROM Card_Transaction__c where Opportunity__r.Id =:oppId and Transaction_Type__c = 'SALE' and Transaction_Status__c = 'SUCCESSFUL'];
        if(transctionList != null && transctionList.size() == 1){
            transactionId = transctionList[0].Transaction_ID__c; 
        }       
        List<Venue__c> ve = [select Name, Street_Address_1__c, Street_Address_2__c, City__c, State__c, Country__c  from Venue__c where Id =: opp.Event__r.Venue__c ]; 
        System.debug(ve);
              
        eventId = opp.Event__c;
        System.debug('eventId'+eventId);      
        startdate = opp.Event__r.Event_Start_Time__c;
        startDateStr = opp.Event__r.Event_Start_Time__c.format('MM/dd/yyyy HH:mm');
        System.debug('this is start date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+startdate);
        //System.debug('this is startdateStr>>>>>>>>>>>>>>>>'+startdateStr);
        enddate = opp.Event__r.Event_Finish_Time__c;
        endDateStr = opp.Event__r.Event_Finish_Time__c.format('MM/dd/yyyy HH:mm');
        System.debug('this is start date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+enddate);
        timeZoneStr = opp.Event__r.Event_Timezone__c;
        eventname = opp.Event__r.Event_Name__c;
        System.debug('this is start date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+eventname);
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
        
        //populating When to do : multiple dates 
        if(opp.Event__r.Event_Start_Date__c != null && opp.Event__r.Event_Start_Time__c != null && opp.Event__r.Event_Finish_Time__c != null) 
        {
            DateTime dt=DateTime.newInstance(opp.Event__r.Event_Start_date__c, Time.newInstance(0, 0, 0, 0));
            String monthString = eventdetailController.getMonthNameFromNumber(dt.Month());
            
            this.eventWhen = dt.format('EEEE') +' '+ dt.Day()+ ' ' +monthString + ' ' + dt.Year();
            this.eventWhentime = String.valueOf(opp.Event__r.Event_Start_Time__c.format('h:mm a')) + ' - ' +
                String.valueOf(opp.Event__r.Event_Finish_Time__c.format('h:mm a')) ;
            if(opp.Event__r.Event_Timezone__c != null){
                this.eventWhentime = this.eventWhentime + ' ' + opp.Event__r.Event_Timezone__c;
            }
            
            if(opp.Event__r.Event_Start_Time__c.date() != opp.Event__r.Event_Finish_Time__c.date()){
                DateTime enddt=DateTime.newInstance(opp.Event__r.Event_Finish_Time__c.date(), Time.newInstance(0, 0, 0, 0));
                String endMonthString = eventdetailController.getMonthNameFromNumber(enddt.Month());
                this.eventWhen = this.eventWhen + ' - '+ enddt.format('EEEE') +' '+enddt.Day()+' ' + endMonthString +' '+ enddt.Year();
            }
        }
    }

}
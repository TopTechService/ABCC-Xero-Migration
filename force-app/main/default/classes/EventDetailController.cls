/*
  Description : controller for page, EventDetail
  
  Change Log: 
  June 15th 2017, initial version created. 
*/
public without sharing class EventDetailController extends PageControllerBase {
    Public Event__c objEvent {get;set;} 
    public Event eventDetail {get;set;} 
    public List<SelectOption> lstAvailalbePurchaseType {Get;set;} 
    public List<SelectOption> lstQunaity {get;set;} 
    Public String PurchaseType {get;set;} 
    public List<earlyBirdRow> lstEarlyBirdRows {get;set;} 
    public set<String> setHeader{get;set;}
    public RelatedAttendeeListCotroller myComponentController { get; set; }
    Public List<struct_Sponsor> lstEventSp {get;set;}
    Public Boolean IsGroupDiscountVisible {get;set;} 
    Public Boolean IsMember {get;set;} 
    public Boolean EventEndDateCheck {get;set;}
    Public TempClass objTempClass;
    
    Public void setobjTempClass(TempClass Value){
        objTempClass = Value;
    }   
        
    Public TempClass getobjTempClass(){
        TempClass objTempClass = new TempClass(); 
        List<RelatedAttendeeListCotroller.AttendeeWrapper> lstAtt = new List<RelatedAttendeeListCotroller.AttendeeWrapper>(); 
        RelatedAttendeeListCotroller.AttendeeWrapper objWrap = new RelatedAttendeeListCotroller.AttendeeWrapper(); 
        objWrap.Firstname = 'Sfsdfsdf'; 
        objWrap.lastname = 'sfdsdfsdf';
        objwrap.email = 'sdfsdfsd@sdfsdfsd.com';
        objwrap.phone ='232323';
        lstAtt.add(objWrap); 
        objTempClass.lstAttendeeWrapper =lstAtt;
        return objTempClass;
    }
  
    public Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper> AttendeeList {get;set;}
    
    
    Public final string currencySymbol ='$';
    
    public EventDetailController(){ 
        Id eventId = apexpages.currentpage().getparameters().get('id');
        objEvent = [select Id,Name,Event_Type__C,Free_Event__c,Total_number_of_Seats__c,Total_No_of_Attendees__c,Event_Name__c,Event_Start_Date__c, Event_Start_Time__c,Timezone__c,Event_End_Date__c, Event_Finish_Time__c, Event_Description_HTML__c,venue__c,Rego_Deadline_Date_Time__c from Event__c where Id=:eventId limit 1];
        if(objEvent.Rego_Deadline_Date_Time__c == null || objEvent.Rego_Deadline_Date_Time__c.Date() >= system.today()){
            EventEndDateCheck = True;
        }else{
            EventEndDateCheck  = False;
        }
/*        
        if(objIn == null) 
        {
            objIn  = new inviteeDetail();
        }
*/       
       eventDetail  = new  Event(objEvent);
       setHeader = new set<String>();
        
       AttendeeList = new Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper>();
       
       lstAvailalbePurchaseType  = populatePurchaseType(objEvent); 
       IsMember = true;
       lstQunaity = populateQuanity(); 
       lstEarlyBirdRows = populateEarlyBirdRows();
       IsGroupDiscountVisible  = false;
//       lstGroupDiscountRows  = new List<GroupDiscountRow>();  
       lstEventSp  =  populateSponsor(eventId);
    }
    
    Public List<struct_Sponsor> populateSponsor(Id eventId){
                
        List<struct_Sponsor> sponsorImageURL = new List<struct_Sponsor>();
        Map<id, Event_Sponsor__c> sponsorMap = new Map<Id, Event_Sponsor__c>([SELECT ID, Name, Sponsor_URL__c FROM Event_Sponsor__c WHERE Event__c = :EventId]);
        system.debug('MapEmpty: '+sponsorMap.isEmpty());
        if(!sponsorMap.isEmpty()){
            
            set<id> mySponsorIds = new set<id>();
            mySponsorIds = sponsorMap.KeySet();
            
            Map<Id, Id> mapFileToSponsor = new Map<Id, Id>();
            List<ContentDocumentLink> listDocoID = new List<ContentDocumentLink>([SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :mySponsorIds]);
            For(ContentDocumentLink objDocoLink : listDocoID){
                mapFileToSponsor.put(objDocoLink.ContentDocumentId, objDocoLink.LinkedEntityId);
            }
            
            set<Id> setDocoIDs = new set<Id>();
            setDocoIDs = mapFileToSponsor.KeySet();
            Map<Id, ContentDistribution> urlMap = new Map<Id, ContentDistribution>([SELECT DistributionPublicUrl, ContentVersionId, ContentDocumentId FROM ContentDistribution WHERE ContentDocumentID IN :setDocoIDs]);
            for( Id objURL : urlMap.KeySet() ){
                struct_Sponsor objSp = new Struct_Sponsor();
                objSp.URL = sponsorMap.get(mapFileToSponsor.get(urlMap.get(objURL).ContentDocumentId)).Sponsor_URL__c;
                objSp.imageURL = urlBuilder(urlMap.get(objURL).DistributionPublicUrl, urlMap.get(objURL).ContentVersionId, urlMap.get(objURL).ContentDocumentId);
                String strSponsorUrl = sponsorMap.get(mapFileToSponsor.get(urlMap.get(objURL).ContentDocumentId)).Sponsor_URL__c;
                SponsorImageURL.add(objSp);
            }
        }
        return SponsorImageURL;
    }
    
    public override void setComponentController(ComponentControllerBase compController) {
       myComponentController = (RelatedAttendeeListCotroller)compController;
    }
    
    public override ComponentControllerBase getMyComponentController() {
        return myComponentController;
    }
/*    
    public void initializeAttendees() {
       myComponentController.populateAttenddes(AttendeeList);
    }
*/    
    Public List<SelectOption> populatePurchaseType(Event__c objEvent) {
        List<SelectOption> lstResult = new List<SelectOption>(); 
        
        lstResult.add(new SelectOption('Table','Table')); 
        lstResult.add(new SelectOption('Single Ticket','SingleTicket')); 
        
        
        return lstResult;
    }
    public list<SelectOption> populateQuanity() {
        List<SelectOption> lstResult = new List<SelectOption>(); 
        
        for(Integer i=1;i<11;i++)
        {
            lstResult.add(new SelectOption(String.Valueof(i),String.Valueof(i)));
        }
        
        return lstResult;
    }
/*    
    Public void CalcluateCost() {
        List<Discount__c> lstTableDiscount = new List<Discount__c>(); 
        Discount__c objApplicableDiscount = new Discount__c(); 
        if(PurchaseType == 'Single Ticket')
        {
            lstTableDiscount = [select Id,Name,Table_Quantity__c,Price__c,Number_of_Delegates__c,Fixed_price_Discount__c
                                 from Discount__c 
                                 where RecordType.Name='Group' and 
                                 Event__c =:objEvent.Id order by Table_Quantity__c asc ];
            for(Discount__c objDis : lstTableDiscount )
             {
                 if(objIn.selectedPurchaseQuantity >= objDis.Number_of_Delegates__c) 
                 {
                     objApplicableDiscount = objDis;
                 }
             }
        }
              
         if(PurchaseType == 'Table') 
         {
             
            lstTableDiscount = [select Id,Name,Table_Quantity__c,Price__c,Fixed_price_Discount__c from Discount__c where RecordType.Name='Table' and Event__c =:objEvent.Id order by Table_Quantity__c asc ];             
             for(Discount__c objDis : lstTableDiscount )
             {
                 if(objIn.selectedPurchaseQuantity >= objDis.Table_Quantity__c) 
                 {
                     objApplicableDiscount = objDis;
                 }
             }
         }
         
         try
         {
             if(objApplicableDiscount != null )
             objIn.currentPriceOfPurchase = currencySymbol +  String.Valueof( ( Decimal.Valueof(UnitPrice.replace('$','')) * objIn.selectedPurchaseQuantity ) - (objApplicableDiscount.Fixed_price_Discount__c));
//             lstGroupDiscountRows = populateGroupDiscount(PurchaseType);
         } Catch(Exception ae)
         {
         }
    }
*/
/*    
    public void searchbasedOnEmail() {
        List<Contact> inviteeCon = [Select Membership_Status__c from Contact where email =:objIn.Email];
        if(!inviteeCon.isEmpty() && inviteeCon.size() == 1){
            objIn.membershipStatus = inviteeCon[0].Membership_Status__c;
        }
    }
*/    
/*    
    Public List<GroupDiscountRow> populateGroupDiscount(string TicketType) {
           IsGroupDiscountVisible =true;
           List<GroupDiscountRow> lstResult = new List<GroupDiscountRow>(); 
           List<Discount__c> lstTableDiscount  = new List<Discount__c>(); 
           
           if(TicketType=='Table') 
           {
              lstTableDiscount = [select Id,Name,Table_Quantity__c,Price__c,Fixed_price_Discount__c 
                                          from Discount__c 
                                          where 
                                          RecordType.Name='Table' and 
                                          Event__c =:objEvent.Id order by Table_Quantity__c asc ];                 
                             
           }
           if(TicketType == 'Single Ticket')
           {
               lstTableDiscount = [select Id,Name,Table_Quantity__c,Price__c,Fixed_price_Discount__c,Number_of_Delegates__c 
                                          from Discount__c 
                                          where 
                                          RecordType.Name='Group' and 
                                          Event__c =:objEvent.Id order by Table_Quantity__c asc ];                 
           }
           return lstResult;
    } 
*/
    Public List<earlyBirdRow> populateEarlyBirdRows() {
        List<earlyBirdRow> lstResult = new List<earlyBirdRow>(); 
//        List<Discount__c> lstDiscount = [select Id,Name,Before_Date__c,Price__c,Event_package__c,(select Id,Event_Package__C,Member_Price__c,Non_Member_Price__C from Early_Bird_Package_Details__r)   from Discount__c where RecordType.Name = 'Early Bird' and Event__c=:objEvent.Id];
        List<Event_Package__C> lstEventPackage = [select Id,name,Member_Price__c,Standard_Price__c,Type__c  from Event_Package__c where Event__C=:objEvent.Id and active__c=true Order By name ASC];
        List<String> args = new String[]{'0','number','###,###,##0.00'};
/*            for(Discount__c objDisc : lstDiscount)
            {
                setHeader.add('Before </br>'+string.Valueof(objDisc.Before_date__c));
            }
*/        
        for(Event_package__c objEventPackage : lstEventPackage) 
        {
            earlyBirdRow objRow = new earlyBirdRow(); 
            objRow.packageName = objEventPackage.Name; 
            
            List<earlyDatePrice> lstTemp  = new List<earlyDatePrice>(); 
/*            for(Discount__c objDisc : lstDiscount)
            {
                earlyDatePrice objEarlyDate = new earlyDatePrice(); 
                for(Early_Bird_Package_Detail__c objEPD : objDisc.Early_Bird_Package_Details__r ) 
                {
                    
                    objEarlyDate.dtDate = objDisc.Before_date__c;
                   if(objEPD.Event_package__c == objEventPackage.Id) {
                        if(isMember){
                            System.debug(objEPD.Member_Price__c);
                            System.debug(objEarlyDate.discountedPrice);
                        } else{    
                            objEarlyDate.discountedPrice = currencySymbol +String.format(objEPD .Non_Member_Price__c.format(), args);
                        }
                    }
                    
                    //calculation of IsValid 
                    
                    if(objDisc.Before_Date__c < Date.Today()) 
                    objEarlyDate.IsValid = false; 
                    else
                    objEarlyDate.IsValid = true; 
                    
                }
                
                              
                lstTemp.add(objEarlyDate); 
            }
*/            
            //------- adding stadnard price ------------
            earlyDatePrice objEarlyDateStdPrice = new earlyDatePrice();    
            if(IsMember)      
            objEarlyDateStdPrice .discountedPrice =currencySymbol + String.format(objEventPackage.Member_Price__c.format(), args);
            else
            objEarlyDateStdPrice .discountedPrice =currencySymbol + String.format(objEventPackage.Standard_Price__c.format(), args);
            
            objEarlyDateStdPrice .discountedPriceNonMember =currencySymbol + String.format(objEventPackage.Standard_Price__c.format(), args) ;
            objEarlyDateStdPrice .TicketType = objEventPackage.Type__c;
            lstTemp.add(objEarlyDateStdPrice ); 
            //------- end of adding standard price -------
            
            objRow.lstEarlyDatePrice = lstTemp; 
            lstResult.add(objRow); 
        }
        return lstResult;
    }
    
    Public Static String urlBuilder(String DistributionPublicUrl, Id ContentVersionId, Id ContentDocumentId){
        String orgId = UserInfo.getOrganizationId();
        String orgDomain = URL.getSalesforceBaseUrl().getHost();
        String orgURL = orgDomain.replace('visual','document');

		String customDomainName = 'https://britishchamber--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=';        
//SB	String customDomainName = 'https://britishchamber--partial--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=';        
        if(!string.isBlank(DistributionPublicUrl)){
            Integer index = DistributionPublicUrl.IndexOf('/a/',0);
            String strSubString = DistributionPublicUrl.substring(index);
            customDomainName = customDomainName + ContentVersionId + '&operationContext=DELIVERY&contentId=' + ContentDocumentId + '&page=0&d=';
            customDomainName = customDomainName + strSubString + '&oid=' + orgId + '&dpt=null&viewId=';
            system.debug('customDomainName: '+customDomainName);
                } else {
                    customDomainName = 'https://britishchamber--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0686F00000T4lY0&operationContext=DELIVERY&contentId=05T6F00001IZvCn&page=0&d=/a/6F000000RIci/IhFWU9tBs40vxQIcgH2NpChjG0hl2tN2GDCvLcYfnCk&oid=00D90000000i66s&dpt=null&viewId=';
                }
                return customDomainName;
    }
        
    public static string getMonthNameFromNumber(Integer monthNumber) {
        string monthString;
        if(monthNumber == 1) {
            monthString = 'January';
        } else if(monthNumber == 2) {
            monthString = 'February';
        }else if(monthNumber == 3) {
            monthString = 'March';
        }else if(monthNumber == 4) {
            monthString = 'April';
        }else if(monthNumber == 5) {
            monthString = 'May';
        }else if(monthNumber == 6) {
            monthString = 'June';
        }else if(monthNumber == 7) {
            monthString = 'July';
        }else if(monthNumber == 8) {
            monthString = 'August';
        }else if(monthNumber == 9) {
            monthString = 'September';
        }else if(monthNumber == 10) {
            monthString = 'October';
        }else if(monthNumber == 11) {
            monthString = 'November';
        }else if(monthNumber == 12) {
            monthString = 'December';
        }else {
            monthString = '';
        }
        
        return monthString;
    }

    //class level 
    
/*    Public class GroupDiscountRow {
        Public Integer count {get;set;} 
        public Decimal FixedDiscount {get;set;} 
        Public Decimal progressBarWidth {get;set;} 
    } */
    Public class earlyBirdRow {
        public string packageName { get;set;} 
        public List<earlyDatePrice> lstEarlyDatePrice {get;set;} 
        Public Decimal standardPrice {get;set;} 
        public Decimal selectedPackageId {get;set;} 
        Public Decimal selectedPrice {get;set;} 
    }
    public class earlyDatePrice {
        public Date dtDate {get;set;} 
        public String strDate { get;set;} 
        public String discountedPrice {get;set;}
        public String discountedPriceNonMember{get;set;}
        Public String TicketType {get;set;} 
    }
    public class struct_Sponsor {
        Public string URL {get;set;} 
        Public string ImageURL {get;set;} 
    }
    Public class Event {
        public string eventName { get;set;} 
        public string eventWhen {get;set;}
        public string eventWhenTime {get;set;}
        public string eventTimeZone {get;set;}
        public string eventWhere {get;set;}
        
        public string customDomainName {get;set;}
        
        public List<String> speakerImageURLs{get;set;}
        public string sponsorImageURL {get;set;} 
        public string sponsorURL {get;set;}
        public string eventAddress { get;set;} 
        public string EventDescriptionHTML {get;set;}
        public string eventType {get;set;}
        
        //addrees properties. 
        public string venueName { get;set;}
        public string streetAddress1 { get;set;} 
        public string streetAddress2 {get;set;} 
        public string city {get;set;} 
        public string city1 {get;set;} 
        public string postalCode {get;set;} 
        public string State {get;set;} 
        public string mapToVenue {get;set;} 
        
        public  Event(Event__c objEvent) {
            //Fetchning all data 
            set<Id> stAllSpeakerIds = new set<Id>(); 
            List<Speaker__c> lstSpeaker = [select Id,Name,Speaker_Contact__c from Speaker__C where Event__c=:objEvent.Id];
            String temp;
            for(Speaker__c objSpeaker : lstSpeaker){
                stAllSpeakerIds.add(objSpeaker .Speaker_Contact__c );
            }
            
            //Code added by Dan, 6/3/2020
            //
            Set<id> setDocumentIds = new set<id>();
            if(stAllSpeakerIds != null && stAllSpeakerIds.size() > 0){
                List<ContentDocumentLink> ListHeadshotLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :stAllSpeakerIds];
                if(!ListHeadshotLinks.isEmpty()){
                    for(ContentDocumentLink objDocoLink : ListHeadshotLinks){
                        setDocumentIds.add(objDocoLink .ContentDocumentId);                    
	                }
                } Else {
                        List<ContentDocumentLink> ListEventImageLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :objEvent.Id];
                        for(ContentDocumentLink objEventImageLink : ListEventImageLinks){
                            setDocumentIds.add(objEventImageLink .ContentDocumentId);
		                }
                }
            } Else {
                List<ContentDocumentLink> ListHeadshotLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :objEvent.Id];
                for(ContentDocumentLink objDocoLink : ListHeadshotLinks){
                    setDocumentIds.add(objDocoLink .ContentDocumentId);
                }
            }
            
            List<ContentDistribution> listPublicURLs = [SELECT DistributionPublicUrl, ContentVersionId, ContentDocumentId FROM ContentDistribution WHERE ContentDocumentID IN :setDocumentIds];

            speakerImageURLs = new List<String>();
            for(ContentDistribution preview : listPublicURLs){
                String customDomainName = urlBuilder(preview.DistributionPublicUrl, preview.ContentVersionId, preview.ContentDocumentId);
                if(customDomainName == 'https://britishchamber--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0686F00000T4lY0&operationContext=DELIVERY&contentId=05T6F00001IZvCn&page=0&d=/a/6F000000RIci/IhFWU9tBs40vxQIcgH2NpChjG0hl2tN2GDCvLcYfnCk&oid=00D90000000i66s&dpt=null&viewId='){
                    customDomainName = 'https://britishchamber--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=0686F00000T4ldo&operationContext=DELIVERY&contentId=05T6F00001IZvWx&page=0&d=/a/6F000000RIcs/R3n8s.YpFCYoyTAp5mvfbnaTuZC8mHWIFtbeYUgptgY&oid=00D90000000i66s&dpt=null&viewId=';
                }
                speakerImageURLs.add(customDomainName);
            }
system.debug('list urls: '+speakerImageURLs);            

            Venue__c  objVenueDate = [select Id,Name,Street_Address_1__c,Map_to_Venue__c,
                                                        Street_Address_2__c,City__c,
                                                         Postal_Code_Zip__c,State__C from Venue__c   where id = :objEvent.venue__c];
            city1 = objVenueDate.City__c+', ';            
            this.eventName = objEvent.Event_Name__C; 
            this.EventDescriptionHTML  = objEvent.Event_Description_HTML__c ;
            this.eventType = objEvent.Event_Type__c;            
                        
            //populating When to do : multiple dates 
            if(objEvent.Event_Start_Date__c != null && objEvent.Event_Start_Time__c != null && objEvent.Event_Finish_Time__c != null) 
            {
                DateTime dt=DateTime.newInstance(objEvent.Event_Start_date__c, Time.newInstance(0, 0, 0, 0));
                String monthString = getMonthNameFromNumber(dt.Month());
              
                this.eventWhen = dt.format('EEEE') +' '+ dt.Day()+ ' ' +monthString + ' ' + dt.Year();
                this.eventWhentime = String.valueOf(objEvent.Event_Start_Time__c.format('h:mm a')) + ' - ' +
                   String.valueOf(objEvent.Event_Finish_Time__c.format('h:mm a'));
                if(objEvent.Event_Start_Time__c.date() != objEvent.Event_Finish_Time__c.date()){
                    DateTime enddt=DateTime.newInstance(objEvent.Event_Finish_Time__c.date(), Time.newInstance(0, 0, 0, 0));
                    String endMonthString = getMonthNameFromNumber(enddt.Month());
                    this.eventWhen = this.eventWhen + ' - '+ enddt.format('EEEE') +' '+enddt.Day()+' ' + endMonthString +' '+ enddt.Year();
                }
                this.eventTimeZone = objEvent.Timezone__c;
            }
            
            //populating Where 
            if(objVenueDate  != null) 
            {
                this.venueName = objVenueDate.Name;
                this.streetAddress1 = objVenueDate.Street_Address_1__c; 
                this.streetAddress2 = objVenueDate.Street_Address_2__c; 
                if(objVenueDate.City__c != null){
                    this.city = objVenueDate.City__c;
                }
                this.PostalCode = objVenueDate.Postal_Code_Zip__C;
                this.State = objVenueDate.State__c;
                this.mapToVenue = objVenueDate.Map_to_Venue__c;
                
                
            }
           
        }
    }
}
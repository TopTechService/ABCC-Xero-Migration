public class UserPreferencePageController {

//    public Boolean checkboolean { get; set; }
    
    public String[] selectedMonthly {get;set;} //Q1
    public String[] selectedTypeEvents {get;set;} //Q4
    public String[] selectedEventFormats {get;set;} //Q2
    public String[] selectedIndusType {get;set;} //Q3
    public String cid; //Contact Id

    List<Contact> lstContacts = new List<Contact>();
    
    Public UserPreferencePageController(){
        selectedTypeEvents = new String[]{};
        selectedMonthly = new String[]{};
        selectedEventFormats = new String[]{};
        selectedIndusType = new String[]{};

        this.cid = ApexPages.currentPage().getParameters().get('id');
        
        System.debug('Contact Id:'+this.cid);
        
        lstContacts = [select Id,Brexit__c,Trade__c,Digital_Cyber__c,Private_Boardroom_Events__c,Cocktail_Evenings__c,
                       Energy_Resources__c,Seminars__c,Business_Lunches__c,Wine_Tastings__c,Whisky_Tastings__c,
                       Gin_Tastings__c,Business_Breakfasts__c,Online_Sessions_business_hours__c,International_Delegations__c,
                       Online_Sessions_evening__c,Evening_Networking__c, Sports_Events__c, Infrastructure__c,Agriculture__c,Technology__c,
                       Financial_Services__c, Gov_Affairs_Policy__c, Resources__c, Education__c,Fintech__c,Human_Resources__c, 
                       Defence__c, Health__c, Tourism__c, Retail__c,Fortnightly_Upcoming_Events_weekly_duri__c,
                       Member_Offers_DNS__c,Monthly_Newsletters_weekly_during_COVID__c,FTA_Brexit_Updates__c,Event_Webinar_Invites__c,
                       TAS__c,NT__c,ACT__c,NSW_Member__c,QLD_Member__c,SA_Member__c,VIC_Member__c,WA_Member__c,Anything_Unsubscribe_All__c
                       from Contact where Id = : this.cid limit 1];
        
        System.debug('Contact:'+lstContacts);
        
        prePopulateDontSendMe();
        prePopulateEventFormats();
        prePopulateIndustryType();
        prePopulateTypeOfEvents();
    }
    
    public List<SelectOption> getTypeOfEvents() {
        List<Selectoption> result = new List<Selectoption>();
        result.add(new selectOption('ACT','ACT'));
        result.add(new selectOption('NSW','NSW'));
        result.add(new selectOption('NT','NT'));
        result.add(new selectOption('QLD','QLD'));
        result.add(new selectOption('SA','SA'));
        result.add(new selectOption('TAS','TAS'));
        result.add(new selectOption('VIC','VIC'));
        result.add(new selectOption('WA','WA'));
        return result;
    }
    
    public List<SelectOption> getMontlyNews() {
        List<Selectoption> result = new List<Selectoption>();
        result.add(new selectOption('Fortnightly Upcoming Events (weekly during COVID)','Fortnightly Upcoming Events (weekly during COVID)'));
        result.add(new selectOption('Member Offers','Member Offers'));
        result.add(new selectOption('Monthly Newsletters (weekly during COVID)','Monthly Newsletters (weekly during COVID)'));
        result.add(new selectOption('FTA/Brexit Updates','FTA/Brexit Updates'));
        result.add(new selectOption('Event/Webinar Invites','Event/Webinar Invites'));
        result.add(new selectOption('Anything (Unsubscribe All)','Anything (Unsubscribe All)'));
        
        return result;
    }

    public List<SelectOption> getEventFormats(){
        List<SelectOption> result = new List<SelectOption>();
        result.add(new selectOption('Business Breakfasts','Business Breakfasts'));
        result.add(new selectOption('Business Lunches','Business Lunches'));
        result.add(new selectOption('Seminars and Briefings','Seminars and Briefings'));
        result.add(new selectOption('Private Boardroom Events','Private Boardroom Events'));
        result.add(new selectOption('Cocktail Evenings','Cocktail Evenings'));
        result.add(new selectOption('Sports Lunches','Sports Lunches'));
        result.add(new selectOption('Evening Networking','Evening Networking'));
        result.add(new selectOption('Wine Tastings','Wine Tastings'));
        result.add(new selectOption('Whisky Tastings','Whisky Tastings'));
        result.add(new selectOption('Gin Tastings','Gin Tastings'));
        result.add(new selectOption('Online Sessions (business hours)','Online Sessions (business hours)'));
        result.add(new selectOption('Online Sessions (evening)','Online Sessions (evening)'));
        result.add(new selectOption('International Delegations','International Delegations'));
        return result;
    }
    
    public List<SelectOption> getIndustryType() {
        List<Selectoption> result = new List<Selectoption>();
        result.add(new selectoption('Agriculture','Agriculture'));
        result.add(new selectoption('Brexit and UK/Australia FTA','Brexit and UK/Australia FTA'));
        result.add(new selectoption('Digital/Cyber','Digital/Cyber'));
        result.add(new selectoption('Defence','Defence'));
        result.add(new selectoption('Education','Education'));
        result.add(new selectoption('Energy & Renewables','Energy & Renewables'));
        result.add(new selectoption('Fintech','Fintech'));
        result.add(new selectoption('Financial Services - Banking','Financial Services - Banking'));
        result.add(new selectoption('Gov Affairs & Policy','Gov Affairs & Policy'));
        result.add(new selectoption('Health','Health'));
        result.add(new selectoption('Human Resources','Human Resources'));
        result.add(new selectoption('Infrastructure','Infrastructure'));
        result.add(new selectoption('Resources','Resources'));
        result.add(new selectoption('Retail','Retail'));
        result.add(new selectoption('Technology','Technology'));
        result.add(new selectoption('Tourism','Tourism'));
        result.add(new selectoption('Trade','Trade'));
        
        return result;
    }
    
    @TestVisible private void prePopulateDontSendMe(){
        if(!lstContacts.isEmpty()){
            if(lstContacts[0].Fortnightly_Upcoming_Events_weekly_duri__c){
                selectedMonthly.add('Fortnightly Upcoming Events (weekly during COVID)');
            }
            if(lstContacts[0].Member_Offers_DNS__c){
                selectedMonthly.add('Member Offers');
            }
            if(lstContacts[0].Monthly_Newsletters_weekly_during_COVID__c){
                selectedMonthly.add('Monthly Newsletters (weekly during COVID)');
            }
            if(lstContacts[0].FTA_Brexit_Updates__c){
                selectedMonthly.add('FTA/Brexit Updates');
            }
            if(lstContacts[0].Event_Webinar_Invites__c){
                selectedMonthly.add('Event/Webinar Invites');
            }
            if(lstContacts[0].Anything_Unsubscribe_All__c){
                selectedMonthly.add('Anything (Unsubscribe All)');
            }
        }
    }
    
    @TestVisible private void prePopulateEventFormats(){
        if(!lstContacts.isEmpty()){
            if(lstContacts[0].Business_Breakfasts__c){
                selectedEventFormats.add('Business Breakfasts');
            }
            if(lstContacts[0].Business_Lunches__c){
                selectedEventFormats.add('Business Lunches');
            }
            if(lstContacts[0].Seminars__c){
                selectedEventFormats.add('Seminars and Briefings');
            }
            if(lstContacts[0].Private_Boardroom_Events__c){
                selectedEventFormats.add('Private Boardroom Events');
            }
            if(lstContacts[0].Cocktail_Evenings__c){
                selectedEventFormats.add('Cocktail Evenings');
            }
            if(lstContacts[0].Sports_Events__c){
                selectedEventFormats.add('Sports Lunches');
            }
            if(lstContacts[0].Evening_Networking__c){
                selectedEventFormats.add('Evening Networking');
            }
            if(lstContacts[0].Wine_Tastings__c){
                selectedEventFormats.add('Wine Tastings');
            }
            if(lstContacts[0].Whisky_Tastings__c){
                selectedEventFormats.add('Whisky Tastings');
            }
            if(lstContacts[0].Gin_Tastings__c){
                selectedEventFormats.add('Gin Tastings');
            }
            if(lstContacts[0].Online_Sessions_business_hours__c){
                selectedEventFormats.add('Online Sessions (business hours)');
            }
            if(lstContacts[0].Online_Sessions_evening__c){
                selectedEventFormats.add('Online Sessions (evening)');
            }
            if(lstContacts[0].International_Delegations__c){
                selectedEventFormats.add('International Delegations');
            }
        }
    }

    @TestVisible private void prePopulateIndustryType(){
        if(!lstContacts.isEmpty()){
            if(lstContacts[0].Agriculture__c ){
                selectedIndusType.add('Agriculture');
            }             
            if(lstContacts[0].Brexit__c){
                selectedIndusType.add('Brexit and UK/Australia FTA');
            }
            if(lstContacts[0].Digital_Cyber__c){
                selectedIndusType.add('Digital/Cyber');
            }
            if(lstContacts[0].Defence__c){
                selectedIndusType.add('Defence');
            }
            if(lstContacts[0].Education__c){
                selectedIndusType.add('Education');
            }
            if(lstContacts[0].Energy_Resources__c){
                selectedIndusType.add('Energy & Renewables');
            }
            if(lstContacts[0].Fintech__c){
                selectedIndusType.add('Fintech');
            }
            if(lstContacts[0].Financial_Services__c){
                selectedIndusType.add('Financial Services - Banking');
            }
            if(lstContacts[0].Gov_Affairs_Policy__c){
                selectedIndusType.add('Gov Affairs & Policy');
            }
            if(lstContacts[0].Health__c)
            {
                selectedIndusType.add('Health');
            }
            if(lstContacts[0].Human_Resources__c)
            {
                selectedIndusType.add('Human Resources');
            }
            if(lstContacts[0].Infrastructure__c ){
                selectedIndusType.add('Infrastructure');
            }
            if(lstContacts[0].Resources__c){
                selectedIndusType.add('Resources');
            }
            if(lstContacts[0].Retail__c){
                selectedIndusType.add('Retail');
            }
            if(lstContacts[0].Technology__c){
                selectedIndusType.add('Technology');
            }
            if(lstContacts[0].Tourism__c){
                selectedIndusType.add('Tourism');
            }
            if(lstContacts[0].Trade__c){
                selectedIndusType.add('Trade');
            }
        }
    }

    @TestVisible private void prePopulateTypeOfEvents(){
        if(!lstContacts.isEmpty()){
            if(lstContacts[0].ACT__c){
                selectedTypeEvents.add('ACT');
            }
            if(lstContacts[0].NSW_Member__c){
                selectedTypeEvents.add('NSW');
            }
            if(lstContacts[0].NT__c){
                selectedTypeEvents.add('NT');
            }
            if(lstContacts[0].QLD_Member__c){
                selectedTypeEvents.add('QLD');
            }
            if(lstContacts[0].SA_Member__c){
                selectedTypeEvents.add('SA');
            }
            if(lstContacts[0].TAS__c){
                selectedTypeEvents.add('TAS');
            }
            if(lstContacts[0].VIC_Member__c){
                selectedTypeEvents.add('VIC');
            }
            if(lstContacts[0].WA_Member__c){
                selectedTypeEvents.add('WA');
            }
        }
    }

    public PageReference submitResponses(){
        
        String selectedDoNotSend = '';
        for(String str : selectedMonthly){
            selectedDoNotSend += str + ';';
        }
        selectedDoNotSend = selectedDoNotSend.removeEnd(';');
        
        boolean Upcoming = (selectedDoNotSend.contains('Fortnightly Upcoming Events (weekly during COVID)')) ? true: false;
        boolean Offers = (selectedDoNotSend.contains('Member Offers')) ? true: false;
        boolean Newsletters = (selectedDoNotSend.contains('Monthly Newsletters (weekly during COVID)')) ? true: false;
        boolean FTA = (selectedDoNotSend.contains('FTA/Brexit Updates')) ? true: false;
        boolean EventWebinar = (selectedDoNotSend.contains('Event/Webinar Invites')) ? true: false;
        boolean Anything = (selectedDoNotSend.contains('Anything (Unsubscribe All)')) ? true: false;


        String otherStates = '';
        for(String str : selectedTypeEvents){
            system.debug('selectedTypeEvent: ' +str);
            otherStates += str + ';';
        }
        otherStates = otherStates.removeEnd(';');
        system.debug('otherStates: '+otherStates);
        
        boolean act = (otherStates.contains('ACT')) ? true: false;
        boolean nsw = (otherStates.contains('NSW')) ? true: false;
        boolean nt = (otherStates.contains('NT')) ? true: false;
        boolean qld = (otherStates.contains('QLD')) ? true: false;
        boolean sa = (otherStates.contains('SA')) ? true: false;
        boolean tas = (otherStates.contains('TAS')) ? true: false;
        boolean vic = (otherStates.contains('VIC')) ? true: false;
        boolean wa = (otherStates.contains('WA')) ? true: false;

        
        String selectedIndustryType = '';
        for(String str : selectedIndusType) {
            selectedIndustryType += str + ';';
        }
        selectedIndustryType = selectedIndustryType.removeEnd(';');
        if(EventWebinar){
            selectedIndustryType = '';
        }
        
        boolean Agriculture = (selectedIndustryType.contains('Agriculture')) ? true: false;
        boolean Brexit = (selectedIndustryType.contains('Brexit and UK/Australia FTA')) ? true: false;
        boolean DigitalandCyber = (selectedIndustryType.contains('Digital/Cyber')) ? true: false;
        boolean Defence = (selectedIndustryType.contains('Defence')) ? true: false;
        boolean Education= (selectedIndustryType.contains('Education')) ? true: false;
        boolean EnergyandResources = (selectedIndustryType.contains('Energy & Renewables')) ? true: false;
        boolean Fintech = (selectedIndustryType.contains('Fintech')) ? true: false;
        boolean FinancialServicesBanking = (selectedIndustryType.contains('Financial Services - Banking')) ? true: false;
        boolean GovernmentAffairsPolicy = (selectedIndustryType.contains('Gov Affairs & Policy')) ? true: false;
        boolean Health = (selectedIndustryType.contains('Health')) ? true: false;
        boolean HR = (selectedIndustryType.contains('Human Resources')) ? true: false;
        boolean Infrastructures = (selectedIndustryType.contains('Infrastructure')) ? true: false;
        boolean Resources = (selectedIndustryType.contains('Resources')) ? true: false;
        boolean Retail = (selectedIndustryType.contains('Retail')) ? true: false;
        boolean Technology = (selectedIndustryType.contains('Technology')) ? true: false;
        boolean Tourism = (selectedIndustryType.contains('Tourism')) ? true: false;
        boolean Trade = (selectedIndustryType.contains('Trade')) ? true: false;
        
        
        string invitationToEvent = '';
        for(string str : selectedEventFormats){
            invitationToEvent += str + ';';
        }
        invitationToEvent = invitationToEvent.removeEnd(';');
        if(EventWebinar){
             invitationToEvent = '';
        }
      
        boolean BusinessBreakfasts = (invitationToEvent.contains('Business Breakfasts')) ? true: false;
        boolean BusinessLunches = (invitationToEvent.contains('Business Lunches')) ? true: false;
        boolean Seminars = (invitationToEvent .contains('Seminars and Briefings')) ? true: false;
        boolean Boardroom = (invitationToEvent.contains('Private Boardroom Events')) ? true: false;
        boolean Cocktail = (invitationToEvent.contains('Cocktail Evenings')) ? true: false;
        boolean SportsLunches = (invitationToEvent.contains('Sports Lunches')) ? true: false;
        boolean EveningNetworking = (invitationToEvent.contains('Evening Networking')) ? true: false;
        boolean Wine = (invitationToEvent.contains('Wine Tasting')) ? true: false;
        boolean Whisky = (invitationToEvent.contains('Whisky Tasting')) ? true: false;
        boolean Gin = (invitationToEvent.contains('Gin Tasting')) ? true: false;
        boolean OnlineBusiness = (invitationToEvent.contains('Online Sessions (business hours)')) ? true: false;
        boolean OnlineEvening = (invitationToEvent.contains('Online Sessions (evening)')) ? true: false;
        boolean International = (invitationToEvent.contains('International Delegations')) ? true: false;
        
        
        lstContacts = [select Id from Contact where Id = : this.cid limit 1];
       
        
 
        if(!lstContacts.isEmpty()) {
            Contact con = lstContacts[0];
            
            con.Fortnightly_Upcoming_Events_weekly_duri__c = Upcoming;
            con.Member_Offers_DNS__c = Offers;
            con.Monthly_Newsletters_weekly_during_COVID__c = Newsletters;
            con.FTA_Brexit_Updates__c = FTA;
            con.Event_Webinar_Invites__c = EventWebinar;
            con.Anything_Unsubscribe_All__c = Anything;

            con.Business_Breakfasts__c = BusinessBreakfasts;
            con.Business_Lunches__c = BusinessLunches;
            con.Seminars__c = Seminars;
            con.Private_Boardroom_Events__c = Boardroom;
            con.Cocktail_Evenings__c = Cocktail;
            con.Sports_Events__c = SportsLunches;
            con.Evening_Networking__c = EveningNetworking;
            con.Wine_Tastings__c = Wine;
            con.Whisky_Tastings__c = Whisky;
            con.Gin_Tastings__c = Gin;
            con.Online_Sessions_business_hours__c = OnlineBusiness;
            con.Online_Sessions_evening__c = OnlineEvening;
            con.International_Delegations__c = International;
            
            con.Agriculture__c = Agriculture;
            con.Brexit__c = Brexit;
            con.Digital_Cyber__c = DigitalandCyber;
            con.Defence__c = Defence;
            con.Education__c = Education;
            con.Energy_Resources__c = EnergyandResources;
            con.Fintech__c = Fintech;
            con.Financial_Services__c = FinancialServicesBanking;
            con.Gov_Affairs_Policy__c= GovernmentAffairsPolicy;
            con.Health__c = Health;
            con.Human_Resources__c = HR;
            con.Infrastructure__c = Infrastructures ;
            con.Resources__c = Resources;
            con.Retail__c = Retail;
            con.Technology__c = Technology;
            con.Tourism__c = Tourism;
			con.Trade__c = Trade;

			con.ACT__c = act;
            con.NSW_Member__c = nsw;
            con.NT__c = nt;
            con.QLD_Member__c = qld;
            con.SA_Member__c = sa;
            con.TAS__c = tas;
            con.VIC_Member__c = vic;
            con.WA_Member__c = wa;
            
            update con;
        }
        Pagereference pg = Page.UserPreferenceResponsePage;
        return pg;
    }
}
public class CampaignResponses {

    public String[] selectedTypeEvents {get;set;}
    public String[] selectedIndusType {get;set;}
    public String cid;
    public String campid;
    public String otherIndustries {get;set;}
    public String usercomment{get;set;}
    List<Contact> lstContacts = new List<Contact>();
    List<Campaign> camplist = new List<Campaign>();
    List<CampaignMember> campmember = new List<CampaignMember>();
    
     Public CampaignResponses () {
        selectedTypeEvents = new String[]{};
        selectedIndusType = new String[]{};
        
        this.cid = ApexPages.currentPage().getParameters().get('id');
        this.campid = ApexPages.currentPage().getParameters().get('campid');
        
        System.debug(this.cid);
        lstContacts = [select Id ,monthly_newsletter__c, Brexit__c,Trade__c,Digital_Cyber__c,Energy_Resources__c, Seminars__c, Other_pref__c, Member_Offers__c, Business_Lunches__c, Business_Breakfasts__c, No_Update_Notification__c, Weekly__c, Fortnightly__c, Monthly__c, Evening_Networking__c, Sports_Events__c, Cultural_Events__c, Infrastructure__c, Financial_Services__c, Gov_Affairs_Policy__c, Resources__c, Education__c, Others__c, Fintech__c, Defence__c, Health__c, Tourism__c, Retail__c,User_Comment__c   from Contact where Id = : this.cid limit 1];
        campmember = [select Id,status,ContactId from CampaignMember where Id=: this.campid ];
        System.debug(campmember);
        System.debug(lstContacts );
        prePopulateTypeOfEvents();
        prePopulateIndustryType();
      }
     public List<SelectOption> getTypeOfEvents() {
        List<Selectoption> result = new List<Selectoption>();
        result.add(new selectOption('Business Lunches','Business Lunches'));
        result.add(new selectOption('Business Breakfasts','Business Breakfasts'));
        result.add(new selectOption('Seminars','Seminars'));
        result.add(new selectOption('Evening Networking','Evening Networking'));
        result.add(new selectOption('Sports Events','Sports Events'));
        result.add(new selectOption('Cultural Events','Cultural Events'));
        return result;
    }
    
     public List<SelectOption> getIndustryType() {
        List<Selectoption> result = new List<Selectoption>();
        result.add(new selectoption('Brexit','Brexit'));
        result.add(new selectoption('Defence','Defence'));
        result.add(new selectoption('Digital/Cyber','Digital/Cyber'));
        result.add(new selectoption('Education','Education'));
        result.add(new selectoption('Energy & Resources','Energy & Resources'));
        result.add(new selectoption('Fintech','Fintech'));
        result.add(new selectoption('Financial Services - Banking','Financial Services - Banking'));
        result.add(new selectoption('Government Affairs & Policy','Government Affairs & Policy'));
        result.add(new selectoption('Health','Health'));
        result.add(new selectoption('Infrastructure','Infrastructure'));
        result.add(new selectoption('Resources','Resources'));
        result.add(new selectoption('Retail','Retail'));
        result.add(new selectoption('Tourism','Tourism'));
        result.add(new selectoption('Trade','Trade'));
        result.add(new selectoption('Other','Other'));
        
        return result;
    }
      @TestVisible private void prePopulateTypeOfEvents()
    {
    if(!lstContacts.isEmpty())
        {
            //for 4st question
            if(lstContacts[0].Business_Lunches__c)
            {
                selectedTypeEvents.add('Business Lunches');
            }
            if(lstContacts[0].Business_Breakfasts__c)
            {
                selectedTypeEvents.add('Business Breakfasts');
            }
            if(lstContacts[0].Evening_Networking__c)
            {
                selectedTypeEvents.add('Evening Networking');
            }
            if(lstContacts[0].Seminars__c)
            {
                selectedTypeEvents.add('Seminars');
            }
             if(lstContacts[0].Sports_Events__c)
            {
                selectedTypeEvents.add('Sports Events');
            }
            if(lstContacts[0].Cultural_Events__c)
            {
                selectedTypeEvents.add('Cultural Events');
            }
        }
    }
    
    
    
    @TestVisible private void prePopulateIndustryType()
    {
        if(!lstContacts.isEmpty())
        {
             //for 5st question
             if(lstContacts[0].Infrastructure__c )
            {
                selectedIndusType.add('Infrastructure');
            }
            if(lstContacts[0].Fintech__c)
            {
                selectedIndusType.add('Fintech');
            }
            if(lstContacts[0].Gov_Affairs_Policy__c)
            {
                selectedIndusType.add('Government Affairs & Policy');
            }
            if(lstContacts[0].Financial_Services__c)
            {
                selectedIndusType.add('Financial Services - Banking');
            }
            if(lstContacts[0].Defence__c)
            {
                selectedIndusType.add('Defence');
            }
            if(lstContacts[0].Resources__c)
            {
                selectedIndusType.add('Resources');
            }
            if(lstContacts[0].Health__c)
            {
                selectedIndusType.add('Health');
            }
            if(lstContacts[0].Retail__c)
            {
                selectedIndusType.add('Retail');
            }
            if(lstContacts[0].Tourism__c)
            {
                selectedIndusType.add('Tourism');
            }
            if(lstContacts[0].Education__c)
            {
                selectedIndusType.add('Education');
            }
            if(lstContacts[0].Brexit__c)
            {
                selectedIndusType.add('Brexit');
            }
            if(lstContacts[0].Digital_Cyber__c)
            {
                selectedIndusType.add('Digital/Cyber');
            }
             if(lstContacts[0].Trade__c)
            {
                selectedIndusType.add('Trade');
            }
            if(lstContacts[0].Energy_Resources__c)
            {
                selectedIndusType.add('Energy & Resources');
            }
            if(lstContacts[0].Others__c)
            {
                selectedIndusType.add('Other');
                otherIndustries = String.isBlank(lstContacts[0].Other_pref__c) ? '' : lstContacts[0].Other_pref__c;
            }
                usercomment = String.isBlank(lstContacts[0].User_Comment__c) ? '' : lstContacts[0].User_Comment__c;
          
        }
    }
    
     public PageReference submitResponses()
    {
        System.debug('text box name id '+otherIndustries );
       
       // System.debug('Anuj noUpdate'+noUpdate);
       
        String invitationToEvent = '';
        for(String str : selectedTypeEvents) {
            invitationToEvent += str + ';';
        }
        invitationToEvent = invitationToEvent.removeEnd(';');
        
        String selectedIndustryType = '';
        for(String str : selectedIndusType) {
            selectedIndustryType += str + ';';
        }
        selectedIndustryType = selectedIndustryType.removeEnd(';');
        
        String otherIndustriesForSave = '';
        if(selectedIndustryType.contains('Other')){
            otherIndustriesForSave = otherIndustries;
            System.debug(otherIndustriesForSave);
        }
        
        String usercomments = usercomment;
        System.debug(otherIndustries);
        System.debug(selectedIndustryType);
        boolean Infrastructures = (selectedIndustryType.contains('Infrastructure')) ? true: false;
        boolean Fintech= (selectedIndustryType.contains('Fintech')) ? true: false;
        boolean GovernmentAffairsPolicy = (selectedIndustryType.contains('Government Affairs & Policy')) ? true: false;
        boolean FinancialServicesBanking = (selectedIndustryType.contains('Financial Services - Banking')) ? true: false;
        boolean Defence= (selectedIndustryType.contains('Defence')) ? true: false;
        boolean Resources= (selectedIndustryType.contains('Resources')) ? true: false;
        boolean Health= (selectedIndustryType.contains('Health')) ? true: false;
        boolean Retail= (selectedIndustryType.contains('Retail')) ? true: false;
        boolean Tourism= (selectedIndustryType.contains('Tourism')) ? true: false;
        boolean Education= (selectedIndustryType.contains('Education')) ? true: false;
        boolean Brexit = (selectedIndustryType.contains('Brexit')) ? true: false;
        boolean DigitalandCyber = (selectedIndustryType.contains('Digital/Cyber')) ? true: false;
        boolean Trad= (selectedIndustryType.contains('Trad')) ? true: false;
        boolean EnergyandResources = (selectedIndustryType.contains('Energy & Resources')) ? true: false;
        boolean Other= (selectedIndustryType.contains('Other')) ? true: false;
       
        boolean BusinessLunches = (invitationToEvent .contains('Business Lunches')) ? true: false;
        boolean BusinessBreakfasts = (invitationToEvent .contains('Business Breakfasts')) ? true: false;
        boolean EveningNetworking= (invitationToEvent .contains('Evening Networking')) ? true: false;
        boolean SportsEvents= (invitationToEvent .contains('Sports Events')) ? true: false;
        boolean Seminars = (invitationToEvent .contains('Seminars')) ? true: false;
        boolean CulturalEvents= (invitationToEvent .contains('Cultural Events')) ? true: false;
        campmember = [select Id,Name,Status,ContactId from Campaignmember where Id=:this.campid];
        System.debug(campmember);
        lstContacts = [select Id ,FirstName,monthly_newsletter__c, Brexit__c,Trade__c,Digital_Cyber__c,Energy_Resources__c, Seminars__c, Other_pref__c, Member_Offers__c, Business_Lunches__c, Business_Breakfasts__c, No_Update_Notification__c,Email, Weekly__c, Fortnightly__c, Monthly__c, Evening_Networking__c, Sports_Events__c, Cultural_Events__c, Infrastructure__c, Financial_Services__c, Gov_Affairs_Policy__c, Resources__c, Education__c, Others__c, Fintech__c, Defence__c, Health__c, Tourism__c, Retail__c ,User_Comment__c  from Contact where Id = : this.cid limit 1];
        System.debug(otherIndustries);
        System.debug(Other);
            
             
        if(!lstContacts.isEmpty()) {
            Contact con = lstContacts[0];
            con.User_Comment__c = usercomment;
            con.Infrastructure__c = Infrastructures ;
            con.Fintech__c = Fintech;
            con.Defence__c = Defence;
            con.Resources__c = Resources;
            con.Health__c = Health;
            con.Retail__c = Retail;
            con.Tourism__c = Tourism;
            con.Education__c = Education;
            con.Gov_Affairs_Policy__c= GovernmentAffairsPolicy;
            con.Financial_Services__c = FinancialServicesBanking;
            con.Business_Lunches__c = BusinessLunches;
            con.Business_Breakfasts__c = BusinessBreakfasts;
            con.Evening_Networking__c =EveningNetworking;
            con.Sports_Events__c = SportsEvents;
            con.Cultural_Events__c = CulturalEvents;
            con.Brexit__c = Brexit ;
            con.Digital_Cyber__c = DigitalandCyber ;
            con.Trade__c = Trad ;
            con.Energy_Resources__c = EnergyandResources ;
            con.Others__c = Other;
            con.Other_pref__c= otherIndustriesForSave;
            con.Seminars__c= Seminars;
            System.debug(con.Fintech__c);
            
            update con;
            
            system.debug('Anuj Updated Contact --> '+con);
        }
        Pagereference pg = Page.UserPreferenceResponsePage;
        return pg;
    }
    
      public PageReference userResponded()
    {
        System.debug( this.cid);
        System.debug( this.campid );
        lstContacts = [select Id ,monthly_newsletter__c, Brexit__c,Trade__c,Digital_Cyber__c,Energy_Resources__c, Seminars__c, Other_pref__c, Member_Offers__c, Business_Lunches__c, Business_Breakfasts__c, No_Update_Notification__c, Weekly__c, Fortnightly__c, Monthly__c, Evening_Networking__c, Sports_Events__c, Cultural_Events__c, Infrastructure__c, Financial_Services__c, Gov_Affairs_Policy__c, Resources__c, Education__c, Others__c, Fintech__c, Defence__c, Health__c, Tourism__c, Retail__c,User_Comment__c   from Contact where Id = : this.cid limit 1];
        campmember = [select Id,status,ContactId from CampaignMember where Id=: this.campid ];
        if(!lstContacts.isEmpty() && !campmember.isEmpty()){
        if(lstContacts[0].Id == campmember[0].ContactId){ 
             if(!campmember.isEmpty()){
                CampaignMember campmembers = campmember[0];
                campmembers.status = 'Responded';
                update campmembers;
                system.debug('Anuj Updated Contact --> '+campmembers);
            }
          }
     
   
    }
     return null;
    }
}
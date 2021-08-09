/*
    This class is responsible for filtering out the lead records for conversion and it  orchestrates the process of lead conversion.
*/
public with sharing class LeadConversionHelper {
    private list <Lead> leads;  
    private map<Id,Id> leadIdVsAccount;
    private map<string,Account> companyNameVsAccount;
     
    /*
    *@desc:Constructor
    *@param: list of leads  
    */
    public LeadConversionHelper(list <Lead> leads) {
        this.leads = leads;
        this.leadIdVsAccount = new Map<Id,Id>();
        this.companyNameVsAccount = new map<string,Account>();
        populateCompanyVsAccountMap();
    }
    
    /*
    *@desc:Getter method for leadId vs existing account map 
    */
    public map<Id,Id> getLeadIdVsExistingAccount() {
        return leadIdVsAccount;
    }
    
    /*
    *@desc:This method will initialize the company name vs accounts map for filtering purpose.
    */
    private void populateCompanyVsAccountMap() {
        set <String> companyNames = new set <String>();
        for(Lead leadRecord : leads) {
            if(!String.isBlank(leadRecord.Company)) {
                companyNames.add(leadRecord.Company);
            }
        }
        
        //Assuming there is no duplicate account in the system.
        for (Account accountRecord : [SELECT Name, Company_Name__c 
                                      FROM Account 
                                      WHERE Name IN: companyNames LIMIT 50000]){
            companyNameVsAccount.put(accountRecord.Name.toLowerCase(), accountRecord);              
        }
    }
    
    /*
    *@desc:This method will filter the lead records which are having existing company.
    */
    public list<Lead> filterLeadsToBeConvertedToExistingAccounts() {
        list<Lead> leadsToBeConverted = new list<Lead>();
        //filter the leads which have existing account record in the system
        for (Lead leadRecord : leads){
            if (leadRecord.Existing_Contact__c == false && 
                !String.isBlank(leadRecord.company) && 
                companyNameVsAccount.containsKey(leadRecord.company.toLowerCase())){
                    
                leadsToBeConverted.add(leadRecord);
                leadIdVsAccount.put(leadRecord.Id, companyNameVsAccount.get(leadRecord.company.toLowerCase()).Id);
            }
        }
        return leadsToBeConverted; 
    } 
    
    /*
    *@desc:This method will filter the lead records which are to be converted to account/Contact.
    */
    public list<Lead> filterLeadsToBeConverted() {
        list<Lead> leadsToBeConverted = new list<Lead>();
        for (Lead leadRecord : leads){
            if (leadRecord.Existing_Contact__c == false && 
                !String.isBlank(leadRecord.company) && 
                !companyNameVsAccount.containsKey(leadRecord.company.toLowerCase())){
                    
                leadsToBeConverted.add(leadRecord);
            }
        }
        return leadsToBeConverted; 
    }
    
    /*
        This method will return LeadConvert record
        @param: Lead Record, Account Id, Master Label, Account Owner Id (Default after conversion)
        @return: Database.LeadConvert
    */
    public static Database.LeadConvert getLeadConvertRecord(Lead leadRecord, Id accountId, String master_Label, String accountOwnerId) {
        Database.LeadConvert lc = new Database.LeadConvert(); 
        lc.setLeadId(leadRecord.Id); 
        lc.setDoNotCreateOpportunity(true); 
        lc.setConvertedStatus(master_Label);
        if(accountOwnerId != null)
            lc.setOwnerId(accountOwnerId);    
        if(accountId != null)
            lc.setAccountId(accountId);
        return lc;
    }
    
     /*
    *@desc:This method will update contact which are created by converting lead
    */
    public void updateConvertedContacts(set<Id> contactsId) {
        list<Contact> convertedContacts = new list<Contact>();
        LeadConversionHelper helper = new LeadConversionHelper(trigger.new);
        convertedContacts = [SELECT name,Auto_Converted_from_Lead__c,National_NonMember__c 
                              FROM Contact 
                              WHERE Id in : contactsId];
         
        Id defaultContactOwnerId = null;
        if(Configurations__c.getInstance(GlobalConstants.CUSTOM_SETTINGS_DEFAULT_CONTACT_OWNER) != null){
        	defaultContactOwnerId = Configurations__c.getInstance(GlobalConstants.CUSTOM_SETTINGS_DEFAULT_CONTACT_OWNER).Value__c;
        }else{
        	defaultContactOwnerId = (defaultContactOwnerId == null)? UserInfo.getUserId() : defaultContactOwnerId; 
        }
        
        
        system.debug('========convertedContacts===========' + convertedContacts);
        
        for(contact con : convertedContacts){
            con.Auto_Converted_from_Lead__c = true;
            //con.Non_Member__c = true;
            con.National_NonMember__c = true;
            con.isConvertedToday__c = true;
            if(defaultContactOwnerId != null){
                con.OwnerId = defaultContactOwnerId;
            }

         }
         
         system.debug('========convertedContacts===========' + convertedContacts);
         if(!convertedContacts.isEmpty()){
            update convertedContacts;
         } 
         
        if (!contactsId.isEmpty()){
            EmailNotificationManager mgr =  new EmailNotificationManager();
            mgr.sendAnEmail(GlobalConstants.CONVERTED_CONTACT_EMAIL_TEMPLATE_NAME, defaultContactOwnerId);
        }
        List<contact> contactRecords = helper.deselectIsConvertedTodayCheckbox(DataFactory.getExistingContacts(contactsId));
        if(!contactRecords.isEmpty()){
            Update contactRecords;
        }
    }
    
    public List<Contact> deselectIsConvertedTodayCheckbox(List<Contact> contacts){
        for (contact con : contacts){
            con.isConvertedToday__c = false;
        }
        return contacts;
    }
    
    
    
    public class LeadConversionException extends Exception { }
}
/**
* @author: Arxxus
* @desc: This is data factory which is used in the all the test class 
*/

public class DataFactory {
    
    // it will return the list of leads without inserted 
    public static list<Lead> getCreatedleads(Integer noOfLeads){
        list<lead> leads = new list<Lead>();
        for(Integer i =0;i<noOfLeads ; i++){
            Lead led = new Lead();
            led.FirstName = 'Lead First Name' + i;
            led.LastName = 'Lead Last Name' + i;
            leads.add(led);
        }
         
        return leads;
    } 
       
    // it will returns the list of inserted leads 
    public static list<Lead> getInsertedleads( Integer noOfLeads ){
        list<lead> leads = new list<Lead>();
        leads.addAll(getCreatedleads(noOfLeads));
        if(!leads.isEmpty()){
           list<Database.SaveResult> results =  database.insert(leads);
            
            set<Id> idset = new set<id>();
            
            for(Database.SaveResult result : results){
                idset.add(result.getId());  
            }
            return getExistingLeads(idset);
        }else{
            return new list<Lead>();
        }
    } 
    
    // This methode will give the existing leads related to provided Ids 
    public static list<Lead> getExistingLeads(Set<Id> leadIdSet){
        Return [SELECT Id,Name,FirstName,LastName,Existing_Contact__c,isConverted,ConvertedAccountId,Company FROM Lead WHERE id in: leadIdSet];
    }

    // it will return the list of leads without inserted 
    public static list<contact> getCreatedContacts (Integer noOfContacts){
        list<contact> contacts = new list<contact>();
        for(Integer i =0;i<noOfContacts ; i++){
            contact con = new contact();
            con.FirstName = 'FirstName';
            con.LastName = 'LastName';
            con.Contact_Unique_Name__c = 'FirstName-LastName';
            contacts.add(con);
        }   
         
        return contacts;
    } 
       
    // it will returns the list of inserted leads 
    public static list<contact> getInsertedContacts( Integer noOfContacts ){
        list<contact> contacts = new list<contact>();
        contacts.addAll(getCreatedContacts(noOfContacts));
        if(!contacts.isEmpty()){
           list<Database.SaveResult> results =  database.insert(contacts);
            
            set<Id> idset = new set<id>();
            
            for(Database.SaveResult result : results){
                idset.add(result.getId());  
            }
            return getExistingContacts(idset);
        }else{
            return new list<Contact>();
        }
           
    } 
    
    // This methode will give the existing leads related to provided Ids 
    public static list<contact> getExistingContacts(Set<Id> contactsIdSet){
        Return [SELECT Id,Name,FirstName,LastName,Duplicate_Contact__c,Contact_Unique_Name__c,NSW_NonMember__c, 
                VIC_NonMember__c,QLD_NonMember__c,WA_NonMember__c ,SA_NonMember__c ,ACT_NM__c,mailingState
                FROM Contact 
                WHERE id in: contactsIdSet];
    }



    // it will return the list of Account without inserted 
    public static list<Account> getCreatedAccounts (Integer noOfAccounts){
        list<Account> accounts = new list<account>();
        for(Integer i =0;i<noOfAccounts ; i++){
            Account acct = new Account();
            acct.Name = 'Arxxus';
            accounts.add(acct);
        }
         
        return accounts;
    } 
       
    // it will returns the list of inserted leads 
    public static list<account> getInsertedAccounts( Integer noOfAccounts ){
        list<Account> accounts = new list<Account>();
        accounts.addAll(getCreatedAccounts(noOfAccounts));
        if(!accounts.isEmpty()){
           list<Database.SaveResult> results =  database.insert(accounts);
            
            set<Id> idset = new set<id>();
            
            for(Database.SaveResult result : results){
                idset.add(result.getId());  
            }
            return getExistingAccounts(idset);
        }else{
            return new list<account>();
        }
           
    } 
    
    // This methode will give the existing leads related to provided Ids 
    public static list<account> getExistingAccounts(Set<Id> accountsIdSet){
        Return [SELECT Id,Name FROM Account WHERE id in: accountsIdSet];
    }
    
    public static void createStateSynanymsCustomSettings(){
        list <State_synonyms__c> stateSynonyms = new list <State_synonyms__c>();
        stateSynonyms.add(new State_synonyms__c(Name = 'ACT', State_Abbreviation__c = 'ACT', FieldAPIName__c = 'ACT_NM__c'));
        stateSynonyms.add(new State_synonyms__c(Name = 'VIC', State_Abbreviation__c = 'VIC', FieldAPIName__c = 'VIC_NonMember__c'));
        stateSynonyms.add(new State_synonyms__c(Name = 'QLD', State_Abbreviation__c = 'QLD', FieldAPIName__c = 'QLD_NonMember__c'));
        insert stateSynonyms;
    } 
}
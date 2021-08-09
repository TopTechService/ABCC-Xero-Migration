/*
*@desc: This class is responsible for Lead Conversion
*/
public with sharing class LeadConverter {
    /*
	*@desc: This method will convert the lead, handler scenario where company exists in salesforce.
	*	    This will only create contact record.
	*/
    public static list <Database.LeadConvertResult> convert(list <Lead> leads, map <Id,Id> leadIdVsAccount) {
    	LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        list<Database.LeadConvert> leadsToBeConverted = new list<Database.LeadConvert> ();
        system.debug('======leads=========' + leads);
        system.debug('======leadIdVsAccount=========' + leadIdVsAccount);
        for(Lead leadRecord : leads){ 
			leadsToBeConverted.add(LeadConversionHelper.getLeadConvertRecord(leadRecord, leadIdVsAccount.get(leadRecord.Id), convertStatus.MasterLabel, null));
        }
        system.debug('======leadsToBeConverted=========' + leadsToBeConverted);
        List<Database.LeadConvertResult> lcr = Database.convertLead(leadsToBeConverted);
        system.debug('======lcr=========' + lcr);
        return lcr;
    }  
    
    /*
	*@desc: This method will convert the lead to account and contact.
	*/
    public static list <Database.LeadConvertResult> convert(list <Lead> leads) {
    	LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        list<Database.LeadConvert> leadsToBeConverted = new list<Database.LeadConvert> ();
        for(Lead leadRecord : leads){
			leadsToBeConverted.add(LeadConversionHelper.getLeadConvertRecord(leadRecord, null, convertStatus.MasterLabel, null));
        }
        List<Database.LeadConvertResult> lcr = Database.convertLead(leadsToBeConverted);
        return lcr;
    }
}
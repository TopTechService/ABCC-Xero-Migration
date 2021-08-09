/*
*@author: Arxxus
*@desc: Overnight batch process which checks all the contacts created today against the existing contacts - 
*		whenever the combination of FN + LN found for the existing contact, mark the contact duplicate.
*       QUERY STRING:
*       SELECT Id, email, Duplicate_Contact_Record__c, Duplicate_Contact__c, 
*    	       Name, FirstName, LastName, Contact_Unique_Name__c, CreatedDate
*    	FROM Contact 
*       WHERE CreatedDate = Today
*/
global class BatchDuplicateContactMarker implements Database.Batchable<SObject>, database.stateful {    
    //This variable holds query string
    public string query = null;
    
    global BatchDuplicateContactMarker(String query){
    	this.query = query;
    }
    
    //Start method will query the database to fetch the todays contacts
    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(query);
    }
    
    //Execute method will run the business logic to mark duplicate contacts
    global void execute(Database.BatchableContext context, List<Contact> contactRecords) {
       ContactDuplicateMarker dupMarker = new ContactDuplicateMarker();
       dupMarker.markDuplicates(contactRecords);
    }
    
    //Finish method will send the list of duplicate contacts to the default lead owner
    global void finish(Database.BatchableContext context) { 
        //Send updated contacts to Default Lead Owner
        Id defaultLeadOwnerId = null;
		if(Configurations__c.getInstance(GlobalConstants.CUSTOM_SETTINGS_DEFAULT_LEAD_OWNER) != null)
		defaultLeadOwnerId = Configurations__c.getInstance(GlobalConstants.CUSTOM_SETTINGS_DEFAULT_LEAD_OWNER).Value__c;
        system.debug('=defaultLeadOwnerId===' + defaultLeadOwnerId);
        defaultLeadOwnerId = (defaultLeadOwnerId == null)? UserInfo.getUserId() : defaultLeadOwnerId; 
        if(!String.isBlank(defaultLeadOwnerId)) {
        	EmailNotificationManager mgr =  new EmailNotificationManager();
        	mgr.sendAnEmail(GlobalConstants.DUPLICATE_CONTACT_EMAIL_TEMPLATE_NAME, defaultLeadOwnerId);
        }
    }
}
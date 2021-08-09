/*
*@author: Arxxus
*@desc: Controller class for Contact List vf page component
*/
public with sharing class ContactListController { 
    public String baseUrl {get;set;}
    
    public ContactListController() {
        baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
    }
    
    /*
	*@desc: This method will fetch the Duplicate contacts created today.
	*/ 
    public list <Contact> getDuplicateContacts() {
    	return [SELECT Id, Name, FirstName, LastName, Duplicate_Contact_Record__c, Email,
                	   Duplicate_Contact_Record__r.Name
    			FROM Contact 
    			WHERE LastModifiedDate = Today 
    			AND Duplicate_Contact__c = true];
    } 
    
    
    /*
	*@desc: This method will fetch the Converted Contact created today .
	*/
    public list <Contact> getConvertedContacts() {
    	return [SELECT Id, Name, FirstName, LastName, isConvertedToday__c, Email 
    			FROM Contact 
    			WHERE isConvertedToday__c = true and createdDate = today];
    			
    } 
}
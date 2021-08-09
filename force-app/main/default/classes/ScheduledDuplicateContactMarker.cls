/*
*@author: Arxxus
*@desc: This class will be scheduled to run a batch process which marks the duplicate contacts.
*/
global class ScheduledDuplicateContactMarker implements Schedulable {
    global void execute(SchedulableContext SC) {
    	String query = 'SELECT Id, email, Duplicate_Contact_Record__c, Duplicate_Contact__c,' + 
					   'Name, FirstName, LastName, Contact_Unique_Name__c, CreatedDate ' +
					   'FROM Contact WHERE CreatedDate = Today';
        BatchDuplicateContactMarker dupeMarker = new BatchDuplicateContactMarker(query);
        Database.executeBatch(dupeMarker);
    }
}
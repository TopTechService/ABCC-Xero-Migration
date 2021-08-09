public class EventTriggerHandler {

    public static void createPackages(list<Event__c> events){
        List<Event_Package__c> packagesToInsert = new List<Event_Package__c>();
        
        for(Event__c event : events){
            Event_Package__c tablePackage = new Event_Package__c();
            tablePackage.Event__c = event.id;
            tablePackage.Name = 'Table of ' + event.Seats_Per_Table__c;
            tablePackage.Type__c = 'table';
            tablePackage.Member_Price__c = 0.0;
            tablePackage.Standard_Price__c = 0.0;
            tablePackage.Active__c = true;
            packagesToInsert.add(tablePackage);
            
            Event_Package__c individualPackage = new Event_Package__c();
            individualPackage.Event__c = event.id;
            individualPackage.Name = 'Single Ticket';
            individualPackage.Type__c = 'Single Ticket';
            individualPackage.Member_Price__c = 0.0;
            individualPackage.Standard_Price__c = 0.0;
            individualPackage.Active__c = true;
            packagesToInsert.add(individualPackage);
        }
        
        insert packagesToInsert;
    }
    
    public static void createTables(list<Event__c> events){
        List<Table__c> tablesToInsert = new List<Table__c>();
        
        for(Event__c event : events){
            for(Integer i=1; i <= event.Number_of_Table__c; i++){
                Table__c tbl = new Table__c();
                tbl.Name = 'table' + String.valueOf(i).leftPad(3, '0');
                tbl.Event__c = event.Id;
                tablesToInsert.add(tbl);
            } 
        }
        insert tablesToInsert;
    }
}
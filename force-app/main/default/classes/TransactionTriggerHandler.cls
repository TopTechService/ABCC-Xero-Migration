public class TransactionTriggerHandler {
    List<Event_Registration__c> eventRegistrationsToUpdate = new List<Event_Registration__c>();
    List<Table__c> tablesToUpdate = new List<Table__c>();
    Map<Id, Map<String, Table__c>> eventToEmptyTableMap = new Map<Id, Map<String, Table__c>>();
    Map<Id, Map<String, Table__c>> eventToFullTableMap = new Map<Id, Map<String, Table__c>>();
    Map<Id, Map<String, Table__c>> eventToPartiallyFilledTableMap = new Map<Id, Map<String, Table__c>>();
    
    public void allocateTables(list<Opportunity> opps){
        List<Id> eventIds = new List<Id>();
        for(Opportunity opp : opps){
            eventIds.add(opp.Event__c);
        }
        
        Map<Id, Event__c> events = new Map<Id, Event__c>([Select Id,(Select Id,Name,Status__c,Vacant_Seats__c,Occupied_Seats__c,Capacity__c From Tables__r ORDER BY Name ASC) From Event__c where Id IN :eventIds]);
        
        for(Event__c event : events.values()){
            Map<String, Table__c> emptyTable = new Map<String, Table__c>();
            Map<String, Table__c> fullTable = new Map<String, Table__c>();
            Map<String, Table__c> partyiallyFilledTable = new Map<String, Table__c>();
            
            for(Table__c tab : event.Tables__r){
                if(tab.Status__c == 'Empty'){
                    emptyTable.put(tab.Id, tab);
                } else if (tab.Status__c == 'Full'){
                    fullTable.put(tab.Id, tab);
                } else if (tab.Status__c == 'Partially Filled'){
                    partyiallyFilledTable.put(tab.Id, tab);
                }
            }
            eventToEmptyTableMap.put(event.Id, emptyTable);
            eventToFullTableMap.put(event.Id, fullTable);
            eventToPartiallyFilledTableMap.put(event.Id, partyiallyFilledTable);
            System.debug('UB: eventToEmptyTableMap'+eventToEmptyTableMap);
            System.debug('UB: eventToFullTableMap'+eventToFullTableMap);
            System.debug('UB: eventToPartiallyFilledTableMap'+eventToPartiallyFilledTableMap);
                  
        }
        System.debug(opps[0].Event_Package__r.Type__c);
         
        for(Opportunity opp : opps){
            if(opp.Event_Package__r.Type__c == 'Table'){
             System.debug(opp.Event_Registrations__r);
       
              System.debug(eventToEmptyTableMap.get(opp.Event__c).size());
              
              System.debug(opp.Ticket_Qty__c);
             
               System.debug('hiiii');
                  
                if(eventToEmptyTableMap.get(opp.Event__c).size() > opp.Ticket_Qty__c){
                    System.debug(eventToEmptyTableMap.get(opp.Event__c).size());
                    List<Table__c> emptyTable = eventToEmptyTableMap.get(opp.Event__c).values();
                    integer i = 0,count = 1;
                   
                    for(Event_Registration__c er : opp.Event_Registrations__r){
                        er.Table__c = emptyTable[i].Id;
                        System.debug(er.Table__r.Capacity__c);
                        eventRegistrationsToUpdate.add(er);
                        System.debug(emptyTable[i].Capacity__c);
                        if(count == emptyTable[i].Capacity__c){
                            emptyTable[i].Occupied_Seats__c = emptyTable[i].Capacity__c;
                            tablesToUpdate.add(emptyTable[i]);
                            eventToFullTableMap.get(opp.Event__c).put(emptyTable[i].Id, emptyTable[i]);
                            eventToEmptyTableMap.get(opp.Event__c).remove(emptyTable[i].Id);
                            i++;
                            count = 0;
                        }
                        count++;
                    }
                }
            } else if(opp.Event_Package__r.Type__c == 'Single Ticket'){
            
                try{
                    if(eventToPartiallyFilledTableMap.get(opp.Event__c).size() > 0){
                        list<Table__c> pfTables = eventToPartiallyFilledTableMap.get(opp.Event__c).values();
                        System.debug(pfTables);
                        findTable(pfTables, opp.Event_Registrations__r.size(), opp.Event_Registrations__r, opp);
                    } else if(eventToEmptyTableMap.get(opp.Event__c).size() > 0) {
                        findTable(eventToEmptyTableMap.get(opp.Event__c).values(), opp.Event_Registrations__r.size(), opp.Event_Registrations__r, opp);
                    }
                } catch(Exception e){
                    
                }
            }
        }
        
        try{
            update eventRegistrationsToUpdate;
            System.debug('jnzfv'+tablesToUpdate);
            update tablesToUpdate;
        } catch(Exception e){
            
        }
        
    }
    
    public void findTable(List<Table__c> pfTables, Integer SeatsToAssign, List<Event_Registration__c> erList, Opportunity opp){
        System.debug('pfTables'+pfTables);
        if(SeatsToAssign > 0){
            System.debug('UB: find table');
            Table__c minVacantSufficient;
            Table__c maxVacantNotSufficient;
            for(Table__c tbl  : pfTables){
                if(tbl.Vacant_Seats__c > SeatsToAssign){
                System.debug('Umang'+tbl.Vacant_Seats__c);
                    if(minVacantSufficient == null) {
                        minVacantSufficient = tbl;
                    } else if(minVacantSufficient != null && minVacantSufficient.Vacant_Seats__c < tbl.Vacant_Seats__c){
                        minVacantSufficient = tbl;
                        System.debug(tbl);
                    } 
                } else {
                    if(maxVacantNotSufficient == null){
                        maxVacantNotSufficient = tbl;
                    } else if(maxVacantNotSufficient != null && maxVacantNotSufficient.Vacant_Seats__c > tbl.Vacant_Seats__c){
                        maxVacantNotSufficient = tbl;
                    }
                }
            }
            
            if(minVacantSufficient != null){
                System.debug('UB: minVacantSufficient');
                for(Event_Registration__c er : erList){
                    er.Table__c = minVacantSufficient.Id;
                    minVacantSufficient.Occupied_Seats__c = (minVacantSufficient.Occupied_Seats__c != null) ?
                        (minVacantSufficient.Occupied_Seats__c + 1) : 1;
                    eventRegistrationsToUpdate.add(er);
                    System.debug(eventRegistrationsToUpdate);
                }
                tablesToUpdate.add(minVacantSufficient);
                System.debug('UB:0'+tablesToUpdate);
                if(minVacantSufficient.Occupied_Seats__c == minVacantSufficient.Capacity__c){
                    eventToFullTableMap.get(opp.Event__c).put(minVacantSufficient.Id, minVacantSufficient);
                    eventToPartiallyFilledTableMap.get(opp.Event__c).remove(minVacantSufficient.Id);
                }
            } else if (maxVacantNotSufficient != null){
                Integer count=1;
                List<Event_Registration__c> remainingER = new List<Event_Registration__c>();
                for(Event_Registration__c er : erList){
                    if(count <= maxVacantNotSufficient.Vacant_Seats__c){
                        er.Table__c = maxVacantNotSufficient.Id;
                        System.debug('UB1:'+maxVacantNotSufficient.Occupied_Seats__c);
                        maxVacantNotSufficient.Occupied_Seats__c = (maxVacantNotSufficient.Occupied_Seats__c != null) ?
                            (maxVacantNotSufficient.Occupied_Seats__c + 1) : 1;
                        eventRegistrationsToUpdate.add(er);
                        count++;
                    } else {
                        remainingER.add(er);
                    }
                }
                tablesToUpdate.add(maxVacantNotSufficient);
                if(maxVacantNotSufficient.Occupied_Seats__c == maxVacantNotSufficient.Capacity__c){
                    eventToFullTableMap.get(opp.Event__c).put(maxVacantNotSufficient.Id, maxVacantNotSufficient);
                    eventToPartiallyFilledTableMap.get(opp.Event__c).remove(maxVacantNotSufficient.Id);
                }
                
                if(remainingER.size() > 0){
                    System.debug('000000'+remainingER.size());
                    if(eventToPartiallyFilledTableMap.get(opp.Event__c).size() > 0){
                        findTable(eventToPartiallyFilledTableMap.get(opp.Event__c).values(), remainingER.size(), remainingER,opp);
                    } else if(eventToEmptyTableMap.get(opp.Event__c).size() > 0){
                        findTable(eventToEmptyTableMap.get(opp.Event__c).values(), remainingER.size(), remainingER,opp);
                    }
                }
            }
        }
    }
}
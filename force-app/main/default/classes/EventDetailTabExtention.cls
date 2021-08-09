public class EventDetailTabExtention {
    @testvisible private Event__c event;
    public List<Event_Registration__c> allEventReg {get; set;}
    public Map<Integer, Event_Registration__c> allEr {get; set;}
    public Map<Integer, Event_Registration__c> mapToShow {get; set;}
    public Map<Integer, Event_Registration__c> AttendeeEr{get; set;}
    public Map<Integer, Event_Registration__c> WaitListEr{get; set;}
    public Map<Integer, Event_Registration__c> CancledEr{get; set;}
    public string filterString {get; set;}
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public EventDetailTabExtention(ApexPages.StandardController stdController) {
        this.event = (Event__c)stdController.getRecord();
        allEventReg = [Select Id, Name, First_Name__c, Last_Name__c, Email__c, Job_Title__c, Company__c, Opportunity__c, 
                    Opportunity__r.Name, Package_Type__c, Registration_Status__c, Registered_From__c,
                    Registration_Type__c, NO_SHOWS__c, Table__r.Name From Event_Registration__c Where Event__c = :event.Id and Opportunity__c != null];
        
        filterString = 'Attendees';
        filterErList();
        mapToShow = AttendeeEr;
    }
    
    public void updateNoShow(){
        update mapToShow.values();
    }
    
    public void filterErList(){
        AttendeeEr = new Map<Integer, Event_Registration__c>();
        WaitListEr = new Map<Integer, Event_Registration__c>();
        CancledEr = new Map<Integer, Event_Registration__c>();
        allEr = new Map<Integer, Event_Registration__c>();
        Integer count = 0;
        
        for(Event_Registration__c er : allEventReg){
            allEr.put(count, er);
            count++;
            
            if(er.Registration_Type__c == 'Guest' || er.Registration_Status__c == 'Successful' || (er.Registered_From__c == 'Manual Registration' && er.Registration_Status__c == 'Outstanding')){
                AttendeeEr.put(count, er);
                count++;
            } else if(er.Registration_Status__c == 'Wait List'){
                WaitListEr.put(count, er);
                count++;
            } else if(er.Registration_Status__c == 'Cancelled'){
                CancledEr.put(count, er);
                count++;
            }
        }
    }
    
    public void changeListToShow(){
        if(filterString == 'All'){
            mapToShow = allEr;
        }else if(filterString == 'Attendees' ){
            mapToShow = AttendeeEr;
        }else if(filterString == 'Wait List' ){
            mapToShow = WaitListEr;
        }else if(filterString ==  'Cancelled'){
            mapToShow = CancledEr;
        }
    }
}
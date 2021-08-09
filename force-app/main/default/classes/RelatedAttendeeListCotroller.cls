public without sharing class RelatedAttendeeListCotroller extends ComponentControllerBase{
    
    public Map<Integer, AttendeeWrapper> Attendees {get; set;}
    Public TempClass tempgivenAttendeeDetail; 
    Public String P1 {set;} 
    Public EventDetailController myPageController{get; set;}
    Public Integer maxAttendees {get; set;}
    
    public TempClass getgivenAttendeeDetail()
    {
        return tempgivenAttendeeDetail;
    }
      
    public Integer count = 1;
    
    public Integer attendeeKey {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String phone {get; set;}
    
    public Integer currentEditable {get; set;}
    
    public RelatedAttendeeListCotroller(){
        Attendees = new Map<Integer, AttendeeWrapper>();
        
        system.debug('Gaurang: vaue of givenAttendeeDetail' + tempgivenAttendeeDetail );         
    }
    public void setgivenAttendeeDetail(TempClass value)
    {
        System.debug('Umang'+value);
        //if(tempgivenAttendeeDetail == null && objTemp != null ) 
        tempgivenAttendeeDetail = value;
        system.debug('Got Value of Setting');
          //tempgivenAttendeeDetail  = objTemp;
          system.debug('Gaurang: vaue of Some ACtion' + tempgivenAttendeeDetail ); 
        if(tempgivenAttendeeDetail != null) 
        {
            system.debug('Gaurang: we are inside not null condition'); 
            List<AttendeeWrapper> lstAttWrapper = tempgivenAttendeeDetail.lstAttendeeWrapper;
            
            if(Attendees.size() == 0){
                Integer mapCount = 1;
                for(AttendeeWrapper objWrap : lstAttWrapper )
                {
                    Attendees.put(mapCount,objWrap);
                    mapCount++; 
                }
                count = mapCount;
            }
        }
    }
    
    Public class ListAttendeeWrapper
    {
       Public List<AttendeeWrapper> lstAttendeeWrapper; 
    }
    public class AttendeeWrapper{
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String email {get; set;}
        public String phone {get; set;}
        public Boolean undefined {get; set;}
        public Integer key {get; set;}
        public Boolean memberInvitee {get; set;}
        public String company {get; set;}
        public String positionTitle {get; set;}
        public String Dietary_Req {get; set;}
    }
 
    // public Getter to provide table headers 
    public string[] getheaders() { 
        return new string [] {'#','Not Known','First Name', 'Last Name', 'Email','Company','Position Title', 'Dietary Requirements'} ; 
    }
    
    public void addAttendeeToList(){
        for(Integer i=Attendees.size(); i<maxAttendees; i++){
            AttendeeWrapper attendee = new AttendeeWrapper();
            attendee.undefined = false;
            attendee.key = count++;
            Attendees.put(attendee.key, attendee);
            System.debug('Umang:'+Attendees);
        }
    }
    
    public void editAttendee(){
        currentEditable = attendeeKey;
    }
    
    public void removeAttendee(){
        Attendees.remove(attendeeKey);
    }
    
    public void populateAttenddes(Map<Integer, AttendeeWrapper> attendeesToPopulate){
       Attendees = attendeesToPopulate;
        //Add other blank values for attendee
        addAttendeeToList();
    }
    
    public void makeRecordUndefined(){
       AttendeeWrapper attendee = Attendees.get(attendeeKey);
        if(attendee.memberInvitee != true){
            attendee.firstName = 'Not Known';
            attendee.lastName = 'Not Known';
            attendee.email = null;
            attendee.phone = null;
            attendee.company = null;
            attendee.positionTitle = null;
            attendee.Dietary_Req = null;
            
        }
    }
}
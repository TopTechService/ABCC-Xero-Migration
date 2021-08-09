public class EditAttendeeController extends PageControllerBase {
    public RelatedAttendeeListCotroller myComponentController { get; set; }
    public Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper> AttendeeList {get;set;}
    
    public EditAttendeeController(){
        Id oppId = apexpages.currentpage().getparameters().get('id');
        Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper> AttendeeList = new Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper>();
        RelatedAttendeeListCotroller.AttendeeWrapper attendee = new RelatedAttendeeListCotroller.AttendeeWrapper();
        attendee.FirstName = 'Umang';
        AttendeeList.put(1, attendee);
    }
    
    public override void setComponentController(ComponentControllerBase compController) {
       myComponentController = (RelatedAttendeeListCotroller)compController;
    }
    
    public override ComponentControllerBase getMyComponentController() {
        return myComponentController;
    }
    
    public void initializeAttendees() {
       //myComponentController.populateAttenddes(AttendeeList);
    }
}
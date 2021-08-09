@IsTest public class RelatedAttendeeListCotroller_Test 
{
    public testmethod static void RelatedAttendeeListCotroller_Test_Method1()
    {
        TempClass obj_TempClass = new TempClass();
        RelatedAttendeeListCotroller.AttendeeWrapper obj_AttendeeWrapper = new RelatedAttendeeListCotroller.AttendeeWrapper();
        obj_AttendeeWrapper.firstName='fnm';
       
        obj_AttendeeWrapper.lastName ='lnm';
        obj_AttendeeWrapper.email  ='email@email.com';
        obj_AttendeeWrapper.phone  ='12212';
        obj_AttendeeWrapper.key =1;
        obj_AttendeeWrapper.memberInvitee = true;
        obj_AttendeeWrapper.company  ='company';
        obj_AttendeeWrapper.positionTitle ='position'; 
        obj_AttendeeWrapper.Dietary_Req  ='dietary';
        
        List<RelatedAttendeeListCotroller.AttendeeWrapper> obj_lst_AttendeeWrapper = new List<RelatedAttendeeListCotroller.AttendeeWrapper>();
         obj_lst_AttendeeWrapper.add(obj_AttendeeWrapper);
         
        RelatedAttendeeListCotroller  obj_RelatedAttendeeListCotroller = new RelatedAttendeeListCotroller();
        
        obj_TempClass.lstAttendeeWrapper=obj_lst_AttendeeWrapper;
        obj_RelatedAttendeeListCotroller.firstName = 'Fname';
        obj_RelatedAttendeeListCotroller.lastName = 'Lname';
        obj_RelatedAttendeeListCotroller.email = 'Test@test.com';
        obj_RelatedAttendeeListCotroller.phone = '1234567897';
        obj_RelatedAttendeeListCotroller.maxAttendees = 2;
        
        obj_RelatedAttendeeListCotroller.setgivenAttendeeDetail(obj_TempClass);
        
         obj_TempClass =obj_RelatedAttendeeListCotroller.getgivenAttendeeDetail();
        
         string[] obj_head=obj_RelatedAttendeeListCotroller.getheaders();
         obj_RelatedAttendeeListCotroller.editAttendee();
    //     obj_RelatedAttendeeListCotroller.makeRecordUndefined();
         Map<Integer,RelatedAttendeeListCotroller.AttendeeWrapper> obj_map_attendeemap = new Map<Integer,RelatedAttendeeListCotroller.AttendeeWrapper>();
         obj_map_attendeemap.put(1,obj_AttendeeWrapper);
         obj_RelatedAttendeeListCotroller.populateAttenddes(obj_map_attendeemap);
         obj_RelatedAttendeeListCotroller.addAttendeeToList();
         obj_RelatedAttendeeListCotroller.removeAttendee();
    }
    
}
@IsTest public class EditAttendeeController_Test 
{
    @TestSetUp public static void SetUpData(){
        
        Account obj_Account = new Account();
        obj_Account.Name = 'Test Account';
        obj_Account.Industry='Accounting';
        insert obj_Account;
        
        opportunity obj_opportunity = new opportunity();
        obj_opportunity.Name='test';
        obj_opportunity.Accountid =obj_Account.id;
        obj_opportunity.CloseDate = date.newInstance(2017, 11, 21);
        obj_opportunity.StageName='Prospecting';
        insert obj_opportunity;
    }
    public testmethod static void EditAttendeeController_Test_Method1()
    {
        opportunity obj_opportunity = [Select id from opportunity limit 1];
        TempClass obj_TempClass = new TempClass();
        RelatedAttendeeListCotroller.AttendeeWrapper obj_AttendeeWrapper = new RelatedAttendeeListCotroller.AttendeeWrapper();
        obj_AttendeeWrapper.firstName='fnm';       
        obj_AttendeeWrapper.lastName ='lnm';
        obj_AttendeeWrapper.email  ='email@email.com';
        obj_AttendeeWrapper.phone  ='12212';
        obj_AttendeeWrapper.key =1;
        obj_AttendeeWrapper.memberInvitee = true;
        obj_AttendeeWrapper.company  ='company';
        obj_AttendeeWrapper.undefined = false;
        
        obj_AttendeeWrapper.positionTitle ='position'; 
        obj_AttendeeWrapper.Dietary_Req  ='dietary';
        
         RelatedAttendeeListCotroller.AttendeeWrapper obj_AttendeeWrapper1 = new RelatedAttendeeListCotroller.AttendeeWrapper();
        obj_AttendeeWrapper1.firstName='fnm';       
        obj_AttendeeWrapper1.lastName ='lnm';
        obj_AttendeeWrapper1.email  ='email@email.com';
        obj_AttendeeWrapper1.phone  ='12212';
        obj_AttendeeWrapper1.key =1;
        obj_AttendeeWrapper1.memberInvitee = true;
        obj_AttendeeWrapper1.company  ='company';
        obj_AttendeeWrapper1.positionTitle ='position'; 
        obj_AttendeeWrapper1.Dietary_Req  ='dietary';
        obj_AttendeeWrapper1.undefined = true;
        List<RelatedAttendeeListCotroller.AttendeeWrapper> obj_lst_AttendeeWrapper = new List<RelatedAttendeeListCotroller.AttendeeWrapper>();
        obj_lst_AttendeeWrapper.add(obj_AttendeeWrapper1);
        
        List<RelatedAttendeeListCotroller.AttendeeWrapper> obj_lst_AttendeeWrapper1 = new List<RelatedAttendeeListCotroller.AttendeeWrapper>();
        obj_lst_AttendeeWrapper.add(obj_AttendeeWrapper);
        
         
        RelatedAttendeeListCotroller  obj_RelatedAttendeeListCotroller = new RelatedAttendeeListCotroller();
       // obj_TempClass.lstAttendeeWrapper=obj_lst_AttendeeWrapper;
        obj_TempClass.lstAttendeeWrapper=obj_lst_AttendeeWrapper1;
    
        PageReference pageRef = Page.EditAttendeeDetail;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', obj_opportunity.id);
        EditAttendeeController obj_EditAttendeeController = new EditAttendeeController();
        obj_EditAttendeeController.getMyComponentController();
        obj_EditAttendeeController.initializeAttendees();
        ComponentControllerBase obj_ComponentControllerBase = new ComponentControllerBase();
        PageControllerBase obj_PageControllerBase = new PageControllerBase();
        
        obj_ComponentControllerBase.pageController =obj_PageControllerBase ;
       // obj_EditAttendeeController.setComponentController(obj_ComponentControllerBase);
     }
}
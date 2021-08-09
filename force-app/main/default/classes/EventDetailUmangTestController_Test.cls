@IsTest (seeAllData = true) 
public class EventDetailUmangTestController_Test 
{
    public testmethod static void EventDetailUmangTestController_Test_Method1()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        List<RecordType> rtypes = [Select Name, Id From RecordType 
                  where sObjectType='Discount__c' and isActive=true and Name='Code'];

        List<RecordType> rtypes2 = [Select Name, Id From RecordType 
                  where sObjectType='Discount__c' and isActive=true and Name='Table'];
        
        Account obj_Account = new Account();
        obj_Account.Name = 'Test Account';
        obj_Account.Industry='Accounting';
        insert obj_Account;
        
        Contact obj_Contact = new Contact();
        obj_Contact.LastName ='Test Lastname';
        obj_Contact.AccountID=obj_Account.id;
        obj_Contact.Business_Function__c = 'Events';
        obj_Contact.Email = 'dsfsdfsdfsdf@sdfsdf.com';
        obj_Contact.PA_Email__c = 'dsfsdfsdfsdf@sdfsdf.com';
        obj_Contact.MailingCountry = 'Australia';
        obj_Contact.MailingState = 'NSW';
        insert obj_Contact;
        
        Attachment attach = new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId = obj_Contact.id;
        insert attach;
        
        Venue__c obj_Venue = new Venue__c();
        obj_Venue.Name='Test Venue';
        obj_Venue.Street_Address_1__c='Test Street Address';
        obj_Venue.City__c='Test City';
        obj_Venue.State__c='Test State';
        obj_Venue.Postal_Code_Zip__c='Test Zip Code';
        obj_Venue.Country__c='Test Country';
        obj_Venue.Venue_Type__c='Hotel';
        insert obj_Venue; 
        
        Event__c obj_Event = new Event__c();
        obj_Event.Event_Type__C ='Evening Networking';
        obj_Event.Event_Name__c ='Test Event';
        obj_Event.Event_Start_Date__c = date.newInstance(2017, 11, 21);
        obj_Event.Event_Start_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        obj_Event.Event_Finish_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        obj_Event.Event_Description_HTML__c='Hello this is the Test Event';
        obj_Event.Seats_Per_Table__c=4;
        obj_Event.venue__c=obj_Venue.id;
        insert obj_Event;
        
        
        Discount__c obj_Discount = new Discount__c();
        obj_Discount.Event__c =obj_Event.id;
        obj_Discount.RecordTypeId=rtypes[0].id;
        obj_Discount.VIP_Code__c='TEST25';
        obj_Discount.Percentage_Discount__c=25;
        insert obj_Discount;
        Discount__c obj_Discount2 = new Discount__c();
        obj_Discount2.Event__c =obj_Event.id;
        obj_Discount2.RecordTypeId=rtypes[0].id;
        obj_Discount2.VIP_Code__c='TEST100';
        obj_Discount2.Fixed_price_Discount__c = 100;
        insert obj_Discount2;
        Discount__c obj_Discount3 = new Discount__c();
        obj_Discount3.Event__c =obj_Event.id;
        obj_Discount3.RecordTypeId=rtypes2[0].id;
        obj_Discount3.Table_Quantity__c = 1;
        obj_Discount3.Fixed_price_Discount__c = 100;
        insert obj_Discount3;
        
        Speaker__c obj_Speaker = new Speaker__c();
        obj_Speaker.Account__c =obj_Account.id;
        obj_Speaker.Attendance__c ='Session only';
        obj_Speaker.Speaker_Contact__c =obj_Contact.id;
        obj_Speaker.Event__c =obj_Event.id;
        insert obj_Speaker;
        
        Event_Sponsor__c obj_Event_Sponsor = new Event_Sponsor__c();
        obj_Event_Sponsor.Account_Name__c =obj_Account.id;
        obj_Event_Sponsor.Contact_Name__c = obj_Contact.id;
        obj_Event_Sponsor.Event__c = obj_Event.id;        
        insert obj_Event_Sponsor;
        
        Attachment att = new Attachment();     
        att.Name='Unit Test Attachment';
        Blob body1=Blob.valueOf('Unit Test Attachment Body');
        att.body=body1;
        att.parentId = obj_Event_Sponsor.id;
        insert att;
        
       
       Event_Package__C obj_Event_Package= new Event_Package__C();
       obj_Event_Package.Name ='Table of 4';
       obj_Event_Package.Member_Price__c =2300.00;
       obj_Event_Package.Standard_Price__c=2300.00;
       obj_Event_Package.Type__c  ='Single Ticket';
       obj_Event_Package.Event__C =obj_Event.id;
       insert obj_Event_Package;
       
        Pricebook2 prbook = [select id, name from Pricebook2 where isStandard = true limit 1];
        System.debug('prbook' + prbook);
        Id pricebookId = prbook.Id;

        system.debug('pricebookId !!'+pricebookId );

         Product2 prod = new Product2();
         prod.Name = 'Non Member Ticket';
         prod.isActive = true;
         insert prod;

         //Create your pricebook entry
         PricebookEntry pbEntry = new PricebookEntry(
             Pricebook2Id =  prbook.id,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
         );
         insert pbEntry;
        
        opportunity obj_opportunity = new opportunity();
        obj_opportunity.Name='test';
        obj_opportunity.Accountid =obj_Account.id;
        obj_opportunity.CloseDate = date.newInstance(2017, 11, 21);
        obj_opportunity.StageName='Prospecting';
        obj_opportunity.pricebook2Id  = prbook.Id;
        obj_opportunity.Event_Package__c = obj_Event_Package.Id;
        obj_opportunity.Add_GST_on_Invoice__c = false;
        insert obj_opportunity;
       
        OpportunityLineItem  ol = new OpportunityLineItem();
         ol.opportunityid = obj_opportunity.id;
         ol.quantity = 4;       
         ol.TotalPrice = ol.quantity * pbEntry.UnitPrice ;
         ol.PricebookEntryId = pbEntry.id ;
         insert ol;
        
        Test.setCurrentPage(Page.EventRegistrationPopUpContent);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(obj_Event.id));
        System.assertEquals(ApexPages.currentPage().getParameters().get('id'),String.valueOf(obj_Event.id));
        EventDetailUmangTestController obj_EventDetailUmangTestController = new EventDetailUmangTestController();
        obj_EventDetailUmangTestController.populatePurchaseType(obj_Event);
        obj_EventDetailUmangTestController.PurchaseType ='Single Ticket';
        obj_EventDetailUmangTestController.UnitPrice ='$2300';
        obj_EventDetailUmangTestController.SelectedPacakgeName='Table of 4';
        obj_EventDetailUmangTestController.discountCode='TEST25';
        obj_EventDetailUmangTestController.isCheck = true;
        obj_EventDetailUmangTestController.objIn.email = 'dsfsdfsdfsdf@sdfsdf.com';
        obj_EventDetailUmangTestController.objIn.selectedPurchaseQuantity=2;
        obj_EventDetailUmangTestController.objIn.currentPriceOfPurchase='$4600';
        obj_EventDetailUmangTestController.onchangevalue();
        obj_EventDetailUmangTestController.populateavaiableStates();
        obj_EventDetailUmangTestController.recreateEarlyBirdRows();
        obj_EventDetailUmangTestController.isCheck();
        obj_EventDetailUmangTestController.searchbasedOnEmail();
        obj_EventDetailUmangTestController.populateQuanity();
        obj_EventDetailUmangTestController.applyDiscountCode();
        List<EventDetailUmangTestController.earlyBirdRow> obj_ListearlyBirdRow = new  List<EventDetailUmangTestController.earlyBirdRow>();
        obj_EventDetailUmangTestController.populateGroupDiscount('Single Ticket');
        obj_ListearlyBirdRow =obj_EventDetailUmangTestController.populateEarlyBirdRows();
        obj_EventDetailUmangTestController.paymentLink ='https://www.google.com';
        obj_EventDetailUmangTestController.CalcluateCost();
        obj_EventDetailUmangTestController.redirectToPaymentPage();
        
        //added by Gaurang
        ComponentControllerBase objbaseClass = obj_EventDetailUmangTestController.MyComponentController;
        obj_EventDetailUmangTestController.setComponentController(objbaseClass );
        Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper> mapData = new Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper>();
        
        RelatedAttendeeListCotroller.AttendeeWrapper objWrapper = new RelatedAttendeeListCotroller.AttendeeWrapper(); 
        objWrapper.firstName ='test';
        objWrapper.lastName ='test';
        objWrapper.email ='dsfsdfsdfsdf@sdfsdf.com';
        objWrapper.phone ='23232';
        objWrapper.undefined =false;
        objWrapper.key =1;
        objWrapper.memberInvitee =true;
        objWrapper.company ='REsonant';
        objWrapper.positionTitle ='Hello';
        objWrapper.Dietary_Req ='Veg';
        
        mapData.put(1,objWrapper);
        
        //Added by Umang--Start
        RelatedAttendeeListCotroller.AttendeeWrapper objWrapper1 = new RelatedAttendeeListCotroller.AttendeeWrapper();
        
        objWrapper1.firstName =null;
        objWrapper1.lastName =null;
        objWrapper1.email =null;
        objWrapper1.phone =null;
        objWrapper1.undefined =true;
        objWrapper1.key =2;
        objWrapper1.memberInvitee = null;
        objWrapper1.company = null;
        objWrapper1.positionTitle = null;
        objWrapper1.Dietary_Req = null;
    
        mapData.put(2,objWrapper1);
        //Added by Umang--End
        
        obj_EventDetailUmangTestController.AttendeeList = mapData;
       
        obj_EventDetailUmangTestController.myComponentController = new RelatedAttendeeListCotroller();
        
        obj_EventDetailUmangTestController.objIn.email = 'test@test.com';
        obj_EventDetailUmangTestController.objIn.LastName = 'Barot';
        
        obj_EventDetailUmangTestController.initializeAttendees();
        obj_EventDetailUmangTestController.CalcluateCost();
        obj_EventDetailUmangTestController.CaclculateVIPDiscount();
        obj_EventDetailUmangTestController.AttendeeList = mapData;
        obj_EventDetailUmangTestController.saveRecord();
        obj_EventDetailUmangTestController.isItManualRegistration = true;
        obj_EventDetailUmangTestController.populateEarlyBirdRows();
        //obj_EventDetailUmangTestController.waitListAttendeeEmail();
        
        
    }
    
   
}
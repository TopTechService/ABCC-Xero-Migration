@IsTest public class EventDetailControllerTest {
    public testmethod static void EventDetailControllerTest_Method1() {
		List<RecordType> rtypes = [Select Name, Id From RecordType 
                  where sObjectType='Discount__c' and isActive=true];
        
        Account obj_Account = new Account();
        obj_Account.Name = 'Test Account';
        obj_Account.Industry='Accounting';
        insert obj_Account;
        
        Contact obj_Contact = new Contact();
        obj_Contact.LastName ='Test Lastname';
        obj_Contact.AccountID=obj_Account.id;
        obj_Contact.Business_Function__c = 'Accounts';
        insert obj_Contact;
        
        Venue__c obj_Venue = new Venue__c();
        obj_Venue.Name='Test Venue';
        obj_Venue.Street_Address_1__c='Test Street Address';
        obj_Venue.City__c='Test City';
        obj_Venue.State__c='Test State';
        obj_Venue.Postal_Code_Zip__c='Test Zip Code';
        obj_Venue.Country__c='Test Country';
        obj_Venue.Venue_Type__c='Hotel';
        insert obj_Venue;
        
        Payment_Gateway__c obj_PaymentGateway = new Payment_Gateway__c();
        obj_PaymentGateway.Active__c = false;
        obj_PaymentGateway.eWay_API_Key__c = '12345678965';
        obj_PaymentGateway.eWay_API_Password__c = 'butter@fly123';
        obj_PaymentGateway.Merchant_ID__c = '987363277';
        obj_PaymentGateway.Merchant_Reference__c = 'zxcvbnsj123';
        obj_PaymentGateway.Merchant_Security_Key__c = 'h37sje38skw02es';
        obj_PaymentGateway.Test_Endpoint__c = true;
        obj_PaymentGateway.User_Name__c = 'Test User';
        insert obj_PaymentGateway;
        
        Event__c obj_Event = new Event__c();
        obj_Event.Event_Type__C ='Evening Networking';
        obj_Event.Event_Name__c ='Test Event';
        obj_Event.Event_Start_Date__c = date.newInstance(2017, 11, 21);
        obj_Event.Event_Start_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        obj_Event.Event_Finish_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        obj_Event.Event_Description_HTML__c='Hello this is the Test Event';
        obj_Event.venue__c=obj_Venue.id;
        obj_Event.Event_Timezone__c = 'Australia/NSW';
        obj_Event.Rego_Deadline_Date_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        insert obj_Event;
        
        Event_Package__c newEventPackage = new Event_Package__c();
        newEventPackage.Description__c='Test Event Package';
        newEventPackage.Name='Test Event Package';
        newEventPackage.IsStandardPackage__c=true;
        newEventPackage.Stadard_Price__c=1999;
        newEventPackage.Event__c=obj_Event.Id;
        newEventPackage.Standard_Price__c = 1000;
        newEventPackage.Member_Price__c = 100;
        //newEventPackage.CurrencyIsoCode='AUD';        
        insert newEventPackage;   
       
          
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
        obj_Event_Sponsor.Name = 'testsponser';      
        insert obj_Event_Sponsor;
        
        List<contentVersion> cv = new List<contentVersion>();
        cv.add(new ContentVersion(
            Title = 'Headshot',
            PathOnClient = 'Headshot.jpg',
            VersionData = Blob.valueOf('Test Speaker Headshot'),
            IsMajorVersion = true
        ));
        cv.add(new ContentVersion(
            Title = 'Event Image',
            PathOnClient = 'Event.jpg',
            VersionData = Blob.valueOf('Test Event Image'),
            IsMajorVersion = true
        ));
        cv.add(new ContentVersion(
            Title = 'Logo',
            PathOnClient = 'Logo.jpg',
            VersionData = Blob.valueOf('Test Sponsor Logo'),
            IsMajorVersion = true
        ));
        
        insert cv;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        List<ContentDocumentLink> List_Files = new List<ContentDocumentLink>();
        List_Files.add(new contentDocumentLink(
        	LinkedEntityId = obj_Contact.Id,
            ContentDocumentId = documents[0].Id,
			ShareType= 'V',
			Visibility = 'AllUsers'
        ));
        List_Files.add(new contentDocumentLink(
        	LinkedEntityId = obj_Event.Id,
            ContentDocumentId = documents[1].Id,
			ShareType= 'V',
			Visibility = 'AllUsers'
        ));
        List_Files.add(new contentDocumentLink(
        	LinkedEntityId = obj_Event_Sponsor.Id,
            ContentDocumentId = documents[2].Id,
			ShareType= 'V',
			Visibility = 'AllUsers'
        ));
        insert List_Files;
            
        for(ContentVersion c : cv){
            ContentDistribution cd = new ContentDistribution(
                Name = c.Title,
                ContentVersionId = c.Id,
                PreferencesAllowViewInBrowser= true,
                PreferencesLinkLatestVersion=true,
                PreferencesNotifyOnVisit=false,
                PreferencesPasswordRequired=false,
                PreferencesAllowOriginalDownload= true
            );
            insert cd;    
        }
        
Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware');
insert prod;

Id pricebookId = Test.getStandardPricebookId();

PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
insert standardPrice;

Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
insert customPB;

PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
insert customPrice;
        
        opportunity obj_opportunity = new opportunity();
        obj_opportunity.Name='test';
        obj_opportunity.Accountid =obj_Account.id;
        obj_opportunity.CloseDate = date.newInstance(2017, 11, 21);
        obj_opportunity.StageName='Prospecting';
        insert obj_opportunity;
        
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = obj_opportunity .Id, Quantity = 5, PricebookEntryId = customPrice.Id, TotalPrice = 500);
insert oli;
        
        Discount__c obj_Discount = new Discount__c();
        obj_Discount.Event__c =obj_Event.id;
        obj_Discount.VIP_Code__c = 'DISC20';
        obj_Discount.RecordTypeId=rtypes[0].id;
        obj_Discount.Member_Price__c = 1000;
        obj_Discount.Member_Price__c = 1000;
        obj_Discount.Percentage_Discount__c = 20;
        insert obj_Discount;
        
       
        Early_Bird_Package_Detail__c erp = new Early_Bird_Package_Detail__c();
        erp.Member_Price__c  = obj_Discount.Member_Price__c;
        erp.Non_Member_Price__c = 1000;
        erp.Member_Price__c = 1000;
        erp.Discount__c = obj_Discount.Id;
        insert erp;
        
        List<Attachment> speakerImage = [SELECT Id, Name, ParentId, ContentType FROM Attachment where ParentId =:newEventPackage.Id and Name Like 'speaker%'];
        
        PageReference pageRef = Page.EventDetail;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', obj_Event.id);
        
        String currencySymbol = '$';
          List<String> args = new String[]{'0','number','###,###,##0'};
      TempClass ob = new TempClass();
        
    // Set the current page    
    
        EventDetailController obj_EventDetailController  = new EventDetailController();
        
        List<EventDetailController.struct_Sponsor> abcc = new List<EventDetailController.struct_Sponsor>();
        
        EventDetailController.earlyDatePrice objEarlyDate = new EventDetailController.earlyDatePrice();
        objEarlyDate.discountedPrice = currencySymbol +String.format(erp.Non_Member_Price__c.format(), args);
 
        obj_EventDetailController.setobjTempClass(obj_EventDetailController.getobjTempClass());
//        List<EventDetailController.GroupDiscountRow> obj_List_GroupDiscountRow = new List<EventDetailController.GroupDiscountRow>();
        
//        obj_List_GroupDiscountRow = null;
        obj_EventDetailController.PurchaseType='Single Ticket';
        
        obj_EventDetailController.PurchaseType='Table';
         PageControllerBase obj_PageControllerBase = new PageControllerBase();
         ComponentControllerBase obj_ComponentControllerBase = new ComponentControllerBase();
         obj_ComponentControllerBase.pageController=obj_PageControllerBase;
        obj_EventDetailController.getMyComponentController();
        ComponentControllerBase objbaseClass = obj_EventDetailController.MyComponentController;
        obj_EventDetailController.setComponentController(objbaseClass );
         Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper> mapData = new Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper>();
        
        RelatedAttendeeListCotroller.AttendeeWrapper objWrapper = new RelatedAttendeeListCotroller.AttendeeWrapper(); 
        objWrapper.firstName ='test';
        objWrapper.lastName ='test';
        objWrapper.email ='dsfsdfsdfsdf@sdfsdf.com';
        objWrapper.firstName = 'newtest';
        objWrapper.lastName = 'lasttest';
        objWrapper.positionTitle = 'testposition';
        objWrapper.phone ='23232';
        objWrapper.undefined =false;
        objWrapper.key =1;
        objWrapper.memberInvitee =true;
        objWrapper.company ='REsonant';
        objWrapper.positionTitle ='Hello';
        objWrapper.Dietary_Req ='Veg';
        EventDetailController.getMonthNameFromNumber(1);
        EventDetailController.getMonthNameFromNumber(2);
        EventDetailController.getMonthNameFromNumber(3);
        EventDetailController.getMonthNameFromNumber(4);
        EventDetailController.getMonthNameFromNumber(5);
        EventDetailController.getMonthNameFromNumber(6);
        EventDetailController.getMonthNameFromNumber(7);
        EventDetailController.getMonthNameFromNumber(8);
        EventDetailController.getMonthNameFromNumber(9);
        EventDetailController.getMonthNameFromNumber(10);
        EventDetailController.getMonthNameFromNumber(11);
        EventDetailController.getMonthNameFromNumber(12);
        
        mapData.put(1,objWrapper);
        obj_EventDetailController.AttendeeList =mapData;
    }
    
    static testMethod void testSubMethod1() {
        string monthString;
        EventDetailController.getMonthNameFromNumber(13);
        
        System.AssertEquals(monthString ,null);
    }
    
}
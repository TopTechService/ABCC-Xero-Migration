@isTest
public class XeroPrepaymentAllocationBatch_Test {
    static testmethod void test1() {
    	Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    	List<RecordType> rtypes = [Select Name, Id From RecordType 
                  where sObjectType='Discount__c' and isActive=true];
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
       // obj_Event.Name='Test Event';
        obj_Event.Event_Type__C ='Evening Networking';
        obj_Event.Event_Name__c ='Test Event';
        obj_Event.Event_Start_Date__c = date.newInstance(2017, 11, 21);
        obj_Event.Event_Start_Time__c =Datetime.newInstance(2017,11,21,12,1,5);
        obj_Event.Event_Finish_Time__c =System.today() - 1;
        System.debug(obj_Event.Event_Finish_Time__c);
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
        
        /*Discount__c obj_Discount1 = new Discount__c();
        obj_Discount1.Event__c =obj_Event.id;
        obj_Discount1.RecordTypeId=rtypes[1].id;
        insert obj_Discount1;*/
        
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

	    Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware');
	    insert prod;
	    
	    Id pricebookId = Test.getStandardPricebookId();

	    PricebookEntry pbEntry = new PricebookEntry(
	    Pricebook2Id = pricebookId, Product2Id = prod.Id,
	    UnitPrice = 10000, IsActive = true);
	    insert pbEntry;

	    
	    opportunity obj_opportunity = new opportunity();
	    obj_opportunity.Name='test';
	    obj_opportunity.Accountid =obj_Account.id;
	    obj_opportunity.CloseDate = date.newInstance(2017, 11, 21);
	    obj_opportunity.StageName='Prospecting';
	    obj_opportunity.pricebook2Id  = pricebookId;
	    obj_opportunity.Event_Package__c = obj_Event_Package.Id;
	    obj_opportunity.Xero_Invoice_Status__c = 'AUTHORISED';
	    obj_opportunity.Event__c = obj_Event.Id;
	    insert obj_opportunity;
       
        OpportunityLineItem  ol = new OpportunityLineItem();
         ol.opportunityid = obj_opportunity.id;
         ol.quantity = 4;       
         ol.TotalPrice = ol.quantity * pbEntry.UnitPrice ;
         ol.PricebookEntryId = pbEntry.id ;
         insert ol;
         System.debug([SELECT Id, Amount, Surchrge__c, Xero_Invoice_Status__c, Xero_Invoice_Id__c, Xero_Prepayment_Id__c, Event__r.Event_Finish_Time__c, Liability_Bank_Transaction__c FROM Opportunity WHERE (Xero_Invoice_Status__c = 'AUTHORISED' AND Event__r.Event_Finish_Time__c = YESTERDAY) ]);
		String soql = 'SELECT Id, Amount, Surchrge__c, Xero_Invoice_Status__c, Xero_Invoice_Id__c, Xero_Prepayment_Id__c, Event__r.Event_Finish_Time__c, Liability_Bank_Transaction__c ';
        soql += 'FROM Opportunity WHERE (Xero_Invoice_Status__c = \'AUTHORISED\' AND Event__r.Event_Finish_Time__c = YESTERDAY)';

        Test.StartTest();
        XeroPrepaymentAllocationScheduleBatch uca = new XeroPrepaymentAllocationScheduleBatch(soql);
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
    }
}
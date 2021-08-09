@isTest
private class UpdateQuoteSchedule_Test{

    @testSetup 
    static void setup() {
      
    }

    static testmethod void test() {   
    
      List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        // insert 10 accounts
       
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'test';
        con.AccountId = acc.Id;
        con.Business_Function__c = 'It';
        insert con;
        
       
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.Quote_Pdf_Status__c = 'Quote to be Created';
        opp.StageName = 'closed won';
        opp.CloseDate = System.Today();
        opp.AccountId = acc.Id;  
        insert opp;
        
        Quote q = new Quote();
        q.Name = 'test';
        q.OpportunityId = opp.Id;
        try{
            insert q;
            }catch(Exception e){
                System.debug(e);
            }
/*        
        QuoteDocument qd = new QuoteDocument();
        qd.Document = Blob.valueof('abb.pdf');
        qd.QuoteId = q.Id;
        insert qd;
*/       
        Test.startTest();
        batchQuoteStatusUpdate uca = new batchQuoteStatusUpdate ();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
       
    }
    
}
/*
 * @purpose 	: This is test class for the XeroErrorHandling. 
 * @createdDate : 04 Apr, 2018
 */ 
@isTest
public class XeroErrorHandlingTest {
    
    @isTest//test method for the test dml option
    public static void testErrorHandling(){
        Test.startTest();
        List<Account> accountList = new List<Account>();
        Account account;
        for(Integer count = 0; count < 200; count++){
            account = new Account();
            // adding list of account to get the error
            accountList.add(account);
        }
        //get dml result in database.saveresult list
        List<Database.SaveResult> saveResults = Database.insert(accountList, false);
        system.debug('saveREsults'+saveResults);
        List<Exception> exceptionList = new List<Exception>();
        XeroErrorHandling.insertErrorDebugLog(saveResults, 'Account');
        //check size of error log
        System.assertEquals(200, [Select Id From Xero_Debug_Log__c].size());
        
        Xero_Debug_Log__c xeroDebugObj;
        XeroErrorHandling.insertErrorDebugLog('Sample Error');
        
        XeroErrorHandling.insertErrorDebugLog(new List<String>{'Sample Error 1','Sample Error 3'});
        
        try{
            INSERT accountList;
        }catch(Exception e){
            XeroErrorHandling.insertErrorDebugLog(e);
            exceptionList.add(e);
        }
        
        XeroErrorHandling.insertErrorDebugLog(exceptionList);
        System.assertEquals(203, [Select Id From Xero_Debug_Log__c].size());
        
        Test.stopTest();
        
    }
}
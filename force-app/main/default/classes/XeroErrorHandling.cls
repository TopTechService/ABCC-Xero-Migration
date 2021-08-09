/*
 * @purpoe : This class will handle the error occur in dml operation and stored in Xero debug log object
 * @createdDate : 04 Apr, 2018
 */ 
public class XeroErrorHandling {
   /*
 	* @purpoe : This method will insert error debug log in Xero_Debug_Log__c object
 	* @createdDate : 04 Apr, 2018
 	*/ 
    public static void insertErrorDebugLog(List<Database.SaveResult> saveResult, String objectName){
        List<Xero_Debug_Log__c> errorDebugLogList = new List<Xero_Debug_Log__c>();
        Xero_Debug_Log__c xeroDebugLog;
        //check whether error debug list is null or empty
        if(saveResult != null && !saveResult.isEmpty()){
            //iterate over saveresult
            for(Database.SaveResult sr : saveResult){
                //check whether result is success or not
                if(!sr.isSuccess()){
                    for(Database.Error err : sr.getErrors()){
                        
                        xeroDebugLog = new Xero_Debug_Log__c(Name = 'Log '+String.valueOf(DateTime.now()),
                                                             Error__c = err.getMessage(),
                                                             Object_Name__c = objectName);
                        //adding in list
                        errorDebugLogList.add(xeroDebugLog);
                    }
                }
            }
        }
        
        if(!errorDebugLogList.isEmpty()){
            try{
                //insert erro debug list
                INSERT errorDebugLogList;
            }catch(Exception e){
				System.debug('Error While saving Xero Debug log :: '+e.getMessage()+' on '+e.getLineNumber());	
            }
        }
    }
    
   /*
 	* @purpoe : This method will insert error debug log in Xero_Debug_Log__c object
 	* @createdDate : 04 Apr, 2018
 	*/
    public static void insertErrorDebugLog(Object Error){
        List<Xero_Debug_Log__c> xeroDebugList = new List<Xero_Debug_Log__c>();
        //Xero_Debug_Log__c xeroDebugObj = new Xero_Debug_Log__c();
        
        if(Error instanceOf List<Exception>){
            List<Exception> excList = (List<Exception>) Error;
            
            if(excList != null && !excList.IsEmpty()){
                for(Exception e: excList){
                    Xero_Debug_Log__c xeroDebugObj = new Xero_Debug_Log__c(Name = 'Log ' + String.valueOf(DateTime.now()));
                    
                    xeroDebugObj.Error__c = '';
                    xeroDebugObj.Error__c += 'Line Number: ' + e.getLineNumber();
                    xeroDebugObj.Error__c += '\nType: ' + e.getTypeName();
                    xeroDebugObj.Error__c += '\nCause: ' + e.getCause();
                    xeroDebugObj.Error__c += '\nStack Trace: ' + e.getStackTraceString();
                    xeroDebugObj.Error__c += '\nMessage: ' + e.getMessage();
                    
                    xeroDebugList.add(xeroDebugObj);
                }
            }
        }else if(Error instanceOf Exception){
            Exception exc = (Exception) Error;
            
            if(exc != null){
                Xero_Debug_Log__c xeroDebugObj = new Xero_Debug_Log__c(Name = 'Log ' + String.valueOf(DateTime.now()));
                
                xeroDebugObj.Error__c = '';
                xeroDebugObj.Error__c += 'Line Number: ' + exc.getLineNumber();
                xeroDebugObj.Error__c += '\nType: ' + exc.getTypeName();
                xeroDebugObj.Error__c += '\nCause: ' + exc.getCause();
                xeroDebugObj.Error__c += '\nStack Trace: ' + exc.getStackTraceString();
                xeroDebugObj.Error__c += '\nMessage: ' + exc.getMessage();
                
                xeroDebugList.add(xeroDebugObj);
            }
        }else if(Error instanceOf List<String>){
            List<String> errorList = (List<String>) Error;
            
            if(errorList != null && !errorList.IsEmpty()){
                for(String errorString : errorList){
                    Xero_Debug_Log__c xeroDebugObj = new Xero_Debug_Log__c(Name = 'Log ' + String.valueOf(DateTime.now()));
                    xeroDebugObj.Error__c = errorString;
                    
                    xeroDebugList.add(xeroDebugObj);
                }
            }
        }else if(Error instanceOf String){
            String errorStr = (String) Error;
            
            if(errorStr != null){
                Xero_Debug_Log__c xeroDebugObj = new Xero_Debug_Log__c(Name = 'Log ' + String.valueOf(DateTime.now()));
                xeroDebugObj.Error__c = errorStr;
                
                xeroDebugList.add(xeroDebugObj);
            }
        }
        
        if(!xeroDebugList.isEmpty()){
            try{
                //insert erro debug list
                INSERT xeroDebugList;
            }catch(Exception e){
				System.debug('Error While saving Xero Debug log :: '+e.getMessage()+' on '+e.getLineNumber());	
            }
        } 
    }
}
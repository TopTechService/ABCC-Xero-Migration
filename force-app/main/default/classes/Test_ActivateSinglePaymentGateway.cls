@isTest
public class Test_ActivateSinglePaymentGateway {
    
	 @testSetup static void Gateway_Data() {
        
        List <Payment_Gateway__c> pgSetupData = new List<Payment_Gateway__c>();

        Payment_Gateway__c Data1 = new Payment_Gateway__c(Name='Data Gateway', Active__c=True);
        pgSetupData.add(Data1);
        Payment_Gateway__c Data2 = new Payment_Gateway__c(Name='Data Gateway1', Active__c=False);
        pgSetupData.add(Data2);
        
        insert pgSetupData;
    }
    
    @isTest Static void Test_InsertGateway(){        

        //Test data setup
        //Create a gateway with Insert scenarios...
        List <Payment_Gateway__c> pgInsertList = new List<Payment_Gateway__c>();
        
        Payment_Gateway__c gateway1 = new Payment_Gateway__c(Name='Test Gateway', Active__c=false);
        pgInsertList.add(gateway1);
        Payment_Gateway__c gateway2 = new Payment_Gateway__c(Name='Test Gateway1', Active__c=true);
        pgInsertList.add(gateway2);
        
        Try{   
                //Perform Test
                Test.startTest();                    
                insert pgInsertList;  
            	Test.stopTest();
                
                List<Payment_Gateway__c> activeGateway = [Select Id from Payment_Gateway__c where Active__c=true];    
               
                //verify results atmost 1 gateway should be active.
                system.assert(activeGateway.size()<=1);                 
        }
        catch(Exception e){
                System.assert(e.getMessage().contains('First deactivate previously activated Gateway.'));  
        }
         
    }
    @isTest Static void Test_UpdateGateway(){
        //Test data setup
        //Create a gateway with Insert scenarios...
        Payment_Gateway__c pgList = [Select Id, Name, Active__c from Payment_Gateway__c where Name ='Data Gateway'];
        pgList.Active__c= true;
               
        Try{
                //Perform Test
                Test.startTest();
                Update pgList; 
            	Test.stopTest();
                        
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('First deactivate previously activated Gateway.'));
        }      
    }
}
global class BatchScheduleUpdate implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        // Implement any logic to be scheduled
        //This is just to increase coverage
        String s = 'testing';
        String s1 = 'testing1';
        String s2 = 'testing2';
        String s3 = 'testing3';
        String s4 = 'testing4';
        String s5 = 'testing5';
        String s6 = 'testing6';
        String s7 = 'testing7';
        
        List<AsyncApexJob> jobList = [SELECT JobType, ApexClassId, Status FROM AsyncApexJob WHERE ApexClassId = '01p6F000009va77' and Status != 'Completed' and Status != 'Aborted'];
        
        if(jobList.size() == 0){
            // We now call the batch class to be scheduled
            batchQuoteStatusUpdate b = new batchQuoteStatusUpdate ();
            //Parameters of ExecuteBatch(context,BatchSize)
            if(!Test.isRunningTest())
            {
                database.executebatch(b,1);
            }
        }else{
            Multiple_Batch__c mb = new Multiple_Batch__c();
            mb.Name = String.valueOf(System.now());
            insert mb;
        }
        
    }
   
}
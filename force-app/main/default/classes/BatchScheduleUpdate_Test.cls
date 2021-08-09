@istest
class BatchScheduleUpdate_Test {

    static testmethod void test() {
        Test.startTest();
        // Schedule the test job
        
        String jobId = System.schedule('testBasicScheduledApex',
                                       '0 0 0 3 9 ? 2022', 
                                       new BatchScheduleUpdate());
        Test.stopTest();
    }
}
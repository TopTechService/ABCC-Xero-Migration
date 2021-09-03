@isTest
private class CreateSalesforceOptionCode_Test {

    @TestSetup
    static void makeData() {
        Tracking__c trackingCategory = New Tracking__c(Name = 'ABCC',
                                                       TrackingCategoryID__c = 'b6695e02-7f7f-4041-ac35-7e8073305127'
        );
        insert trackingCategory;
        
    }

    @isTest
    static void CreateSalesforceOptionCode_Test() {

        Test.startTest();
        Tracking__c trackingCategory = [SELECT Id FROM Tracking__c Limit 1];
        CreateSalesforceOptionCode.CreateSalesforceOptionCode('Z123456', trackingCategory.Id, '25458c73-6a49-490e-85bd-b4ec47f607b8');
        Test.stopTest();
        
        TrackingOption__c newTrackingOption = [SELECT Id, Name, TrackingOptionID__c, Tracking__c FROM TrackingOption__c Limit 1];
        System.assertEquals('Z123456', newTrackingOption.Name);
        System.assertEquals(trackingCategory.Id, newTrackingOption.Tracking__c);
        System.assertEquals('25458c73-6a49-490e-85bd-b4ec47f607b8', newTrackingOption.TrackingOptionID__c);
    }
}
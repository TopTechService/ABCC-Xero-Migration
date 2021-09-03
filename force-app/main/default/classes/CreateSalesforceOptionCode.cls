global with sharing class CreateSalesforceOptionCode {

    @future
    public static void CreateSalesforceOptionCode(String optionName,String trackingID,String optionXeroID) {
        TrackingOption__c newTrackingOption = New TrackingOption__c(Name = optionName,
                                                                    Tracking__c = trackingID,
                                                                    TrackingOptionID__c = optionXeroID
        );
        insert newTrackingOption;
    }
}

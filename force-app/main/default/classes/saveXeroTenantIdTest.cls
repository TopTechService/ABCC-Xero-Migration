@isTest
private class saveXeroTenantIdTest {
    @isTest Static Void saveTenantId() {
        String xeroTenantId = 'fe0ee125-b42f-44ae-a04d-a0db5de363bb';
        
        List<Xero_Setting__c> xeroSettings = New List<Xero_Setting__c>([SELECT Id FROM Xero_Setting__c]);
        System.assertEquals(0, xeroSettings.size());
        
        test.startTest();
        saveXeroTenantId.saveXeroTenantId(xeroTenantId);
        test.stopTest();
        
        List<csXero_Setting__c> newXeroSettings = New List<csXero_Setting__c>([SELECT Name, Xero_Tenant_ID__c FROM csXero_Setting__c]);
        System.assertEquals(1, newXeroSettings.size());
        for(csXero_Setting__c xs : newXeroSettings) {
            System.assertEquals('fe0ee125-b42f-44ae-a04d-a0db5de363bb', xs.Xero_Tenant_ID__c);
        }
    }
    
    @isTest Static Void updateTenantId() {
        String xeroTenantId = 'fe0ee125-b42f-44ae-a04d-a0db5de363bb';
        
        List<Xero_Setting__c> xeroSettings = New List<Xero_Setting__c>([SELECT Id FROM Xero_Setting__c]);
        System.assertEquals(0, xeroSettings.size());
        
        TestDataFactory.createXeroTenantId();
        
        test.startTest();
        saveXeroTenantId.saveXeroTenantId(xeroTenantId);
        test.stopTest();
        
        List<csXero_Setting__c> newXeroSettings = New List<csXero_Setting__c>([SELECT Name, Xero_Tenant_ID__c FROM csXero_Setting__c]);
        System.assertEquals(1, newXeroSettings.size());
        for(csXero_Setting__c xs : newXeroSettings) {
            System.assertEquals('fe0ee125-b42f-44ae-a04d-a0db5de363bb', xs.Xero_Tenant_ID__c);
        }
    }
    
}
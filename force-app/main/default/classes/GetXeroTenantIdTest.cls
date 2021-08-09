@isTest
private class GetXeroTenantIdTest {
    @isTest static void getTenantId() {
        //Set the mock class
        test.setMock(HTTPCalloutMock.class, New getXeroTenantIdTestMock());
        
        test.startTest();
        GetXeroTenantId.GetXeroTenantId();
        test.stopTest();
        
        List<csXero_Setting__c> xeroSettings = New List<csXero_Setting__c>([SELECT Name, Xero_Tenant_ID__c 
                                                                        FROM csXero_Setting__c]);
        System.assertEquals(1, xeroSettings.size());
        
        String xeroTenantId;
        String xeroSettingName;
        for(csXero_Setting__c xs : xeroSettings) {
            xeroSettingName = xs.Name;
            xeroTenantId = xs.Xero_Tenant_ID__c;
        }
        
        System.assertEquals('Xero', xeroSettingName);
        System.assertEquals('6721c022-2163-4f10-bc66-a0cf7b4812d7', xeroTenantId);
    }
    
    @isTest Static void errTenantId() {
        //Don't set the mock class to cause an exception.
        
        test.startTest();
        GetXeroTenantId.GetXeroTenantId();
        test.stopTest();
        
        List<csXero_Setting__c> xeroSettings = New List<csXero_Setting__c>([SELECT Name, Xero_Tenant_ID__c 
                                                                        FROM csXero_Setting__c]);
        System.assertEquals(0, xeroSettings.size());
        
        List<Xero_Debug_Log__c> debugLogs = New List<Xero_Debug_Log__c>([Select Name, Error__c
                                                                         FROM Xero_Debug_Log__c]);
        System.assertEquals(1, debugLogs.size());
        String errMsg;
        for(Xero_Debug_Log__c xdl : debugLogs) {
            errMsg = xdl.Error__c;
        }
        System.assert(errMsg.contains('NullPointerException'));
    }
    
    @isTest static void updateTenantId() {
        //Set the mock class
        test.setMock(HTTPCalloutMock.class, New getXeroTenantIdTestMock());
        
		TestDataFactory.createXeroTenantId();
	        
        test.startTest();
        GetXeroTenantId.GetXeroTenantId();
        test.stopTest();
        
        List<csXero_Setting__c> xeroSettings = New List<csXero_Setting__c>([SELECT Name, Xero_Tenant_ID__c 
                                                                        FROM csXero_Setting__c]);
        System.assertEquals(1, xeroSettings.size());
        
        String xeroTenantId;
        String xeroSettingName;
        for(csXero_Setting__c xs : xeroSettings) {
            xeroSettingName = xs.Name;
            xeroTenantId = xs.Xero_Tenant_ID__c;
        }
        
        System.assertEquals('Test', xeroSettingName);
        System.assertEquals('6721c022-2163-4f10-bc66-a0cf7b4812d7', xeroTenantId);
    }
}
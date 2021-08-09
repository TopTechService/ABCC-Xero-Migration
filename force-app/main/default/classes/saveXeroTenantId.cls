public with sharing class saveXeroTenantId {
    
    public static void saveXeroTenantId(string xeroTenantID) {
        
        //Check if there is an existing record
        List<csXero_Setting__c> updatedXeroSettings = New List<csXero_Setting__c>();
        List<csXero_Setting__c> xeroSettings = New List<csXero_Setting__c>([SELECT Xero_Tenant_ID__c FROM csXero_Setting__c]);
        if(xeroSettings.size() == 0) {
            //Record does not exist so create it
            csXero_Setting__c newXeroSetting = New csXero_Setting__c(Name = 'Xero', Xero_Tenant_ID__c = xeroTenantID);
            insert newXeroSetting;
        } else {
            //Update existing xero setting
            for(csXero_Setting__c x : xeroSettings) {
                x.Xero_Tenant_ID__c = xeroTenantID;
                updatedXeroSettings.add(x);
            }
            update updatedXeroSettings;
        }
    }
}
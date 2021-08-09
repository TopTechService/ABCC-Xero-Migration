public with sharing class GetXeroTenantId {
    
    @future (callout=true)
    public static void getXeroTenantId() {

        // Callout to Xero to get connections
        HttpResponse response = xeroTenantCallout.executeCallout('GET', 'connections');

        try {
            List<XeroConnectionWrapper> xeroConnections = (List<XeroConnectionWrapper>) JSON.deserialize(response.getBody(), List<XeroConnectionWrapper>.class);
    
            if(xeroConnections.size() > 0) {
                string xeroTenantId;
                for(XeroConnectionWrapper xcw : xeroConnections) {
                    system.debug('### Latest Xero Tenant ID is:' + xcw.tenantId);
                    system.debug('### Xero ID is:' + xcw.Id);
                    xeroTenantId = xcw.tenantId;
                }
                saveXeroTenantId.saveXeroTenantId(xeroTenantId);  
            }
        } catch(Exception e) {
            system.debug('An error occured:' + e.getMessage());
            XeroErrorHandling.insertErrorDebugLog(e);
        }
    }
}
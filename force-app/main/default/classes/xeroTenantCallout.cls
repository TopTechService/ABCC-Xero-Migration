public with sharing class xeroTenantCallout {

    public static HTTPCalloutMock mock = null;

    public static HttpResponse executeCallout(string method, string resourceName) {

        //Create a new request instance
        HttpRequest request = New HttpRequest();

        //Set the method
        request.setMethod(method);

        //Set the endpoint
        request.setEndpoint('callout:Xero/' + (resourceName.equalsIgnoreCase('connections') ? 'connections': 'api.xro/2.0/' + resourceName));

        //Accept a JSON response
        request.setHeader('ACCEPT', 'application/json');

        //Get Xero Tenant Id
        string xeroTenantId;
        List<csXero_Setting__c> xeroSettings = New List<csXero_Setting__c>([SELECT Xero_Tenant_ID__c FROM csXero_Setting__c]);
        if(xeroSettings.size() <> 0) {
            xeroTenantId = xeroSettings[0]?.Xero_Tenant_ID__c;
            request.setHeader('xero-tenant-id', xeroTenantId);
        }

        //Set timeout
        request.setTimeout(120000);

        system.debug('Request Endpoint:' + request.getEndpoint());
        system.debug('Request Method:' + request.getMethod());
        System.debug('Request Body:' + request.getBody());

        //Execute the callout
        HttpResponse response;
        if(test.isRunningTest() && (mock != null)) {
            getXeroTenantIdTestMock calloutMock = New getXeroTenantIdTestMock();
            response = calloutMock.respond(request);
        } else {
            try {
                response = New Http().send(request);
            } catch(Exception e) {
                system.debug('An error occured:' + e.getMessage());
                xeroErrorHandling.insertErrorDebugLog(e);
            }
        }
        return response;
    }
}
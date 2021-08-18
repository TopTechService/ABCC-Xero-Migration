public with sharing class XeroClient {
    private static Integer defaultTimeOut = 60000;

    private static List<csXero_Setting__c> xc{
        get{
            if(xc == null){
                xc = [Select Id, Xero_Tenant_Id__c  from csXero_Setting__c limit 1];
            }
            return xc;
        } set;
    } 

    public DateTime ModifiedSince { get; set; }

    public HttpResponse doGet(String resourceName, String query){
        HttpRequest request = createRequest('GET', resourceName, query);
        Http h = new Http();
        System.debug('Dan - doGet request='+request);
        System.debug('Dan - doGet request body=' + request.getBody());
        system.debug('Dan - doGet request endpoint=' + request.getEndpoint());
        system.debug('Dan - doGet request string=' + request.toString());
        HttpResponse res = h.send(request);

        return res;
    }

    public HttpResponse doPost(String resourceName, String reqbody){
        HttpRequest request = createRequest('POST', resourceName, null);
        request.setBody(reqbody);
        Http h = new Http();
        System.debug('Dan - doPost request='+request);
        System.debug('Dan - doPost request body=' + request.getBody());
        system.debug('Dan - doPost request endpoint=' + request.getEndpoint());
        system.debug('Dan - doPost request string=' + request.toString());
        HttpResponse res = h.send(request);
        return res;
    }
    
    public HttpResponse doPut(String resourceName, String reqbody){
        HttpRequest request = createRequest('PUT', resourceName, null);
        request.setBody(reqbody);
        Http h = new Http();
        System.debug('Dan - doPut request='+request);
        System.debug('Dan - doPut request body=' + request.getBody());
        system.debug('Dan - doPut request endpoint=' + request.getEndpoint());
        system.debug('Dan - doPut request string=' + request.toString());
        HttpResponse res = h.send(request);
        return res;
    }
    
    public HttpRequest createRequest(string method, string resourceName, String query)
    {
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setHeader('xero-tenant-id', xc[0].Xero_Tenant_Id__c);
                
        //request.setHeader('If-Modified-Since', modifiedSince);
        request.setTimeout(defaultTimeOut);
        request.setMethod(method);
        // Set the endpoint using the named credential
        request.setEndpoint(
            'callout:Xero/' +
            (resourceName.equalsIgnoreCase('connections') ? 'connections': 'api.xro/2.0/' + resourceName)
        );

        return request;
    }
}
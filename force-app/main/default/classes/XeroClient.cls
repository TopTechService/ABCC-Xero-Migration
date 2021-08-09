public with sharing class XeroClient {
    private static Integer defaultTimeOut = 60000;

    private static List<Xero_Setting__c> xc{
        get{
            if(xc == null){
                xc = [Select Id, Name, Private_Key__c  from Xero_Setting__c limit 1];
            }
            return xc;
        } set;
    } 

    public DateTime ModifiedSince { get; set; }

    public HttpResponse doGet(String endpoint, String query){
        HttpRequest request = createRequest(endpoint, 'GET', query);
        Http h = new Http();
        System.debug(request);
        HttpResponse res = h.send(request);

        return res;
    }

    public HttpResponse doPost(String endpoint, String reqbody){
        HttpRequest request = createRequest(endpoint, 'POST', null);
        request.setBody(reqbody);
        Http h = new Http();
        HttpResponse res = h.send(request);
        return res;
    }
    
    public HttpResponse doPut(String endpoint, String reqbody){
        HttpRequest request = createRequest(endpoint, 'PUT', null);
        request.setBody(reqbody);
        Http h = new Http();
        HttpResponse res = h.send(request);
        return res;
    }
    
    public HttpRequest createRequest(String endpoint, string method, String query)
    {
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        
        /*Datetime fourHourErlierTime = System.now() - (1/6.0);
        String modifiedSince = String.valueOf(fourHourErlierTime.yearGmt() + '-' + String.valueOf(fourHourErlierTime.MonthGMT()).leftPad(2, '0') + '-'+ String.valueOf(fourHourErlierTime.dayGMT()).leftPad(2, '0') + 'T' + String.valueOf(fourHourErlierTime.hourGMT()).leftPad(2, '0') + ':00:00'); 
        System.debug(modifiedSince);*/
        
        //request.setHeader('If-Modified-Since', modifiedSince);
        request.setTimeout(defaultTimeOut);
        request.setMethod(method);

        if(xc != null && xc.size() == 1){
            String signatureUri = String.isBlank(query) ? endpoint : endpoint + '?' + query;
            Map<String, String> oAuthParams = new RsaSha1Signer().CreateSignature(xc[0].Private_Key__c, xc[0].Name, endpoint, method);

            String oAuthString = '';
            for(String key : oAuthParams.keySet()){
                oAuthString += '&' + key + '=' + oAuthParams.get(key);
            }
            //oAuthString = oAuthString.substring(1);

            endpoint += '?';
            if(String.isBlank(query)){
                endpoint += oAuthString.substring(1);
            } else{
                endpoint += query + oAuthString;
            }

            System.debug(endpoint);
            
            request.setEndpoint(endpoint);
        }
        
        return request;
    }
}
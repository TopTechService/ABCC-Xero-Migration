public class TrackingOption {
	public TrackingOption() {
			
	}
    
    public TrackingCategoryResponse createTrackingOption(String trackOptionName , String TrackCatId){
		XeroClient xc = new XeroClient();
   
        TrackingCategoryRequest req = PrepareTrackingCategories(trackOptionName);
        //TrackingOption__c ToMyp = new TrackingOption__c();
        //TrackingOption__c nullTo = new TrackingOption__c();
        
        String jsonreq;
        if(req != null)
        {
            jsonreq = JSON.serialize(req);
        }
        ////
        HttpResponse res1 = xc.doGet(XeroConfig.API_ENDPOINT_URL+'TrackingCategories/'+TrackCatId+'/Options', '');
        TrackingCategoryResponse response1 = TrackingCategoryResponse.parse(res1.getBody());
        TrackingCategoryResponse response;
        Boolean Present = false;
        system.debug('Yatish response1 ----->' + response1);
        for(TrackingCategoryResponse.Options resp : response1.Options)
        {
            if(resp.Name == trackOptionName)
            {
                System.debug('already present');
                Present = true;
            }
        }
        
        if(Present == true)
        {
            response = TrackingCategoryResponse.parse(res1.getBody());
        }else{
            system.debug('Yatish req -----> ' + jsonreq);
            HttpResponse res = xc.doPut(XeroConfig.API_ENDPOINT_URL+'TrackingCategories/'+TrackCatId+'/Options', jsonreq);
            system.debug('Yatish res ----->' + res.getBody());
            response = TrackingCategoryResponse.parse(res.getBody());
        }
        
        return response;
	}
    
    public TrackingCategoryRequest PrepareTrackingCategories(String trackOptionName){
		TrackingCategoryRequest TrackRequest = new TrackingCategoryRequest();
        if(trackOptionName!=null && trackOptionName!='')
        {
            TrackRequest.Name = trackOptionName;
        }
        return TrackRequest;
	}
    
    
    
}
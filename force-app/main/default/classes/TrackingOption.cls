public class TrackingOption {
	public TrackingOption() {
			
	}
    
    public String createTrackingOption(String trackOptionName , String TrackCatId, String TrackingCategoryID){
		XeroClient xc = new XeroClient();
   
        TrackingCategoryRequest req = PrepareTrackingCategories(trackOptionName);
        
        String jsonreq;
        if(req != null)
        {
            jsonreq = JSON.serialize(req);  //Serialized Tracking Option Name
        }
        ////
        HttpResponse res1 = xc.doGet('TrackingCategories?' + TrackCatId, null);
        System.debug('Dan - res1=' + res1.getBody());
        TrackingOptionsResponse response1 = TrackingOptionsResponse.parse(res1.getBody());
        TrackingOptionsResponse response;
        String trackingOptionID;
        Boolean Present = false;
        system.debug('Yatish response1 ----->' + response1);
        
        for(TrackingOptionsResponse.TrackingCategories trackingCats : response1.TrackingCategories) {
            for(TrackingOptionsResponse.Options trackOptions : trackingCats.Options) {
                System.debug('Dan - TrackingOptionName=' + trackOptions.Name);
                if(trackOptions.Name == trackOptionName) {
                    System.debug('Tracking Option in Xero');
                    Present = true;
                    trackingOptionID = trackOptions.TrackingOptionID;
                }
            }
        }
        
        if(Present != true) {
            system.debug('Tracking Option not in Xero');
            HttpResponse res = xc.doPut('TrackingCategories/' + TrackCatId + '/Options', jsonreq);
            if(res.getStatusCode() == 200) {
                system.debug('Yatish res ----->' + res.getBody());
                response = TrackingOptionsResponse.parse(res.getBody());
                for(TrackingOptionsResponse.TrackingCategories tC :response.TrackingCategories) {
                    for(TrackingOptionsResponse.Options tO :tC.Options) {
                        trackingOptionID = tO.TrackingOptionID;
                    }
                }
            }
        }
        return trackingOptionID;
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
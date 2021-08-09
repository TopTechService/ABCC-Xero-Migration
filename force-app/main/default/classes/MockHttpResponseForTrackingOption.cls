@isTest
global class MockHttpResponseForTrackingOption implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{'+
		'  \"Id\": \"b9159060-d289-48f8-81ed-ceef44ba9668\",'+
		'  \"Status\": \"OK\",'+
		'  \"ProviderName\": \"TBCC-June\",'+
		'  \"DateTimeUTC\": \"\\/Date(1559798433941)\\/\",'+
		'  \"Options\": ['+
		'    {'+
		'      \"TrackingOptionID\": \"3002e998-1a27-44bd-ad1a-2bc494a42a7d\",'+
		'      \"Name\": \"res1YP\",'+
		'      \"Status\": \"ACTIVE\",'+
		'      \"HasValidationErrors\": false,'+
		'      \"IsDeleted\": false,'+
		'      \"IsArchived\": false,'+
		'      \"IsActive\": true'+
		'    }'+
		'  ]'+
		'}');
        res.setStatusCode(200);
        return res;
        
    }
}
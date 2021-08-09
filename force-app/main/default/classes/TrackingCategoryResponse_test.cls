@IsTest
public class TrackingCategoryResponse_test {
    static testMethod void testParse() {
        String json = '{'+
            '  \"Id\": \"b9159060-d289-48f8-81ed-ceef44ba9668\",'+
            '  \"Status\": \"OK\",'+
            '  \"ProviderName\": \"TBCC-June\",'+
            '  \"DateTimeUTC\": \"\\/Date(1559798433941)\\/\",'+
            '  \"Options\": ['+
            '    {'+
            '      \"TrackingOptionID\": \"13b0ee7c-9e3c-4f8e-9fd5-2cda7fd417c1\",'+
            '      \"Name\": \"12345678YP\",'+
            '      \"Status\": \"ACTIVE\",'+
            '      \"HasValidationErrors\": false,'+
            '      \"IsDeleted\": false,'+
            '      \"IsArchived\": false,'+
            '      \"IsActive\": true'+
            '    },'+
            '    {'+
            '      \"TrackingOptionID\": \"3002e998-1a27-44bd-ad1a-2bc494a42a7d\",'+
            '      \"Name\": \"res1YP\",'+
            '      \"Status\": \"ACTIVE\",'+
            '      \"HasValidationErrors\": false,'+
            '      \"IsDeleted\": false,'+
            '      \"IsArchived\": false,'+
            '      \"IsActive\": true'+
            '    },'+
            '    {'+
            '      \"TrackingOptionID\": \"6fa85b70-5c36-4014-8fc2-691b291c8970\",'+
            '      \"Name\": \"testYP\",'+
            '      \"Status\": \"ACTIVE\",'+
            '      \"HasValidationErrors\": false,'+
            '      \"IsDeleted\": false,'+
            '      \"IsArchived\": false,'+
            '      \"IsActive\": true'+
            '    }'+
            '  ]'+
            '}';
        TrackingCategoryRequest obj = TrackingCategoryRequest.parse(json);
        System.assert(obj != null);
    }
}
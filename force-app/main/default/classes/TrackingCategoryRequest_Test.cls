@IsTest
public class TrackingCategoryRequest_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Name\": \"New Category\"'+
		'}';
		TrackingCategoryRequest obj = TrackingCategoryRequest.parse(json);
		System.assert(obj != null);
	}
}
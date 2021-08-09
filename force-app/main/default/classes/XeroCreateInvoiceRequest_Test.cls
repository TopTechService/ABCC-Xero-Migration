@IsTest
public class XeroCreateInvoiceRequest_Test {

// Added by Yp
	static testMethod void testParse() {
		String json = '{'+
		'  \"Type\": \"ACCREC\",'+
		'  \"CurrencyCode\": \"USD\",'+
		'  \"Contact\": { '+
		'    \"ContactID\": \"eaa28f49-6028-4b6e-bb12-d8f6278073fc\" '+
		'  },'+
		'  \"Date\": \"\\/Date(1518685950940+0000)\\/\",'+
		'  \"DueDate\": \"\\/Date(1518685950940+0000)\\/\",'+
		'  \"DateString\": \"2009-05-27T00:00:00\",'+
		'  \"DueDateString\": \"2009-06-06T00:00:00\",'+
		'  \"LineAmountTypes\": \"Inclusive\",'+
		'  \"LineItems\": ['+
		'    {'+
		'      \"Description\": \"Consulting services as agreed\",'+
		'      \"Quantity\": \"5.0000\",'+
		'      \"UnitAmount\": \"99\",'+
		'      \"AccountCode\": \"200\",'+
		'      \"Tracking\": ['+
		'        {'+
		'          \"Name\": \"Activity/Workstream\",'+
		'          \"Option\": \"Onsite consultancy\"'+
		'        }'+
		'      ]'+
		'    }'+
		'  ]'+
		'}';
		XeroCreateInvoiceRequest r = XeroCreateInvoiceRequest.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		XeroCreateInvoiceRequest.LineItems objLineItems = new XeroCreateInvoiceRequest.LineItems(System.JSON.createParser(json));
		System.assert(objLineItems != null);
		System.assert(objLineItems.Description == null);
		System.assert(objLineItems.Quantity == null);
		System.assert(objLineItems.UnitAmount == null);
		System.assert(objLineItems.AccountCode == null);
		System.assert(objLineItems.Tracking == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		XeroCreateInvoiceRequest.Tracking objTracking = new XeroCreateInvoiceRequest.Tracking(System.JSON.createParser(json));
		System.assert(objTracking != null);
		System.assert(objTracking.Name == null);
		System.assert(objTracking.Option == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		XeroCreateInvoiceRequest objTestTrackingCategoryResponse = new XeroCreateInvoiceRequest(System.JSON.createParser(json));
		System.assert(objTestTrackingCategoryResponse != null);
		System.assert(objTestTrackingCategoryResponse.Type_Z == null);
		
		System.assert(objTestTrackingCategoryResponse.Contact == null);
		
		System.assert(objTestTrackingCategoryResponse.DueDate == null);
		System.assert(objTestTrackingCategoryResponse.DateString == null);
		System.assert(objTestTrackingCategoryResponse.DueDateString == null);
		System.assert(objTestTrackingCategoryResponse.LineAmountTypes == null);
		System.assert(objTestTrackingCategoryResponse.LineItems == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		XeroCreateInvoiceRequest.Contact objContact = new XeroCreateInvoiceRequest.Contact(System.JSON.createParser(json));
		System.assert(objContact != null);
		System.assert(objContact.ContactID == null);
	}
}
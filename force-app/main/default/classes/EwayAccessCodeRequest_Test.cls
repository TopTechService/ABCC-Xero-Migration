@IsTest
public class EwayAccessCodeRequest_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'        \"Payment\": {'+
		'           \"TotalAmount\": 1055,'+
		'           \"CurrencyCode\": \"AUD\"'+
		'        },'+
		'        \"RedirectUrl\": \"http://www.eway.com.au\",'+
		'        \"Method\": \"ProcessPayment\",'+
		'        \"TransactionType\": \"Purchase\"'+
		'}';
		EwayAccessCodeRequest r = EwayAccessCodeRequest.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		EwayAccessCodeRequest.Payment objPayment = new EwayAccessCodeRequest.Payment(System.JSON.createParser(json));
		System.assert(objPayment != null);
		System.assert(objPayment.TotalAmount == null);
		System.assert(objPayment.CurrencyCode == null);
	}
}
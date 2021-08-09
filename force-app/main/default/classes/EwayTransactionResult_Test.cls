@IsTest
public class EwayTransactionResult_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"AccessCode\": \"A1001kUI52lIC3V3QfNgBVvjU5-SPTKts9vKO543dcArYUFXpnSPzksjAKdyecQYmwnnkUl4aDx-OJQavkNN1Jalxy9IxahEhiFPfgSYYvr4vH3AYdHEIz60uP7grSHrr3buQ7GJi5bG9YCIS9kT4lJTv8A==\",'+
		'    \"AuthorisationCode\": \"294228\",'+
		'    \"ResponseCode\": \"00\",'+
		'    \"ResponseMessage\": \"A2000\",'+
		'    \"InvoiceNumber\": \"\",'+
		'    \"InvoiceReference\": \"\",'+
		'    \"TotalAmount\": 2,'+
		'    \"TransactionID\": 16926320,'+
		'    \"TransactionStatus\": true,'+
		'    \"TokenCustomerID\": null,'+
		'    \"BeagleScore\": 0,'+
		'    \"Options\": [],'+
		'    \"Verification\": {'+
		'        \"CVN\": 0,'+
		'        \"Address\": 0,'+
		'        \"Email\": 0,'+
		'        \"Mobile\": 0,'+
		'        \"Phone\": 0'+
		'    },'+
		'    \"BeagleVerification\": {'+
		'        \"Email\": 0,'+
		'        \"Phone\": 0'+
		'    },'+
		'    \"Errors\": null'+
		'}';
		EwayTransactionResult r = EwayTransactionResult.parse(json);
		System.assert(r != null);


		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		EwayTransactionResult.Options objOptions = new EwayTransactionResult.Options(System.JSON.createParser(json));
		System.assert(objOptions != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		EwayTransactionResult.Verification objVerification = new EwayTransactionResult.Verification(System.JSON.createParser(json));
		System.assert(objVerification != null);
		System.assert(objVerification.CVN == null);
		System.assert(objVerification.Address == null);
		System.assert(objVerification.Email == null);
		System.assert(objVerification.Mobile == null);
		System.assert(objVerification.Phone == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		EwayTransactionResult.BeagleVerification objBeagleVerification = new EwayTransactionResult.BeagleVerification(System.JSON.createParser(json));
		System.assert(objBeagleVerification != null);
		System.assert(objBeagleVerification.Email == null);
		System.assert(objBeagleVerification.Phone == null);
	}
}
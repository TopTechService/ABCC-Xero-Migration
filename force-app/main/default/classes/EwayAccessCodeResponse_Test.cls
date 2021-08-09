@IsTest
public class EwayAccessCodeResponse_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"AccessCode\": \"F9802VCDNSSUVQyjV4BSwdS9rGHay5wWTZhu-bADhqM4vZkGpS_ESjxihJzusJgvk_GIMUWC9QHxLD1ApYzpfbwLDJ0rwuAmdB5aCavJOOdxsVdCh4wrgYsSo3e0S7TRP3JSEFIEqDQyIjtxPAM0o4WN4LA==\",'+
		'    \"Customer\": {'+
		'        \"CardNumber\": \"\",'+
		'        \"CardStartMonth\": \"\",'+
		'        \"CardStartYear\": \"\",'+
		'        \"CardIssueNumber\": \"\",'+
		'        \"CardName\": \"\",'+
		'        \"CardExpiryMonth\": \"\",'+
		'        \"CardExpiryYear\": \"\",'+
		'        \"IsActive\": false,'+
		'        \"TokenCustomerID\": null,'+
		'        \"Reference\": \"\",'+
		'        \"Title\": \"Mr.\",'+
		'        \"FirstName\": \"\",'+
		'        \"LastName\": \"\",'+
		'        \"CompanyName\": \"\",'+
		'        \"JobDescription\": \"\",'+
		'        \"Street1\": \"\",'+
		'        \"Street2\": \"\",'+
		'        \"City\": \"\",'+
		'        \"State\": \"\",'+
		'        \"PostalCode\": \"\",'+
		'        \"Country\": \"\",'+
		'        \"Email\": \"\",'+
		'        \"Phone\": \"\",'+
		'        \"Mobile\": \"\",'+
		'        \"Comments\": \"\",'+
		'        \"Fax\": \"\",'+
		'        \"Url\": \"\"'+
		'    },'+
		'    \"Payment\": {'+
		'        \"TotalAmount\": 5,'+
		'        \"InvoiceNumber\": null,'+
		'        \"InvoiceDescription\": null,'+
		'        \"InvoiceReference\": null,'+
		'        \"CurrencyCode\": \"AUD\"'+
		'    },'+
		'    \"FormActionURL\": \"https://secure-au.sandbox.ewaypayments.com/AccessCode/F9802VCDNSSUVQyjV4BSwdS9rGHay5wWTZhu-bADhqM4vZkGpS_ESjxihJzusJgvk_GIMUWC9QHxLD1ApYzpfbwLDJ0rwuAmdB5aCavJOOdxsVdCh4wrgYsSo3e0S7TRP3JSEFIEqDQyIjtxPAM0o4WN4LA==\",'+
		'    \"CompleteCheckoutURL\": null,'+
		'    \"Errors\": null'+
		'}';
		EwayAccessCodeResponse r = EwayAccessCodeResponse.parse(json);
		
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		EwayAccessCodeResponse.Payment objPayment = new EwayAccessCodeResponse.Payment(System.JSON.createParser(json));
		System.assert(objPayment != null);
		System.assert(objPayment.TotalAmount == null);
		System.assert(objPayment.InvoiceNumber == null);
		System.assert(objPayment.InvoiceDescription == null);
		System.assert(objPayment.InvoiceReference == null);
		System.assert(objPayment.CurrencyCode == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		EwayAccessCodeResponse.Customer objCustomer = new EwayAccessCodeResponse.Customer(System.JSON.createParser(json));
		System.assert(objCustomer != null);
		System.assert(objCustomer.CardNumber == null);
		System.assert(objCustomer.CardStartMonth == null);
		System.assert(objCustomer.CardStartYear == null);
		System.assert(objCustomer.CardIssueNumber == null);
		System.assert(objCustomer.CardName == null);
		System.assert(objCustomer.CardExpiryMonth == null);
		System.assert(objCustomer.CardExpiryYear == null);
		System.assert(objCustomer.IsActive == null);
		System.assert(objCustomer.TokenCustomerID == null);
		System.assert(objCustomer.Reference == null);
		System.assert(objCustomer.Title == null);
		System.assert(objCustomer.FirstName == null);
		System.assert(objCustomer.LastName == null);
		System.assert(objCustomer.CompanyName == null);
		System.assert(objCustomer.JobDescription == null);
		System.assert(objCustomer.Street1 == null);
		System.assert(objCustomer.Street2 == null);
		System.assert(objCustomer.City == null);
		System.assert(objCustomer.State == null);
		System.assert(objCustomer.PostalCode == null);
		System.assert(objCustomer.Country == null);
		System.assert(objCustomer.Email == null);
		System.assert(objCustomer.Phone == null);
		System.assert(objCustomer.Mobile == null);
		System.assert(objCustomer.Comments == null);
		System.assert(objCustomer.Fax == null);
		System.assert(objCustomer.Url == null);
	}
}
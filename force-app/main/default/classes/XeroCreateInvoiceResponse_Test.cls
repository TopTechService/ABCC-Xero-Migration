//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class XeroCreateInvoiceResponse_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		' \"Id\": \"903494e5-b3fe-4b25-ba0f-1a6f00afa32c\",'+
		' \"Status\": \"OK\",'+
		' \"ProviderName\": \"Test App\",'+
		' \"DateTimeUTC\": \"\\/Date(1526630466108)\\/\",'+
		' \"Invoices\": ['+
		'   {'+
		'     \"Type\": \"ACCREC\",'+
		'     \"InvoiceID\": \"62c18a41-cfe8-41e6-827c-35cf239a9245\",'+
		'     \"InvoiceNumber\": \"INV-0105\",'+
		'     \"Reference\": \"1234567890\",'+
		'     \"Prepayments\": [],'+
		'     \"Overpayments\": [],'+
		'     \"AmountDue\": 100.00,'+
		'     \"AmountPaid\": 0.00,'+
		'     \"SentToContact\": false,'+
		'     \"CurrencyRate\": 1.000000,'+
		'     \"HasErrors\": false,'+
		'     \"IsDiscounted\": false,'+
		'     \"Contact\": {'+
		'       \"ContactID\": \"ec35967a-62c9-4638-9182-ae58980ffa49\",'+
		'       \"ContactNumber\": \"003N000001BolmEIAR\",'+
		'       \"ContactStatus\": \"ACTIVE\",'+
		'       \"Name\": \"dsjvf skeiufgdsj\",'+
		'       \"EmailAddress\": \"\",'+
		'       \"BankAccountDetails\": \"\",'+
		'       \"Addresses\": ['+
		'         {'+
		'           \"AddressType\": \"STREET\",'+
		'           \"City\": \"\",'+
		'           \"Region\": \"\",'+
		'           \"PostalCode\": \"\",'+
		'           \"Country\": \"\"'+
		'         },'+
		'         {'+
		'           \"AddressType\": \"POBOX\",'+
		'           \"City\": \"\",'+
		'           \"Region\": \"\",'+
		'           \"PostalCode\": \"\",'+
		'           \"Country\": \"\"'+
		'         }'+
		'       ],'+
		'       \"Phones\": ['+
		'         {'+
		'           \"PhoneType\": \"DEFAULT\",'+
		'           \"PhoneNumber\": \"\",'+
		'           \"PhoneAreaCode\": \"\",'+
		'           \"PhoneCountryCode\": \"\"'+
		'         },'+
		'         {'+
		'           \"PhoneType\": \"DDI\",'+
		'           \"PhoneNumber\": \"\",'+
		'           \"PhoneAreaCode\": \"\",'+
		'           \"PhoneCountryCode\": \"\"'+
		'         },'+
		'         {'+
		'           \"PhoneType\": \"FAX\",'+
		'           \"PhoneNumber\": \"\",'+
		'           \"PhoneAreaCode\": \"\",'+
		'           \"PhoneCountryCode\": \"\"'+
		'         },'+
		'         {'+
		'           \"PhoneType\": \"MOBILE\",'+
		'           \"PhoneNumber\": \"\",'+
		'           \"PhoneAreaCode\": \"\",'+
		'           \"PhoneCountryCode\": \"\"'+
		'         }'+
		'       ],'+
		'       \"UpdatedDateUTC\": \"\\/Date(1526017954263+0000)\\/\",'+
		'       \"ContactGroups\": [],'+
		'       \"IsSupplier\": false,'+
		'       \"IsCustomer\": true,'+
		'       \"SalesTrackingCategories\": [],'+
		'       \"PurchasesTrackingCategories\": [],'+
		'       \"ContactPersons\": [],'+
		'       \"HasValidationErrors\": false'+
		'     },'+
		'     \"DateString\": \"2018-05-18T00:00:00\",'+
		'     \"Date\": \"\\/Date(1526601600000+0000)\\/\",'+
		'     \"DueDateString\": \"2017-10-17T00:00:00\",'+
		'     \"DueDate\": \"\\/Date(1508198400000+0000)\\/\",'+
		'     \"Status\": \"AUTHORISED\",'+
		'     \"LineAmountTypes\": \"Exclusive\",'+
		'     \"LineItems\": ['+
		'       {'+
		'         \"Description\": \"Hello WORLD Tuesday 17 October 2017(1 x Non Member Ticket)\",'+
		'         \"UnitAmount\": 100.00,'+
		'         \"TaxType\": \"EXEMPTOUTPUT\",'+
		'         \"TaxAmount\": 0.00,'+
		'         \"LineAmount\": 100.00,'+
		'         \"AccountCode\": \"0518\",'+
		'         \"Tracking\": [],'+
		'         \"Quantity\": 1.0000,'+
		'         \"LineItemID\": \"c86ba516-c953-42be-95ad-889693373232\",'+
		'         \"ValidationErrors\": []'+
		'       }'+
		'     ],'+
		'     \"SubTotal\": 100.00,'+
		'     \"TotalTax\": 0.00,'+
		'     \"Total\": 100.00,'+
		'     \"UpdatedDateUTC\": \"\\/Date(1526630465827+0000)\\/\",'+
		'     \"CurrencyCode\": \"AUD\"'+
		'   }'+
		' ]'+
		'}';
		XeroCreateInvoiceResponse r = XeroCreateInvoiceResponse.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		XeroCreateInvoiceResponse.Invoices objInvoices = new XeroCreateInvoiceResponse.Invoices(System.JSON.createParser(json));
		System.assert(objInvoices != null);
		System.assert(objInvoices.Type_Z == null);
		System.assert(objInvoices.InvoiceID == null);
		System.assert(objInvoices.InvoiceNumber == null);
		System.assert(objInvoices.Reference == null);
		System.assert(objInvoices.AmountDue == null);
		System.assert(objInvoices.AmountPaid == null);
		System.assert(objInvoices.Contact == null);
		System.assert(objInvoices.DateString == null);
		System.assert(objInvoices.Date_z == null);
		System.assert(objInvoices.DueDateString == null);
		System.assert(objInvoices.DueDate == null);
		System.assert(objInvoices.Status == null);
		System.assert(objInvoices.LineAmountTypes == null);
		System.assert(objInvoices.SubTotal == null);
		System.assert(objInvoices.TotalTax == null);
		System.assert(objInvoices.Total == null);
		System.assert(objInvoices.UpdatedDateUTC == null);
		System.assert(objInvoices.CurrencyCode == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		XeroCreateInvoiceResponse.Contact objContact = new XeroCreateInvoiceResponse.Contact(System.JSON.createParser(json));
		System.assert(objContact != null);
		System.assert(objContact.ContactID == null);
		System.assert(objContact.Name == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		XeroCreateInvoiceResponse objXeroCreateInvoiceResponse = new XeroCreateInvoiceResponse(System.JSON.createParser(json));
		System.assert(objXeroCreateInvoiceResponse != null);
		System.assert(objXeroCreateInvoiceResponse.Invoices == null);
	}
}
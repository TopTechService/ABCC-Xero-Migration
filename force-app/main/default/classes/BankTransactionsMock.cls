@isTest
global class BankTransactionsMock implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
	    res.setHeader('Content-Type', 'application/json');
	    res.setBody('{\"BankTransactions\": [{'+
	    '\"BankTransactionID\": \"142fda37-8c13-4073-920d-487752b78df5\",'+
	    '  \"BankAccount\": {'+
	    '    \"AccountID\": \"26b5746d-74e9-4102-82bc-619442978769\",'+
	    '    \"Code\": \"100\",'+
	    '    \"Name\": \"test\"'+
	    '  },'+
	    '  \"Type\": \"RECEIVE-PREPAYMENT\",'+
	    '  \"IsReconciled\": false,'+
	    '  \"CurrencyRate\": 1.000000,'+
	    '  \"PrepaymentID\": \"a8018f40-35d9-45ec-8e09-e58b157c3f29\",'+
	    '  \"Contact\": {'+
	    '    \"ContactID\": \"ec35967a-62c9-4638-9182-ae58980ffa49\",'+
	    '    \"ContactNumber\": \"003N000001BolmEIAR\",'+
	    '    \"ContactStatus\": \"ACTIVE\",'+
	    '    \"Name\": "dsjvf skeiufgdsj",'+
	    '    \"EmailAddress\": \"\",'+
	    '    \"BankAccountDetails\": \"\",'+
	    '    \"Addresses\": ['+	    
	    '      {'+
	    '        \"AddressType\": \"STREET\",'+
	    '        \"City\": \"\",'+
	    '        \"Region\": \"\",'+
	    '        \"PostalCode\": \"\",'+
	    '        \"Country\": \"\"'+
	    '      },'+
	    '      {'+
	    '        \"AddressType\": \"POBOX\",'+
	    '        \"City\": \"\",'+
	    '        \"Region\": \"\",'+
	    '        \"PostalCode\": \"\",'+
	    '        \"Country\": \"\"'+
	    '      }'+
	    '    ],'+
	    '    \"Phones\": ['+
	    '     {'+
	    '       \"PhoneType\": \"DEFAULT\",'+
	    '       \"PhoneNumber\": \"\",'+
	    '       \"PhoneAreaCode\": \"\",'+
	    '       \"PhoneCountryCode\": \"\"'+
	    '     }'+
	    '   ]'+
	    ' },'+
	    ' \"DateString\": \"2018-05-17T00:00:00\",'+
	    ' \"Status\": \"AUTHORISED\",'+
	    ' \"LineAmountTypes\": \"Inclusive\",'+
		' \"LineItems\": ['+
	    '   {'+
	    '    \"Description\": \"Hello WORLD Tuesday 17 October 2017(1 x Non Member Ticket)\",'+
	    '      \"UnitAmount\": 100.00,'+
	    '      \"TaxType\": \"EXEMPTOUTPUT\",'+
	    '      \"TaxAmount\": 0.00,'+
	    '      \"LineAmoun\": 100.00,'+
	    '      \"AccountCode\": \"3050\",'+
	    '      \"Tracking\": [],'+
	    '      \"Quantity\": 1.0000,'+
	    '      \"LineItemID\": \"37ffabb7-bd77-4b0a-b830-4e633fe266d3\",'+
	    '      \"ValidationErrors\": []'+
	    '    }'+
	    '  ],'+
	    '  \"SubTotal\": 100.00,'+
	    '  \"TotalTax\": 0.00,'+
	    '  \"Total\": 100.00,'+
	    '  \"CurrencyCode\": \"AUD\"'+
		'   }]}');
		res.setStatusCode(200);
        return res;
	}
}
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{'+
		'  \"Id\": \"74040457-1368-4c85-971f-07c95053de21\",'+
		'  \"Status\": \"OK\",'+
		'  \"ProviderName\": \"DemoApp\",'+
		'  \"DateTimeUTC\": \"\\/Date(1526024821332)\\/\",'+
		'  \"Invoices\": ['+
		'    {'+
		'      \"Type\": \"ACCREC\",'+
		'      \"InvoiceID\": \"a4fe025e-0e69-4d56-a7f4-5aaa12ea6287\",'+
		'      \"InvoiceNumber\": \"INV-0075\",'+
		'      \"Reference\": \"\",'+
		'      \"Prepayments\": [],'+
		'      \"Overpayments\": [],'+
		'      \"AmountDue\": 1452.00,'+
		'      \"AmountPaid\": 0.00,'+
		'      \"SentToContact\": false,'+
		'      \"CurrencyRate\": 1.000000,'+
		'      \"HasErrors\": false,'+
		'      \"IsDiscounted\": false,'+
		'      \"Contact\": {'+
		'        \"ContactID\": \"b7a9f13b-f738-4301-90db-9d3a8ce5f239\",'+
		'        \"ContactNumber\": \"0010k00000c8rPxAAI\",'+
		'        \"ContactStatus\": \"ACTIVE\",'+
		'        \"Name\": \"Kunal\",'+
		'        \"EmailAddress\": \"\",'+
		'        \"BankAccountDetails\": \"\",'+
		'        \"Addresses\": ['+
		'          {'+
		'            \"AddressType\": \"STREET\",'+
		'            \"City\": \"\",'+
		'            \"Region\": \"\",'+
		'            \"PostalCode\": \"\",'+
		'            \"Country\": \"\"'+
		'          },'+
		'          {'+
		'            \"AddressType\": \"POBOX\",'+
		'            \"City\": \"\",'+
		'            \"Region\": \"\",'+
		'            \"PostalCode\": \"\",'+
		'            \"Country\": \"\"'+
		'          }'+
		'        ],'+
		'        \"Phones\": ['+
		'          {'+
		'            \"PhoneType\": \"DEFAULT\",'+
		'            \"PhoneNumber\": \"\",'+
		'            \"PhoneAreaCode\": \"\",'+
		'            \"PhoneCountryCode\": \"\"'+
		'          },'+
		'          {'+
		'            \"PhoneType\": \"DDI\",'+
		'            \"PhoneNumber\": \"\",'+
		'            \"PhoneAreaCode\": \"\",'+
		'            \"PhoneCountryCode\": \"\"'+
		'          },'+
		'          {'+
		'            \"PhoneType\": \"FAX\",'+
		'            \"PhoneNumber\": \"\",'+
		'            \"PhoneAreaCode\": \"\",'+
		'            \"PhoneCountryCode\": \"\"'+
		'          },'+
		'          {'+
		'            \"PhoneType\": \"MOBILE\",'+
		'            \"PhoneNumber\": \"\",'+
		'            \"PhoneAreaCode\": \"\",'+
		'            \"PhoneCountryCode\": \"\"'+
		'          }'+
		'        ],'+
		'        \"UpdatedDateUTC\": \"\\/Date(1525953251687+0000)\\/\",'+
		'        \"ContactGroups\": [],'+
		'        \"IsSupplier\": false,'+
		'        \"IsCustomer\": true,'+
		'        \"SalesTrackingCategories\": [],'+
		'        \"PurchasesTrackingCategories\": [],'+
		'        \"ContactPersons\": [],'+
		'        \"HasValidationErrors\": false'+
		'      },'+
		'      \"DateString\": \"2018-05-11T00:00:00\",'+
		'      \"Date\": \"\\/Date(1525996800000+0000)\\/\",'+
		'      \"DueDateString\": \"2018-05-14T00:00:00\",'+
		'      \"DueDate\": \"\\/Date(1526256000000+0000)\\/\",'+
		'      \"Status\": \"AUTHORISED\",'+
		'      \"LineAmountTypes\": \"Inclusive\",'+
		'      \"LineItems\": ['+
		'        {'+
		'          \"Description\": \"Total debt $1452.00 accepted $XXXXX Saved $XXXXX\",'+
		'          \"UnitAmount\": 1452.00,'+
		'          \"TaxType\": \"TAX001\",'+
		'          \"TaxAmount\": 132.00,'+
		'          \"LineAmount\": 1452.00,'+
		'          \"AccountCode\": \"200\",'+
		'          \"Tracking\": [],'+
		'          \"Quantity\": 1.0000,'+
		'          \"LineItemID\": \"8a91148a-9ba9-407b-9b1e-f9ab793f97db\",'+
		'          \"ValidationErrors\": []'+
		'        }'+
		'      ],'+
		'      \"SubTotal\": 1320.00,'+
		'      \"TotalTax\": 132.00,'+
		'      \"Total\": 1452.00,'+
		'      \"UpdatedDateUTC\": \"\\/Date(1526024821067+0000)\\/\",'+
		'      \"CurrencyCode\": \"INR\"'+
		'    }'+
		'  ]'+
		'}');
        res.setStatusCode(200);
        return res;
    }    
}
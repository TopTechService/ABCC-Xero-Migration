global class PaymentMock implements HttpCalloutMock {

	global HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
	    res.setHeader('Content-Type', 'application/json');
	    res.setBody('{'+
		'  \"Payments\": ['+
		'    {'+
		'      \"PaymentID\": \"b26fd49a-cbae-470a-a8f8-bcbc119e0379\",'+
		'      \"BankAmount\": 500.00,'+
		'      \"Amount": 500.00,'+
		'      \"Reference\": \"INV-0001\",'+
		'      \"CurrencyRate\": 1.000000,'+
		'      \"PaymentType\": "ACCRECPAYMENT\",'+
		'      \"Status\": \"AUTHORISED\",'+
		'      \"HasAccount\": true,'+
		'      \"IsReconciled\": true,'+
		'      \"Account\": {'+
		'        \"AccountID\": \"ac993f75-035b-433c-82e0-7b7a2d40802c\",'+
		'        \"Code\": \"090\"'+
		'      },'+
		'      \"Invoice\": {'+
		'        \"Type\": "ACCREC\",'+
		'        \"InvoiceID\": \"b0875d8b-ff26-4ce8-8aea-6955492ead48\",'+
		'		 \"Status\": \"PAID\",'+
		'        \"InvoiceNumber\": \"INV-0001\",'+
		'        \"Contact\": {'+
		'          \"ContactID\": \"fef6755f-549b-4617-b1e9-60bdffb517d8\",'+
		'          \"Name\": \"Ridgeway University\"'+
		'        }'+
		'      }'+
		'    }'+
		'  ]'+
		'}');
		res.setStatusCode(200);
        return res;
	}	
}
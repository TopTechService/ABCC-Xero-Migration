public class EwayAccessCodeRequest {
	public static void consumeObject(JSONParser parser) {
		Integer depth = 0;
		do {
			JSONToken curr = parser.getCurrentToken();
			if (curr == JSONToken.START_OBJECT || 
				curr == JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == JSONToken.END_OBJECT ||
				curr == JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

	public class Payment {
		public Integer TotalAmount {get;set;} 
		public String CurrencyCode {get;set;}
		public String InvoiceReference {get;set;}
		public String InvoiceDescription {get;set;}
		public Payment()
        {
            
        }
		public Payment(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'TotalAmount') {
							TotalAmount = parser.getIntegerValue();
						} else if (text == 'CurrencyCode') {
							CurrencyCode = parser.getText();
						} else if (text == 'InvoiceReference'){
							InvoiceReference = parser.getText();
						} else if (text == 'InvoiceDescription'){
							InvoiceDescription = parser.getText();
						}else {
							System.debug(LoggingLevel.WARN, 'Payment consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	//public class EwayAccessCodeRequest {
		public Payment Payment {get;set;} 
		public String RedirectUrl {get;set;} 
		public String Method {get;set;} 
		public String TransactionType {get;set;} 
		
    	public EwayAccessCodeRequest()
        {
            
        }
		public EwayAccessCodeRequest(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Payment') {
							Payment = new Payment(parser);
						} else if (text == 'RedirectUrl') {
							RedirectUrl = parser.getText();
						} else if (text == 'Method') {
							Method = parser.getText();
						} else if (text == 'TransactionType') {
							TransactionType = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'EwayAccessCodeRequest consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	//}
	
	
	public static EwayAccessCodeRequest parse(String json) {
		return new EwayAccessCodeRequest(System.JSON.createParser(json));
	}
}
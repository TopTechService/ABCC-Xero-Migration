public class XeroCreateBankTransactionRequest {
	
    public XeroCreateBankTransactionRequest(){
        
    }
    
    public class LineItems {
		public String Description {get;set;} 
		public String Quantity {get;set;} 
		public String UnitAmount {get;set;} 
        public String AccountCode {get;set;}
        public LineItems(){
            
        }
		public LineItems(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'Quantity') {
							Quantity = parser.getText();
						} else if (text == 'UnitAmount') {
							UnitAmount = parser.getText();
						}else if (text == 'AccountCode') {
							AccountCode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'LineItems consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String Type_Z {get;set;} // in json: Type
	public Contact Contact {get;set;} 
	public List<LineItems> LineItems {get;set;} 
	public BankAccount BankAccount {get;set;}
	public String Reference {get;set;}

	public XeroCreateBankTransactionRequest(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Type') {
						Type_Z = parser.getText();
					} else if (text == 'Reference') {
						Reference = parser.getText();
					} else if (text == 'Contact') {
						Contact = new Contact(parser);
					} else if (text == 'LineItems') {
						LineItems = arrayOfLineItems(parser);
					} else if (text == 'BankAccount') {
						BankAccount = new BankAccount(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class BankAccount {
		public String Code {get;set;} 
        public BankAccount(){
            
        }
		public BankAccount(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Code') {
							Code = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'BankAccount consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Contact {
		public String ContactID {get;set;} 
        public Contact(){
            
        }
		public Contact(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ContactID') {
							ContactID = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Contact consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static XeroCreateBankTransactionRequest parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new XeroCreateBankTransactionRequest(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	




    private static List<LineItems> arrayOfLineItems(System.JSONParser p) {
        List<LineItems> res = new List<LineItems>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new LineItems(p));
        }
        return res;
    }
    
}
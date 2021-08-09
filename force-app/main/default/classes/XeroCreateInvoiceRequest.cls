public class XeroCreateInvoiceRequest {
	
    public XeroCreateInvoiceRequest(){
        
    }
    
    public class LineItems {
		public String Description {get;set;} 
		public String Quantity {get;set;} 
		public String UnitAmount {get;set;} 
		public String AccountCode {get;set;} 
        public String DiscountRate {get;set;}
        public String TaxType {get;set;}
        
        //added by yp
		public List<Tracking> Tracking {get;set;} 
        //Added by yp end
        
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
						} else if (text == 'AccountCode') {
							AccountCode = parser.getText();
						} else if (text == 'DiscountRate') {
							DiscountRate = parser.getText();
						} else if (text == 'TaxType') {
							TaxType = parser.getText();
						}else if (text == 'Tracking') {
							Tracking = arrayOfTracking(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'LineItems consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
    
    //Added by yp
    public class Tracking {
		public String Name {get;set;} 
		public String Option {get;set;} 
		public Tracking(){
            
        }
		public Tracking(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Name') {
							Name = parser.getText();
						} else if (text == 'Option') {
							Option = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Tracking consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	//Added by yp end
    
	public String Type_Z {get;set;} // in json: Type
	public String InvoiceNumber {get;set;}
	public Contact Contact {get;set;} 
	public String Date_z {get;set;} 
	public String DueDate {get;set;} 
	public String DateString {get;set;} 
    public String Status {get;set;} 
	public String DueDateString {get;set;} 
	public String LineAmountTypes {get;set;} 
	public List<LineItems> LineItems {get;set;}
	public String InvoiceID {get;set;} 
	public String Reference {get;set;}
	
    
	public XeroCreateInvoiceRequest(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
                System.debug('Yp testing text ' + text);
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Type') {
						Type_Z = parser.getText();
					}else if (text == 'InvoiceNumber') {
						InvoiceNumber = parser.getText();
					} else if (text == 'Contact') {
						Contact = new Contact(parser);
					} else if (text == 'Date') {
						Date_z = parser.getText();
					} else if (text == 'Status') {
						Status = parser.getText();
					} else if (text == 'Reference') {
						Reference = parser.getText();
					} else if (text == 'InvoiceID') {
						InvoiceID = parser.getText();
					} else if (text == 'DueDate') {
						DueDate = parser.getText();
					} else if (text == 'DateString') {
						DateString = parser.getText();
					} else if (text == 'DueDateString') {
						DueDateString = parser.getText();
					} else if (text == 'LineAmountTypes') {
						LineAmountTypes = parser.getText();
					} else if (text == 'LineItems') {
						LineItems = arrayOfLineItems(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
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
	
	
	public static XeroCreateInvoiceRequest parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new XeroCreateInvoiceRequest(parser);
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
    
    //Added by yp
    private static List<Tracking> arrayOfTracking(System.JSONParser p) {
        List<Tracking> res = new List<Tracking>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Tracking(p));
        }
        return res;
    }
    //Added by yp end
    
}
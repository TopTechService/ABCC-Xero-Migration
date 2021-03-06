//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class XeroPrepaymentAllocationResponse {

	public class Allocations {
		public Double Amount {get;set;} 
		public String Date_z {get;set;} 
		public Invoice Invoice {get;set;} 
		public Prepayment Prepayment {get;set;} 
		public List<Payments> ValidationErrors {get;set;} 

		public Allocations(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Amount') {
							Amount = parser.getDoubleValue();
						} else if (text == 'Date') {
							Date_z = parser.getText();
						} else if (text == 'Invoice') {
							Invoice = new Invoice(parser);
						} else if (text == 'Prepayment') {
							Prepayment = new Prepayment(parser);
						} else if (text == 'ValidationErrors') {
							ValidationErrors = arrayOfPayments(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Allocations consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Invoice {
		public String InvoiceID {get;set;} 
		public List<Payments> Payments {get;set;} 
		public List<Payments> CreditNotes {get;set;} 
		public List<Payments> Prepayments {get;set;} 
		public List<Payments> Overpayments {get;set;} 
		public Boolean HasErrors {get;set;} 
		public Boolean IsDiscounted {get;set;} 
		public List<Payments> LineItems {get;set;} 
		public List<Payments> ValidationErrors {get;set;} 

		public Invoice(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'InvoiceID') {
							InvoiceID = parser.getText();
						} else if (text == 'Payments') {
							Payments = arrayOfPayments(parser);
						} else if (text == 'CreditNotes') {
							CreditNotes = arrayOfPayments(parser);
						} else if (text == 'Prepayments') {
							Prepayments = arrayOfPayments(parser);
						} else if (text == 'Overpayments') {
							Overpayments = arrayOfPayments(parser);
						} else if (text == 'HasErrors') {
							HasErrors = parser.getBooleanValue();
						} else if (text == 'IsDiscounted') {
							IsDiscounted = parser.getBooleanValue();
						} else if (text == 'LineItems') {
							LineItems = arrayOfPayments(parser);
						} else if (text == 'ValidationErrors') {
							ValidationErrors = arrayOfPayments(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Invoice consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String Id {get;set;} 
	public String Status {get;set;} 
	public String ProviderName {get;set;} 
	public String DateTimeUTC {get;set;} 
	public List<Allocations> Allocations {get;set;} 

	public XeroPrepaymentAllocationResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Id') {
						Id = parser.getText();
					} else if (text == 'Status') {
						Status = parser.getText();
					} else if (text == 'ProviderName') {
						ProviderName = parser.getText();
					} else if (text == 'DateTimeUTC') {
						DateTimeUTC = parser.getText();
					} else if (text == 'Allocations') {
						Allocations = arrayOfAllocations(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'XeroPrepaymentAllocationResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Payments {

		public Payments(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Payments consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Prepayment {
		public String PrepaymentID {get;set;} 
		public String ID {get;set;} 
		public List<Payments> LineItems {get;set;} 

		public Prepayment(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'PrepaymentID') {
							PrepaymentID = parser.getText();
						} else if (text == 'ID') {
							ID = parser.getText();
						} else if (text == 'LineItems') {
							LineItems = arrayOfPayments(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Prepayment consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static XeroPrepaymentAllocationResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new XeroPrepaymentAllocationResponse(parser);
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
	




    private static List<Allocations> arrayOfAllocations(System.JSONParser p) {
        List<Allocations> res = new List<Allocations>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Allocations(p));
        }
        return res;
    }



    private static List<Payments> arrayOfPayments(System.JSONParser p) {
        List<Payments> res = new List<Payments>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Payments(p));
        }
        return res;
    }





}
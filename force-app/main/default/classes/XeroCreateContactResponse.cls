public class XeroCreateContactResponse {
	
    public XeroCreateContactResponse()
    {
        
    }
    
    public class Addresses {
		public String AddressType {get;set;} 
		public String AddressLine1 {get;set;} 
		public String City {get;set;} 
		public String PostalCode {get;set;} 
		public String AttentionTo {get;set;} 

		public Addresses(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AddressType') {
							AddressType = parser.getText();
						} else if (text == 'AddressLine1') {
							AddressLine1 = parser.getText();
						} else if (text == 'City') {
							City = parser.getText();
						} else if (text == 'PostalCode') {
							PostalCode = parser.getText();
						} else if (text == 'AttentionTo') {
							AttentionTo = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Addresses consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public List<Contacts> Contacts {get;set;} 

	public XeroCreateContactResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Contacts') {
						Contacts = arrayOfContacts(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Phones {
		public String PhoneType {get;set;} 
		public String PhoneNumber {get;set;} 
		public String PhoneAreaCode {get;set;} 
		public String PhoneCountryCode {get;set;} 

		public Phones(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'PhoneType') {
							PhoneType = parser.getText();
						} else if (text == 'PhoneNumber') {
							PhoneNumber = parser.getText();
						} else if (text == 'PhoneAreaCode') {
							PhoneAreaCode = parser.getText();
						} else if (text == 'PhoneCountryCode') {
							PhoneCountryCode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Phones consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Contacts {
		public String ContactID {get;set;} 
		public String ContactStatus {get;set;}
        public String ContactNumber {get;set;}
		public String Name {get;set;} 
		public String FirstName {get;set;} 
		public String LastName {get;set;} 
		public String EmailAddress {get;set;} 
		public String SkypeUserName {get;set;} 
		public String BankAccountDetails {get;set;} 
		public String TaxNumber {get;set;} 
		public String AccountsReceivableTaxType {get;set;} 
		public String AccountsPayableTaxType {get;set;} 
		public List<Addresses> Addresses {get;set;} 
		public List<Phones> Phones {get;set;} 
		public String UpdatedDateUTC {get;set;} 
		public Boolean IsSupplier {get;set;} 
		public Boolean IsCustomer {get;set;} 
		public String DefaultCurrency {get;set;} 

		public Contacts(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ContactID') {
							ContactID = parser.getText();
						} else if (text == 'ContactStatus') {
							ContactStatus = parser.getText();
						} else if (text == 'Name') {
							Name = parser.getText();
						} else if (text == 'ContactNumber') {
							ContactNumber = parser.getText();
						} else if (text == 'FirstName') {
							FirstName = parser.getText();
						} else if (text == 'LastName') {
							LastName = parser.getText();
						} else if (text == 'EmailAddress') {
							EmailAddress = parser.getText();
						} else if (text == 'SkypeUserName') {
							SkypeUserName = parser.getText();
						} else if (text == 'BankAccountDetails') {
							BankAccountDetails = parser.getText();
						} else if (text == 'TaxNumber') {
							TaxNumber = parser.getText();
						} else if (text == 'AccountsReceivableTaxType') {
							AccountsReceivableTaxType = parser.getText();
						} else if (text == 'AccountsPayableTaxType') {
							AccountsPayableTaxType = parser.getText();
						} else if (text == 'Addresses') {
							Addresses = arrayOfAddresses(parser);
						} else if (text == 'Phones') {
							Phones = arrayOfPhones(parser);
						} else if (text == 'UpdatedDateUTC') {
							UpdatedDateUTC = parser.getText();
						} else if (text == 'IsSupplier') {
							IsSupplier = parser.getBooleanValue();
						} else if (text == 'IsCustomer') {
							IsCustomer = parser.getBooleanValue();
						} else if (text == 'DefaultCurrency') {
							DefaultCurrency = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Contacts consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static XeroCreateContactResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new XeroCreateContactResponse(parser);
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
	
    private static List<Addresses> arrayOfAddresses(System.JSONParser p) {
        List<Addresses> res = new List<Addresses>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Addresses(p));
        }
        return res;
    }







    private static List<Phones> arrayOfPhones(System.JSONParser p) {
        List<Phones> res = new List<Phones>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Phones(p));
        }
        return res;
    }




    private static List<Contacts> arrayOfContacts(System.JSONParser p) {
        List<Contacts> res = new List<Contacts>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Contacts(p));
        }
        return res;
    }
    
}
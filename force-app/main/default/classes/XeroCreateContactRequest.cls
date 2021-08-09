public class XeroCreateContactRequest {
    
    public XeroCreateContactRequest()
    {
        
    }
    
    public class Addresses {
		public String AddressType {get;set;} 
		public String AddressLine1 {get;set;} 
		public String AddressLine2 {get;set;} 
		public String City {get;set;} 
		public String PostalCode {get;set;} 
	
        public Addresses(){
            
        }
		public Addresses(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AddressType') {
							AddressType = parser.getText();
						} else if (text == 'AddressLine1') {
							AddressLine1 = parser.getText();
						} else if (text == 'AddressLine2') {
							AddressLine2 = parser.getText();
						} else if (text == 'City') {
							City = parser.getText();
						} else if (text == 'PostalCode') {
							PostalCode = parser.getText();
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
    
	

	public XeroCreateContactRequest(JSONParser parser) {
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
		
        public Phones(){
            
        }
		public Phones(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'PhoneType') {
							PhoneType = parser.getText();
						} 
                        if (text == 'PhoneNumber') {
							PhoneNumber = parser.getText();
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
		public String Name {get;set;}
		public String FirstName {get;set;}
		public String LastName {get;set;}
        public String ContactNumber {get;set;}
		public List<Addresses> Addresses {get;set;} 
		public List<Phones> Phones {get;set;} 
		public String UpdatedDateUTC {get;set;} 
		public String IsSupplier {get;set;} 
		public String IsCustomer {get;set;} 
		
        public Contacts()
        {
            
        }
        
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
                        }if (text == 'FirstName') {
							FirstName = parser.getText();
						}if (text == 'LastName') {
							LastName = parser.getText();
						}else if (text == 'ContactNumber') {
							ContactNumber = parser.getText();
						}else if (text == 'Addresses') {
							Addresses = arrayOfAddresses(parser);
						} else if (text == 'Phones') {
							Phones = arrayOfPhones(parser);
						} else if (text == 'UpdatedDateUTC') {
							UpdatedDateUTC = parser.getText();
						} else if (text == 'IsSupplier') {
							IsSupplier = parser.getText();
						} else if (text == 'IsCustomer') {
							IsCustomer = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Contact consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static XeroCreateContactRequest parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new XeroCreateContactRequest(parser);
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
	


    private static List<Phones> arrayOfPhones(System.JSONParser p) {
        List<Phones> res = new List<Phones>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Phones(p));
        }
        return res;
    }

    private static List<Addresses> arrayOfAddresses(System.JSONParser p) {
        List<Addresses> res = new List<Addresses>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Addresses(p));
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
public class XeroCreateInvoiceResponse {
    
    
    public XeroCreateInvoiceResponse()
    {
        
    }
    
    public List<Invoices> Invoices {get;set;} 

    public XeroCreateInvoiceResponse(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'Invoices') {
                        Invoices = arrayOfInvoices(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Invoices {
        public String Type_Z {get;set;} // in json: Type
        public Contact Contact {get;set;} 
        public String Date_z {get;set;} 
        public String DueDate {get;set;} 
        public String DateString {get;set;} 
        public String DueDateString {get;set;} 
        public String Status {get;set;} 
        public String LineAmountTypes {get;set;} 
        public Double SubTotal {get;set;} 
        public String TotalTax {get;set;} 
        public String Total {get;set;} 
        public String UpdatedDateUTC {get;set;} 
        public String CurrencyCode {get;set;} 
        public String InvoiceID {get;set;} 
        public String InvoiceNumber {get;set;} 
        public String AmountDue {get;set;} 
        public String AmountPaid {get;set;} 
        public String AmountCredited {get;set;} 
        public String Reference {get;set;} 

        public Invoices(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'Type') {
                            Type_Z = parser.getText();
                        } else if (text == 'Contact') {
                            Contact = new Contact(parser);
                        } else if (text == 'Date') {
                            Date_z = parser.getText();
                        } else if (text == 'DueDate') {
                            DueDate = parser.getText();
                        } else if (text == 'DateString') {
                            DateString = parser.getText();
                        } else if (text == 'DueDateString') {
                            DueDateString = parser.getText();
                        } else if (text == 'Status') {
                            Status = parser.getText();
                        } else if (text == 'LineAmountTypes') {
                            LineAmountTypes = parser.getText();
                        } else if (text == 'SubTotal') {
                            SubTotal = parser.getDoubleValue();
                        } else if (text == 'TotalTax') {
                            TotalTax = parser.getText();
                        } else if (text == 'Total') {
                            Total = parser.getText();
                        } else if (text == 'UpdatedDateUTC') {
                            UpdatedDateUTC = parser.getText();
                        } else if (text == 'CurrencyCode') {
                            CurrencyCode = parser.getText();
                        } else if (text == 'InvoiceID') {
                            InvoiceID = parser.getText();
                        } else if (text == 'InvoiceNumber') {
                            InvoiceNumber = parser.getText();
                        } else if (text == 'AmountDue') {
                            AmountDue = parser.getText();
                        } else if (text == 'AmountPaid') {
                            AmountPaid = parser.getText();
                        } else if (text == 'AmountCredited') {
                            AmountCredited = parser.getText();
                        } else if (text == 'Reference') {
                            Reference = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Invoices consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Contact {
        public String ContactID {get;set;} 
        public String Name {get;set;} 

        public Contact(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'ContactID') {
                            ContactID = parser.getText();
                        } else if (text == 'Name') {
                            Name = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Contact consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static XeroCreateInvoiceResponse parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new XeroCreateInvoiceResponse(parser);
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
    
    private static List<Invoices> arrayOfInvoices(System.JSONParser p) {
        List<Invoices> res = new List<Invoices>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Invoices(p));
        }
        return res;
    }
    
}
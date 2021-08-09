public class XeroPrepaymentAllocationRequest {
	
    public XeroPrepaymentAllocationRequest(){
        
    }
    
    public class Invoice {
		public String InvoiceID;
        
        public Invoice(){
        
    }
	}
	
	public String Amount;
	public Invoice Invoice;

	
	public static XeroPrepaymentAllocationRequest parse(String json) {
		return (XeroPrepaymentAllocationRequest) System.JSON.deserialize(json, XeroPrepaymentAllocationRequest.class);
	}
    
}
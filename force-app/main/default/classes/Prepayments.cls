public class Prepayments {
	
    public Prepayments()
    {
        
    }
    
    public XeroPrepaymentAllocationResponse allocateBankTransactions(String invoiceId, String prePaymentId, Decimal amount){
        XeroClient xc = new XeroClient();
        XeroPrepaymentAllocationRequest req = PreparePaymentDetailsFromOpportunity(invoiceId, amount);
        String jsonreq;
        if(req != null)
        	jsonreq = JSON.serialize(req);
        system.debug('Req ::' + jsonreq);
        HttpResponse res = xc.doPut(XeroConfig.API_ENDPOINT_URL+'Prepayments/'+prePaymentId+'/Allocations', jsonreq);
        system.debug('Urvish :' + res.getBody());
        XeroPrepaymentAllocationResponse resposne = XeroPrepaymentAllocationResponse.parse(res.getBody());
        return resposne;
    }
    
    public XeroPrepaymentAllocationRequest PreparePaymentDetailsFromOpportunity(String invoiceId, Decimal amount){
        XeroPrepaymentAllocationRequest prepaymentallocaterequest = new XeroPrepaymentAllocationRequest();
        XeroPrepaymentAllocationRequest.Invoice invoice = new XeroPrepaymentAllocationRequest.Invoice();
        invoice.InvoiceID = invoiceId;
        prepaymentallocaterequest.invoice = invoice;
        prepaymentallocaterequest.Amount = String.valueOf(amount);
        return prepaymentallocaterequest;
    }
    
}
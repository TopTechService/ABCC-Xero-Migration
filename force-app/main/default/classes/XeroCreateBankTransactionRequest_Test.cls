//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class XeroCreateBankTransactionRequest_Test {
	
	static testMethod void testParse() {
		String json = '{\"Type_Z\":\"RECEIVE-PREPAYMENT\",\"Reference\":\"INV-0105\",\"LineItems\":[{\"UnitAmount\":\"100.00\",\"Quantity\":\"1.00\",\"Description\":\"Hello WORLD Tuesday 17 October 2017(1 x Non Member Ticket)\",\"AccountCode\":\"3050\"}],\"Contact\":{\"ContactID\":\"ec35967a-62c9-4638-9182-ae58980ffa49\"},\"BankAccount\":{\"Code\":\"100\"}}';
		XeroCreateBankTransactionRequest obj = XeroCreateBankTransactionRequest.parse(json);
		System.assert(obj != null);
	}
}
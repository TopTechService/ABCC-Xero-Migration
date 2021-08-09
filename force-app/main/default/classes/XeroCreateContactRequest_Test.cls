@IsTest
public class XeroCreateContactRequest_Test {

	static testMethod void testParse() {
		String json = '{\"Contacts\":[{\"UpdatedDateUTC\":null,\"Phones\":[{\"PhoneType\":\"ddxf\",\"PhoneNumber\":\"ddxf\"}],\"Name\":\"dsjvf skeiufgdsj\",\"IsSupplier\":null,\"IsCustomer\":null,\"ContactStatus\":null,\"ContactNumber\":\"003N000001BolmEIAR\",\"ContactID\":null,\"Addresses\":[{\"PostalCode\":\"ddxf\",\"City\":\"gfds\",\"AddressType\":\"ddxf\",\"AddressLine2\":\"ddxf\",\"AddressLine1\":\"fgbfdsbg\"}]}]}';
		XeroCreateContactRequest obj = XeroCreateContactRequest.parse(json);
		System.assert(obj != null);
}
    
    
}
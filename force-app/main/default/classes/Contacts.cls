public class Contacts {
	public Contacts() {
			
	}

	public XeroCreateContactResponse createContacts(List<Contact> lstCon){
		XeroClient xc = new XeroClient();
        List<Account> updatedAcc = new List<Account>();
        map<String,String> mapAcctoXeroId = new map<String,String>();
        XeroCreateContactRequest req = PrepareContactDetailsFromAccount(lstCon);
        String jsonreq;
        if(req != null)
        	jsonreq = JSON.serialize(req);
        system.debug('Urvish ::' + jsonreq);
        HttpResponse res = xc.doPost(XeroConfig.API_ENDPOINT_URL+'contacts', jsonreq);
        system.debug('Res :' + res.getBody());
        XeroCreateContactResponse response = XeroCreateContactResponse.parse(res.getBody());
        system.debug('Urvish 25/4:::' + response);

        return response;
	}

	public XeroCreateContactResponse getContacts(Integer page){
		XeroClient xc = new XeroClient();
		HttpResponse res = xc.doGet(XeroConfig.API_ENDPOINT_URL+'contacts', null);
        system.debug('Res :' + res.getBody());
        XeroCreateContactResponse response = XeroCreateContactResponse.parse(res.getBody());

        return response;
	}

	public XeroCreateContactRequest PrepareContactDetailsFromAccount(List<Contact> lstCon){
		XeroCreateContactRequest createcontactrequest = new XeroCreateContactRequest();
        if(lstCon != null && lstCon.size() > 0){
			XeroCreateContactRequest.Addresses addresses = new XeroCreateContactRequest.Addresses();
            XeroCreateContactRequest.Phones phones = new XeroCreateContactRequest.Phones();
            XeroCreateContactRequest.Contacts contact = new XeroCreateContactRequest.Contacts();
            for(Contact objCon : lstCon)
            {
                System.debug(objCon);
                if(objCon.Account != null && objCon.Account.Name != null){
                   system.debug('Dan1:' + objCon.Account.Name); 
                   contact.Name = objCon.Account.Name;
                }else{
                   contact.Name = objCon.Company_Name__c != null ? objCon.Company_Name__c : objCon.Name; 
                }
                
                contact.FirstName = objCon.FirstName;
                contact.LastName = objCon.LastName;
                
                contact.addresses = new List<XeroCreateContactRequest.Addresses>();
                	addresses.AddressType = 'POBOX';
                    addresses.AddressLine1 = objCon.MailingStreet;
                	addresses.AddressLine2 = '';
                    addresses.City = objCon.MailingCity;
                    addresses.PostalCode = objCon.MailingPostalCode;
                contact.addresses.Add(addresses);
                
                contact.phones = new List<XeroCreateContactRequest.Phones>();
                    phones.PhoneNumber = objCon.Phone;
                contact.phones.add(phones);

                System.debug(contact);
                
                createcontactrequest.Contacts = new List<XeroCreateContactRequest.Contacts>();
                createcontactrequest.Contacts.add(contact);
            }
            return createcontactrequest;
		}
        return null;
	}
}
@isTest
public class Contacts_test {
     @testsetup
    Public Static void testData(){
         List<Contact> conList = new List<Contact>();
         Contact con = new Contact();
         con.LastName = 'test';
         conList.add(con);
        
         Contact con1 = new Contact();
         con1.LastName = 'test2';
         conList.add(con1);
        
        if(conList.size()>0)
        {
           insert conList;
        }
        csXero_Setting__c xeroSetting = New csXero_Setting__c(Name = 'Xero',
                                                             Xero_Tenant_Id__c = '7febd1ae-5213-4189-a4a5-adc7f39551a5');
        insert xeroSetting;        
    }
    
@istest
    static void testcreateContacts(){
        List<Contact> cons = [Select id,Name,Xero_Contact_Id__c,MailingPostalCode,MailingStreet,Account.Name,
                                MailingCity,MailingState,Phone,Company_Name__c,FirstName,LastName from Contact];
        Contacts objcon = new Contacts();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
       	objcon.createContacts(cons);
        Test.StopTest();
    }
}
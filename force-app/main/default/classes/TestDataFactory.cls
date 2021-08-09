@isTest
public class TestDataFactory {

    public static void createXeroTenantId() {
        csXero_Setting__c tenantId = New csXero_Setting__c(Name = 'Test',
                                                                    Xero_Tenant_Id__c = 'd3ad10bc-3fdd-4e39-8954-e165fa6bd1ba');
        insert tenantId;
    }
/*
    public static List<Account> createAccounts(Integer numOfAccounts, String typeOfAccount) {
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numOfAccounts;i++) {
            Account a = new Account(Name = 'ABC Limited' + i,
                                   Xero_First_Name__c = 'Andrea',
                                   Xero_Last_Name__c = 'Dutchess' + i,
                                   Xero_eMail__c = 'a.dutchess' + i + '@abclimited.com',
                                   Account_Status__c = 'Active',
                                   Type = typeOfAccount);
            accts.add(a);
        }
        
        insert accts;
        
        return accts;
    }
*/    
    public static Map<Id, List<Contact>> createContacts(List<Account> Accounts, Integer numOfContacts) {

        Map<Id, List<Contact>> mapOfAccountIdToListOfContacts = New Map<Id, List<Contact>>();
        List<Contact> addedContacts = New List<Contact>();
        List<Contact> accContacts = New List<Contact>();

        for(Account ac :Accounts) {
            for(Integer i=0;i<numOfContacts;i++) {
                accContacts.clear();
                Contact newContact = New Contact(LastName='TestContact'+i,
                                                AccountId=ac.Id);
                accContacts.add(newContact);
            }
            mapOfAccountIdToListOfContacts.put(ac.Id, accContacts);
            addedContacts.addAll(accContacts);
        }
        insert addedContacts;
        return mapOfAccountIdToListOfContacts;
    }
/*
    public static Void createAffiliates(List<Account> accounts) {
        List<Bread_Winner__Breadwinner_Account_Connection__c> affiliates = 
            New List<Bread_Winner__Breadwinner_Account_Connection__c>();
        
        for(Account ac :accounts) {
            Bread_Winner__Breadwinner_Account_Connection__c bwac = 
                New Bread_Winner__Breadwinner_Account_Connection__c(Bread_Winner__CompanyName__c = ac.Name,
                                                                   Bread_Winner__EmailAddress__c = ac.Xero_eMail__c,
                                                                   Bread_Winner__FirstName__c = ac.Xero_First_Name__c,
                                                                   Bread_Winner__LastName__c = ac.Xero_Last_Name__c,
                                                                   Bread_Winner__Is_Customer__c = true,
                                                                   Bread_Winner__Salesforce_Account__c = ac.Id,
                                                                   Bread_Winner__Reference_Id__c = 'bd2270c3-8706-4c11-9cfb-000b551c3f51',
                                                                   Bread_Winner__Status__c = 'ACTIVE',
                                                                   Bread_Winner__Xero_Org_ID__c = '!wQSk-');
            affiliates.add(bwac);
        }
        insert affiliates;
    }
    
    public static List<Opportunity> createOpportunities(List<Account> accountsList, Map<Id, List<Contact>> mapOfAccountIdToListOfContacts, Integer numOfOpportunities) {
        
        List<Opportunity> Opportunities = New List<Opportunity>();
        Id oppContact;
        
        for(Account ac :accountsList) {
            List<Contact> relatedContacts = mapOfAccountIdToListOfContacts.get(ac.Id);
            if(relatedContacts.size()>0) {
                oppContact = relatedContacts[0].Id;
            }
            for(Integer i=0;i<numOfOpportunities;i++) {
                Opportunity opportunity = New Opportunity(Name = 'Test' + i,
                                                         AccountId = ac.Id,
                                                         CloseDate = Date.today(),
                                                         StageName = 'Discovery Meeting',
                                                         Contact__c = oppContact);
                Opportunities.add(opportunity);
            }
        }
        insert Opportunities;
        return opportunities;
    }
*/    
    public static List<PricebookEntry> createProducts(Integer numOfProducts) {
        
        List<Product2> Products = New List<Product2>();
        for(Integer i=0;i<numOfProducts;i++) {
            Product2 p = New Product2(Name = 'TestProduct' + i,
                                     isActive = true,
                                     Description = 'TestProduct' + i);
            Products.add(p);
        }
        insert Products;
        
        //Create an instance of the standard price book
        Pricebook2 standardPriceBook = New Pricebook2(ID = test.getStandardPricebookId(),
                                                     isActive = true);
        update standardPriceBook;
        
        //Create pricebook entries for each product
        List<PricebookEntry> PricebookEntries = New List<PricebookEntry>();
        for(Product2 p2 :Products) {
            PricebookEntry pbe = New PricebookEntry(Pricebook2Id = standardPriceBook.Id,
                                                   Product2Id = p2.Id,
                                                   UnitPrice = 1080,
                                                   isActive = true);
            PricebookEntries.add(pbe);
        }
        insert PricebookEntries;
        return PricebookEntries;
    }
    
    public static void addProductsToOpportunities(List<Opportunity> opportunityList, List<PricebookEntry> pricebookEntryList) {
        
        List<OpportunityLineItem> opportunityProducts = New List<OpportunityLineItem>();
        for(Opportunity oppo :opportunityList) {
            for(PricebookEntry pbe :pricebookEntryList) {
                OpportunityLineItem oli = New OpportunityLineItem(OpportunityId = oppo.Id,
                                                                 PricebookEntryId = pbe.Id,
                                                                 Product2Id = pbe.Product2Id,
                                                                 Quantity = 1,
                                                                 ServiceDate = Date.today());
                opportunityProducts.add(oli);
            }
        }
        insert opportunityProducts;
    }
}
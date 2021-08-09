@isTest
public class XeroClient_test {
     @testsetup
    Public Static void testData(){
       Xero_Setting__c XS = new Xero_Setting__c();
       XS.Name='TESTSETTING';
       XS.Private_Key__c='MIICWgIBAAKBgFXnHNuquNSBAyz/gIx7BJvmiGQve6w7mjQtzmyA8Bee2tsq8Ai0'+
                            'VA4AUzodNIJOwcBmcca4ZWGwsJs7hscS80pxk+CA94kV8SRaMRbKryG1PNaBzRpJ'+
                            'azZEEYhvCrMb7qw0+VGvBxbBWyJMu4n2BK3WFiMEutfa0VXZnMCeKWX/AgMBAAEC'+
                            'gYAG+CIiPD6Ulwbv7qa6PvzHvTNRlXyeI5PGKfU2XlucPvoYj+o7eo3bOPGHpHjv'+
                            'HX6gom8WpT0saM5bOcAchJASYPpFdOsCgZlnNDa7yPJ86Eb7BQXUxvOu/XqyyZ3r'+
                            'E50cDSQ0mGaF/ZkO+HbDSguNkpntI4CnCWcQnKhQmLbtYQJBAJ34Y7OA3K+qbh+D'+
                            '88pgPDYiod0sAq6sUq5RrbhseESX4X+/PNPtJLjcqnXZCX35v1oQFaG7YwpbB1fZ'+
                            'gRS3OZECQQCLNeAfJbeWqzR9ggt489tM8CibJsJYhU60h9iUZj/GVYIKlHeHalU2'+
                            'CgUs1z9JWOaUswKtZU9zAMctgherXV6PAkBhfuwJ3X5W7NkKmmXcgYin4LgFySPe'+
                            'qnxdGgwdxtRzgUmrjlv8cGA5t/d8xHcXSQzQiRzQtNZrjcL6dUM1heABAkBqaD3t'+
                            '0PiplCfFH5gBVfR0tMV1AoVfAFaOq5+inx10Tnvd9mn++go0Cii2g7j+KZPmaYZM'+
                            'X7oA38FfSacp926FAkBcmT0mVMCurwfXGE1dUZ/d3efwowRCHXRUwlsczmOX1GTU'+
                            'C+1df34YrEq/RiaSXix/usNoLxUfTA+23BWSkgEv';
       insert XS;
    }
    @isTest
    static void testdoGet(){
        Xero_Setting__c xsc = [Select Id, Name, Private_Key__c  from Xero_Setting__c limit 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        XeroClient XC = new XeroClient();
        Test.startTest();
       	XC.doGet('www.anything,com','query');
        Test.StopTest();
    }
     @isTest
    static void testdoPost(){
        Xero_Setting__c xsc = [Select Id, Name, Private_Key__c  from Xero_Setting__c limit 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        XeroClient XC = new XeroClient();
        Test.startTest();
       	XC.doPost('www.anything,com','{"example":"test"}');
        Test.StopTest();
    }
     @isTest
    static void testdoPut(){
        Xero_Setting__c xsc = [Select Id, Name, Private_Key__c  from Xero_Setting__c limit 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        XeroClient XC = new XeroClient();
        Test.startTest();
       	XC.doPut('www.anything,com','{"example":"test"}');
        Test.StopTest();
    }
}
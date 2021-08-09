@isTest
global class getXeroTenantIdTestMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest req) {
        system.assertEquals('callout:Xero/connections', req.getEndpoint());
        system.assertEquals('GET', req.getMethod());

        //Create a fake response
        HTTPResponse response = New HttpResponse();
        String xeroResponseBody = '[{"Id": "fe0ee125-b42f-44ae-a04d-a0db5de363bb", '+
                                '"authEventId":"3b4a88d4-c12b-4f4f-9999-d7de279194d0", '+
                                '"tenantId":"6721c022-2163-4f10-bc66-a0cf7b4812d7", '+
                                '"tenantType":"ORGANISATION", '+
                                '"tenantName":"Test Co.", '+
                                '"createdDateUtc":"2021-01-18T05:58:32.0252800", '+
                                '"updatedDateUtc":"2021-01-18T05:58:32.0282580"}]';

        response.setHeader('Date', 'Tue, 19 Jan 2021 03:28:28 GMT');
        response.setBody(xeroResponseBody);
        response.setStatusCode(200);

        return response;
    }
}
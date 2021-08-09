public class connectXero {
    
    public connectXero(ApexPages.StandardController controller){
    }
    
    public static PageReference authorizeNamedCredential() {

        //Schedule the get Xero Tenant Id job in 5 minutes.
        Datetime schedTime = Datetime.Now().addMinutes(5);
        String hour = String.valueOf(schedTime.hour());
        String min = String.valueOf(schedTime.minute()); 
        String ss = String.valueOf(schedTime.second());
        
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        
        UpdateXeroTenantIdSched s = new UpdateXeroTenantIdSched(); 
        Id schedJobId = System.schedule('Get Xero Tenant Id - ' + String.valueOf(Datetime.now()), nextFireTime, s);
        system.debug('Job Id:'+schedJobId);        
    
        AuthProvider provider = [
            SELECT Id,OauthKickoffUrl
            FROM AuthProvider
            WHERE DeveloperName = 'Xero'
        ];

        List<NamedCredential> credential = [
        SELECT Id 
        FROM NamedCredential 
        WHERE DeveloperName = 'Xero'];

    String oid = UserInfo.getOrganizationId();
    String domain = Url.getOrgDomainUrl().toExternalForm();
    String path = '/services/auth/xds/' + oid + '/Xero';
    String startUrl = '/' + String.valueOf(credential[0].Id).Left(15);

    Pagereference redirect = New Pagereference(domain + path);
    redirect.getParameters().put('startURL', startUrl);
    return redirect;
    }
}
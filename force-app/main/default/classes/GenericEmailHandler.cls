//Generic class to send Email
public class GenericEmailHandler{
    private Set<Id> oppIds;
    
    public static List<OrgWideEmailAddress> lstOrgWideEmailAddress{ get{
        if(lstOrgWideEmailAddress == null)
            lstOrgWideEmailAddress = [select id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName='Australian British Chamber of Commerce'];
        return lstOrgWideEmailAddress;
    } set;}
    
    public static List<EmailTemplate> lstET{ get{
        if(lstET == null)
            lstET = [SELECT HtmlValue FROM EmailTemplate where Name = :Label.TempId];
        return lstET;
    } set;}
    
    public static List<EmailTemplate> lstRefundET{ get{
        if(lstRefundET == null)
            lstRefundET = [SELECT HtmlValue FROM EmailTemplate where Name = 'Refund Email Template'];
        return lstRefundET;
    } set;}
    
    @future(callout=true)
    public static void generateEmailFormatForRefund(Set<Id> oppIds){
        List<Opportunity> refundSuccessOpps = [Select Id, Primary_Contact__c, Event__r.Event_Manager__r.Email from Opportunity where Id IN :oppIds];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for(Opportunity opp : refundSuccessOpps){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            if(!lstET.isEmpty())
            {
                message.setTemplateId(lstRefundET[0].id);
            }
            //getting Org wide email
            if(lstOrgWideEmailAddress.size()>0){
                message.setOrgWideEmailAddressId(lstOrgWideEmailAddress[0].id);
            }
            
            message.setTargetObjectId(Opp.Primary_Contact__c);
            message.setSaveAsActivity(false);
            message.setReplyTo(Opp.Event__r.Event_Manager__r.Email);
            message.setWhatId(opp.Id);
            mails.add(message);
        }
        if(!Test.isRunningTest()){
        Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        }
    }
}
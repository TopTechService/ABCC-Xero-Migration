/*
*@author: Arxxus
*@desc: This class is responsible for sending email notifications to receipents specified.
*/
public with sharing class EmailNotificationManager {
	
	/*
    * @desc: This method will send an email notification.
    * @param: developer name of the template, target object id
    */
    public boolean sendAnEmail(String emailTemplateDevName, Id recipient) {
    	Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { getEmailMessage(getEmailTemplate(emailTemplateDevName), recipient) });
    	if(!results[0].isSuccess()) {
    		return false;
    	}
        return true;
    }
    
    /*
    * @desc: This method will return the email template id when dev name is provided
    * @param: developer name of the template
    */
    public Id getEmailTemplate(String developerName) {
        return [SELECT ID FROM EmailTemplate WHERE DeveloperName =: developerName].Id;
    }
    
     /*
    * @desc: This method will return an object of Single email message
    * @param: template id, whatId, targetObjet
    */
    public Messaging.SingleEmailMessage getEmailMessage(Id emailTemplateId, Id targetObjectId) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTargetObjectId(targetObjectId);
        email.setOrgWideEmailAddressId(getFromAddress()) ;
        email.setTemplateId(emailTemplateId);
        email.setSaveAsActivity(false); //only for USER
        return email; 
    }
    
   /**
   * @Desc - This is responsible to give the from address from custom setting 
   */
    private id getFromAddress(){
      OrgWideEmailAddress org = [select id, Address,DisplayName  from OrgWideEmailAddress WHERE DisplayName ='Jennifer Cramond'];
      return org.Id;
    }
    
}
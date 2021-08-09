public class campaignRespondController {
    public String eventId {get;set;}
    public String response {get;set;}
    public String urlToCall {get;set;} 
	public campaignRespondController()
    {
        this.eventId = ApexPages.currentPage().getParameters().get('id');
        //this.response = ApexPages.currentPage().getParameters().get('response');
        System.debug('ANuj test '+this.eventId);
        //System.debug('ANuj test '+response);
        urlToCall = Label.EventRegistrationPageBaseURL+''+this.eventId;
    }
    
    /*public Pagereference updateCampaignMember()
    {
        try{
            CampaignMember cmpMember = [SELECT id,Status from CampaignMember where Id = :this.campaignMemberId];
            System.debug('Anuj cmpMember --> :'+cmpMember);
            if(response == 'yes'){
                cmpMember.Status = 'Responded Yes';
            }else if(response == 'no'){
                cmpMember.Status = 'Responded No';
            }
            update cmpMember;
            
            System.debug('Anuj cmpMember updated --> :'+cmpMember);
            
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Something went wrong'));
            System.debug('Exception '+e);
        }
		
        return null;
    }*/
    
    public PageReference callRedirect()
    {
        //wait for 2 sec
        //sleep(10000);
        //appending ID
        System.debug('urlToCall -->'+urlToCall);
        PageReference pg = new PageReference(urlToCall);
        pg.setRedirect(true);
        return pg;
    }
    
    /*public static void sleep(Long milliSeconds)
	{
        System.debug('Waiting start');
        Long timeDiff = 0;
        DateTime firstTime = System.now();
        do
        {
            timeDiff = System.now().getTime() - firstTime.getTime();
        }
        while(timeDiff <= milliSeconds);
        System.debug('Waiting End');
	}*/
}
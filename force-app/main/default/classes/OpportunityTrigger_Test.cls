@isTest
private class OpportunityTrigger_Test {
	
	@isTest static void erStatusUpdate() {
		//Arrange
		Opportunity opp =  new Opportunity();
		opp.StageName =  'Prospacting';
		opp.Name = 'Test Opp';
		opp.CloseDate = System.today();

		Insert Opp;

		Venue__c venue =  new Venue__c();
		venue.Name = 'Test Venue';
		venue.City__c = 'Test City';
		venue.Country__c = 'Test Country';
		venue.Postal_Code_Zip__c =  '123456';
		venue.State__c = 'Test State';
		venue.Street_Address_1__c = 'Test Street';
		insert venue;

		Event__c event = new Event__c();
		event.Name = 'Test Event';
		event.Venue__c = venue.Id;
		insert event;

		Event_Registration__c er = new Event_Registration__c();
		er.Opportunity__c = Opp.Id;
		er.Event__c = event.Id;
        er.Email__c = 'test@test.com';
		insert er;

		//act
		Test.startTest();
			Opp.StageName = 'Closed Won';
			update Opp;
			Opp.StageName = 'Closed Lost';
			update Opp;

		Test.stopTest();

		//assert

	}
	
}
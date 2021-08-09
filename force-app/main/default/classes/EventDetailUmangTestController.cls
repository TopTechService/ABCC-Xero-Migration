/*
  Description : controller for page, EventDetail
  
  Change Log: 
  June 15th 2017, initial version created. 
*/
public without Sharing class EventDetailUmangTestController extends PageControllerBase
{ 
    Public Event__c objEvent {get;set;} 
    public Event eventDetail {get;set;} 
    public inviteeDetail objIn {get;set;} 
    public List<SelectOption> lstAvailalbePurchaseType {Get;set;} 
    public List<SelectOption> lstQunaity {get;set;} 
    Public String PurchaseType {get;set;} 
    public String UnitPrice {Get;set;} 
    public String SelectedPacakgeName {Get;set;}
    Public Map<String, Event_Package__c> eventPackageNameMap {Get;set;}
    Public Discount__c objApplicableDiscount {Get;set;}
    public List<earlyBirdRow> lstEarlyBirdRows {get;set;} 
    public set<String> setHeader{get;set;}
    public RelatedAttendeeListCotroller myComponentController { get; set; }
    public List<GroupDiscountRow> lstGroupDiscountRows {get;set;} 
    Public Boolean IsGroupDiscountVisible {get;set;} 
    Public Boolean IsMember {get;set;} 
    public Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper> AttendeeList {get;set;}
    public Decimal maxAttendees {get;set;}
    public string vipCode {get;set;}
    public boolean isVIP {get;set;}
    public string paymentLink {get;set;}
    public Id oppId {get;set;}
    public boolean isCheck {get; set;}
    public List<SelectOption> avaiableStates {get; set;}
    public List<SelectOption> avaiableCountry {get; set;}
    public String registrationContext { get; set;}
    public Boolean isItManualRegistration { get; set;}
    public Boolean isDiscountCode {get; set;}
    public String discountCode {get; set;}
    public String opportunityLink{ get; set;}
    public string redirectionLink{get;set;}
    public boolean isItGuestReg {get;set;}
    public boolean alreadyPaid {get; set;}
    public boolean visiblePayNow {get; set;}
    public boolean visibleRegister {get; set;}
    public string eventManager {get; set;}
    
    public void isCheck(){
    
        if(isCheck == true){
            isCheck = True;
        }
    }
    
    public void onchangevalue(){}
    
    //class level 
    Public final string currencySymbol ='$';
    
    
    public EventDetailUmangTestController()
    {
        System.debug('In Constructor'+registrationContext);
        String registrationType = apexPages.currentPage().getParameters().get('type');
        isItManualRegistration = false;
        isDiscountCode = true;
        visiblePayNow = true;
        visibleRegister = false;
        if(registrationType != null && registrationType == 'manual'){
            List<Profile> userProfile = [Select Id, UserType from Profile Where Id=:userinfo.getprofileid()];
            if(userProfile.size() == 1 && userProfile[0].UserType != 'Guest'){
                isItManualRegistration = true;
            }
        }
        String eventIdParam = apexPages.currentPage().getParameters().get('id');
        System.debug('UB: eventIdParam ' + eventIdParam );
        objEvent = [select Id,Name,Event_Type__C,Event_Manager__c, Event_Manager__r.Name, Event_Manager__r.FirstName, 
                    Event_Name__c,Total_No_of_Attendees__c,Total_number_of_Seats__c,Event_Start_Date__c,Event_Start_Time__c,
                    Event_Finish_Time__c,Event_Description_HTML__c,Seats_Per_Table__c,venue__c,Timezone__c,
                    Venue__r.Name, Venue__r.Street_Address_1__c from Event__c where Id=:eventIdParam  limit 1];
        eventManager = objEvent.Event_Manager__r.FirstName;
        if(objIn == null) 
        {
            objIn  = new inviteeDetail();
        }
       eventDetail  = new  Event(objEvent);
       setHeader = new set<String>();
        
       AttendeeList = new Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper>();
       eventPackageNameMap = new Map<String, Event_Package__c>();
       objApplicableDiscount = new Discount__c();
       
       lstAvailalbePurchaseType  = populatePurchaseType(objEvent); 
       IsMember = false;
       lstQunaity = populateQuanity(); 
       lstEarlyBirdRows = populateEarlyBirdRows();
       IsGroupDiscountVisible  = false;
       lstGroupDiscountRows  = new List<GroupDiscountRow>();
       maxAttendees = 1;
        isVIP = false;
        populateavaiableStates();
        populateavaiableCountry();
        opportunityLink = URL.getSalesforceBaseUrl().toExternalForm();
        objIn.country = 'Australia';
        isItGuestReg = false;
        alreadyPaid = false;
    }
    
    Public void populateavaiableStates(){ 
        avaiableStates = new List<SelectOption>();
        avaiableStates.add(new SelectOption('',''));
        avaiableStates.add(new SelectOption('ACT','ACT'));
        avaiableStates.add(new SelectOption('NSW','NSW'));
        avaiableStates.add(new SelectOption('NT','NT'));
        avaiableStates.add(new SelectOption('QLD','QLD'));
        avaiableStates.add(new SelectOption('SA','SA'));
        avaiableStates.add(new SelectOption('TAS','TAS'));
        avaiableStates.add(new SelectOption('VIC','VIC'));
        avaiableStates.add(new SelectOption('WA','WA'));
        
    }
    
     Public void populateavaiableCountry(){ 
     avaiableCountry = new List<SelectOption>();
     avaiableCountry.add(new SelectOption('Afghanistan','Afghanistan'));
     avaiableCountry.add(new SelectOption('Albania','Albania'));
     avaiableCountry.add(new SelectOption('Algeria','Algeria')); 
     avaiableCountry.add(new SelectOption('American Samoa','American Samoa'));
     avaiableCountry.add(new SelectOption('Andorra','Andorra'));
     avaiableCountry.add(new SelectOption('Angola','Angola'));
     avaiableCountry.add(new SelectOption('Anguilla','Anguilla'));
     avaiableCountry.add(new SelectOption('Antarctica','Antarctica'));
     avaiableCountry.add(new SelectOption('Antigua and Barbuda','Antigua and Barbuda'));
     avaiableCountry.add(new SelectOption('Argentina','Argentina'));
     avaiableCountry.add(new SelectOption('Armenia','Armenia'));
     avaiableCountry.add(new SelectOption('Aruba','Aruba'));
     avaiableCountry.add(new SelectOption('Australia','Australia'));
     avaiableCountry.add(new SelectOption('Austria','Austria'));
     avaiableCountry.add(new SelectOption('Azerbaijan','Azerbaijan'));
     avaiableCountry.add(new SelectOption('Bahamas','Bahamas'));
     avaiableCountry.add(new SelectOption('Bahrain','Bahrain'));
     avaiableCountry.add(new SelectOption('Bangladesh','Bangladesh'));
     avaiableCountry.add(new SelectOption('Barbados','Barbados'));
     avaiableCountry.add(new SelectOption('Belarus','Belarus'));
     avaiableCountry.add(new SelectOption('Belgium','Belgium'));
     avaiableCountry.add(new SelectOption('Benin','Benin'));
     avaiableCountry.add(new SelectOption('Bermuda','Bermuda'));
     avaiableCountry.add(new SelectOption('Bhutan','Bhutan'));
     avaiableCountry.add(new SelectOption('Bolivia','Bolivia'));
     avaiableCountry.add(new SelectOption('Bosnia and Herzegowina','Bosnia and Herzegowina'));
     avaiableCountry.add(new SelectOption('Botswana','Botswana'));
     avaiableCountry.add(new SelectOption('Bouvet Island','Bouvet Island'));
     avaiableCountry.add(new SelectOption('Brazil','Brazil'));
     avaiableCountry.add(new SelectOption('British Indian Ocean Territory','British Indian Ocean Territory'));
     avaiableCountry.add(new SelectOption('Brunei Darussalam','Brunei Darussalam'));
     avaiableCountry.add(new SelectOption('Bulgaria','Bulgaria'));
     avaiableCountry.add(new SelectOption('Burkina Faso','Burkina Faso'));
     avaiableCountry.add(new SelectOption('Burundi','Burundi'));
     avaiableCountry.add(new SelectOption('Cambodia','Cambodia'));
     avaiableCountry.add(new SelectOption('Cameroon','Cameroon'));
     avaiableCountry.add(new SelectOption('Canada','Canada'));
     avaiableCountry.add(new SelectOption('Cape Verde','Cape Verde'));
     avaiableCountry.add(new SelectOption('Cayman Islands','Cayman Islands'));
     avaiableCountry.add(new SelectOption('Central African Republic','Central African Republic'));
     avaiableCountry.add(new SelectOption('Chad','Chad'));
     avaiableCountry.add(new SelectOption('Chile','Chile'));
     avaiableCountry.add(new SelectOption('China','China'));
     avaiableCountry.add(new SelectOption('Christmas Island','Christmas Island'));
     avaiableCountry.add(new SelectOption('Cocos (Keeling) Islands','Cocos (Keeling) Islands'));
     avaiableCountry.add(new SelectOption('Colombia','Colombia'));
     avaiableCountry.add(new SelectOption('Comoros','Comoros'));
     avaiableCountry.add(new SelectOption('Congo','Congo'));
     avaiableCountry.add(new SelectOption('Congo, the Democratic Republic of the','Congo, the Democratic Republic of the'));
     avaiableCountry.add(new SelectOption('Cook Islands','Cook Islands'));
     avaiableCountry.add(new SelectOption('Costa Rica','Costa Rica'));
     avaiableCountry.add(new SelectOption('Cote d\'Ivoire','Cote d\'Ivoire'));
     avaiableCountry.add(new SelectOption('Croatia (Hrvatska)','Croatia (Hrvatska)'));
     avaiableCountry.add(new SelectOption('Cuba','Cuba'));
     avaiableCountry.add(new SelectOption('Cyprus','Cyprus'));
     avaiableCountry.add(new SelectOption('Czech Republic','Czech Republic'));
     avaiableCountry.add(new SelectOption('Denmark','Denmark'));
     avaiableCountry.add(new SelectOption('Djibouti','Djibouti'));
     avaiableCountry.add(new SelectOption('Dominica','Dominica'));
     avaiableCountry.add(new SelectOption('Dominican Republic','Dominican Republic'));
     avaiableCountry.add(new SelectOption('East Timor','East Timor'));
     avaiableCountry.add(new SelectOption('Ecuador','Ecuador'));
     avaiableCountry.add(new SelectOption('Egypt','Egypt'));
     avaiableCountry.add(new SelectOption('El Salvador','El Salvador'));
     avaiableCountry.add(new SelectOption('Equatorial Guinea','Equatorial Guinea'));
     avaiableCountry.add(new SelectOption('Eritrea','Eritrea'));
     avaiableCountry.add(new SelectOption('Estonia','Estonia'));
     avaiableCountry.add(new SelectOption('Ethiopia','Ethiopia'));
     avaiableCountry.add(new SelectOption('Falkland Islands (Malvinas)','Falkland Islands (Malvinas)'));
     avaiableCountry.add(new SelectOption('Faroe Islands','Faroe Islands'));
     avaiableCountry.add(new SelectOption('Fiji','Fiji'));
     avaiableCountry.add(new SelectOption('Finland','Finland'));
     avaiableCountry.add(new SelectOption('France','France'));
     avaiableCountry.add(new SelectOption('France, Metropolitan','France, Metropolitan'));
     avaiableCountry.add(new SelectOption('French Guiana','French Guiana'));
     avaiableCountry.add(new SelectOption('French Polynesia','French Polynesia'));
     avaiableCountry.add(new SelectOption('French Southern Territories',''));
     avaiableCountry.add(new SelectOption('Gabon','Gabon'));
     avaiableCountry.add(new SelectOption('Gambia','Gambia'));
     avaiableCountry.add(new SelectOption('Georgia','Georgia'));
     avaiableCountry.add(new SelectOption('Germany','Germany'));
     avaiableCountry.add(new SelectOption('Ghana','Ghana'));
     avaiableCountry.add(new SelectOption('Gibraltar','Gibraltar'));
     avaiableCountry.add(new SelectOption('Greece','Greece'));
     avaiableCountry.add(new SelectOption('Greenland','Greenland'));
     avaiableCountry.add(new SelectOption('Grenada','Grenada'));
     avaiableCountry.add(new SelectOption('Guadeloupe','Guadeloupe'));
     avaiableCountry.add(new SelectOption('Guam','Guam'));
     avaiableCountry.add(new SelectOption('Guatemala','Guatemala'));
     avaiableCountry.add(new SelectOption('Guinea','Guinea'));
     avaiableCountry.add(new SelectOption('Guinea-Bissau','Guinea-Bissau'));
     avaiableCountry.add(new SelectOption('Guyana','Guyana'));
     avaiableCountry.add(new SelectOption('Haiti','Haiti'));
     avaiableCountry.add(new SelectOption('Heard and Mc Donald Islands','Heard and Mc Donald Islands'));
     avaiableCountry.add(new SelectOption('Holy See (Vatican City State)','Holy See (Vatican City State)'));
     avaiableCountry.add(new SelectOption('Honduras','Honduras'));
     avaiableCountry.add(new SelectOption('Hong Kong','Hong Kong'));
     avaiableCountry.add(new SelectOption('Hungary','Hungary'));
     avaiableCountry.add(new SelectOption('Iceland','Iceland'));
     avaiableCountry.add(new SelectOption('India','India'));
     avaiableCountry.add(new SelectOption('Indonesia','Indonesia'));
     avaiableCountry.add(new SelectOption('Iran (Islamic Republic of)','Iran (Islamic Republic of)'));
     avaiableCountry.add(new SelectOption('Iraq','Iraq'));
     avaiableCountry.add(new SelectOption('Ireland','Ireland'));
     avaiableCountry.add(new SelectOption('Israel','Israel'));
     avaiableCountry.add(new SelectOption('Italy','Italy'));
     avaiableCountry.add(new SelectOption('Jamaica','Jamaica'));
     avaiableCountry.add(new SelectOption('Japan','Japan'));
     avaiableCountry.add(new SelectOption('Jordan','Jordan'));
     avaiableCountry.add(new SelectOption('Kazakhstan','Kazakhstan'));
     avaiableCountry.add(new SelectOption('Kenya','Kenya'));
     avaiableCountry.add(new SelectOption('Kiribati','Kiribati'));
     avaiableCountry.add(new SelectOption('Korea, Democratic People\'s Republic of','Korea, Democratic People\'s Republic of'));
     avaiableCountry.add(new SelectOption('Korea, Republic of','Korea, Republic of'));
     avaiableCountry.add(new SelectOption('Kuwait','Kuwait'));
     avaiableCountry.add(new SelectOption('Kyrgyzstan','Kyrgyzstan'));
     avaiableCountry.add(new SelectOption('Lao People\'s Democratic Republic','Lao People\'s Democratic Republic'));
     avaiableCountry.add(new SelectOption('Latvia','Latvia'));
     avaiableCountry.add(new SelectOption('Lebanon','Lebanon'));
     avaiableCountry.add(new SelectOption('Lesotho','Lesotho'));
     avaiableCountry.add(new SelectOption('Liberia','Liberia'));
     avaiableCountry.add(new SelectOption('Libyan Arab Jamahiriya','Libyan Arab Jamahiriya'));
     avaiableCountry.add(new SelectOption('Liechtenstein','Liechtenstein'));
     avaiableCountry.add(new SelectOption('Lithuania','Lithuania'));
     avaiableCountry.add(new SelectOption('Luxembourg','Luxembourg'));
     avaiableCountry.add(new SelectOption('Macau','Macau'));
     avaiableCountry.add(new SelectOption('Macedonia, The Former Yugoslav Republic of','Macedonia, The Former Yugoslav Republic of'));
     avaiableCountry.add(new SelectOption('Madagascar','Madagascar'));
     avaiableCountry.add(new SelectOption('Malawi','Malawi'));
     avaiableCountry.add(new SelectOption('Malaysia','Malaysia'));
     avaiableCountry.add(new SelectOption('Maldives','Maldives'));
     avaiableCountry.add(new SelectOption('Mali','Mali'));
     avaiableCountry.add(new SelectOption('Malta','Malta'));
     avaiableCountry.add(new SelectOption('Marshall Islands','Marshall Islands'));
    avaiableCountry.add(new SelectOption('Martinique','Martinique'));
    avaiableCountry.add(new SelectOption('Mauritania','Mauritania'));
    avaiableCountry.add(new SelectOption('Mauritius','Mauritius'));
    avaiableCountry.add(new SelectOption('Mayotte','Mayotte'));
    avaiableCountry.add(new SelectOption('Mexico','Mexico'));
    avaiableCountry.add(new SelectOption('Micronesia, Federated States of','Micronesia, Federated States of'));
    avaiableCountry.add(new SelectOption('Moldova, Republic of','Moldova, Republic of'));
    avaiableCountry.add(new SelectOption('Monaco','Monaco'));
    avaiableCountry.add(new SelectOption('Mongolia','Mongolia'));
    avaiableCountry.add(new SelectOption('Montserrat','Montserrat'));
    avaiableCountry.add(new SelectOption('Morocco','Morocco'));
    avaiableCountry.add(new SelectOption('Mozambique','Mozambique'));
    avaiableCountry.add(new SelectOption('Myanmar','Myanmar'));
    avaiableCountry.add(new SelectOption('Namibia','Namibia'));
    avaiableCountry.add(new SelectOption('Nauru','Nauru'));
    avaiableCountry.add(new SelectOption('Nepal','Nepal'));
    avaiableCountry.add(new SelectOption('Netherlands','Netherlands'));
    avaiableCountry.add(new SelectOption('Netherlands Antilles','Netherlands Antilles'));
    avaiableCountry.add(new SelectOption('New Caledonia','New Caledonia'));
    avaiableCountry.add(new SelectOption('New Zealand','New Zealand'));
    avaiableCountry.add(new SelectOption('Nicaragua','Nicaragua'));
    avaiableCountry.add(new SelectOption('Niger','Niger'));
    avaiableCountry.add(new SelectOption('Nigeria','Nigeria'));
    avaiableCountry.add(new SelectOption('Niue','Niue'));
    avaiableCountry.add(new SelectOption('Norfolk Island','Norfolk Island'));
    avaiableCountry.add(new SelectOption('Northern Mariana Islands','Northern Mariana Islands'));
    avaiableCountry.add(new SelectOption('Norway','Norway'));
    avaiableCountry.add(new SelectOption('Oman','Oman'));
    avaiableCountry.add(new SelectOption('Pakistan','Pakistan'));
    avaiableCountry.add(new SelectOption('Palau','Palau'));
    avaiableCountry.add(new SelectOption('Panama','Panama'));
    avaiableCountry.add(new SelectOption('Papua New Guinea','Papua New Guinea'));
    avaiableCountry.add(new SelectOption('Paraguay','Paraguay'));
    avaiableCountry.add(new SelectOption('Peru','Peru'));
    avaiableCountry.add(new SelectOption('Philippines','Philippines'));
    avaiableCountry.add(new SelectOption('Pitcairn','Pitcairn'));
    avaiableCountry.add(new SelectOption('Poland','Poland'));
    avaiableCountry.add(new SelectOption('Portugal','Portugal'));
    avaiableCountry.add(new SelectOption('Puerto Rico','Puerto Rico'));
    avaiableCountry.add(new SelectOption('Qatar','Qatar'));
    avaiableCountry.add(new SelectOption('Reunion','Reunion'));
    avaiableCountry.add(new SelectOption('Russian Federation','Russian Federation'));
    avaiableCountry.add(new SelectOption('Rwanda','Rwanda'));
    avaiableCountry.add(new SelectOption('Saint Kitts and Nevis','Saint Kitts and Nevis'));
    avaiableCountry.add(new SelectOption('Saint LUCIA','Saint LUCIA'));
    avaiableCountry.add(new SelectOption('Saint Vincent and the Grenadines','Saint Vincent and the Grenadines'));
    avaiableCountry.add(new SelectOption('Samoa','Samoa'));
    avaiableCountry.add(new SelectOption('San Marino','San Marino'));
    avaiableCountry.add(new SelectOption('Sao Tome and Principe','Sao Tome and Principe'));
    avaiableCountry.add(new SelectOption('Saudi Arabia','Saudi Arabia'));
    avaiableCountry.add(new SelectOption('Senegal','Senegal'));
    avaiableCountry.add(new SelectOption('Seychelles','Seychelles'));
    avaiableCountry.add(new SelectOption('Sierra Leone','Sierra Leone'));
    avaiableCountry.add(new SelectOption('Singapore','Singapore'));
    avaiableCountry.add(new SelectOption('Slovakia (Slovak Republic)','Slovakia (Slovak Republic)'));
    avaiableCountry.add(new SelectOption('Slovenia','Slovenia'));
    avaiableCountry.add(new SelectOption('Solomon Islands','Solomon Islands'));
    avaiableCountry.add(new SelectOption('Somalia','Somalia'));
    avaiableCountry.add(new SelectOption('South Africa','South Africa'));
    avaiableCountry.add(new SelectOption('South Georgia and the South Sandwich Islands','South Georgia and the South Sandwich Islands'));
    avaiableCountry.add(new SelectOption('Spain','Spain'));
    avaiableCountry.add(new SelectOption('Sri Lanka','Sri Lanka'));
    avaiableCountry.add(new SelectOption('St. Helena','St. Helena'));
    avaiableCountry.add(new SelectOption('St. Pierre and Miquelon','St. Pierre and Miquelon'));
    avaiableCountry.add(new SelectOption('Sudan','Sudan'));
    avaiableCountry.add(new SelectOption('Suriname','Suriname'));
    avaiableCountry.add(new SelectOption('Svalbard and Jan Mayen Islands','Svalbard and Jan Mayen Islands'));
    avaiableCountry.add(new SelectOption('Swaziland','Swaziland'));
    avaiableCountry.add(new SelectOption('Sweden','Sweden'));
    avaiableCountry.add(new SelectOption('Switzerland','Switzerland'));
    avaiableCountry.add(new SelectOption('Syrian Arab Republic','Syrian Arab Republic'));
   avaiableCountry.add(new SelectOption('Taiwan, Province of China','Taiwan, Province of China'));
   avaiableCountry.add(new SelectOption('Tajikistan','Tajikistan'));
   avaiableCountry.add(new SelectOption('Tanzania, United Republic of','Tanzania, United Republic of'));
   avaiableCountry.add(new SelectOption('Thailand','Thailand'));
   avaiableCountry.add(new SelectOption('Togo','Togo'));
   avaiableCountry.add(new SelectOption('Tokelau','Tokelau'));
   avaiableCountry.add(new SelectOption('Tonga','Tonga'));
   avaiableCountry.add(new SelectOption('Trinidad and Tobago','Trinidad and Tobago'));
   avaiableCountry.add(new SelectOption('Tunisia','Tunisia'));
   avaiableCountry.add(new SelectOption('Turkey','Turkey'));
   avaiableCountry.add(new SelectOption('Turkmenistan','Turkmenistan'));
   avaiableCountry.add(new SelectOption('Turks and Caicos Islands','Turks and Caicos Islands'));
   avaiableCountry.add(new SelectOption('Tuvalu','Tuvalu'));
   avaiableCountry.add(new SelectOption('Uganda','Uganda'));
   avaiableCountry.add(new SelectOption('Ukraine','Ukraine'));
   avaiableCountry.add(new SelectOption('United Arab Emirates','United Arab Emirates'));
   avaiableCountry.add(new SelectOption('United Kingdom','United Kingdom'));
   avaiableCountry.add(new SelectOption('United States','United States'));
   avaiableCountry.add(new SelectOption('United States Minor Outlying Islands','United States Minor Outlying Islands'));
   avaiableCountry.add(new SelectOption('Uruguay','Uruguay'));
   avaiableCountry.add(new SelectOption('Uzbekistan','Uzbekistan'));
   avaiableCountry.add(new SelectOption('Vanuatu','Vanuatu'));
   avaiableCountry.add(new SelectOption('Venezuela','Venezuela'));
   avaiableCountry.add(new SelectOption('Viet Nam','Viet Nam'));
   avaiableCountry.add(new SelectOption('Virgin Islands (British)','Virgin Islands (British)'));
   avaiableCountry.add(new SelectOption('Virgin Islands (U.S.)','Virgin Islands (U.S.)'));
   avaiableCountry.add(new SelectOption('Wallis and Futuna Islands','Wallis and Futuna Islands'));
   avaiableCountry.add(new SelectOption('Western Sahara','Western Sahara'));
   avaiableCountry.add(new SelectOption('Yemen','Yemen'));
   avaiableCountry.add(new SelectOption('Yugoslavia','Yugoslavia'));
    avaiableCountry.add(new SelectOption('Zambia','Zambia'));
   avaiableCountry.add(new SelectOption('Zimbabwe','Zimbabwe'));

   }
    
    public void recreateEarlyBirdRows(){
        lstEarlyBirdRows = populateEarlyBirdRows();
    }
    public override void setComponentController(ComponentControllerBase compController) {
       myComponentController = (RelatedAttendeeListCotroller)compController;
    }
    public override ComponentControllerBase getMyComponentController() {
        return myComponentController;
    }
    
    public void initializeAttendees() {
       RelatedAttendeeListCotroller.AttendeeWrapper atd = new RelatedAttendeeListCotroller.AttendeeWrapper();
       atd.firstName = objIn.firstName;
       atd.lastName = objIn.LastName;
       atd.email = objIn.email;
       atd.company = objIn.company;
       atd.positionTitle = objIn.positionTitle;
       atd.undefined = false;
       
       AttendeeList.put(0, atd);
       myComponentController.populateAttenddes(AttendeeList);
    }
    
    Public List<SelectOption> populatePurchaseType(Event__c objEvent) 
    {
        List<SelectOption> lstResult = new List<SelectOption>(); 
        
        lstResult.add(new SelectOption('Table','Table')); 
        lstResult.add(new SelectOption('Single Ticket','SingleTicket')); 
        
        
        return lstResult;
    }
    public list<SelectOption> populateQuanity()
    {
        List<SelectOption> lstResult = new List<SelectOption>(); 
        
        for(Integer i=1;i<11;i++)
        {
            lstResult.add(new SelectOption(String.Valueof(i),String.Valueof(i)));
        }
        if(isItManualRegistration){
            for(Integer i=11;i<31;i++){
                lstResult.add(new SelectOption(String.Valueof(i),String.Valueof(i)));
            }
        }
        
        
        return lstResult;
    }
    Public void CalcluateCost()
    {
        if(!String.isBlank(UnitPrice)){
            System.debug('Integer'+UnitPrice);
            if(Integer.Valueof(UnitPrice.replace('$','').replaceAll(',','')) == 0){
                isItGuestReg = true;
            }
            List<Discount__c> lstTableDiscount = new List<Discount__c>(); 
            objApplicableDiscount = new Discount__c();
            System.debug('Umang' + PurchaseType); 
            if(PurchaseType == 'Single Ticket')
            {
                lstTableDiscount = [select Id,Name,Table_Quantity__c,Price__c,Number_of_Delegates__c,Fixed_price_Discount__c
                                     from Discount__c 
                                     where RecordType.Name='Group' and 
                                     Event__c =:objEvent.Id order by Table_Quantity__c asc ];
                for(Discount__c objDis : lstTableDiscount )
                 {
                     if(objIn.selectedPurchaseQuantity >= objDis.Number_of_Delegates__c) 
                     {
                         objApplicableDiscount = objDis;
                     }
                 }
                System.debug('SelectedPurchaseQuantity: '+objIn.selectedPurchaseQuantity);
                system.debug('CurrentPriceOfPurchase: ' +objIn.currentPriceOfPurchase);
                maxAttendees = objIn.selectedPurchaseQuantity;
            }
            System.debug('Umang' + PurchaseType);       
             if(PurchaseType == 'Table') 
             {
                 
                lstTableDiscount = [select Id,Name,Table_Quantity__c,Price__c,Fixed_price_Discount__c from Discount__c where RecordType.Name='Table' and Event__c =:objEvent.Id order by Table_Quantity__c asc ];             
                 for(Discount__c objDis : lstTableDiscount )
                 {
                     if(objIn.selectedPurchaseQuantity >= objDis.Table_Quantity__c) 
                     {
                         objApplicableDiscount = objDis;
                     }
                 }
                 System.debug('Umang'+objIn.selectedPurchaseQuantity + objEvent.Seats_Per_Table__c);
                 maxAttendees = objIn.selectedPurchaseQuantity * objEvent.Seats_Per_Table__c;
             }
             
             system.debug('Gaurang: got value of UnitPrice :' + unitPrice); 
            if(unitPrice == '$0'){
                visiblePayNow = false;
                visibleRegister = true;
            } Else {
                visiblePayNow = true;
                visibleRegister = false;
            }
             try
             {
                 List<String> args = new String[]{'0','number','###,###,##0.00'};
                 if(objApplicableDiscount != null && objApplicableDiscount.Fixed_price_Discount__c !=null && !string.IsBlank(UnitPrice) && objIn.selectedPurchaseQuantity != null  )
                 objIn.currentPriceOfPurchase = currencySymbol +  String.format( (( Decimal.Valueof(UnitPrice.replace('$','').replaceAll(',','')) * objIn.selectedPurchaseQuantity ) - (objApplicableDiscount.Fixed_price_Discount__c)).format(), args);
                 else if (!string.IsBlank(UnitPrice))
                 objIn.currentPriceOfPurchase  = currencySymbol +  String.format( (( Decimal.Valueof(UnitPrice.replace('$','').replaceAll(',','')) * objIn.selectedPurchaseQuantity ).setScale(2) ).format(), args);
                 lstGroupDiscountRows = populateGroupDiscount(PurchaseType);
             } Catch(Exception ae)
             {
                 throw ae;
             }
            
            //refresh Attendee List
            AttendeeList = new Map<Integer, RelatedAttendeeListCotroller.AttendeeWrapper>();
        }
    }
        
    Public void applyDiscountCode(){
        system.debug('isItManual: '+isItManualRegistration);
        if(isItManualRegistration){
            if(!String.isEmpty(discountCode) && !String.isEmpty(objIn.currentPriceOfPurchase)){
                CalcluateCost();
                system.debug('I am back here.');
                List<String> args = new String[]{'0','number','###,###,##0.00'};
                Decimal DiscountedPrice = Decimal.valueOf(objIn.currentPriceOfPurchase.replace('$','').replaceAll(',','')) - Decimal.valueOf(discountCode);
                objIn.currentPriceOfPurchase = currencySymbol +  
                    String.format((DiscountedPrice > 0 ? DiscountedPrice : 0).format(), args);
            } else {
                CalcluateCost();
            }
            }
        
        if(!isItManualRegistration){
            system.debug('Applying code');
		    Decimal result = 0;  //assign with Price at last tab.
       		List<Discount__c> objDisc = [select Id,Fixed_Price_Discount__c,Percentage_Discount__c from Discount__c where RecordType.Name='Code' and VIP_Code__c =:discountCode limit 1 ];
        	if(!objDisc.isEmpty() && objDisc[0].Percentage_Discount__c != null  ){
                CalcluateCost();  
           		system.debug('current price: '+objIn.currentPriceOfPurchase);
           		objIn.currentPriceOfPurchase = currencySymbol +  String.Valueof( (Decimal.Valueof(objIn.currentPriceOfPurchase.replace('$','').replaceAll(',',''))) - (Decimal.Valueof(objIn.currentPriceOfPurchase.replace('$','').replaceAll(',','')) * objDisc[0].Percentage_Discount__c)/ 100 );
       		}
        	Else if(!objDisc.isEmpty() && objDisc[0].Fixed_Price_Discount__c != null){
                CalcluateCost();
            	List<String> args = new String[]{'0','number','###,###,##0.00'};
            	Decimal DiscountedPrice = Decimal.valueOf(objIn.currentPriceOfPurchase.replace('$','').replaceAll(',','')) - objDisc[0].Fixed_Price_Discount__C;
            	objIn.currentPriceOfPurchase = currencySymbol +  
                String.format((DiscountedPrice > 0 ? DiscountedPrice : 0).format(), args);
        	} else {
                CalcluateCost();
        	}
        }
    }
    
    Public void CaclculateVIPDiscount()
    {
       Decimal result = 0;  //assign with Price at last tab.
       List<Discount__c> objDisc = [select Id,Name,Percentage_Discount__c from Discount__c where RecordType.Name='VIP' and VIP_Code__c =:VIPCode limit 1 ];
       if(!objDisc.isEmpty() && objDisc[0].Percentage_Discount__c != null  )
       {   
           system.debug('Value of Perc : '+ objDisc[0].Percentage_Discount__c);  
           objIn.currentPriceOfPurchase = currencySymbol +  String.Valueof( (Decimal.Valueof(objIn.currentPriceOfPurchase.replace('$','').replaceAll(',',''))) - (Decimal.Valueof(objIn.currentPriceOfPurchase.replace('$','').replaceAll(',','')) * objDisc[0].Percentage_Discount__c)/ 100 );
           isVIP = true;
       }
    }
    
    public void searchbasedOnEmail()
    {
        System.debug('Email: '+objIn.Email);
		List<Contact> inviteeCon = [Select Id, FirstName, LastName, Email,Company_Name__c, MobilePhone, Phone, Title, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, Nominated_Contact__c from Contact where email =:objIn.Email OR PA_Email__c =:objIn.Email OR Personal_Email__c =:objIn.Email];
        System.debug(inviteeCon);
        if(!inviteeCon.isEmpty() && !String.isBlank(objIn.Email)){
            if(inviteeCon[0].Nominated_Contact__c != null)
            	objIn.membershipStatus = inviteeCon[0].Nominated_Contact__c;
            List<Opportunity> opps = [Select Id from Opportunity where Primary_Contact__c = :inviteeCon[0].Id limit 1];
            List<Event_Registration__c> ers = [Select Id from Event_Registration__c where Contact__c = :inviteeCon[0].Id limit 1];
            if(!opps.isEmpty() || !ers.isEmpty()){
/*                
                if(inviteeCon[0].Phone != null)
                    objIn.workphone = inviteeCon[0].Phone;
                if(inviteeCon[0].MobilePhone != null)
                    objIn.MobilePhone = inviteeCon[0].MobilePhone;
                if(inviteeCon[0].Title != null)
                    objIn.positionTitle = inviteeCon[0].Title;
                if(inviteeCon[0].MailingStreet != null)
                    objIn.addressLine1 = inviteeCon[0].MailingStreet;
                if(inviteeCon[0].MailingCity != null)
                    objIn.city = inviteeCon[0].MailingCity;
                if(inviteeCon[0].MailingPostalCode != null)
                    objIn.PostalCode = inviteeCon[0].MailingPostalCode;
                    System.debug(objIn.PostalCode);
                if(inviteeCon[0].Company_Name__c != null)
                    objIn.Company = inviteeCon[0].Company_Name__c;
                if(objIn.FirstName == inviteeCon[0].firstName != null)
                    objIn.FirstName = inviteeCon[0].firstName;
                if(objIn.LastName == inviteeCon[0].LastName != null)
                    objIn.LastName = inviteeCon[0].LastName;
*/
                if(inviteeCon[0].MailingCountry != null)
                    objIn.Country = inviteeCon[0].MailingCountry;
                if(inviteeCon[0].MailingState != null)
                    objIn.State = inviteeCon[0].MailingState;
            }
            
            if(objIn.membershipStatus != null && objIn.membershipStatus == true){
                isMember = true;
            }else{
                isMember = false;
            }
            
        } else{
            isMember = false;
        }        
    }
    Public List<GroupDiscountRow> populateGroupDiscount(string TicketType)
    {
           system.debug('Gaurang: populateGroupDiscount called');
           //IsGroupDiscountVisible =true;
           List<GroupDiscountRow> lstResult = new List<GroupDiscountRow>(); 
           
           List<Discount__c> lstTableDiscount  = new List<Discount__c>(); 
           
           if(TicketType=='Table') 
           {
              lstTableDiscount = [select Id,Name,Table_Quantity__c,Price__c,Fixed_price_Discount__c 
                                          from Discount__c 
                                          where 
                                          RecordType.Name='Table' and 
                                          Event__c =:objEvent.Id order by Table_Quantity__c asc ];                 
                             
           }
           if(TicketType == 'Single Ticket')
           {
               lstTableDiscount = [select Id,Name,Table_Quantity__c,Price__c,Fixed_price_Discount__c,Number_of_Delegates__c 
                                          from Discount__c 
                                          where 
                                          RecordType.Name='Group' and 
                                          Event__c =:objEvent.Id order by Table_Quantity__c asc ];                 
           }
           if((lstTableDiscount!=null)&&(lstTableDiscount.size()>0))
           {
               //
               IsGroupDiscountVisible =true;
           }
           else
           {
               IsGroupDiscountVisible =false;
           }
           for(Discount__c objDis : lstTableDiscount) 
               {
                   GroupDiscountRow objRow = new GroupDiscountRow(); 
                   if(TicketType == 'Table') 
                   objRow.count = Integer.Valueof(objDis.Table_Quantity__c); 
                   else if(TicketType=='Single Ticket')
                   objRow.count = Integer.Valueof(objDis.Number_of_Delegates__c); 
                   
                   objRow.FixedDiscount  = objDis.Fixed_Price_Discount__c;
                   objRow.progressBarWidth = objDis.Fixed_Price_Discount__c / 10; 
                   lstResult.add(objRow);
               }
           return lstResult;
    } 
    Public List<earlyBirdRow> populateEarlyBirdRows()
    {
        List<earlyBirdRow> lstResult = new List<earlyBirdRow>(); 
        List<Discount__c> lstDiscount = [select Id,Name,Before_Date__c,Price__c,Event_package__c,(select Id,Event_Package__C,Member_Price__c,Non_Member_Price__C from Early_Bird_Package_Details__r)   from Discount__c where RecordType.Name = 'Early Bird' and Event__c=:objEvent.Id];
        List<Event_Package__C> lstEventPackage = [select Id,name,Member_Price__c,Standard_Price__c,Type__c  from Event_Package__c where Event__C=:objEvent.Id and Active__c=true ORDER BY name ASC];
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        
        for(Event_package__c objEventPackage : lstEventPackage) 
        {
            eventPackageNameMap.put(objEventPackage.Name, objEventPackage);
            earlyBirdRow objRow = new earlyBirdRow(); 
            objRow.packageName = objEventPackage.Name; 
            
            List<earlyDatePrice> lstTemp  = new List<earlyDatePrice>(); 
            for(Discount__c objDisc : lstDiscount)
            {
                setHeader.add('Before </br>'+string.Valueof(objDisc.Before_date__c));
                
                earlyDatePrice objEarlyDate = new earlyDatePrice(); 
                for(Early_Bird_Package_Detail__c objEPD : objDisc.Early_Bird_Package_Details__r ) 
                {
                    
                    objEarlyDate.dtDate = objDisc.Before_date__c;
                    
                    //calculation of IsValid 
                    
                    if(objDisc.Before_Date__c > Date.Today()){
                        objEarlyDate.IsValid = true; 
                    } else {
                        objEarlyDate.IsValid = false;
                    }
                }
                
                
                              
                lstTemp.add(objEarlyDate); 
            }
            
            //------- adding stadnard price ------------
            earlyDatePrice objEarlyDateStdPrice = new earlyDatePrice();    
            if(IsMember)      
            objEarlyDateStdPrice .discountedPrice =currencySymbol + String.format(objEventPackage.Member_Price__c.format(), args);
            else
            objEarlyDateStdPrice .discountedPrice =currencySymbol + String.format(objEventPackage.Standard_Price__c.format(), args);
            
            objEarlyDateStdPrice .discountedPriceNonMember =currencySymbol + String.format(objEventPackage.Standard_Price__c.format(), args);
            objEarlyDateStdPrice .TicketType = objEventPackage.Type__c;
            objEarlyDateStdPrice.isValid = true;          
            lstTemp.add(objEarlyDateStdPrice ); 
            //------- end of adding standard price -------
            
            objRow.lstEarlyDatePrice = lstTemp; 
            lstResult.add(objRow); 
        }
        //Add guest package for manual registration
        if(isItManualRegistration){
            earlyBirdRow guestRowTable = new earlyBirdRow();
            guestRowTable.packageName = 'Table(Guest)';
            List<earlyDatePrice> lstTemp = new List<earlyDatePrice>();
            earlyDatePrice guestPrice = new earlyDatePrice();
            guestPrice.discountedPrice = currencySymbol + String.valueOf(0);
            guestPrice.discountedPriceNonMember = currencySymbol +String.valueOf(0);
            guestPrice.TicketType = 'Table';
            guestPrice.IsValid = true;
            lstTemp.add(guestPrice);
            guestRowTable.lstEarlyDatePrice = lstTemp;
            lstResult.add(guestRowTable);

            earlyBirdRow guestRowticket = new earlyBirdRow();
            guestRowticket.packageName = 'Single Ticket(Guest)';
            List<earlyDatePrice> lstTemp1 = new List<earlyDatePrice>();
            earlyDatePrice guestPriceTicket = new earlyDatePrice();
            guestPriceTicket.discountedPrice = currencySymbol + String.valueOf(0);
            guestPriceTicket.IsValid = true;
            guestPriceTicket.TicketType = 'Single Ticket';
            guestPriceTicket.discountedPriceNonMember = currencySymbol +String.valueOf(0);
            lstTemp1.add(guestPriceTicket);
            guestRowticket.lstEarlyDatePrice = lstTemp1;
            lstResult.add(guestRowticket);

            eventPackageNameMap.put('Single Ticket(Guest)',lstEventPackage[0]);
            if(lstEventPackage.size() > 1){
               eventPackageNameMap.put('Table(Guest)',lstEventPackage[1]); 
            } 
        }

        return lstResult;
    }
    Public without sharing class GroupDiscountRow
    {
        Public Integer count {get;set;} 
        public Decimal FixedDiscount {get;set;} 
        Public Decimal progressBarWidth {get;set;} 
    }
    Public without sharing class earlyBirdRow
    {
        public string packageName { get;set;} 
        public List<earlyDatePrice> lstEarlyDatePrice {get;set;} 
        Public Decimal standardPrice {get;set;} 
        public Decimal selectedPackageId {get;set;} 
        Public Decimal selectedPrice {get;set;} 
    }
    public without sharing class earlyDatePrice 
    {
        public Date dtDate {get;set;} 
        public String strDate { get;set;} 
        public String discountedPrice {get;set;}
        public String discountedPriceNonMember{get;set;}
        Public String TicketType {get;set;} 
        Public boolean IsValid {get;set;} 
    }
    Public without sharing class inviteeDetail
    {
        public string firstName { get;set;} 
        public string lastname  { get;set; } 
        public string email {Get;set;}
        public string positionTitle {get;set;} 
        public string company {get;set;} 
        public string addressLine1 { get;set;} 
        public string addressLine2 { get;set;} 
        public string city {Get;set;} 
        public string State {Get;set;} 
        public string PostalCode {get;set;} 
        public string Country {get;set;} 
        public string workphone {get;set;} 
        public string notes {get;set;} 
        public boolean member {get;set;}
        public boolean membershipStatus {get;set;}
        public string MobilePhone {get;set;}
        
        //Selected Purchase Type and Qunaity
        public string selectedPurchaseType {get;set;} 
        public Integer selectedPurchaseQuantity {get;set;} 
        public String currentPriceOfPurchase {get;set;} 
        public string discountCode {get;set;}
    }
    Public without sharing class Event
    {
        public string eventName { get;set;} 
        public string eventWhen {get;set;} 
        public string eventWhere {get;set;}
        public string eventWhentime {get;set;}
        public string speakerImageURL {get;set;} 
        public string sponserImageURL {get;set;} 
        public string sponserURL {get;set;}
        public string eventAddress { get;set;} 
        public string EventDescriptionHTML {get;set;}
        public string eventType {get;set;}
        
        //addrees properties. 
        public string eventlocation {get;set;}
        
        public  Event(Event__c objEvent)
        {
            //Fetchning all data 
            Venue__c   objVenueDate = [select Id,Name,Street_Address_1__c,Map_to_Venue__c,
                                                        Street_Address_2__c,City__c,
                                                         Postal_Code_Zip__c,State__C,Country__c from Venue__c   where Id = :objEvent.venue__c];
            
            this.eventName = objEvent.Event_Name__C; 
            this.EventDescriptionHTML  = objEvent.Event_Description_HTML__c ;
            this.eventType = objEvent.Event_Type__c;
            
            //populating When to do : multiple dates 
            if(objEvent.Event_Start_Date__c != null && objEvent.Event_Start_Time__c != null && objEvent.Event_Finish_Time__c != null) 
            {
                DateTime dt=DateTime.newInstance(objEvent.Event_Start_date__c, Time.newInstance(0, 0, 0, 0));
                String monthString = eventdetailController.getMonthNameFromNumber(dt.Month());
              
                this.eventWhen = dt.format('EEEE') +' '+ dt.Day()+ ' ' +monthString + ' ' + dt.Year();
                this.eventWhentime = String.valueOf(objEvent.Event_Start_Time__c.format('h:mm a')) + ' - ' +
                   String.valueOf(objEvent.Event_Finish_Time__c.format('h:mm a')) ;
                if(objEvent.Timezone__c != null){
                    this.eventWhentime = this.eventWhentime + ' ' + objEvent.Timezone__c;
                }
                
                if(objEvent.Event_Start_Time__c.date() != objEvent.Event_Finish_Time__c.date()){
                    DateTime enddt=DateTime.newInstance(objEvent.Event_Finish_Time__c.date(), Time.newInstance(0, 0, 0, 0));
                    String endMonthString = eventdetailController.getMonthNameFromNumber(enddt.Month());
                    this.eventWhen = this.eventWhen + ' - '+ enddt.format('EEEE') +' '+ enddt.Day() +' ' +endMonthString +' ' + enddt.Year();
                }
            }
            
            //populating Where 
            if(objVenueDate  != null) 
            {
                eventlocation = objVenueDate.Name;
                if(!String.isBlank(objVenueDate.Street_Address_1__c))
                    eventlocation = eventlocation + ', ' + objVenueDate.Street_Address_1__c;
                if(!String.isBlank(objVenueDate.Street_Address_2__c))
                    eventlocation = eventlocation + ', ' + objVenueDate.Street_Address_2__c;
                if(!String.isBlank(objVenueDate.City__c))
                    eventlocation = eventlocation + ', ' + objVenueDate.City__c;
                if(!String.isBlank(objVenueDate.State__c))
                    eventlocation = eventlocation + ', ' + objVenueDate.State__c;
                if(!String.isBlank(objVenueDate.Country__c))
                    eventlocation = eventlocation + ', ' + objVenueDate.Country__c;
                System.debug('this is start date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+eventlocation); 
            }
        }
    }

    public void saveRecord(){
        Map<string, Id> emailToContactMap = new Map<string, Id>();
        
        //If there is already a contact record with same Email Address provided in the step - 1 update contact with the provided
        //details in step-1. If there is no contact create new contact.
        Contact bookingContact; 
        Id bookingAccountId;
        List<Contact> inviteeContactList = new List<Contact>();
        if(!String.isBlank(objIn.email)){
            inviteeContactList = [SELECT Id, FirstName, AccountId, Account.Name, LastName, Email, Phone, MobilePhone, Title, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, Company_Name__c FROM Contact where Email=:objIn.email Limit 1];
        }
        System.debug('Invitees:- '+inviteeContactList);
        if(!inviteeContactList.isEmpty() && inviteeContactList.size() == 1){
            bookingContact = inviteeContactList[0];
            if(objIn.firstName != null && bookingContact.firstName != objIn.firstName){}
            if(objIn.lastName != null && bookingContact.lastName != objIn.lastName){}
            if(objIn.Company != null && bookingContact.Company_Name__c  != objIn.Company )
                bookingContact.Company_Name__c  = objIn.Company;
            if(objIn.positionTitle != null && bookingContact.Title != objIn.positionTitle)
                bookingContact.Title = objIn.positionTitle;
            if(bookingContact.MailingStreet != (objIn.addressLine1 + objIn.addressLine2 ))
                bookingContact.MailingStreet = objIn.addressLine1 + objIn.addressLine2 ;
            if(objIn.city != null && bookingContact.MailingCity != objIn.city)
                bookingContact.MailingCity = objIn.city;
            if(objIn.State != null && bookingContact.MailingState != objIn.State)
                bookingContact.MailingState = objIn.State;
            if(objIn.PostalCode != null && bookingContact.MailingPostalCode != objIn.PostalCode)
                bookingContact.MailingPostalCode = objIn.PostalCode;
            if(objIn.Country != null && bookingContact.MailingCountry != objIn.Country)
                bookingContact.MailingCountry = objIn.Country;
            if(objIn.workphone != null && bookingContact.Phone != objIn.workphone)
                bookingContact.Phone = objIn.workphone;
            if(objIn.MobilePhone != null && bookingContact.MobilePhone != objIn.MobilePhone)
                bookingContact.MobilePhone = objIn.MobilePhone;

            if(bookingContact.AccountId != null){
                if(!String.isBlank(objIn.Company) && bookingContact.Account.Name != objIn.Company){
                    bookingContact.Account.Name = objIn.Company;
                }
                bookingAccountId = bookingContact.AccountId;
            } else {
                if(!String.isBlank(objIn.Company)){
                    try{
                        Account acc = new Account();
                        acc.Name = objIn.Company;
                        acc.Industry = 'Other';

                        insert acc;

                        bookingContact.AccountId = acc.Id;
                        bookingAccountId = acc.Id;
                    } Catch(Exception e){
                        System.debug('Account Exception!!'+ e);
                    }
                }
            }
            
            if(!isItManualRegistration){
                System.debug('bookingContact'+bookingContact);
                update bookingContact;
                emailToContactMap.put(objIn.email, bookingContact.Id);
            }            
        } else {
            List<Contact> inviteeContactListPA = new List<Contact>();
            if(!String.isBlank(objIn.email)){
                inviteeContactListPA = [SELECT Id, FirstName, AccountId, Account.Name, LastName, Email, Phone, MobilePhone, Title, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, Company_Name__c FROM Contact where PA_Email__c=:objIn.email Limit 1];
            }
            if(!inviteeContactList.isEmpty() && inviteeContactList.size() == 1){
                 bookingContact = inviteeContactListPA[0];
            } else if(!String.isBlank(objIn.email)){
                bookingContact = new Contact();
                
                bookingContact.FirstName = objIn.firstName;
                bookingContact.LastName = objIn.LastName;
                bookingContact.Email = objIn.Email;
                bookingContact.Phone = objIn.workphone;
                bookingContact.Title = objIn.positionTitle;
                bookingContact.Company_Name__c  = objIn.Company;
                bookingContact.MailingStreet = objIn.addressLine1 + objIn.addressLine2 ;
                bookingContact.MailingCity = objIn.city;
                bookingContact.MailingState = objIn.State;
                bookingContact.MailingPostalCode = objIn.PostalCode;
                bookingContact.MailingCountry = objIn.Country;
                bookingContact.MobilePhone = objIn.Mobilephone;
                bookingContact.Phone = objIn.workphone;
                bookingContact.Source__c = 'Event Registration';
                if(objIn.State == 'ACT'){
                    bookingContact.ACT_NM__c = true;
                } else if(objIn.State == 'NSW'){
                    bookingContact.NSW_NonMember__c = true;
                }else if(objIn.State == 'NT'){
                    bookingContact.National_NonMember__c = true;
                }else if(objIn.State == 'QLD'){
                    bookingContact.QLD_NonMember__c = true;
                }else if(objIn.State == 'SA'){
                    bookingContact.SA_NonMember__c = true;
                }else if(objIn.State == 'TAS'){
                    bookingContact.National_NonMember__c = true;
                }else if(objIn.State == 'VIC'){
                    bookingContact.NSW_NonMember__c = true;
                }else if(objIn.State == 'WA'){
                    bookingContact.WA_NonMember__c = true;
                }

                If(!String.isBlank(objIn.Company)){
                    List<Account> accList = [Select Id from Account where Name =: objIn.Company];
                    if(accList.size() > 0){
                        bookingContact.AccountId = accList[0].Id;
                        bookingAccountId = accList[0].Id;
                    } else{
                        Account acc = new Account();
                        acc.Name = objIn.Company;
                        acc.Industry = 'Other';

                        insert acc;

                        bookingContact.AccountId = acc.Id;
                        bookingAccountId = acc.Id;
                    }
                }
                
                insert bookingContact;
                emailToContactMap.put(objIn.email, bookingContact.Id);
            }
            
        }
        
        List<Contact> contactsToInsert = new List<Contact>();
        Set<String> allAttendeeEmail = new Set<String>();
        Set<String> allAttendeeAccount = new Set<String>();
        System.debug(AttendeeList);
        for(RelatedAttendeeListCotroller.AttendeeWrapper atd : AttendeeList.values()){
            if(!String.isBlank(atd.email)){
                allAttendeeEmail.add(atd.email);
            }
            if(!String.isBlank(atd.company)){
                allAttendeeAccount.add(atd.company);
                System.debug(atd.company);
            }
        }

        System.debug('allAttendeeAccount'+allAttendeeAccount);
        
        Map<Id, Contact> AttendeeContacts = new Map <Id, Contact> ([Select Id, email, FirstName, LastName, Title, Company_Name__c from Contact where email IN :allAttendeeEmail]);
        for(Contact con : AttendeeContacts.values()){
            if(!emailToContactMap.containsKey(con.email)){
                emailToContactMap.put(con.email, con.Id);
            }
        }

        Map<String, Account> nameToAccountMap =  new Map<String, Account>();
        List<Account> AttendeeAcc = [Select Id, Name, Industry from Account where Name IN :allAttendeeAccount];
        for(Account acc : AttendeeAcc){
            if(!nameToAccountMap.containsKey(acc.Name)){
                nameToAccountMap.put(acc.Name, acc);
            }
        }
        System.debug(nameToAccountMap);

        List<Contact> newConWithoutAcc = new List<Contact>();
        Map<String, Account> newNameToAccountMap = new Map<String, Account>();
        for(RelatedAttendeeListCotroller.AttendeeWrapper atd : AttendeeList.values()){
            if(atd.email != null && !emailToContactMap.containsKey(atd.email)){
                Contact newContact = new Contact();
                newContact.FirstName = atd.firstName;
                newContact.LastName = atd.LastName;
                newContact.Email = atd.Email;
                newContact.Title = atd.positionTitle;
                newContact.Source__c = 'Event Registration';
                //newContact.Business_Function__c = 'Events';
                if(nameToAccountMap.get(atd.Company) != null){
                    newContact.Company_Name__c = atd.Company;
                    newContact.AccountId = nameToAccountMap.get(atd.Company).Id;
                    contactsToInsert.add(newContact);
                } else{
                    if(!String.isBlank(atd.Company)){
                        Account acc = new Account();
                        acc.Name = atd.Company;
                        acc.Industry = 'Other';

                        newContact.Company_Name__c = atd.Company;
                        System.debug('atd.Company'+atd.Company);
                        newNameToAccountMap.put(atd.Company, acc);
                        newConWithoutAcc.add(newContact);
                    }
                }
            } else{
                //Update Existing Contact
                Contact existingCon = AttendeeContacts.get(emailToContactMap.get(atd.email));
                if(existingCon != null){
                    if(atd.firstName != null && existingCon.FirstName != atd.firstName){
                    }
                    if(atd.LastName != null && existingCon.LastName != atd.LastName){
                    }
                    if(atd.positionTitle != null && existingCon.Title != atd.positionTitle){
                        existingCon.Title = atd.positionTitle;
                    }
                    if(atd.Company != null && existingCon.Company_Name__c != atd.Company){
                        existingCon.Company_Name__c = atd.Company;
                    }
                    contactsToInsert.add(existingCon);
                }
            }
        }
        System.debug('newNameToAccountMap.values()' + newNameToAccountMap.values());
        for(Contact con : newConWithoutAcc){
            if(newNameToAccountMap.get(con.Company_Name__c) != null){
                con.AccountId = newNameToAccountMap.get(con.Company_Name__c).Id;
                contactsToInsert.add(con);
            }
        }
        
        
        for(Contact insertedcontact : contactsToInsert){
            emailToContactMap.put(insertedcontact.email, insertedcontact.Id);
        }
        
        //Create Opportunity
        System.debug('UB: In Save Record');
        Opportunity opp = new Opportunity();
        String oppName = objIn.firstName + ' ' +  objIn.lastname +' - '+ objIn.selectedPurchaseQuantity+ ' x ';
        string oppNameSubstring = (purchaseType == 'Single Ticket') ? (objIn.selectedPurchaseQuantity == 1) ? oppName + 'Ticket' : oppName + 'Tickets'
                   :objIn.selectedPurchaseQuantity == 1 ? oppName + 'Table of ' + objEvent.Seats_Per_Table__c : oppName + 'Tables of ' + objEvent.Seats_Per_Table__c;
        opp.Name = objEvent.Name + ' - ' + oppNameSubstring;
        opp.Event__c = objEvent.Id;
        System.debug('map of event'+eventPackageNameMap);
        System.debug(SelectedPacakgeName);
        System.debug(eventPackageNameMap.containsKey(SelectedPacakgeName));
        System.debug(eventPackageNameMap.keySet());
        opp.Event_Package__c = eventPackageNameMap.get(SelectedPacakgeName).Id;
        System.debug('id of event is'+ opp.Event_Package__c);
        opp.Primary_Contact__c = bookingContact != null ? bookingContact.Id : null;
        opp.StageName = isItManualRegistration ? 'Invoiced' : 'Prospecting';
        opp.CloseDate = System.Date.today();
        opp.Ticket_Qty__c = objIn.selectedPurchaseQuantity;
        System.debug('UB0:'+objIn.selectedPurchaseQuantity);
        System.debug('UB1:'+eventPackageNameMap);
        System.debug('UB2:'+SelectedPacakgeName);
        opp.Booking_Contact_First_Name__c = objIn.FirstName;
        opp.Booking_Contact_Last_Name__c = objIn.LastName;
        opp.Event_Name__c = eventDetail.eventName;
        opp.Event_Time__c = eventDetail.eventWhenTime;
        opp.Event_Date__c = eventDetail.eventWhen;
        opp.Event_location__c = objEvent.Venue__r.Name + ' ' + objEvent.Venue__r.Street_Address_1__c;
        opp.Notes__c = objIn.Notes;        
        opp.Early_Bird_Discounts__c = 0.00;
        If(!string.isBlank(discountCode)){
            opp.Discount__c = true;
            opp.Discount_Code_Applied__c = discountCode;
        }
        opp.Amount = objIn.currentPriceOfPurchase != null ? Double.valueof(objIn.currentPriceOfPurchase.replace('$','').replaceAll(',','')) : 0.00 ;
        opp.Amount_Due__c = opp.Amount;
        opp.Group_Amount__c = objApplicableDiscount != null ? objApplicableDiscount.Fixed_price_Discount__c != null ? objApplicableDiscount.Fixed_price_Discount__c : 0.00 : 0.00;
        opp.Type = 'Event';
        opp.Product__c = 'Event Attendee';
        opp.Xero_Invoice_Status__c = 'Pending';
        opp.Liability_Bank_Transaction__c = 'Pending';
        if(!isItManualRegistration){
            opp.status_of_payment__c = 'Awaiting For Payment';
        }
        if(alreadyPaid || isItGuestReg){
            opp.StageName = 'Closed Won';
            opp.Probability = 100;
            opp.Amount_Due__c = null;
			opp.Amount_Paid__c = opp.Amount;
        }
        if(AttendeeList.values() != null && AttendeeList.values().size() > 0){
            opp.Attending_Name__c = AttendeeList.values()[0].FirstName + ' ' + AttendeeList.values()[0].LastName;
        }
        if(bookingAccountId != null){
            opp.AccountId = bookingAccountId;
        }
        if(isItManualRegistration){
            opp.Bespoke_Discount__c = !String.isEmpty(discountCode) ? Decimal.valueOf(discountCode.replace('$', '')) : 0;
        }
        insert opp;
        oppId = opp.Id;
        opportunityLink = URL.getSalesforceBaseUrl().toExternalForm() + '/' +oppId;
        if(opp.Amount <= 0){
            redirectionLink = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Success?oppId=' + oppId;
        } else {
            redirectionLink = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/PaymentTestPage?oppId=' + oppId;
        }
        
        
        Blob cryptoKey = EncodingUtil.base64decode(Label.cryptoKey);
        // Generate the data to be encrypted.
        Blob data = Blob.valueOf(oppId);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
        String encryptedString = EncodingUtil.base64encode(encryptedData);
        String encryptedLink = Label.eventRegistrationSiteURL + 'EventRegistrationEditPage?eventRegId=' + EncodingUtil.urlEncode(encryptedString, 'UTF-8');
    	opp.Payment_Link__c = encryptedLink;
        update opp;
        
        //Create Opportunity Line Item
        System.debug('isMember' + isMember);
        string product = isMember ? PurchaseType == 'table' ? 'Member Table' : 'Member Ticket' : PurchaseType == 'table' ? 'Non Member Table' : 'Non Member Ticket';
        System.debug('product'+product);
        list<PriceBookEntry> priceBookList = [Select Id from PriceBookEntry where Product2.Name=:product AND PriceBook2.isStandard=true LIMIT 1];
        System.debug('pricebook'+priceBookList);
        OpportunityLineItem oppline = new OpportunityLineItem();
        oppline.OpportunityId = oppId;
        if(priceBookList != null && priceBookList.size() == 1)
        {
            oppline.PricebookEntryId = priceBookList[0].Id;
        }
        oppline.Quantity = objIn.selectedPurchaseQuantity;
        oppline.UnitPrice = opp.Amount / oppline.Quantity;
        oppline.Description = eventDetail.eventName + ' ' +eventDetail.eventWhen + '(' + objIn.selectedPurchaseQuantity+ ' x ' + product + ')';
        insert oppline;

        //create quote record.
        if(!isItManualRegistration &&  registrationContext != 'waitlist'){
            PaymentUtility.createQuoteRecord(opp);
        }
        
        System.debug('UB: Event Registration Attendee Records');
        //Create Event Registration Attendee Records
        List<Event_Registration__c> erAttendeesToInsert = new List<Event_Registration__c>();
        System.debug('UB1' + registrationContext);
        for(RelatedAttendeeListCotroller.AttendeeWrapper atd : AttendeeList.values()){
            if(atd.undefined == false){
                Event_Registration__c erAttendee = new Event_Registration__c();
                erAttendee.Opportunity__c = oppId;
                erAttendee.First_Name__c = atd.firstName;
                erAttendee.Last_Name__c = atd.lastName;
                erAttendee.Email__c = atd.email;
                erAttendee.Job_Title__c = atd.positionTitle;
                erAttendee.Company__c = atd.company;
                erAttendee.Dietary_Requirements__c = atd.Dietary_Req;
                erAttendee.Package_Type__c = purchaseType;
                erAttendee.Event__c = objEvent.Id;
                erAttendee.Registration_Type__c = isItManualRegistration ? isItGuestReg ? 'Guest':'Paying':null;
                
                if(isItManualRegistration){
                    erAttendee.Registered_From__c = 'Manual Registration';
                    erAttendee.Registration_Status__c = alreadyPaid || isItGuestReg ? 'Successful' : 'Outstanding';
                    erAttendee.Net_Attendee_Amount__c = opp.Amount / AttendeeList.size();
                } else if(opp.Amount <= 0){
                        erAttendee.Registered_From__c = 'Event Registration App';
                        erAttendee.Registration_Status__c = alreadyPaid || isItGuestReg ? 'Successful' : 'Successful';
                }else{
                    erAttendee.Registered_From__c = 'Event Registration App';
                }
                
                if(registrationContext == 'waitlist'){
                    erAttendee.Registration_Status__c = 'Wait List';
                }
                erAttendeesToInsert.Add(erAttendee);
            } else {
                Event_Registration__c erAttendee = new Event_Registration__c();
                erAttendee.First_Name__c = 'Not Known';
                erAttendee.Last_Name__c = 'Not Known';
                erAttendee.Opportunity__c = oppId;
                erAttendee.Package_Type__c = purchaseType;
                erAttendee.Event__c = objEvent.Id;
                erAttendee.Registration_Type__c = null;
                erAttendee.Registration_Type__c = isItManualRegistration ? isItGuestReg ? 'Guest':'Paying':null;
                if(registrationContext == 'waitlist'){
                    erAttendee.Registration_Status__c = 'Wait List';
                }
                if(isItManualRegistration){
                    erAttendee.Registered_From__c = 'Manual Registration';
                    erAttendee.Registration_Status__c = alreadyPaid || isItGuestReg ? 'Successful' : 'Outstanding';
                    erAttendee.Net_Attendee_Amount__c = opp.Amount / AttendeeList.size();
                } else if(opp.Amount <= 0){
                        erAttendee.Registered_From__c = 'Event Registration App';
                        erAttendee.Registration_Status__c = alreadyPaid || isItGuestReg ? 'Successful' : 'Successful';
                }else{
                    erAttendee.Registered_From__c = 'Event Registration App';
                }
                erAttendeesToInsert.Add(erAttendee);
            }
            
        }
        
        insert erAttendeesToInsert;
    }
    
    public void redirectToPaymentPage(){
       
    }
    
    public void waitListAttendeeEmail(){
        //Send Email for confirmation to Invitee
        List<EmailTemplate> lstET = [SELECT Id, Name, DeveloperName, HtmlValue FROM EmailTemplate where DeveloperName = 'waitListEmail'];
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        List<OrgWideEmailAddress>lstOrgWideEmailAddress =[select id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName='Australian British Chamber of Commerce'];
        if(lstOrgWideEmailAddress.size()>0){
            message.setOrgWideEmailAddressId(lstOrgWideEmailAddress[0].id);
        }
        message.subject =  'Event Attendees Added To WaitList For' + ' ' + objEvent.Name;
        message.settargetObjectId(objEvent.Event_Manager__c);
        string htmlemailbody = lstET[0].HtmlValue;
        System.debug(LoggingLevel.INFO,'UB0:'+htmlemailbody);
        htmlemailbody = htmlemailbody.replace('&lt;&lt;eventManagerName&gt;&gt;', objEvent.Event_Manager__r.Name)
            .replace('&lt;&lt;Event Name&gt;&gt;', objEvent.Name)
            .replace('&lt;&lt;opportunityurl&gt;&gt;', (Label.SalesforceBaseURL+'/'+oppId));
        System.debug(LoggingLevel.INFO,'UB1:'+htmlemailbody);
        message.setHtmlBody(htmlemailbody) ;
        message.saveAsActivity = false;
        if(!Test.isRunningTest()){
            Messaging.SingleEmailMessage[] mails = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        }
    }
}
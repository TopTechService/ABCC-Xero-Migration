public class TrackingCategoryResponse {

	public class Options {
		public String TrackingOptionID;
		public String Name;
		public String Status;
		public Boolean HasValidationErrors;
		public Boolean IsDeleted;
		public Boolean IsArchived;
		public Boolean IsActive;
	}

	public String Id;
	public String Status;
	public String ProviderName;
	public String DateTimeUTC;
	public List<Options> Options;

	
	public static TrackingCategoryResponse parse(String json) {
		return (TrackingCategoryResponse) System.JSON.deserialize(json, TrackingCategoryResponse.class);
	}
}
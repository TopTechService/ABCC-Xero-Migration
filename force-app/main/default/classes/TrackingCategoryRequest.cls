public class TrackingCategoryRequest {

	public String Name;

	
	public static TrackingCategoryRequest parse(String json) {
		return (TrackingCategoryRequest) System.JSON.deserialize(json, TrackingCategoryRequest.class);
	}
}
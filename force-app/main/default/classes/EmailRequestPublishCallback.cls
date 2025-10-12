// Callback class to handle success and failure when publishing platform events
public class EmailRequestPublishCallback implements EventBus.EventPublishSuccessCallback
, EventBus.EventPublishFailureCallback {
    
    // Map to correlate event UUIDs with record IDs
    private Map<String, String> eventUuidToRecordIdMap;
    // Constructor accepts the map for tracking event-to-record relationships
    public EmailRequestPublishCallback(Map<String, String> eventUuidToRecordIdMap) {
        this.eventUuidToRecordIdMap = eventUuidToRecordIdMap;
    }
    
    // Called when platform events are published successfully
    public void onSuccess(EventBus.SuccessResult result) {
        // Get UUIDs of successful events
        List<String> eventUuids = result.getEventUuids();
        // Implement logic to handle successful publishing, e.g., create follow-up tasks/logs
    }
    
    // Called when publishing platform events fails
    public void onFailure(EventBus.FailureResult result) {
        // Get UUIDs of failed events
        List<String> eventUuids = result.getEventUuids();
        // Implement logic to handle errors publishing, e.g., log errors or retry publishing
    }
}
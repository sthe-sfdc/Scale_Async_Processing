trigger AccountTrigger on Account (after insert) {
    
    // List to hold Email_Request__e platform event records to be published
    List<Email_Request__e> events = new List<Email_Request__e>();
    // Map to track the relationship between event UUIDs and Account record IDs
    Map<String, String> eventUuidToRecordIdMap = new Map<String, String>();
    
    // Loop through each newly inserted Account record
    for (Account acc : Trigger.new) {
        
        // Create a new Email_Request__e platform event instance
        Email_Request__e event = (Email_Request__e)Email_Request__e.sObjectType.newSObject(null, true);
        event.Record_Id__c = acc.Id;
        event.Template_Id__c = 'NEW_ACCOUNT_WELCOME_TEMPLATE';
        event.To_Email__c = acc.Email__c;
        
        // Add the event to the list for publishing
        events.add(event);
        
        // Map the event's UUID to the Account Id for tracking
        eventUuidToRecordIdMap.put(event.EventUuid, event.Record_Id__c);
    }
    
    // If there are events to publish, publish them with a callback handler
    if (!events.isEmpty()) {
        // Create a callback instance to handle publish results
        EmailRequestPublishCallback callback = new EmailRequestPublishCallback(eventUuidToRecordIdMap);
        // publish platform events with an instance of the callback
        EventBus.publish(events, callback);
    }
}


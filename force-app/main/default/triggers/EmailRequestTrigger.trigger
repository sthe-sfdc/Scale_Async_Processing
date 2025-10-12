

// Trigger to process Email_Request__e platform events after they are inserted
trigger EmailRequestTrigger on Email_Request__e (after insert) {
    // List to hold all email request wrapper objects created from the events
    List<EmailRequestWrapper> allRequests = new List<EmailRequestWrapper>();

    // Loop through each event in the trigger context
    for (Email_Request__e evt : Trigger.new) {
        // Create a wrapper for each event and add it to the list
        allRequests.add(new EmailRequestWrapper(
            evt.Record_Id__c,   
            evt.Template_Id__c,
            evt.To_Email__c
        ));
    }
    
    // split into chunks of 100 (max callouts per transaction)
    // or configure batch size using PlatformEventSubscriberConfig 
    if (!allRequests.isEmpty()) {
        // Enqueue a Queueable job to process each chunk asynchronously
        System.enqueueJob(new EmailRequestQueueable(allRequests, 0));
    }
}



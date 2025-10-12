// Queueable Apex class to process a list of email requests with retry logic.
// Uses Database.AllowsCallouts for external HTTP callouts.
// Attaches a Transaction Finalizer to handle retries and logging.
public class EmailRequestQueueable implements Queueable, Database.AllowsCallouts {

    private List<EmailRequestWrapper> requests;
    private Integer retryCount;

    public EmailRequestQueueable(List<EmailRequestWrapper> requests, Integer retryCount) {
        this.requests   = requests;
        this.retryCount = retryCount == null ? 0 : retryCount;
    }

    public void execute(QueueableContext context) {
        // Track failed requests separately
        List<EmailRequestWrapper> failedRequests = new List<EmailRequestWrapper>();

        for (EmailRequestWrapper reqWrap : requests) {
            try {
                // Check governor limit for callouts
                if (Limits.getCallouts() >= Limits.getLimitCallouts()) {
                    throw new CalloutException('Reached max callouts per transaction');
                }

                // TODO: Build the HTTP request
                HttpRequest req = new HttpRequest();
                
                // Send the HTTP callout
                Http http = new Http();
                HttpResponse res = http.send(req);

                // Check for successful response
                if (res.getStatusCode() <> 200) {
                    throw new CalloutException(
                        'Failed for ' + reqWrap.toEmail + 
                        ' with status ' + res.getStatus()
                    );
                }

            } catch (Exception ex) {
                // Track this request as failed
                failedRequests.add(reqWrap);
            }
        }
        // Always attach the finalizer with failed requests
        System.attachFinalizer(new EmailRequestFinalizer(failedRequests, retryCount));
        // If we had failures, throw once so job is marked as FAILED
        if (!failedRequests.isEmpty()) {
            throw new CalloutException('One or more requests failed in this job.');
        }
    }
    
}
// Finalizer class to handle post-processing after the Queueable job finishes.
// Implements the Finalizer interface to allow logic to run after asynchronous Apex completes.
public class EmailRequestFinalizer implements Finalizer {
    // List of email requests that were processed
    private List<EmailRequestWrapper> requests;
    // Number of times this batch has been retried
    private Integer retryCount;

    // Constructor to initialize the requests and retry count
    public EmailRequestFinalizer(List<EmailRequestWrapper> requests, Integer retryCount) {
        this.requests   = requests;
        this.retryCount = retryCount;
    }

    // Method called automatically after the associated Queueable job finishes
    public void execute(System.FinalizerContext context) {
        // If the Queueable job succeeded, nothing more to do
        if (context.getResult() == System.ParentJobResult.SUCCESS) {
            return; // Done
        }

        // If this is the first failure, retry the batch once by enqueuing a new job
        if (retryCount < 1) {
            System.enqueueJob(new EmailRequestQueueable(requests, retryCount + 1));
            return;
        }

        // If the batch has already been retried and still failed, 
        // log all failed requests to Email_Log__c
    }
}


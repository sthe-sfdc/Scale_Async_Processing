// Wrapper class to hold information needed for sending an email request
public class EmailRequestWrapper {
    // The ID of the related record (e.g., Account, Contact)
    public String recordId;    
    // The ID of the email template to use
    public String templateId;  
    // The recipient's email address
    public String toEmail;     

    // Constructor to initialize all fields of the wrapper
    public EmailRequestWrapper(String recordId, String templateId, String toEmail) {
        this.recordId   = recordId;
        this.templateId = templateId;
        this.toEmail    = toEmail;
    }
}
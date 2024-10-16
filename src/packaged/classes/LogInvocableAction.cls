/**
 * This Action class provides interface to flow infrastructure to be able to create log
 * entries in the central framework.
 *
 * Note: All the ApexCRUDViolation rules are explicitly turned off intentionally.
 */
@SuppressWarnings('PMD.ApexCRUDViolation')
public with sharing class LogInvocableAction {
    /**
     * Create a log entry.
     *
     * @param requestList List of provisioning requests.
     */
    @InvocableMethod(Label='Create a Log Entry'
            Description='Creates a log entry. Use for example in error handling.')
    public static void makeLogEntry(List<Request> requestList) {
        Log.me().log(LoggingLevel.valueOf(requestList[0].level), requestList[0].message, requestList[0].source);
    }

    /**
     * Request payload structure for log entry.
     */
    public class Request {
        @InvocableVariable(Label='Source' Description='Uniquely traceable developer name here. Example is flow developer name' Required=true)
        public String source;

        @InvocableVariable(Label='Log Level' Description='Enter one of the supported log levels. Refer to LoggingLevel for valid values.' DefaultValue='ERROR')
        public String level;

        @InvocableVariable(Label='Message' Description='Message to be logged')
        public String message;
    }
}
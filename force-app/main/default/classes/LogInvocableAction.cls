/**
 * This Action class provides interface to flow infrastructure to be able to create log 
 * entries in the central framework. 
 * 
 * Note: All the ApexCRUDViolation rules are explicitly turned off intententionally
 */
@SuppressWarnings('PMD.ApexCRUDViolation')
public with sharing class LogInvocableAction {
     /**
     * Create a log entry
     * 
     * @param preProvisioningRequests List of provisioning requests
     */
    @InvocableMethod(label='Create a Log Entry' 
                    description='Creates a log entry using log.me() library' 
                    category='Pre Provisioning')
    public static void makeLogEntry(List<Request> requestList) {
        Log.me().put(LoggingLevel.valueOf(requestList[0].level), requestList[0].message, requestList[0].flowGuid);
    }
    public class Request {
        @InvocableVariable(label='Flow Guid' description='Pass {!$Flow.InterviewGuid}' required='true')
        public String flowGuid;
        @InvocableVariable(label='Log Level' description='Enter on of the supported log levels. Refer to LoggingLevel for valid values.')
        public String level;
        @InvocableVariable(label='Message' description='Message to be logged')
        public String message;
    }
}
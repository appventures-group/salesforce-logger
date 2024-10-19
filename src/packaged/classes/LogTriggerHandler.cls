/**
 * Created by jaapbranderhorst on 16/10/2024.
 */

public with sharing class LogTriggerHandler {

    private List<Log__e> events;

    public LogTriggerHandler(List<Log__e> events) {
        this.events = events;
    }

    public void handleTrigger() {
        List<LogEntry__c> logEntries = new List<LogEntry__c>();
        for (Log__e event : events) {
            logEntries.add(new LogEntry__c(
                    User__c = event.User__c,
                    Level__c = event.Level__c,
                    Quiddity__c = event.Quiddity__c,
                    RequestId__c = event.RequestId__c,
                    Message__c = event.Message__c,
                    Source__c = event.Source__c,
                    StackTrace__c = event.StackTrace__c,
                    Method__c = event.Method__c,
                    Line__c = event.Line__c
            ));
        }
        insert as system logEntries; // events must always be logged, but the automated process user runs this which has all rights.
    }

}
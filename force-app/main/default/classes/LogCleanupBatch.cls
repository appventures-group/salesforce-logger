/**
 * Batch job enables cleanup 
 */
@SuppressWarnings('PMD.EmptyStatementBlock')
public without sharing class LogCleanupBatch Implements Database.batchable<sObject> {
    public final Integer retentionDays = 7;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM LogEntry__c');
    }
    
    public  void execute(Database.BatchableContext bc, List<LogEntry__c> scope) {
         delete scope;
    }

    public void finish(Database.BatchableContext bc){
        //DO nothing
    }
}
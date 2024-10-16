/**
 * Batch job enables cleanup 
 */
@SuppressWarnings('PMD.EmptyStatementBlock')
public with sharing class LogCleanupBatch implements Database.Batchable<SObject> {
    private Integer retentionDays = -7;

    public LogCleanupBatch(Integer inputDays) {
        retentionDays = -(inputDays);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Datetime latestRetentionTime = System.now().addDays(retentionDays);
        return Database.getQueryLocator('SELECT Id FROM LogEntry__c WHERE CreatedDate <= :latestRetentionTime');
    }
    
    public  void execute(Database.BatchableContext bc, List<LogEntry__c> scope) {
         delete as system scope; // this is a cleanup job and should run in system context
    }

    public void finish(Database.BatchableContext bc){
        //DO nothing
    }
}
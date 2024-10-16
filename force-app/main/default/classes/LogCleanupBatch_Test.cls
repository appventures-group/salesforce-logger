/**
 * Test class cleanup job
 */
@IsTest
public with sharing class LogCleanupBatch_Test {
    @IsTest
	private static void testLogCleanup() {
        List<LogEntry__c> entries = new List<LogEntry__c>();
        Integer nrOfEntries = 10;
        for (Integer i = 0; i < nrOfEntries; i++) {
            entries.add(new LogEntry__c());
        }
        insert entries;
        System.Test.startTest();
        Integer numDays = 0;
        LogCleanupBatch b = new LogCleanupBatch(numDays);
        Database.executeBatch(b, 2000);
        System.Test.stopTest();

        Assert.areEqual(0, [SELECT Id FROM LogEntry__c].size());
    }
}

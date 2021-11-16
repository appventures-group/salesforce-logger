/**
 * Logs Cleanup Scheudler
 * 
 * Note: All the ApexCRUDViolation rules are explicitly turned off intententionally
 */
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class LogCleanupSchedulable implements Schedulable {
    public void execute(SchedulableContext sc) {
        LogCleanupBatch b = new LogCleanupBatch();
        database.executebatch(b,2000);
    }
}
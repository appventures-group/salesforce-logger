/**
 * Test class for Log invocable action
 */
@IsTest
public class LogInvocableAction_Test {
    @IsTest
	private static void testMakeLogEntry() {
        List<LogInvocableAction.Request> listOfRequests = new List<LogInvocableAction.Request>();
        LogInvocableAction.Request req = new LogInvocableAction.Request();
        req.level = 'ERROR';
        req.source = 'Test_Flow_Name';
        req.message='Test Message';
        listOfRequests.add(req);
        Test.startTest();
        LogInvocableAction.makeLogEntry(listOfRequests);
        Test.stopTest();
        List<LogEntry__c> logEntries = [
                SELECT
                        Class__c,
                        CreatedById,
                        CreatedDate,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Level__c,
                        Line__c,
                        Message__c,
                        Method__c,
                        Name,
                        OwnerId,
                        Quiddity__c,
                        RequestId__c,
                        Source__c,
                        StackTrace__c,
                        SystemModstamp,
                        User__c,
                        Id
                FROM LogEntry__c];
        Assert.areEqual(1, logEntries.size());
        Assert.areEqual(req.level, logEntries[0].Level__c);
        Assert.areEqual(req.source, logEntries[0].Source__c);
        Assert.areEqual(req.message, logEntries[0].Message__c);
    } 
}
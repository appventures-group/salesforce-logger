@IsTest
public with sharing class Log_Test {
    @IsTest
	private static void testAllLogLevels() {
        Log.me().error('ERROR Message');
        Log.me().warn('WARN Message');
        Log.me().info('INFO Message');
        Log.me().debug('DEBUG Message');
        Log.me().pause();
        Log.me().debug('This will not be logged');
        Log.me().fine('This wioll not be logged');
        Log.me().resume();
        Log.me().fine('FINE Message');
        Log.me().finer('FINER Message');
        Log.me().finest('FINEST Message');
        
        Integer logCount = [SELECT COUNT() FROM LogEntry__c];
        Integer expectedLogCount = 0;
        LoggingLevel currentLogLevel = Log.me().getCurrentLogLevel();
        switch on currentLogLevel {
            when ERROR {
                expectedLogCount = 1;
            }
            when WARN {
                expectedLogCount = 2;
            }
            when INFO {
                expectedLogCount = 3;
            }
            when DEBUG {
                expectedLogCount = 4;
            }
            when FINE {
                expectedLogCount = 5;
            }
            when FINER {
                expectedLogCount = 6;
            }
            when FINEST {
                expectedLogCount = 7;
            }
            when else {
                expectedLogCount = 0;
            }
        }
        System.assertEquals(expectedLogCount, logCount, 'Expected log messages count does not match with actual' + logCount);
    }        
}
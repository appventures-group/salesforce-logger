/**
 * This Action class provides core logging framework and public methods.
 *
 * Note: All the ApexCRUDViolation rules are explicitly turned off intentionally.
 */
@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class Log {
    // Singleton instance of the Log class
    private static Log instance = null;

    // Pattern to parse stack trace lines
    private static final Pattern STACK_LINE = Pattern.compile('^(?:Class\\.)?([^.]+)\\.?([^\\.\\:]+)?[\\.\\:]?([^\\.\\:]*): line (\\d+), column (\\d+)$');

    // List to store log entries
    private final List<Map<String,Object>> logEntries = new List<Map<String,Object>>();

    // Logger dynamic controls
    public Boolean mute {get; set;}
    public Boolean muteFlush {get; set;}
    public LoggingLevel currentLogLevel {get; set;}

    // Flags to control where to write logs
    private Boolean writeToEvent {get; set;}
    private Boolean writeToSystemDebug {get; set;}

    // Constructor to load log settings
    public Log() {
        loadLogSettings();
    }

    /**
     * Actual log entry is made by this method depending on settings.
     *
     * @param level The logging level.
     * @param message The log message.
     * @param source The source of the log entry.
     */
    public void log(LoggingLevel level, Object message, String source) { // TODO: either remove the push or emit method
        // Log to System Debug, when enabled.
        if (writeToSystemDebug) {
            System.debug(level, message);
        }

        // Return if muted or if the current log level is lower than the requested log level.
        if(currentLogLevel.ordinal() > level.ordinal() || !writeToEvent) {
            return;
        }

        if (writeToEvent) {
            LoggerStackTrace stackTrace = new LoggerStackTrace(getStackTraceString());
            EventBus.publish(new Log__e(
                    User__c = UserInfo.getUserId(),
                    Level__c = level.name(),
                    Quiddity__c = Request.getCurrent().getQuiddity().name(),
                    RequestId__c = Request.getCurrent().getRequestId(),
                    Message__c = String.valueOf(message), // TODO: check how to log the exception message better
                    StackTrace__c = stackTrace?.ParsedStackTraceString,
                    Source__c = source != null ? source : stackTrace?.Source.ApiName,
                    Line__c = stackTrace?.Source?.LineNumber,
                    Method__c = stackTrace?.Source?.ActionName
            ));
        }
    }

    /**
     * Reads the MDT settings for the current user if found and sets the log levels.
     * If not found, system settings are read from "System" developer name.
     * If no settings are found, System.debug behavior is emulated.
     */
    private void loadLogSettings() {
        LogSetting__mdt logSettings = LogSetting__mdt.getInstance('UserId_' + UserInfo.getUserId());
        if(logSettings == null) {
            logSettings = LogSetting__mdt.getInstance('ProfileId_' + UserInfo.getProfileId());
        }
        if(logSettings == null) {
            logSettings = LogSetting__mdt.getInstance('System');
        }
        writeToEvent = logSettings != null ? logSettings.WriteToEvent__c : false;
        writeToSystemDebug = logSettings != null ? logSettings.WriteToSystemDebug__c : true;
        currentLogLevel = logSettings != null ? LoggingLevel.valueOf(logSettings.LogLevel__c) : LoggingLevel.FINEST;
    }

    /**
     * Returns the Apex stack trace.
     *
     * @return The stack trace string.
     */
    private String getStackTraceString() {
        String stackTraceString = new DmlException().getStackTraceString();
        if (stackTraceString.length() > 5000) {
            stackTraceString = stackTraceString.substring(0, 5000); // TODO: why 5000?
        }
        return stackTraceString;
    }

    /**
     * Static method returns the singleton instance if found or instantiates one.
     *
     * @return The singleton instance of the Log class.
     */
    public static Log me() {
        if(instance == null) {
            instance = new Log();
        }
        return instance;
    }
}
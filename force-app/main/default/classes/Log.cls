public without sharing class Log {
    private static Log instance = null;

	private static Log__e currentEvent = null;

    private static LogEntry__c currentRecord = null;

    private static final Pattern STACK_LINE = Pattern.compile('^(?:Class\\.)?([^.]+)\\.?([^\\.\\:]+)?[\\.\\:]?([^\\.\\:]*): line (\\d+), column (\\d+)$');

    //Logger Dynamic Controls
    private Boolean mute {get; set;}
    private Boolean logViaEvents {get; set;}
    private Boolean logViaObject {get; set;}
    private Boolean logViaSystemDebug {get; set;}
    private LoggingLevel currentLogLevel {get; set;}
    /**
     * Constructor reads the MDT settings for current user if found and sets the log levels. If not found
     * System setings are read from "Org" developer name. If not found then only System debug behaviour is
     * emulated.
     */
    public Log() {
        loadLogSettings();
    }

	// Public logging methods
    public void error(Object message) {
        emit(LoggingLevel.ERROR, message, null);
	}
    public void warn(Object message) {
        emit(LoggingLevel.WARN, message, null);
	}
    public void info(Object message) {
        emit(LoggingLevel.INFO, message, null);
	}
	public void debug(Object message) {
        emit(LoggingLevel.DEBUG, message, null);
	}
    public void fine(Object message) {
        emit(LoggingLevel.FINE, message, null);
	}
    public void finer(Object message) {
        emit(LoggingLevel.FINER, message, null);
	}
    public void finest(Object message) {
        emit(LoggingLevel.FINEST, message, null);
	}
    public void put(LoggingLevel level, Object message, String source) {
        emit(level, message, 'Flow - ' + source);
	}

    //Control Methods
    public void pause() {
        mute = true;
    }
    public void resume() {
        mute = false;
    }
	
    public LoggingLevel getCurrentLogLevel() {
        return currentLogLevel;
    }

	/**
     * Actual log entry is made by this method depending on settings.  
     */ 
	private void emit(LoggingLevel level, Object message, String source) {
        //Return, if muted. 
        if(mute) {
            return;
        }
        // Don't log if current log level is set to lower than requested log level.
        if(currentLogLevel.ordinal() > level.ordinal()) {
            return;
        }
        // Resolve Apex Source code details where log is invoked from. 
        String sourcePointer =  source == null? getSourcePointer() : source;

        //Log to platform event, when enabled.
		if(logViaEvents) {
			currentEvent = new Log__e();
			currentEvent.User__c = UserInfo.getUserId();
            currentEvent.Level__c = level.name() ;
            currentEvent.Quiddity__c = Request.getCurrent().getQuiddity().name();
            currentEvent.RequestId__c = Request.getCurrent().getRequestId();
			currentEvent.Message__c = String.valueOf(message);
            currentEvent.Source__c = sourcePointer;

            System.debug(LoggingLevel.DEBUG, 'publishing message ' + currentEvent);
            Database.SaveResult result = EventBus.publish(currentEvent);
            if (!result.isSuccess()) {
                System.debug(LoggingLevel.ERROR, 'Error returned: ' + result.getErrors());
            }
		}

        //Log to custom object, when enabled.
        if(logViaObject) {
            currentRecord = new LogEntry__c();
            currentRecord.User__c = UserInfo.getUserId();
            currentRecord.Level__c = level.name();
            currentRecord.Quiddity__c = Request.getCurrent().getQuiddity().name();
            currentRecord.RequestId__c = Request.getCurrent().getRequestId();
			currentRecord.Message__c = String.valueOf(message);
            currentRecord.Source__c = sourcePointer;

            insert currentRecord;
        }

        //Log to System Debug, when enabled.
        if (logViaSystemDebug) {
			System.debug(level, message);
		}
	}

    @TestVisible
    private void loadLogSettings() {
        LogSetting__mdt logSettings = LogSetting__mdt.getInstance('UserId_' + UserInfo.getUserId());
        if(logSettings == null) {
            logSettings = LogSetting__mdt.getInstance('ProfileId_' + UserInfo.getProfileId());
        }
        if(logSettings == null) {
            logSettings = LogSetting__mdt.getInstance('System');
        }
        mute = logSettings != null ? logSettings.Mute__c : false;
        logViaEvents = logSettings != null ? logSettings.LogViaEvents__c : false;
        logViaObject = logSettings != null ? logSettings.LogViaObject__c : false;
        logViaSystemDebug = logSettings != null ? logSettings.LogViaSystemDebug__c : true;
        //Note - Finest log level enables it to reach system debug.
        currentLogLevel = logSettings != null ? LoggingLevel.valueOf(logSettings.LogLevel__c) : LoggingLevel.FINEST; 
    }
    /** 
     * This extracts code information to populate in the log object.
     */ 
	private String getSourcePointer() {
		// Note: Idea taken from https://salesforce.stackexchange.com/questions/153835
        String sourcePointer = 'UNKNOWN';
        Map<String, Object> codeDetails =  new Map<String, Object>();
		List<String> stacktrace = new DmlException().getStackTraceString().split('\n');
		for(String line : stacktrace) {
			Matcher matcher = STACK_LINE.matcher(line);
			if(matcher.find() && !line.startsWith('Class.Log.')) {
				Boolean hasNamespace = String.isNotBlank(matcher.group(3));
				if(hasNamespace) {
                    //namespace.className.methodName
                    sourcePointer = 'Apex - ' + matcher.group(1) + '.' + matcher.group(2) + '.' + prettyMethod(matcher.group(3));
				}
				else {
                    //className.methodName
                    sourcePointer = 'Apex - ' + matcher.group(1) + '.' + prettyMethod(matcher.group(2));
				}
				//Line Number
                sourcePointer += '#' + String.valueOf(matcher.group(4));
				return sourcePointer;
			}
		}
        return sourcePointer;
	}

    /**
     * Enhances method names to be more readable format. 
     */
	private String prettyMethod(String method) {
		String result = (method == null) ? 'anonymous' : method;
		return (result.contains('init')) ? 'constructor' : result;
	}

    /**
     * Static method returns the singlton instance if found or instantiates one.
     */
    public static Log me() {
        if(instance == null) {
            instance = new Log();
        }
        return instance;
    }
}
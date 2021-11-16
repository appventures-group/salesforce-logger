/**
 * Public interfacing methods for logging.
 * 
 */
public without sharing class Logger {
    public static void error(Object message) {
        Log.me().put(LoggingLevel.ERROR, message, null);
	}
    public static void warn(Object message) {
        Log.me().put(LoggingLevel.WARN, message, null);
	}
    public static void info(Object message) {
        Log.me().put(LoggingLevel.INFO, message, null);
	}
	public static void debug(Object message) {
        Log.me().put(LoggingLevel.DEBUG, message, null);
	}
    public static void fine(Object message) {
        Log.me().put(LoggingLevel.FINE, message, null);
	}
    public static void finer(Object message) {
        Log.me().put(LoggingLevel.FINER, message, null);
	}
    public static void finest(Object message) {
        Log.me().put(LoggingLevel.FINEST, message, null);
	}

    // Pubish and/or write inmemory log objects to event bus and/or database 
    public static void flush() {
        Log.me().flush();
    }
    
    //Pause logging, any log entries after this will be ignored until resumed.
    public static void pause() {
        Log.me().mute=true;
    }
    //Resumes logging.
    public static void resume() {
        Log.me().mute = false;
    }

    //Defers flushing, means any flush statements are ignored until keepFlushing is invoked. 
    public static void deferFlushing() {
        Log.me().muteFlush = true;
    }
    //Start to respect flush statements, if previously defered. 
    public static void keepFlushing() {
        Log.me().muteFlush = false;
    }
	
    //Returns the current loggin level.
    public static LoggingLevel getCurrentLogLevel() {
        return Log.me().currentLogLevel;
    }
}
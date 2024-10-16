/**
 * Public interfacing methods for logging.
 * 
 */
@SuppressWarnings('PMD.AvoidGlobalModifier')
public without sharing class Logger {
    public static void error(Object message) {
        Log.me().log(LoggingLevel.ERROR, message, null);
	}
    public static void warn(Object message) {
        Log.me().log(LoggingLevel.WARN, message, null);
	}
    public static void info(Object message) {
        Log.me().log(LoggingLevel.INFO, message, null);
	}
	public static void debug(Object message) {
        Log.me().log(LoggingLevel.DEBUG, message, null);
	}
    public static void fine(Object message) {
        Log.me().log(LoggingLevel.FINE, message, null);
	}
    public static void finer(Object message) {
        Log.me().log(LoggingLevel.FINER, message, null);
	}
    public static void finest(Object message) {
        Log.me().log(LoggingLevel.FINEST, message, null);
	}
    public static void exception(Exception ex) {
        error(ex);
    }
	
    //Returns the current loggin level.
    public static LoggingLevel getCurrentLogLevel() {
        return Log.me().currentLogLevel;
    }
}
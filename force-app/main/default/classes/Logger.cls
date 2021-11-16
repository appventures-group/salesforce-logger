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

    public static void flush() {
        Log.me().flush();
    }
    
    //Control Methods
    public static void pause() {
        //Log.me().pause();
        Log.me().mute=true;
    }
    public static void resume() {
        //Log.me().resume();
        Log.me().mute = false;
    }
	
    public static LoggingLevel getCurrentLogLevel() {
        //return Log.me().getCurrentLogLevel();
        return Log.me().currentLogLevel;
    }
}

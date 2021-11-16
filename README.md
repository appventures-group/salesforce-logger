# Salesforce Logger [![Codacy Badge](https://app.codacy.com/project/badge/Grade/4a1dd9a074e74d728503b6c56176df8e)](https://www.codacy.com/gh/vbattula/salesforce-logger/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=vbattula/salesforce-logger&amp;utm_campaign=Badge_Grade)

A lightweght logging framework for Salesforce platform with ability to log to multiple streams (custom object, platform event, system debug) supporting all salesforce LoggingLevels. Framework provides ability to enable logging at system, profile and individual user level to be able to collect logs from environments with heavy load to be able to debug the functionality. Log entries can be made with any declarative tools support invocable action (any declarative tool runs on Flow infrastructure) in addition to apex.

# Emulates System.debug
Stop worrying if to use System.debut of Logger as this logger fully emulates System.debug inaddition to making the log entries into other streams. By default, framework is enabled to emulate System.debug with no settings. However, make sure that you set "Enable System Debug" for respective setting to continue applying this behaviour. 

# How to use it
Log framework provides interface to used in Apex and Flow. 

## Apex
Use following methods Apex code. All formats of message structure is supported as long as it can fit into String.valueOf(message), which is similar to System.debug capabilities. 

```
Logger.error(message);
Logger.warn(message);
Logger.info(message);
Logger.debug(message);
Logger.fine(message);
Logger.finer(message);
Logger.finest(message);
```

and finally close your module code with -  

```
Logger.flush(); 
```

Note: Keeping too many log entries in memory may cause memory heap issues. Hence, balancing between flush and number of entries in memory is key to acheive optimal performance, especially in ERROR mode as production mode ideally is set at ERROR log level. 

## Flows

Use "Make Log Entry" apex action and provide the following input

  - **Source**: Set this to source identifier that gets stamped in log entries. Salesforce does not support dynamic declartative tool developer names, hence this is provided to developer to have controle on tagging source identifier. 
  - **Level**: Use one of the supported log levels. Thes values are same as Apex LoggingLevel Enum, as string. 
  - **Message**: Message to be logged.
  - **Flush Now**: Any events in memory for now will be flushed. Especially useful to set this to true on the last log entry in a flow. 
  - **Force Flush** : Flush now above will not flush logs when defer flushing is enabled previously by any apex code executed with in this transaction. Force Flush comes to rescue to override defer and keep flushing.  

# Enable / Disable Logging

Enable disable logging via custom metadata records. If no metadata is defined this framework emulates System.debug behavour.  Logging configuraiton can be set at there levels. 
  - **Org Level** : Metadata record developer name is 'System'
  - **Profile Level**: Metadata record developer name is expected as 'ProfileId_<Profile Record Id>'
  - **User Level**: Metadata record developer name is expected as 'UserId_<User Record Id>'

First available settings will be used in the following order to the current context.  
- User Level -> Profile Level -> System Level --> Default behaviour.  

There are different settings for each of these settings and following are the explanations for these attributes. 
  - **Log Level** : Applicalbe runtime log level for this run time context
  - **Mute**: Enable or disable mute upon logger initilization for each transaction in this context. 
  - **Enable Events**: Generate platform events for this run time context. 
  - **Enable OBject**: Generate Custom Object Records for this runt time context
  - **Enable System Debug**: Emulate System.debug for Logger statements. 

# Pause and Resume Logging
In some scenarios, a developer may want to pause logging by reused capabilities as it is working and only like to enable logging
for new code bering developed. I some other cases, you may need to avoid logging as using some functionality in batch processing
can not scale as it makes large data entries when single record functionality is invoked by batch process. 

Here comes pause and resume logging functions. 

Any logger statements after this until resume is invoked will be ignored and no logging will be made.

```
Logger.pause()
```

Resume logging 

```
Logger.resume()
```

# Defer and Keep Flushing
Each module us generally expected to enable its own logging and flush at the end of its code execution. However, when a complex functionality uses different modules, you may want to defer flushing until all different modules are executed to be able to save DMLs until the end. Defer and keep flushing capabilities comes to rescue. 

Defer flushing - once this is invokde any flush() statements are ignored until keepFlusing is invoked or forceFlush is set to true by flow. 

```
Logger.deferFlushing()
```

Stop defering and respect flush() statements. Please note that this does not trigger implicit flushing and is expected to call flush() after this if the expectation is to flush logs.  
```
Logger.keepFlushing()
```

# View and Manage Logs
A custom application (Log Monitor) with two tabs is configured readily usable for develppers to view logs live stream from platform events and view logs from custom objects as well. Access to this application and underlaying objects is enabled via custom permission set "Log Monitoring Permission". Simply add this permission set to any developer/admin who would like to have access to all logs. 
  
This permission allows access to all log entries and live stream of platform events across the system. 
  
## Log Monitoring Application

![image](https://user-images.githubusercontent.com/3853657/140729053-c771b086-c1b4-482f-9cc5-f530394c91f6.png)
  
## Log Monitor from Platform Events Stream

![image](https://user-images.githubusercontent.com/3853657/140729510-e0241aaa-dad3-4a5d-9e5f-40b771e2add4.png)
  
## Log Entries Records
 
![image](https://user-images.githubusercontent.com/3853657/140729695-446cf8c1-6d31-4348-baaf-727a89403488.png)

# Credits
I have referenced multiple logging framework to pull this framework together. 
- I have used custom LWC to monitor platform events from [Apex Unified Logging framework](https://github.com/rsoesemann/apex-unified-logging) and enhanced to add some features. 
- Some of the features are inspired by [Nebula Logger](https://github.com/jongpie/NebulaLogger)
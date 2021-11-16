# Salesforce Logger

A lightweght logging framework for Salesforce platform with ability to log to multiple streams (custom object, platform event, system debug) supporting all salesforce LoggingLevels. Framework provides ability to enable logging at system, profile and individual user level to be able to collect logs from environments with heavy load to be able to debug the functionality. Log entries can be made with any declarative tools support invocable action (any declarative tool runs on Flow infrastructure) in addition to apex.

# How to use it?
Log framework provides interface to used in Apex and Flow. 

## Apex
Use following methods Apex code. All formats of message structure is supported as long as it can fit into String.valueOf(message), which is similar to System.debug capabilities. 

- Logger.error(message);
- Logger.warn(message);
- Logger.info(message);
- Logger.debug(message);
- Logger.fine(message);
- Logger.finer(message);
- Logger.finest(message);


and finally add a Logger.flush();

## Flows

Use "Make Log Entry" apex action and provide the following input

- **Source**: Set this to source identifier that gets stamped in log entries. Salesforce does not support dynamic declartative tool developer names, hence this is provided to developer to have controle on tagging source identifier. 
- **Level**: Use one of the supported log levels. Thes values are same as Apex LoggingLevel Enum, as string. 
- **Message**: Message to be logged.

# Enable / Disable Logging

Enable disable logging via custom metadata records. If no metadata is defined this framework emulates System.debug behavour.  Logging configuraiton can be set at there levels. 
- **Org Level** : Metadata record developer name is 'System'
- **Profile Level**: Metadata record developer name is expected as 'ProfileId_<Profile Record Id>'
- **User Level**: Metadata record developer name is expected as 'UserId_<User Record Id>'

First available settings will be used in the following order to the current context.  
- User Level -> Profile Level -> System Level --> Default behaviour.  
  
# View and Manage Logs
A custom application (Log Monitor) with two tabs is configured readily usable for develppers to view logs live stream from platform events and view logs from custom objects as well. Access to this application and underlaying objects is enabled via custom permission set "Log Monitoring Permission". Simply add this permission set to any developer/admin who would like to have access to all logs. 
  
This permission allows access to all log entries and live stream of platform events across the system. 
  
## Log Monitoring Application

![image](https://user-images.githubusercontent.com/3853657/140729053-c771b086-c1b4-482f-9cc5-f530394c91f6.png)
  
## Log Monitor from Platform Events Stream

![image](https://user-images.githubusercontent.com/3853657/140729510-e0241aaa-dad3-4a5d-9e5f-40b771e2add4.png)
  
## Log Entries Records
 
![image](https://user-images.githubusercontent.com/3853657/140729695-446cf8c1-6d31-4348-baaf-727a89403488.png)




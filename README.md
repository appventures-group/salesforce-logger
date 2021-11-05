# Salesforce Log.me()

A lightweght logging framework for Salesforce platform with ability to log to multiple streams (custom object, platform event, system debug) supporting all salesforce LoggingLevels. Framework provides ability to enable logging at system, profile and individual user level to be able to collect logs from environments with heavy load to be able to debug the functionality. Log entries can be made with any declarative tools support invocable action (any declarative tool runs on Flow infrastructure) in addition to apex.

# How to use it?
Log framework provides interface to used in Apex and Flow. 

## Apex
Use following methods Apex code. All formats of message structure is supported as long as it can fit into String.valueOf(message), which is similar to System.debug capabilities. 

- Log.me().error(message);
- Log.me().warn(message);
- Log.me().info(message);
- Log.me().debug(message);
- Log.me().fine(message);
- Log.me().finer(message);
- Log.me().finest(message);

## Flows

Use "Make Log Entry" apex action and provide the following input

- Flow Guid: Always set this {!$Flow.InterviewGuid}. This will be logged in to source. 
- Level: Use one of the supported log levels. Thes values are same as Apex LoggingLevel Enum, but as string. 
- Message: Message to be logged.

# Enable / Disable Logging

Enable disable logging via custom metadata records. If no metadata is defined this framework emulates System.debug behavour.  Logging configuraiton can be set at there levels. 
- Org Level : Metadata record developer name is 'System'
- Profile Level: Metadata record developer name is expected as 'ProfileId_<Profile Record Id>'
- User Level: Metadata record developer name is expected as 'UserId_<User Record Id>'

First available settings will be used in the following order to the current context.  
- User Level -> Profile Level -> System Level --> Default behaviour.  
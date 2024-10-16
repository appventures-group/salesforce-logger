/**
 * Created by jaapbranderhorst on 16/10/2024.
 */

trigger LogTrigger on Log__e (after insert) {
    LogTriggerHandler handler = new LogTriggerHandler(Trigger.new);
    handler.handleTrigger();
}
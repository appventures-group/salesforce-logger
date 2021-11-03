import { LightningElement, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { subscribe, unsubscribe, onError } from "lightning/empApi";
import userId from "@salesforce/user/Id";
import locale from "@salesforce/i18n/locale";

export default class LogMonitor extends LightningElement {
    subscription;
    isMuted = false;
    logs = {};

    logsAsTree = [];
    columns = [
        {
            type: "number",
            fieldName: "index",
            label: "#",
            initialWidth: 100
        },
        {
            type: "text",
            fieldName: "RequestId__c",
            label: "RequestId",
            initialWidth: 100
        },
        {
            type: "text",
            fieldName: "User__c",
            label: "User",
            initialWidth: 100
        },
        {
            type: "text",
            fieldName: "Quiddity__c",
            label: "Quiddity",
            initialWidth: 100
        },
        {
            type: "text",
            fieldName: "Level__c",
            label: "Level",
            initialWidth: 100
        },
        {
            type: "text",
            fieldName: "time",
            label: "Time",
            initialWidth: 100
        },
        {
            type: "text",
            fieldName: "Source__c",
            label: "Source",
            initialWidth: 300
        },
        {
            type: "text",
            fieldName: "Message__c",
            label: "Message",
        }
    ];

    connectedCallback() {
        this.subscribe();
    }


    disconnectedCallback() {
        this.unsubscribe();
    }


    clearAll() {
        this.logs = {};
        this.logsAsTree = [];
    }


    async subscribe() {
        this.subscription = await subscribe("/event/Log__e", -1, (message) => this.receive(message));
        onError(error => {
            this.dispatchEvent( new ShowToastEvent({
                variant: "error",
                title: "Received error from server:",
                message: JSON.stringify(error),
            }) );
        });
        console.log()
    }


    unsubscribe() {
        unsubscribe(this.subscription, response => {});
    }


    receive(message) {
        console.log('message received', JSON.stringify(message));
        const log = message.data.payload;
        if(log.User__c === userId) {
            const timeFormat = { hour: 'numeric', minute: 'numeric', second: 'numeric' };
            log.time = new Intl.DateTimeFormat(locale, timeFormat).format(new Date(log.CreatedDate));
      
            const RequestId__c = log.RequestId__c;
            this.logs[RequestId__c] = this.logs[RequestId__c] || [];
            this.logs[RequestId__c].push(log);

            this.renderTree();
        }
    }


    renderTree() {
        let index = 1;
        this.logsAsTree = [];

        for(const RequestId__c in this.logs) {
            let log = this.logs[RequestId__c][0];
            log.index = index;
            log.RequestId__c = RequestId__c; 

            if(this.logs[RequestId__c].length > 1) {
                log._children = this.logs[RequestId__c].slice(1);
            }

            this.logsAsTree.push(log);
            index++;
        }

        this.template
            .querySelector("lightning-tree-grid")
            .expandAll();
    }
  
    handleRequestIdChange() {

    }

    toggleMute() {
        this.isMuted = !this.isMuted;

        if(this.isMuted) {
            this.unsubscribe();
        }
        else {
            this.subscribe();
        }
    }


    get muteIcon() {
        return (this.isMuted) ? "utility:volume_off" : "utility:volume_high";
    }

    
    get muteLabel() {
        return (this.isMuted) ? "Unmute" : "Mute";
    }
}
trigger LeadRecordTrigger on Lead_Record__c (before insert, before update, after insert, after update) {
 
    if(Trigger.isBefore){
        System.debug('Trigger.isBefore');
        // Call Methods for Before Triggers.     
        // Call After Insert methods.
        if(Trigger.isInsert){
            System.debug('Trigger.isInsert');
            // Call a utility method from another class
            LeadRecordTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        
        // Call After Update methods.
        if(Trigger.isUpdate){
            System.debug('Trigger.isUpdate');
            LeadRecordTriggerHandler.beforeUpdateHandler(Trigger.new);
        }           
    }
    
    if(Trigger.isAfter){
        System.debug('Trigger.isAfter');
        // Call After Insert methods.
        if(Trigger.isInsert){
            System.debug('Trigger.isInsert');
            // Call a utility method from another class
            LeadRecordTriggerHandler.afterInsertHandler(Trigger.new);
        }
        
        // Call After Update methods.
        if(Trigger.isUpdate){
            System.debug('Trigger.isUpdate');
            LeadRecordTriggerHandler.afterUpdateHandler(Trigger.new);
        }
    }
}
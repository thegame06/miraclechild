public with sharing class LeadRecordTriggerHandler {
    public LeadRecordTriggerHandler() {
    }
    public static void beforeInsertHandler(list<Lead_Record__c> lstLeadRecord){
        // Business logic.        
    }
    
    public static void beforeUpdateHandler(list<Lead_Record__c> lstLeadRecord){
        for (Lead_Record__c record : lstLeadRecord) {
            if (record.Status__c == 'Close') 
            {
                ContentDocumentLink[] documents = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId = :record.Id];   
                if (documents.size() == 0) {                    
                    record.addError('Lead Record cannot be closed. An attachment corresponding to the Digital Sign is required. ' + record.Name);    
                }
            }
        }
    }      

    public static void afterInsertHandler(list<Lead_Record__c> lstLeadRecord){
        // Business logic.
    }
    
    public static void afterUpdateHandler(list<Lead_Record__c> lstLeadRecord){
        // Business logic.
        for (Lead_Record__c record : lstLeadRecord) {
            if (record.Status__c == 'Close') 
            {
                if (record.Country__c == 'USA United States' || record.Country__c == 'CAN Canada') { 

                } else {
                    EmailManager.sendMail(record.Email__c, 'Sponsoring a Child', 'You can’t enroll in the App.');
                }
            }
        }        
    }     
}

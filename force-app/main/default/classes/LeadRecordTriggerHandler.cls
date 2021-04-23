public with sharing class LeadRecordTriggerHandler {
    public LeadRecordTriggerHandler() {
    }
    public static void beforeInsertHandler(list<Lead_Record__c> lstLeadRecord){
        // Business logic.          
        for (Lead_Record__c record : lstLeadRecord) {
                Account[] account = AccountHandler.getAccount(record.Country__c);                      
                if (account.size() > 0) {
                    //Linked Account
                    record.Account__c = account[0].Id;  
                }            
        }                   
    }    

    public static void beforeUpdateHandler(list<Lead_Record__c> lstLeadRecord){
        List<Opportunity> oppList = new List<Opportunity>();
        
        for (Lead_Record__c record : lstLeadRecord) {
            if (record.Status__c == 'Close') 
            {
                ContentDocumentLink[] documents = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId = :record.Id AND ContentDocument.FileType IN ('PDF') ];   
                if (documents.size() == 0) {                    
                    record.addError('Lead Record cannot be closed. An attachment corresponding to the Digital Sign is required (pdf file). ' + record.Name);    
                }else {
                    Map<Id,Account> acctsWithOppsAndConts = new Map<Id,Account>(
                        [SELECT Id,(SELECT Id FROM Opportunities WHERE TrackingNumber__c = : record.Id) FROM Account WHERE Id = :record.Account__c]);
                        if (acctsWithOppsAndConts.size() > 0) {
                                if (acctsWithOppsAndConts.get(record.Account__c).Opportunities.size() == 0) {
    
                                    oppList.add(new Opportunity(Name = record.Name,
                                                               StageName= 'Prospecting',
                                                               CloseDate= System.today().addMonths(1),
                                                               AccountId = record.Account__c,
                                                               TrackingNumber__c=record.Id));
                                }                          
                    }                        
                }
            }
        }

        if (oppList.size() > 0) {
            insert oppList;            
        }  
    }    
      
    public static void afterInsertHandler(list<Lead_Record__c> lstLeadRecord){
        // Business logic.     
    }

    public static void afterUpdateHandler(list<Lead_Record__c> lstLeadRecord){
        // Business logic.        
        List<Contact> contList = new List<Contact>();
        List<Invalid_Request__c> invalidList = new List<Invalid_Request__c>();
            
        for (Lead_Record__c record : lstLeadRecord) {

            if (record.Status__c == 'Close') 
            {
                Map<Id,Account> acctsWithOppsAndConts = new Map<Id,Account>(
                    [SELECT Id,(SELECT Id FROM Opportunities WHERE TrackingNumber__c = : record.Id) FROM Account WHERE Id = :record.Account__c]);

                    if (acctsWithOppsAndConts.size() > 0) {
                            if (acctsWithOppsAndConts.get(record.Account__c).Opportunities.size() == 1) {
                                
                                contList.add(new Contact(LastName = record.Name,
                                                         Phone = record.Cell_Phone__c,
                                                         Email = record.Email__c,
                                                         AccountId = record.Account__c ));                                
                            }                          
                } else {

                    EmailManager.sendMail(record.Email__c, 'Sponsoring a Child', 'You can’t enroll in the App.');

                    List<Invalid_Request__c> check = [SELECT Id FROM Invalid_Request__c WHERE Lead_Record__c = : record.Id];

                    if (check.size() == 0) {
                        invalidList.add(new Invalid_Request__c(Name = record.Name,
                                                               Lead_Record__c = record.Id));
                    }
                }
            }
        }            
        if (contList.size() > 0) {
            try {
                insert contList;
            } catch (Exception ex) {}
        }          
        if (invalidList.size() > 0) {
            insert invalidList;
        }          
    }     
}

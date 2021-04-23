public with sharing class SampleDataController {

    public class LeadRecordObject {
        public String FirstName;
        public String LastName;
        public String CellPhone;
        public String Email;
        public String Country;
    }

    @AuraEnabled
    public static boolean uploadFiles(List<Map<String, Object>> files){
        Boolean isSuccess = false;        

        List<Lead_Record__c> leadRecords = new List<Lead_Record__c>();
        for (Map<String, Object> file : files) {
            String fileJson = (String)file.get('Content');            
            List<LeadRecordObject> leadRecordObjects = (List<LeadRecordObject>) JSON.deserialize(
                fileJson,
                List<LeadRecordObject>.class
            );                
            for (LeadRecordObject lead : leadRecordObjects) {
                Lead_Record__c lead_Record_c = new Lead_Record__c();
                lead_Record_c.Name = lead.FirstName + ' ' + lead.LastName;
                lead_Record_c.First_Name__c = lead.FirstName;
                lead_Record_c.Last_Name__c = lead.LastName;
                lead_Record_c.Cell_Phone__c = lead.CellPhone;
                lead_Record_c.Email__c = lead.Email;
                lead_Record_c.Country__c = lead.Country;
                leadRecords.add(lead_Record_c);    
            }             
        }
        //insert leadRecords;   
        Database.saveResult[] srList = Database.insert(leadRecords);
        for (Database.SaveResult saveResult : srList ) {
            isSuccess = saveResult.isSuccess();
        }        

        return isSuccess;
    }
}

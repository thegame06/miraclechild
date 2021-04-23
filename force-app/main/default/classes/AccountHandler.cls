public with sharing class AccountHandler {    
    public AccountHandler() {
    }
    public static void loadAccounts(){
        String[] countries = new String[] {'USA United States','CAN Canada'};
        List<Account> accs = getAccounts(countries);
        if (accs.size() == 0) {
            for (String country : countries) {
                Account acc = new Account();
                acc.Name = country;
                acc.Country__c = country;
                accs.add(acc);
            }
            insert accs;
        }    
    }
    public static void checkAccounts(){
        String[] countries = new String[] {'USA United States','CAN Canada'};
        List<Account> accs = getAccounts(countries);
        if (accs.size() > 0) {
            delete [SELECT Id FROM Lead_Record__c];
            delete [SELECT Id FROM Invalid_Request__c];
            delete [SELECT Id FROM Opportunity];            
            delete [SELECT Id FROM Contact]; 
            delete [SELECT Id FROM Account];            
        }    
    }    
    public static List<Account>  getAccounts(String[] pCountries){
        return [SELECT Id, Name, Country__c FROM Account WHERE Country__c IN : pCountries AND Name IN : pCountries LIMIT 2];
    } 
    public static Account[]  getAccount(String pCountry){
        loadAccounts();
        return getAccounts(new String[]{  pCountry });
    } 
}
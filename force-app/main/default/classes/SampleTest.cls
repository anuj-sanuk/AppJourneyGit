public with sharing class SampleTest {
    @AuraEnabled(Cacheable=true)
    
    // public static List<Contact> getContactListPagiSort(string  LastName, Date Birthdate, String MailingPostalCode) {
    //     String fieldnames = 'Id, Name,MobilePhone, Birthdate';
    //     //String query = 'SELECT '+ fieldNames + ' FROM Contact where Name =:UserName AND (Birthdate =:BirthDates OR MobilePhone =:Mobile)';
    //      String query = 'SELECT '+ fieldNames + ' FROM Contact LIMIT 100';
    //      system.debug('query---'+query);
    //      //List<Contact> listOfContacts = Database.query( query );
       
    //      return Database.query( query );
    //     // return listOfContacts;
    // }
   
    public static List<Contact> getContactListPagiSort(string lastName, Date birthdate, String mailingPostalCode) {
         String fieldnames = 'Id, LastName,MailingPostalCode, Birthdate';
       //String query = 'SELECT '+ fieldNames + ' FROM Contact where Name =:UserName AND (Birthdate =:BirthDates OR MobilePhone =:Mobile)';
        String query = 'SELECT '+ fieldNames + ' FROM Contact LIMIT 100';
        system.debug('query---'+query);
       
      
        return Database.query( query );
    }
}
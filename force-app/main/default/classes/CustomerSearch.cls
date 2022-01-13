public with sharing class CustomerSearch {
    @AuraEnabled(Cacheable=true)
   
public static List<Contact> searchForContacts(String lastName,String mailingPostalCode,Date birthDate){
   String fieldNames = 'Id,LastName,BirthDate';
      String query = String.escapeSingleQuotes('SELECT'+fieldNames+'FROM  Contact where LastName=:lastName AND (BirthDate= :birthDate or MailingPostalCode= :mailingPostalCode)');
List<Contact>conList=database.query(query);
    return conList;
}
}
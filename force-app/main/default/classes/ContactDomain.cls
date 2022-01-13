public with sharing class ContactDomain {
    
    public static List<Contact> getContactsRecords(String strJsonFormat){
        String strQuery = 'Select id,Name,MailingPostalCode,BirthDate from Contact where  ';
        system.debug('json' +strJsonFormat);
            Map<String,object> mapJsonInput = (Map<String, object>) JSON.deserializeUntyped(strJsonFormat);
           system.debug('mapjson input' + mapJsonInput);
           string lastNameValue= String.valueOf(mapJsonInput.get('lastName'));
           string dateOfBirtValue = String.valueOf(mapJsonInput.get('dateOfBirth'));
           string postCodeValue = String.valueOf(mapJsonInput.get('postCode'));
          if(mapJsonInput.containsKey('lastName')){
            //query = query + ' Industry=\'' + String.escapeSingleQuotes(industry) + '\'';
              strQuery =strQuery + ' Name=\'' + lastNameValue + '\'';
              system.debug('jsonlastname' + strQuery);
              
              if(mapJsonInput.containsKey('dateOfBirth')){
                    
                strQuery =  strQuery + ' AND BirthDate=' + dateOfBirtValue ;
                system.debug('json birthdate' + strQuery);
                //strQuery =  strQuery + ' BirthDate=:' + (String.valueOf(mapJsonInput.get('dateOfBirth'));
            }  
                else if(mapJsonInput.containsKey('postCode')){
                   
                    strQuery =  strQuery + ' AND  MailingPostalCode=\''+ postCodeValue + '\'';
                    system.debug('json postcode' + strQuery);
                    //strQuery =  strQuery + ' MailingPostalCode=:'+ (String.valueOf(mapJsonInput.get('postCode'));
                }
                else if(mapJsonInput.containsKey('dateOfBirth') && (mapJsonInput.containsKey('postCode'))){
                    //strQuery =  strQuery  + ' AND MailingPostalCode=:'+ postCodeValue +' AND  BirthDate=: '+ dateOfBirtValue;
                    strQuery =  strQuery  + ' AND MailingPostalCode=\''+ postCodeValue + '\'' + ' AND  BirthDate=' + dateOfBirtValue;  
                    //strQuery =  strQuery  + ' AND MailingPostalCode=:'+ String.valueOf(mapJsonInput.get('postCode')) +' AND  BirthDate=: '+ String.valueOf(mapJsonInput.get('dateOfBirth')); 
                    system.debug('json birthdate and postcode' + strQuery);
                }
            
               
                
                
             }    
        
        List<Contact> records = ContactSelector.getContactDetails(strQuery);
    System.debug(records);
        return records;
    }
}
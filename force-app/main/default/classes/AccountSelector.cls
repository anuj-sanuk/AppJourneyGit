/*------------------------------------------------------------
Author: Ahshan Ali
Company: Coforge
Description: A utility class to return F Number after querying it from Account Object.
Inputs: F Number (String)
Test Class: AccountSelectorTest
History
<Date>      <Authors Name>  <Brief Description of Change>
02-11-2021   Ahshan Ali      Initial Draft
------------------------------------------------------------*/
public with sharing class AccountSelector { 
    
    /*------------------------------------------------------------
    Author: Ahshan Ali
    Company: Coforge
    Description: A apex method to return account record.
    Inputs: F Number (String)
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    02-11-2021   Ahshan Ali      Initial Draft
    ------------------------------------------------------------*/
    public static List<Account> getAccountDetails(String strFNumber) {
        String strLikeFnumber='%'+strFNumber+'%';
        
        return Security.stripInaccessible(AccessType.READABLE,[SELECT Id 
                                                               FROM Account 
                                                               WHERE FinServ__SourceSystemId__c LIKE  : strLikeFnumber
                                                              ]).getRecords();
        
  
    }
    /*------------------------------------------------------------
    Author: Alekya Avadutha
    Company: Coforge
    Description: A apex method to return account records.
    Inputs:  String
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    30-11-2021   Alekya Avadutha     Initial Draft
    ------------------------------------------------------------*/
   public static List<Account> getAccountRecords(String strDynamicQuery) {
       List<Account> lstAccountRecords = Database.query(strDynamicQuery);
       return Security.stripInaccessible(AccessType.READABLE,lstAccountRecords).getRecords();
    }
   
}
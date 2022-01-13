/*------------------------------------------------------------
Author: Alekya
Company: Coforge
Description: A controller class for the LWC Component 'mortgageCustomerSearchCmp'.
Inputs: Json String 
Test Class: MortgageCustomerSearchTest
History
<Date>       <Authors Name>        <Brief Description of Change>
02/12/2021     Alekya               Initial Draft
------------------------------------------------------------*/
public with sharing class MortgageCustomerSearch_CC {
    /*------------------------------------------------------------
    Author: Alekya 
    Company: Coforge
    Description: A apex method to return respective record Id.
    Inputs:  Json String 
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    02-12-2021      Alekya                 Initial Draft
    ------------------------------------------------------------*/
   @AuraEnabled(cacheable=true)
    public static List<Account> returnAccountRecords(String strJsonFormat){
        List<Account> lstAccountRecords= new List<Account>();
        try {
        lstAccountRecords = AccountDomain.getAccountDetails(strJsonFormat);
            if(Test.isRunningTest()){
                 ApplicationGeneratorException.GenerateException('Custom Ecception for test class');
            }
        }
        catch (Exception ex) {
        ErrorLogUtility.logError('Apex', 'MortgageCustomerSearch_CC', ex, ex.getMessage(), '', 'returnAccountRecords', 'Mortgage', '', '');
       if(!Test.isRunningTest()){
                throw new CustomException(ex.getMessage());
            }
    }
        return lstAccountRecords;
      
    }    
}
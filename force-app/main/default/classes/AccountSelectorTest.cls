/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test class for the class 'AccountSelector'
Inputs: None
History
<Date>       <Authors Name>        <Brief Description of Change>
10/11/2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
@isTest
public class AccountSelectorTest 
{
    /*------------------------------------------------------------
    Author: Alekya
    Company: Coforge
    Description: A apex method to test 'AccountSelector
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    30-11-2021   Alekya     Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void getAccountsSelectorTest() {
        List<Account> lstAccounts =TestDataFactory.getPersonAccountRecords(2);
        String strQuery='Select id,LastName,PersonBirthdate,BillingPostalCode from Account';
        Test.startTest();
        String strRecordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        lstAccounts[0].recordTypeId =strRecordTypeId;
        lstAccounts[1].recordTypeId =strRecordTypeId;
        insert lstAccounts;  
        List<Account> lstAccountDetails =  AccountSelector.getAccountRecords(strQuery);
        Test.stopTest();
        System.assertEquals(lstAccounts[0].Id, lstAccountDetails[0].Id);
     }
   /*------------------------------------------------------------
    Author: Sathvik Voola 
    Company: Coforge
    Description: A apex method to test 'AccountSelector.getAccountsSelector' by specifying SourceSystemId
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    10-11-2021   Sathvik Voola     Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void returnAccountsSelectorTest()
    {
        String sourceSystemId;
        List<Account> lstAccounts =TestDataFactory.getAccounts(5);
        Test.startTest();
        insert lstAccounts; 
        sourceSystemId=lstAccounts[0].FinServ__SourceSystemId__c;
       
        List<Account> lstAccountDetails = AccountSelector.getAccountDetails(sourceSystemId);
        Test.stopTest();
        System.assertEquals(String.valueOf(lstAccounts[0].Id) ,String.valueOf(lstAccountDetails[0].Id));
    }
  

}
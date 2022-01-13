/*------------------------------------------------------------
Author: Alekya
Company: Coforge
Description: A test class for the class 'MortgageApplicationSearch_CC'
Inputs: None
History
<Date>       <Authors Name>        <Brief Description of Change>
10/11/2021    Alekya                  Initial Draft
------------------------------------------------------------*/
@isTest
public class MortgageCustomerSearchTest {
    /*------------------------------------------------------------
    Author: Alekya
    Company: Coforge
    Description: A apex method to test 'MortgageCustomerSearch_CC.returnAccountRecords' 
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    10-11-2021      Alekya         Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void getMortgageCustomerSearchTest()
    {
        List<Account> lstAccounts = TestDataFactory.getPersonAccountRecords(2);
        String strRecordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();        
        lstAccounts[0].recordTypeId =strRecordTypeId;
        lstAccounts[1].recordTypeId =strRecordTypeId;
        string jsonString ='{"lastName":"TestingPersonAccount0","dateOfBirth":"2021-12-12","postCode":"111111"}';
        Test.startTest();
        insert lstAccounts; 
        List<Account> accountsDetails =MortgageCustomerSearch_CC.returnAccountRecords(jsonString);
        Test.stopTest();
        System.assertEquals(lstAccounts[0].lastName, accountsDetails[0].lastName);
    }
}
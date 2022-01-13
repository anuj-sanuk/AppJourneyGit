/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test class for the class 'AccountDomain'
Inputs: None
History
<Date>       <Authors Name>        <Brief Description of Change>
10/11/2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
@isTest
public class AccountDomainTest 
{
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: A apex method to test 'AccountDomain.getAccountDomain' by specifying Fnumber
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    10-11-2021   Sathvik Voola     Initial Draft
    ------------------------------------------------------------*/
    @isTest
	public static void getAccountDomainTest()
    {
        
        List<Account> lstAccounts =  TestDataFactory.getAccounts(5);
        Test.startTest();
        insert lstAccounts; 
        String strRecordId = AccountDomain.getCustomerDetails('F-000000001');
        Test.stopTest();
        System.assertEquals(String.valueOf(lstAccounts[0].Id) , strRecordId);
    }
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: A apex method to test different formats of Fnumber
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    10-11-2021   Sathvik Voola     Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void returnFNumberTest()
    {
        String strFNumberOne=AccountDomain.returnFNumber('F000000001');
        System.assertEquals('000000001', strFNumberOne);
        String strFNumberTwo=AccountDomain.returnFNumber('F 000000001');
        System.assertEquals('000000001', strFNumberTwo);
        String strFNumberThree=AccountDomain.returnFNumber('F-000000001');
        System.assertEquals('000000001', strFNumberThree);
        String strFNumberFour=AccountDomain.returnFNumber('000000001');
        System.assertEquals('000000001', strFNumberFour);
    }
    /*------------------------------------------------------------
    Author: Alekya
    Company: Coforge
    Description: A apex method to test AccountDomain Class
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    02-12-2021     Alekya             Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void getAccountsTest(){
        List<Account> lstAccounts = TestDataFactory.getPersonAccountRecords(2);
        string jsonString ='{"lastName":"TestingPersonAccount0","dateOfBirth":"2021-12-12","postCode":"111111"}';
        String strRecordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        lstAccounts[0].recordTypeId =strRecordTypeId;
        lstAccounts[1].recordTypeId =strRecordTypeId;
        Test.startTest();
        insert lstAccounts;
        List<Account> accountsDetails =AccountDomain.getAccountDetails(jsonString);
        Test.stopTest();
        System.assertEquals(lstAccounts[0].Id , accountsDetails[0].Id);
        
    }
    
    }
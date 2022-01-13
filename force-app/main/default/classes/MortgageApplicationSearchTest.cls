/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test class for the class 'MortgageApplicationSearch_CC'
Inputs: None
History
<Date>       <Authors Name>        <Brief Description of Change>
10/11/2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
@isTest
public class MortgageApplicationSearchTest 
{
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: A apex method to test 'MortgageApplicationSearch_CC.getRecordIdToNavigate' by specifying application name
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    10-11-2021   Sathvik Voola     Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void getMortgageApplicationsTest()
    {
        //TestDataFactoryMortgageApplication dataFactory = new TestDataFactoryMortgageApplication();
        List<Account> lstAccounts =  TestDataFactory.getAccounts(5);
        Test.startTest();
        insert lstAccounts;

        List<ResidentialLoanApplication> residentialLoanApplication = TestDataFactory.getResidentialLoanApplications(1,lstAccounts[0].Id);
        insert residentialLoanApplication;
        String jsonString = '{"applicationNumber":"'+residentialLoanApplication[0].Name+'"}';
        
        String retId=MortgageApplicationSearch_CC.getRecordIdToNavigate(jsonString);
        Test.stopTest();
        System.assertEquals(String.valueOf(residentialLoanApplication[0].Id) , retId);
        
    }
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: A apex method to test 'MortgageApplicationSearch_CC.getRecordIdToNavigate' by specifying Fnumber name
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    10-11-2021   Sathvik Voola     Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void getAccountControllerTest()
    {
        List<Account> lstAccounts =  TestDataFactory.getAccounts(5);
        Test.startTest();
        insert lstAccounts;   
       
        String strRecordId = MortgageApplicationSearch_CC.getRecordIdToNavigate('{"fNumber":"F-000000001"}');
        Test.stopTest();
        System.assertEquals(String.valueOf(lstAccounts[0].Id) , strRecordId);
    }
    
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: A apex method to test 'MortgageApplicationSearch_CC.getRecordIdToNavigate' for exception Handling
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    10-11-2021   Sathvik Voola     Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void getExceptionsTest()
    {
        Test.startTest();
        String strRecordId=MortgageApplicationSearch_CC.getRecordIdToNavigate('');
        Test.stopTest();
        System.assertEquals(null, strRecordId);
    }

}
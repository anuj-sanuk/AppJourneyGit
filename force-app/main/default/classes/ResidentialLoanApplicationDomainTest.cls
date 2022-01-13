/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test class for the class 'ResidentialLoanApplicationDomain'
Inputs: None
History
<Date>       <Authors Name>        <Brief Description of Change>
10/11/2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
@isTest
public class ResidentialLoanApplicationDomainTest {
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: A apex method to test 'ResidentialLoanApplicationDomain.applicationMethod' by specifying application name
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    10-11-2021   Sathvik Voola     Initial Draft
    ------------------------------------------------------------*/
@isTest  
static void applicationMethodTest()
	{
        String strApplicationName;
        String strRecordId;

        List<Account> lstAccounts = TestDataFactory.getAccounts(5);
        Test.startTest();
        insert lstAccounts; 
        List<ResidentialLoanApplication> lstResidentialLoanApplication = TestDataFactory.getResidentialLoanApplications(5,lstAccounts[0].id);
        insert lstResidentialLoanApplication;

        strApplicationName = lstResidentialLoanApplication[0].name;
        strRecordId= String.valueOf(lstResidentialLoanApplication[0].Id);
        
        String strApplicationId=ResidentialLoanApplicationDomain.getApplicationDetails(strApplicationName);
        Test.stopTest();
        System.assertEquals(strRecordId , strApplicationId);
        
        
    }
}
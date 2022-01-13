/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test class for the class ' ResidentialLoanApplicationSelector'
Inputs: None
History
<Date>       <Authors Name>        <Brief Description of Change>
10/11/2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
@isTest
public class ResidentialLoanApplicationSelectorTest {
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: A apex method to test 'ResidentialLoanApplicationSelector.getResidentialLoanApplications' by specifying application name
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    10-11-2021   Sathvik Voola     Initial Draft
    ------------------------------------------------------------*/
@isTest 
    static  void getResidentialLoanApplicationsTest()
    {
        List<Account> lstAccounts =  TestDataFactory.getAccounts(5);
        Test.startTest();
        insert lstAccounts; 
        List<ResidentialLoanApplication> lstResidentialLoanApplication = TestDataFactory.getResidentialLoanApplications(5,lstAccounts[0].id);
        insert lstResidentialLoanApplication;
        
        List<ResidentialLoanApplication> lstResidentialLoanApplicationDetails =  ResidentialLoanApplicationSelector.getResidentialLoanApplications(String.valueOf(lstResidentialLoanApplication[0].Name));
        Test.stopTest();
        System.assertEquals(String.valueOf(lstResidentialLoanApplication[0].Id) , lstResidentialLoanApplicationDetails[0].Id);
        
    }
  
    
}
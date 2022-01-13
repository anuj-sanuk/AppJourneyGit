/*------------------------------------------------------------
Author: Alekya Avadutha 
Company: Coforge
Description: Apex class to fetch application details on basis of application number
Inputs: Application Number (String)
Test Class: ResidentialLoanApplicationDomainTest
History
<Date>       <Authors Name>         <Brief Description of Change>
02-11-2021   Alekya Avadutha        Initial Draft
------------------------------------------------------------*/
public with sharing class ResidentialLoanApplicationDomain {
   
    /*------------------------------------------------------------
    Author: Alekya Avadutha 
    Company: Coforge
    Description: Apex method to fetch application details on basis of application number
    Inputs: Application Number (String)
    History
    <Date>      <Authors Name>       <Brief Description of Change>
    02-11-2021   Alekya Avadutha      Initial Draft
    ------------------------------------------------------------*/
    public static String getApplicationDetails(String strApplicationName){
        String strResedentialLoanApplicationId;
        List<ResidentialLoanApplication> lstResidentialLoanApplication = ResidentialLoanApplicationSelector.getResidentialLoanApplications(strApplicationName);
        if(!lstResidentialLoanApplication.isEmpty()){
            strResedentialLoanApplicationId = String.valueOf(lstResidentialLoanApplication[0].Id);
        }
        return strResedentialLoanApplicationId;

    }
    
    
}
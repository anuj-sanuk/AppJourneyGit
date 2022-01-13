/*------------------------------------------------------------
Author: Alekya Avadutha 
Company: Coforge
Description: Apex class to fetch application details on basis of application number
Inputs: Application Number (String)
Test Class: ResidentialLoanApplicationSelectorTest
History
<Date>       <Authors Name>         <Brief Description of Change>
02-11-2021   Alekya Avadutha        Initial Draft
------------------------------------------------------------*/
public with sharing class ResidentialLoanApplicationSelector {

    /*------------------------------------------------------------
    Author: Alekya Avadutha 
    Company: Coforge
    Description: Apex method to fetch application details on basis of application number
    Inputs: Application Number (String)
    History
    <Date>      <Authors Name>       <Brief Description of Change>
    02-11-2021   Alekya Avadutha      Initial Draft
    ------------------------------------------------------------*/
    public static List<ResidentialLoanApplication>  getResidentialLoanApplications(String strApplicationNumber) {

         return Security.stripInaccessible(AccessType.READABLE,[SELECT Id,
                                                                       Name 
                                                                FROM ResidentialLoanApplication 
                                                                WHERE Name =: strApplicationNumber limit 1
                                                                ]).getRecords();       
        
    }
    
}
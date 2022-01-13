/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A controller class for the LWC Component 'mortgageApplicationSearchCmp'.This takes Json strong as input and
returns record Id of the respective objects which help for navigation.
Inputs: Json String with Fnumber or application Number
Test Class: MortgageApplicationSearchTest
History
<Date>       <Authors Name>        <Brief Description of Change>
08/11/2021   Sathvik Voola          Initial Draft
------------------------------------------------------------*/
public with sharing class MortgageApplicationSearch_CC {

    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: A apex method to return respective record Id.
    Inputs:  Json String with Fnumber or application Number
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    02-11-2021   Sathvik Voola       Initial Draft
    ------------------------------------------------------------*/
    @AuraEnabled(Cacheable=true)
    public static string getRecordIdToNavigate( String strJsonFormat){
        String strRecordId;
        if(strJsonFormat != null){
            try {
                Map<String,object> mapJsonInput = (Map<String, object>) JSON.deserializeUntyped(strJsonFormat);
                
                if(mapJsonInput.containsKey('fNumber')){
                    strRecordId=AccountDomain.getCustomerDetails(String.valueOf(mapJsonInput.get('fNumber')));
                }else if(mapJsonInput.containsKey('applicationNumber')){
                    strRecordId=ResidentialLoanApplicationDomain.getApplicationDetails(String.valueOf(mapJsonInput.get('applicationNumber')));
                }
            }catch (Exception ex) {
                //ErrorLogUtility.logError('MortgageApplicationSearch_CC', 'getRecordIdToNavigate', ex, ex.getMessage(), 'NULL', 'NULL', 'Mortgage', 'NUll', 'NULL');
            } 
        }
        return strRecordId;
    }
}
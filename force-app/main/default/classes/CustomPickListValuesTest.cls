/*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A test class for the Class CustomPickListValues_CC
Inputs: Object API Name (String) ; Pick List Field API Name (String) 
History
<Date>      <Authors Name>  <Brief Description of Change>
09-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
@isTest
public class CustomPickListValuesTest {
    /*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A test Method to cover for the Class CustomPickListValues_CC.getPicklistValues()
Inputs: Object API Name (String) ; Pick List Field API Name (String) 
History
<Date>      <Authors Name>  <Brief Description of Change>
09-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
    @isTest
    public static void getPicklistValuestest(){
        Test.startTest();
        String strReturnedPickListValues=CustomPickListValues_CC.getPicklistValues('ResidentialLoanApplication','RLA_Stages__c');
        Test.stopTest();
        System.assert(strReturnedPickListValues.length() > 0);
    }
}
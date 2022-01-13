/*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A test class for the class CustomPickListValuesSelector
Inputs: Object API Name (String) ; Pick List Field API Name (String)
History
<Date>      <Authors Name>  <Brief Description of Change>
09-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
@isTest
public class CustomPickListValuesSelectorTest {
    /*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A test Method  for the class CustomPickListValuesSelector.returnPickListValues()
Inputs: Object API Name (String) ; Pick List Field API Name (String)
History
<Date>      <Authors Name>  <Brief Description of Change>
09-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
    @isTest
    public static void returnPickListValuesTest(){
        Test.startTest();
        List<String> lstPickListValues=CustomPickListValuesSelector.returnPickListValues('ResidentialLoanApplication','RLA_Stages__c');
        Test.stopTest();
        System.assert(lstPickListValues.size() > 0);
    }
}
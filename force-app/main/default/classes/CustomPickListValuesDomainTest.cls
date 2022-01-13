/*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A test class for the class  CustomPickListValuesDomain
Inputs: Object API Name (String) ; Pick List Field API Name (String)
History
<Date>      <Authors Name>  <Brief Description of Change>
09-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
@isTest
public class CustomPickListValuesDomainTest {
    /*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A test class for the class  CustomPickListValuesDomain.getWrappedPickValues()
Inputs: Object API Name (String) ; Pick List Field API Name (String)
History
<Date>      <Authors Name>  <Brief Description of Change>
09-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
    @isTest
    public static void getWrappedPickValuesTest(){
        Test.startTest();
        String strSerializedValues=CustomPickListValuesDomain.getWrappedPickValues('ResidentialLoanApplication','RLA_Stages__c');
        Test.stopTest();
        System.assert(strSerializedValues.length() >0);
    }

}
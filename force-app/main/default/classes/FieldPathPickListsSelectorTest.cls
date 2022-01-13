/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test class for FieldPathPickListsSelector class
Inputs: None
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
@isTest
public with sharing class FieldPathPickListsSelectorTest {
    /*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test method for FieldPathPickListsSelector class
Inputs: None
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
    @isTest
    public static void getFieldsMetaTest(){
        Test.startTest();
        List<Schema.SObjectField> lstObjectFields=FieldPathPicklistsSelector.getFieldsMeta('Opportunity');
        Test.stopTest();
        System.assert(lstObjectFields.size() > 0);
        
    }

}
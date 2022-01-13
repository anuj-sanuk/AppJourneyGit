/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A Selector class to retive the meta data of fields depending on the object name
Inputs: Object API Name
Test Class: FieldPathPickListsSelectorTest
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
public with sharing class FieldPathPickListsSelector{
    /*------------------------------------------------------------
	Author: Sathvik Voola
	Company: Coforge
	Description: A method which uses object API name as parameter and returns the list of metadata of fields
	Inputs: Object API Name
	Test Class: FieldPathPickListsSelectorTest
	History
	<Date>      <Authors Name>  <Brief Description of Change>
	18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
    public static List<Schema.SObjectField> getFieldsMeta(String strCurrentPageObjectName){
        Map<String, Schema.SObjectField> mapCurrObjectfields = Schema.getGlobalDescribe().get(strCurrentPageObjectName).getDescribe().fields.getMap();
        return mapCurrObjectfields.values();
    }
    
}
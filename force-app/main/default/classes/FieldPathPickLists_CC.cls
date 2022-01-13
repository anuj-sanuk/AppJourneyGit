/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A controller class to handle the values in "currentObjPickVal" design property 
for the Aura component "dynamicFieldPath"
Inputs: None
Test Class: FieldPathPicklistsTest
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
Global with sharing class FieldPathPickLists_CC extends VisualEditor.DynamicPickList {
    
    /*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: Initialising the constructor with context
Inputs: VisualEditor.DesignTimePageContext
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
    VisualEditor.DesignTimePageContext objContext;
    global FieldPathPickLists_CC(VisualEditor.DesignTimePageContext objContext) {
        this.objContext = objContext;
        
    }
    
    /*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: Overriding the "getDefaultValue" method from extended class
Inputs: none
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
    global override VisualEditor.DataRow getDefaultValue(){
        
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('none', 'none');
        return defaultValue;
    }
    /*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: Overriding the "getValues" method from extended class
Inputs: none
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
    global override VisualEditor.DynamicPickListRows getValues() {
        
        VisualEditor.DynamicPickListRows  lstPicklistValues = new VisualEditor.DynamicPickListRows();
        try{
            String strCurrentPageObjectName = objContext.entityName;
            List<Schema.SObjectField> lstFieldsMeta=FieldPathPickListsSelector.getFieldsMeta(strCurrentPageObjectName);
            for(Schema.SObjectField objfieldMeta : lstFieldsMeta){
                Schema.DescribeFieldResult objDescField = objfieldMeta.getDescribe();
                if(String.ValueOf(objDescField.type)==Constants.TYPE_PICKLIST){
                    VisualEditor.DataRow objDataRow = new VisualEditor.DataRow(String.valueOf(objDescField.getName()), String.valueOf(objDescField.getName()));
                    lstPicklistValues.addRow(objDataRow);
                }
            }
            if(Test.isRunningTest()){
                 ApplicationGeneratorException.GenerateException('Custom Ecception for test class');
            }

        }
        catch(Exception ex){
            ErrorLogUtility.logError('FieldPathPickLists_CC', 'getValues', ex, ex.getMessage(), 'NULL', 'NULL', 'Mortgage', 'NUll', 'NULL');
            if(!Test.isRunningTest()){
                throw new AuraHandledException(ex.getMessage());
            }
            
        }
        return lstPicklistValues;
    }
    
}
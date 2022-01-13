/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test class for FieldPathPickLists class
Inputs: None 
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
@isTest
public class FieldPathPickListsTest {
    /*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test method for FieldPathPickLists class
Inputs: None
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
    @isTest
    public static void getDefaultValueTest(){
        VisualEditor.DesignTimePageContext objVisualEditor=TestDataFactory.getVisualEditor();
        FieldPathPickLists_CC objFieldPathPickListsController=new FieldPathPickLists_CC(objVisualEditor);
        Test.startTest();
        VisualEditor.DataRow objDefaultValue=objFieldPathPickListsController.getDefaultValue();
        Test.stopTest();
        System.assertEquals(null, objDefaultValue);
    }
    /*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test method for FieldPathPickListsController class
Inputs: None 
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
    @isTest
    public static void getValuesTest(){
        VisualEditor.DynamicPickListRows objReturnedValue = new VisualEditor.DynamicPickListRows();
        VisualEditor.DesignTimePageContext objVisualEditor=TestDataFactory.getVisualEditor();
        Test.startTest();
        FieldPathPickLists_CC objFieldPathPickListsController=new FieldPathPickLists_CC(objVisualEditor);
        objReturnedValue=objFieldPathPickListsController.getValues();
        Test.stopTest();
        System.assert(objReturnedValue.size() > 0);
    }
}
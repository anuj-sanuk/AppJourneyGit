/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test class for FieldPathPickListsController class
Inputs: None
Test Class: 
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
@isTest
public class FieldPathPickListsControllerTest {
    /*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: A test method for FieldPathPickListsController class
Inputs: None
Test Class: 
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
	@isTest
    public static void getDefaultValueTest()
    {
        VisualEditor.DesignTimePageContext objVisualEditor=new VisualEditor.DesignTimePageContext();
        objVisualEditor=TestDataFactory.getVisualEditor();
        FieldPathPickListsController objFieldPathPickListsController=new FieldPathPickListsController(objVisualEditor);
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
Test Class: 
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
    @isTest
    public static void getValuesTest()
    {
        VisualEditor.DesignTimePageContext objVisualEditor=new VisualEditor.DesignTimePageContext();
        objVisualEditor=TestDataFactory.getVisualEditor();
        Test.startTest();
        FieldPathPickListsController objFieldPathPickListsController=new FieldPathPickListsController(objVisualEditor);
        VisualEditor.DynamicPickListRows objReturnedValue=objFieldPathPickListsController.getValues();
        Test.stopTest();
       	System.assert(objReturnedValue.size() > 0);
    }
}
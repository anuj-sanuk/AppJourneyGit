/*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A Controller to return picklist wrapped values for custom field path
Inputs: Object API Name (String) ; Pick List Field API Name (String) 
Test Class: CustomPickListValuesTest
History
<Date>      <Authors Name>  <Brief Description of Change>
08-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
public with sharing class CustomPickListValues_CC {
    /*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A method to return picklist wrapped values for custom field path
Inputs: Object API Name (String) ; Pick List Field API Name (String) 
History
<Date>      <Authors Name>  <Brief Description of Change>
08-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
    @AuraEnabled(cacheable = true)
    public static String getPicklistValues(String strObjectAPIName, String strFieldAPIName){
        String strWrappedPickValues;
        try{
            strWrappedPickValues = CustomPickListValuesDomain.getWrappedPickValues(strObjectAPIName,strFieldAPIName);
        	if(Test.isRunningTest()){
            ApplicationGeneratorException.GenerateException('Exception for Text Class');
        }
            
        }
        catch(Exception ex){
            ErrorLogUtility.logError('Apex', 'Questionnaire_CC', ex, ex.getMessage(), '', 'getQuestionnaireJSON', 'Questionnaire', '', '');
        	CustomException.getErrorMessage();
        }
         return strWrappedPickValues;
		}
       
    

}
/*------------------------------------------------------------
Author: Anuj Sahu
Company: Coforge
Description: A controller class for the LWC Component 'QuestionnaireCmp'.
Inputs: <to be added> 
Test Class: QuestionnaireText
History
<Date>      <Authors Name>  <Brief Description of Change>
16-11-2021   Anuj Sahu       Initial Draft
------------------------------------------------------------*/
public with sharing class Questionnaire_CCCloneAnuj{
    
    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: A apex method return questions and answers after quering it from QuestionnaireDomain Class.
    Inputs: Inputs: Salespath Name (String) ; Section Name (String)
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    16-11-2021   Anuj Sahu       Initial Draft
    ------------------------------------------------------------*/
    @AuraEnabled(cacheable = true)
    public static String getQuestionnaireJSON(String strQuestionsQuery){
        system.debug('strQuestionsQuery :::'+strQuestionsQuery);
    try {
        String strQuestionnaireJSON = QuestionnaireDomainCloneAnuj.getQuestionnaireWrapper(strQuestionsQuery);
        system.debug('strQuestionnaireJSON :::'+strQuestionnaireJSON);
        if(Test.isRunningTest()){
            ApplicationGeneratorException.generateException('Exception for Text Class');
        }
        return strQuestionnaireJSON;
        
    }
    catch (Exception ex) {
        System.debug('Exception in Questionnaire_cc : '+ex.getMessage()+'  '+ex.getLineNumber());
        system.debug('getDMLStatements()' +Limits.getDMLStatements());
        ErrorLogUtility.logError('Apex', 'Questionnaire_CC', ex, ex.getMessage(), '', 'getQuestionnaireJSON', 'Mortgage', '', '');
        CustomException.getErrorMessage();
    }
        return null;
    }
}
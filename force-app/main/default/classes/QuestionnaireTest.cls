/*------------------------------------------------------------
Author: Anuj Sahu
Company: Coforge
Description: A test class for the class 'Questionnaire_CC'
Inputs: None
History
<Date>       <Authors Name>        <Brief Description of Change>
10/11/2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
@isTest
public with sharing class QuestionnaireTest {
    
    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: A apex method to test 'Questionnaire_CC.QuestionnaireTest' by specifying Salespath and Accordian Section names.
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    10-11-2021   Anuj Sahu     Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void questionnaireDataTest() {

        List<Questionnaire__c> lstQuestions = TestDataFactory.getQuestionnaire(1);
        List<Questionnaire__c> lstAllQuestions = new List<Questionnaire__c>();
        Test.startTest();
            insert lstQuestions;
        	lstAllQuestions = TestDataFactory.getQuestionnaire(6);
        	lstAllQuestions[0].ParentQuestion__c = lstQuestions[0].Id;
       		insert lstAllQuestions;
            String quesListJSON = JSON.serialize(lstAllQuestions);
            String questionnaireJSON =  Questionnaire_CC.getQuestionnaireJSON(lstAllQuestions[0].SalesPath__c, lstAllQuestions[0].SectionName__c);
        Test.stopTest();
        for(Questionnaire__c objQues : lstAllQuestions) {
            System.assert(objQues.DataType__c != null,'Data type cannot be null');
        }
        System.assertNotEquals(quesListJSON,questionnaireJSON,'Questionnaire records should be available.');
    }
}
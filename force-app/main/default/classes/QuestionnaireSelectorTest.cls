/*------------------------------------------------------------
Author: Anuj Sahu
Company: Coforge
Description: A test class for the class 'QuestionnaireSelector'
Inputs: None
History
<Date>       <Authors Name>        <Brief Description of Change>
10/11/2021   Anuj      Initial Draft
------------------------------------------------------------*/
@isTest
public with sharing class QuestionnaireSelectorTest {

    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: A apex method to test 'QuestionnaireSelector.getQuestionsAndAnswers' by specifying Salespath and Accordian Section names.
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    10-11-2021   Anuj Sahu     Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void QuestionnaireDataTest() {
        
       List<Questionnaire__c> lstQuestions = TestDataFactory.getQuestionnaire(1);
        List<Questionnaire__c> lstAllQuestions = new List<Questionnaire__c>();
        Test.startTest();
            insert lstQuestions;
        	lstAllQuestions = TestDataFactory.getQuestionnaire(6);
        	lstAllQuestions[0].ParentQuestion__c = lstQuestions[0].Id;
       		insert lstAllQuestions;
            QuestionnaireSelector.getQuestionsAndAnswers(lstAllQuestions[0].SalesPath__c, lstAllQuestions[0].SectionName__c);
        Test.stopTest();
        for(Questionnaire__c objQues : lstAllQuestions) {
            System.assert(objQues.DataType__c != null,'Data type cannot be null');
        }
        System.assert(lstAllQuestions.size()>0,'Questionnaire records should be available.');
    }
    /*------------------------------------------------------------
    Author: Sathvik VOola
    Company: Coforge
    Description: A apex method to test 'QuestionnaireSelector.getSections' by specifying Salespath.
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    08-12-2021   Sathvik VOola     Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void getSectionsTest() {
        
       List<Questionnaire__c> lstQuestions = TestDataFactory.getQuestionnaire(1);
        List<Questionnaire__c> lstAllQuestions = new List<Questionnaire__c>();
        Test.startTest();
            insert lstQuestions;
        	lstAllQuestions = TestDataFactory.getQuestionnaire(6);
        	lstAllQuestions[0].ParentQuestion__c = lstQuestions[0].Id;
       		insert lstAllQuestions;
            QuestionnaireSelector.getSections(lstAllQuestions[0].SalesPath__c);
        Test.stopTest();
        for(Questionnaire__c objQues : lstAllQuestions) {
            System.assert(objQues.DataType__c != null,'Data type cannot be null');
        }
        System.assert(lstAllQuestions.size()>0,'Questionnaire records should be available.');
    }
}
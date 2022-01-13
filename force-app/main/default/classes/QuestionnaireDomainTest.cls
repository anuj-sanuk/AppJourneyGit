/*------------------------------------------------------------
Author: Anuj Sahu
Company: Coforge
Description: A test class for the class 'QuestionnaireDomain'
Inputs: None
History
<Date>       <Authors Name>        <Brief Description of Change>
21/11/2021    Anuj Sahu             Initial Draft
------------------------------------------------------------*/
@isTest
public with sharing class QuestionnaireDomainTest {
    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: A apex method to test 'QuestionnaireDomain.getQuestionnaireWrapper' by specifying Salespath and Accordian Section names.
    Inputs:  none
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    21-11-2021   Anuj Sahu     Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void getQuestionnaireDomainTest() {

       // List<Questionnaire__c> lstQuestions = TestDataFactory.getQuestionnaire();
        List<Questionnaire__c> lstQuestions = TestDataFactory.getQuestionnaire(1);
        List<Questionnaire__c> lstAllQuestions = new List<Questionnaire__c>();
        Test.startTest();
            insert lstQuestions;
        	lstAllQuestions = TestDataFactory.getQuestionnaire(10);
        	lstAllQuestions[0].ParentQuestion__c = lstQuestions[0].Id;
       		insert lstAllQuestions;
            String quesListJSON = JSON.serialize(lstQuestions);
            String questionnaireJSON = QuestionnaireDomain.getQuestionnaireWrapper('Set-up','Regulation');
        Test.stopTest();
        for(Questionnaire__c ObjQues : lstQuestions) {
            System.assert(ObjQues.DataType__c != null,'Data type cannot be null');
        }
        System.assertNotEquals(quesListJSON,questionnaireJSON,'Questionnaire records should be available.');
    }
}
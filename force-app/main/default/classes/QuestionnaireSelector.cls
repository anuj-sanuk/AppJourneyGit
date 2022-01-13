/*------------------------------------------------------------
Author: Anuj Sahu
Company: Coforge
Description: A selector class to get questions and answers after quering it from Questionnaire__c object.
Inputs: Tab Name (String) ; Section Name (String) 
Test Class: QuestionnaireSelectorText
History
<Date>      <Authors Name>  <Brief Description of Change>
16-11-2021   Anuj Sahu       Initial Draft
------------------------------------------------------------*/
public with sharing class QuestionnaireSelector {
    
    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: A apex method return questions and answers after quering it from Questionnaire__c object.
    Inputs: Inputs: Salespath Name (String) ; Section Name (String)
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    16-11-2021   Anuj Sahu       Initial Draft
    ------------------------------------------------------------*/
    public static List<Questionnaire__c> getQuestionsAndAnswers(String strSalesPathName, String strSectionName) {

        return Security.stripInaccessible(AccessType.READABLE,[ SELECT Id,
                                                                       DataType__c,
                                                                       Index__c,
                                                                       Options__c,
                                                                       ParentAnswer__c,
                                                                       ParentQuestion__c,
                                                                       HelpText__c,
                                                                       Question__c,
                                                                       SalesPath__c,
                                                                       IsActive__c,
                                                                       SectionName__c,
                                                                       Type__c,
                                                                       IsOptionAvailable__c,
                                                                       ErrorType__c,
                                                                       NegativeAnswer__c,
                                                                       ErrorMessage__c,
                                                                       IsDynamic__c,
                                                                       SubSectionName__c,
                                                                       IsLine__c,
                                                                       FieldAPIName__c,
                                                                       IsDyanmicLogicNeeded__c,
                                                                       Default_Text__c,
                                                                       Subsection_Help_Text__c
                                                                FROM Questionnaire__c 
                                                                WHERE SalesPath__c =: strSalesPathName 
                                                                AND SectionName__c =: strSectionName
                                                                AND IsActive__c = TRUE
                                                                ORDER BY Index__c ASC
                                                              ]).getRecords();
    }
    
    public static list<Questionnaire__c> getQuestionnaires(String strQuestionsQuery){
      system.debug('strDynamicQuery selector:::'+strQuestionsQuery);
      List<Questionnaire__c> lstQuestionRecords = Database.query(strQuestionsQuery);
      system.debug('lstQuestionRecords:::'+lstQuestionRecords);
      return Security.stripInaccessible(AccessType.READABLE,lstQuestionRecords).getRecords();
    }
}
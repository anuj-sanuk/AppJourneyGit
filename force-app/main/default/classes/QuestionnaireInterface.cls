// An interface that defines what a purchase order looks like in general
public interface QuestionnaireInterface {
    // All other functionality excluded
    String getQuestionnaireWrapper(String strSalespathName, String strSectionName);
    String getQuestionnaireJSON(String strSalespathName, String strSectionName);
    List<Questionnaire__c> getQuestionsAndAnswers(String strSalespathName, String strSectionName);
}
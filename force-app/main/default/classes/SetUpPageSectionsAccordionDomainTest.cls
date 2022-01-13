/*------------------------------------------------------------
Author: Sathvik VOola
Company: Coforge
Description: A test class for the class 'SetUpPageSectionsAccordionDomain'
Inputs: None
History
<Date>       <Authors Name>        <Brief Description of Change>
08/12/2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
@isTest
public class SetUpPageSectionsAccordionDomainTest {
    /*------------------------------------------------------------
Author: Sathvik VOola
Company: Coforge
Description: A test method for the class 'SetUpPageSectionsAccordionDomain.getSetupPageSectionsWrapper'
Inputs: None
History
<Date>       <Authors Name>        <Brief Description of Change>
08/12/2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
    @isTest
    public static void getSetupPageSectionsWrapperTest(){
        List<Questionnaire__c> lstQuestions = TestDataFactory.getQuestionnaire(1);
        List<Questionnaire__c> lstAllQuestions = new List<Questionnaire__c>();
        Test.startTest();
        insert lstQuestions;
        lstAllQuestions = TestDataFactory.getQuestionnaire(6);
        lstAllQuestions[0].ParentQuestion__c = lstQuestions[0].Id;
        insert lstAllQuestions;
        String strWrappedSections=SetUpPageSectionsAccordionDomain.getSetupPageSectionsWrapper(lstAllQuestions[0].SalesPath__c);
        Test.stopTest();
        System.assert(strWrappedSections.length() > 0);
        
    }
    
}
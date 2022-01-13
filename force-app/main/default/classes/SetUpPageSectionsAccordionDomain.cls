/*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: This is class where the sections data is wrapped to customize the behaviour of sections
Inputs:String strSalesPath
Test Class: SetUpPageSectionsAccordionDomainTest
History
<Date>      <Authors Name>  <Brief Description of Change>
06-12-2021   Sathvik     	Initial Draft
------------------------------------------------------------*/
public with sharing class  SetUpPageSectionsAccordionDomain {
    /*------------------------------------------------------------
Author: Sathvik Voola
Company: Coforge
Description: This method procceses the query results for section names and wraps other required content for section behaviour
Inputs:String strSalesPath
History
<Date>      <Authors Name>  <Brief Description of Change>
06-12-2021   Sathvik     Initial Draft
------------------------------------------------------------*/
    public static String getSetupPageSectionsWrapper(String strSalesPath){
        
        String strSectionJSON;
        List<SectionWrapper> lstSectionWrapper = new List<SectionWrapper>();
        List<Questionnaire__c>  lstApplicationJourney = QuestionnaireSelector.getSections(strSalesPath);
        List<String> lstSections=new List<String>();
        for(Questionnaire__c objQuestionnaire : lstApplicationJourney){
            if(!lstSections.contains(objQuestionnaire.SectionName__c))
                lstSections.add(objQuestionnaire.SectionName__c);
        }
        Integer numSeq=0;
        for(String strSec : lstSections){
            numSeq++;
            SectionWrapper objSectionWrapper = new SectionWrapper();
            objSectionWrapper.isActive=true;
            objSectionWrapper.strSalesPath='Set-up';
            objSectionWrapper.numSequence=numSeq;
            objSectionWrapper.isComplete=false;
            objSectionWrapper.strSection=strSec;
            lstSectionWrapper.add(objSectionWrapper);
        }
        strSectionJSON=JSON.serialize(lstSectionWrapper);
        return strSectionJSON;
        
    }
    public class SectionWrapper{
        @AuraEnabled
        public Boolean isActive;
        @AuraEnabled
        public String strSalesPath;
        @AuraEnabled
        Public Decimal numSequence; 
        @AuraEnabled
        public Boolean isComplete;
        @AuraEnabled
        public String strSection;
    }
    
}
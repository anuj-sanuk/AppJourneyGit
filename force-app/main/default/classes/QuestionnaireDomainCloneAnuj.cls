/*------------------------------------------------------------
Author: Darshan S Almiya
Company: Coforge
Description: A selector class to get questions and answers after quering it from Question_Answer__c object.
Inputs: Tab Name (String) ; Section Name (String) 
Test Class: QuestionnaireDomainTest
History
<Date>      <Authors Name>  <Brief Description of Change>
16-11-2021   Darshan S Almiya      Initial Draft
---------------------------------------------- */
public with sharing class QuestionnaireDomainCloneAnuj {
    
    public Static String getQuestionnaireWrapper(String strQuestionsQuery){
    
        String strQuestionnaireJSON;
        String strSalespathName = 'Set-up';
        String strSectionName = 'Regulation';

        //List<Questionnaire__c> lstQuestionnaire = QuestionnaireSelector.getQuestionsAndAnswers(strSalespathName,strSectionName);
        String strQuery = generateQuery(strQuestionsQuery);
        System.debug('strQuery::'+strQuery);
        List<Questionnaire__c> lstQuestionnaire = QuestionnaireSelector.getQuestionnaires(strQuery);
    
        if(!lstQuestionnaire.isEmpty()){
            Integer i= 0;
            List<QuestionnaireWrappper> lstQuestionnaireWrapper = new List<QuestionnaireWrappper>();
            Map<String, List<String>> mapStringRecordId = new Map<String, List<String>>(); //Map of String, List of String to store the ParentId and Record Id for Dynamic fields
            //To storing the record on to the mapStringRecordId Map
            for(Questionnaire__c questionnaire : lstQuestionnaire){
                if(questionnaire.ParentQuestion__c != null){
                    if(!mapStringRecordId.containsKey(questionnaire.ParentQuestion__c)){
                        mapStringRecordId.put(questionnaire.ParentQuestion__c, new List<String>());
                    }
                    mapStringRecordId.get(questionnaire.ParentQuestion__c).add(questionnaire.Id);
                }
            }

            //For storing the value on Wrapper class
            for(Questionnaire__c questionnaire : lstQuestionnaire){
                i++;
                QuestionnaireWrappper objQuestionnaireWrapper = new QuestionnaireWrappper();
                objQuestionnaireWrapper.strQuestion = questionnaire.Question__c;
                objQuestionnaireWrapper.strRecordId = questionnaire.Id;                
                objQuestionnaireWrapper.strDataType = questionnaire.DataType__c;
                objQuestionnaireWrapper.numIndex = questionnaire.Index__c;
                objQuestionnaireWrapper.strParentAnswer = questionnaire.ParentAnswer__c;
                objQuestionnaireWrapper.strParentQuestion = questionnaire.ParentQuestion__c;
                objQuestionnaireWrapper.strFieldAPIName = questionnaire.FieldAPIName__c;
                objQuestionnaireWrapper.strSalesPath = questionnaire.SalesPath__c;
                objQuestionnaireWrapper.strSectionName = questionnaire.SectionName__c;
                objQuestionnaireWrapper.strSubSectionName = questionnaire.SubSectionName__c;
                objQuestionnaireWrapper.strSubSectionHelpText = questionnaire.Subsection_Help_Text__c;
                objQuestionnaireWrapper.IsLine = questionnaire.IsLine__c;
                objQuestionnaireWrapper.strDefaultText=questionnaire.Default_Text__c;
                objQuestionnaireWrapper.strType = questionnaire.Type__c;
                objQuestionnaireWrapper.isOption = questionnaire.IsOptionAvailable__c;
                objQuestionnaireWrapper.isDynamic = questionnaire.IsDynamic__c;
                objQuestionnaireWrapper.strHelpText = questionnaire.HelpText__c;
                //here .split(Constants.SEMI_COLON);
                //objQuestionnaireWrapper.strNegativeAnswer = questionnaire.NegativeAnswer__c;
                 if(questionnaire.SubSectionName__c != null){
                     objQuestionnaireWrapper.isSubSectionNameShow=true;
                   }
                if(questionnaire.NegativeAnswer__c != null){
                    objQuestionnaireWrapper.strNegativeAnswer = questionnaire.NegativeAnswer__c.split(Constants.SEMI_COLON);
                }
                
                objQuestionnaireWrapper.strErrorMessage = questionnaire.ErrorMessage__c;
                objQuestionnaireWrapper.isDyanmicLogicNeeded = questionnaire.IsDyanmicLogicNeeded__c;
                if(questionnaire.IsDyanmicLogicNeeded__c == true){
                    objQuestionnaireWrapper.isAdditionalDynCmp=false;
                }
                objQuestionnaireWrapper.strErrorClass = 'ErrorClass-'+questionnaire.Index__c;
                if(!String.isBlank(questionnaire.ErrorMessage__c)){
                    objQuestionnaireWrapper.strErrorMessage = questionnaire.ErrorMessage__c;
                }

                if(questionnaire.IsDynamic__c == true){
                    objQuestionnaireWrapper.isFlag = true;
                }
                if(questionnaire.HelpText__c != null){
                    objQuestionnaireWrapper.isHelp = true;
                }
                if(questionnaire.DataType__c == Constants.TYPE_PICKLIST){ //Constants.TYPE_PICKLIST
                    objQuestionnaireWrapper.isComboBox = true;
                    objQuestionnaireWrapper.strFieldName = Constants.TYPE_PICKLIST +'-'+String.valueOf(i);
                }
                else if(questionnaire.DataType__c == Constants.TYPE_TEXT){
                    objQuestionnaireWrapper.isText = true;
                    objQuestionnaireWrapper.strFieldName = Constants.TYPE_TEXT +'-'+String.valueOf(i);
                }
                else if(questionnaire.DataType__c == Constants.TYPE_TEXTAREA){
                    objQuestionnaireWrapper.isTextArea = true;
                    objQuestionnaireWrapper.strFieldName = Constants.TYPE_TEXTAREA +'-'+String.valueOf(i);
                }
                else if(questionnaire.DataType__c == Constants.TYPE_SELECT){
                    objQuestionnaireWrapper.isPickList = true;
                    objQuestionnaireWrapper.strFieldName = Constants.TYPE_SELECT +'-'+String.valueOf(i);
                }                
                else if(questionnaire.DataType__c == Constants.TYPE_CURRENCY){
                    objQuestionnaireWrapper.isCurrency = true;
                    objQuestionnaireWrapper.strFieldName = Constants.TYPE_CURRENCY +'-'+String.valueOf(i);
                }
                else if(questionnaire.DataType__c == Constants.TYPE_BOOLEAN){
                    objQuestionnaireWrapper.isRadio = true;
                    objQuestionnaireWrapper.strFieldName = Constants.TYPE_BOOLEAN +'-'+String.valueOf(i);
                }
                else if(questionnaire.DataType__c == Constants.TYPE_DATE){
                    objQuestionnaireWrapper.isDate = true;
                    objQuestionnaireWrapper.strFieldName = Constants.TYPE_DATE +'-'+String.valueOf(i);
                }
                else if(questionnaire.DataType__c == Constants.TYPE_INTEGER){
                    objQuestionnaireWrapper.isNumber = true;
                    objQuestionnaireWrapper.strFieldName = Constants.TYPE_INTEGER +'-'+String.valueOf(i);
                }
                if( questionnaire.Options__c != null && questionnaire.Options__c.contains(Constants.SEMI_COLON)){ 
                        List<String> lstOption = questionnaire.Options__c.split(Constants.SEMI_COLON);
                        for(String option : lstOption){
                            OptionWrapper objOptionWrapper = new OptionWrapper();
                            objOptionWrapper.label = option;
                            objOptionWrapper.value = option;
                            objQuestionnaireWrapper.lstOptions.add(objOptionWrapper);
                        }
                }

                if(!mapStringRecordId.isEmpty()){
                    if(mapStringRecordId.containsKey(questionnaire.Id)){
                        objQuestionnaireWrapper.lstReleatedRecordId.addAll(mapStringRecordId.get(questionnaire.Id));
                    }
                }
                lstQuestionnaireWrapper.add(objQuestionnaireWrapper);
            }
            
            strQuestionnaireJSON = JSON.serialize(lstQuestionnaireWrapper) ;   
        }
        return strQuestionnaireJSON;
    }

    public class QuestionnaireWrappper{
        @AuraEnabled
        public String strQuestion;
        @AuraEnabled
        public String strErrorMessage;
        @AuraEnabled
        public String strErrorClass;
        @AuraEnabled
        public String strRecordId;
        @AuraEnabled
        public String strDataType;
        @AuraEnabled
        public Decimal numIndex;
        @AuraEnabled
        public List<OptionWrapper> lstOptions;
        @AuraEnabled
        public String strParentAnswer;
        //@AuraEnabled
        //public String strNegativeAnswer;
        //Change here
        @AuraEnabled
        public List<String> strNegativeAnswer;
        @AuraEnabled
        public String strParentQuestion;
        @AuraEnabled
        public String strFieldAPIName;
        @AuraEnabled
        public String strSalesPath;
        @AuraEnabled
        public String strSectionName;
        @AuraEnabled
        public String strType;
        @AuraEnabled
        public String strHelpText;
        @AuraEnabled
        public Boolean isOption;
        @AuraEnabled
        public Boolean isComboBox;
        @AuraEnabled
        public Boolean isText;
        @AuraEnabled
        public Boolean isTextArea;
        @AuraEnabled
        public Boolean isPickList;
        @AuraEnabled
        public Boolean isRadio;
        @AuraEnabled
        public Boolean isDate;
        @AuraEnabled
        public Boolean isCurrency;
        @AuraEnabled
        public Boolean isDynamic;
        @AuraEnabled
        public Boolean isHelp;
        @AuraEnabled
        public Boolean isNumber;
        @AuraEnabled
        public Boolean isDynamicFieldShow;
        @AuraEnabled
        public Map<String, List<String>> mapRecordIds;
        @AuraEnabled
        public String strFieldName;
        @AuraEnabled
        public Boolean isDyanmicLogicNeeded;
        @AuraEnabled
        public List<String> lstReleatedRecordId;
        @AuraEnabled
        public Boolean isAddtionalQuestionRequired;
        @AuraEnabled
        public Boolean isFlag;
        @AuraEnabled
        public Boolean isSubSectionNameShow;
        @AuraEnabled
        public Boolean IsLine;
        @AuraEnabled
        public String strSubSectionName;
        @AuraEnabled
        public Boolean isAdditionalDynCmp;
        @AuraEnabled
        public String strDefaultText;
        @AuraEnabled
        public String strSubSectionHelpText;

        public QuestionnaireWrappper(){
            strDefaultText=null;
            strSubSectionHelpText=null;
            strQuestion = null;
            strErrorMessage = null;
            strErrorClass = null;
            strRecordId = null;
            strDataType = null;
            numIndex = 1;
            lstOptions = new List<OptionWrapper>();
            strParentAnswer = null;
            //here
            strNegativeAnswer = new List<String>();
            //strNegativeAnswer =null;
            strParentQuestion = null;
            strFieldAPIName = null;
            strSalesPath = null;
            strSectionName = null;
            strType = null;
            strHelpText = null;
            isOption = false;
            isComboBox = false;
            isText = false;
            isTextArea = false;
            isPickList = false;
            isRadio = false;
            isDate = false;
            isCurrency = false;
            isDynamic = false;
            isDynamicFieldShow = false;
            mapRecordIds = new Map<String, List<String>>();
            strFieldName = null; 
            isHelp = false;
            isDyanmicLogicNeeded = false;
            lstReleatedRecordId = new List<String>();
            isAddtionalQuestionRequired = false;
            isNumber = false;
            isFlag = false;
            isAdditionalDynCmp=true;
            strSubSectionName = null;
            isSubSectionNameShow= false;
            IsLine=null;
        }
    }

    public class OptionWrapper{
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;
    }
    
    public static String generateQuery(String strQuestionsQuery){
        String strOrderBy = ' ORDER BY Index__c ASC';
        String strDynamicQuery  ='Select Id,DataType__c,Index__c,Options__c,ParentAnswer__c,ParentQuestion__c,HelpText__c,Question__c,SalesPath__c,IsActive__c,SectionName__c,Type__c,IsOptionAvailable__c,ErrorType__c,NegativeAnswer__c,ErrorMessage__c,IsDynamic__c,SubSectionName__c,IsLine__c,FieldAPIName__c,IsDyanmicLogicNeeded__c,Default_Text__c,Subsection_Help_Text__c,ApplicationJourney__c from Questionnaire__c WHERE IsActive__c = True ';
        Map<String,object> mapJsonData =(Map<String, object>)JSON.deserializeUntyped(strQuestionsQuery);
        system.debug('mapJsonData::'+mapJsonData);
        
        if(mapJsonData.containsKey('applicationName')){
            String strApplicationName = mapJsonData.containsKey('applicationName')!=null ? String.valueOf(mapJsonData.get('applicationName')):'';
            strDynamicQuery = strDynamicQuery+'AND ApplicationJourney__c=\''+strApplicationName+'\'';
        }
        
        if(mapJsonData.containsKey('salesPath') && mapJsonData.containsKey('sectionName')){
            String salesPath =  mapJsonData.containsKey('salesPath')!=null ? String.valueOf(mapJsonData.get('salesPath')):'';
            String sectionName =  mapJsonData.containsKey('sectionName')!=null ? String.valueOf(mapJsonData.get('sectionName')):'';

            strDynamicQuery = strDynamicQuery+' AND SalesPath__c=\''+salesPath+'\'' +' AND SectionName__c=\''+sectionName+'\'';

        }
        strDynamicQuery = strDynamicQuery + strOrderBy;
        system.debug('Final Query:::: '+strDynamicQuery);
        return strDynamicQuery;
    }
}
public with sharing class QuestionnaireWrapper {
    
    public class QuestionWrappper{
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
        @AuraEnabled
        public String strNegativeAnswer;
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

        public QuestionWrappper(){
            strQuestion = null;
            strErrorMessage = null;
            strErrorClass = null;
            strRecordId = null;
            strDataType = null;
            numIndex = 1;
            lstOptions = new List<OptionWrapper>();
            strParentAnswer = null;
            strNegativeAnswer = null;
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
        }
    }

    public class OptionWrapper{
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;
    }
}

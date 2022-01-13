/*------------------------------------------------------------
Author: Darshan Singh
Company: Coforge
Description: Data factory class
History
<Date>       <Authors Name>        <Brief Description of Change>
08/11/2021   Darshan Singh          Initial Draft
------------------------------------------------------------*/
@isTest
public with sharing class TestDataFactory {

    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: to create account data
    Inputs:  Json String with Fnumber or application Number
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    02-11-2021   Sathvik Voola       Initial Draft
    ------------------------------------------------------------*/
    public Static List<Account> getAccounts(Integer intRecordCount){
        List<Account> lstAccounts = new List<Account>();
        for(Integer i=1; i<=intRecordCount;i++){
            Account objAccount= new Account();         
            objAccount.Name='Test Account '+i;
            
            objAccount.FinServ__SourceSystemId__c='ABCD000'+ i;
            

            
            lstAccounts.add(objAccount);
        }
            return lstAccounts;
    }
  /*------------------------------------------------------------
    Author: Alekya
    Company: Coforge
    Description: to create account data
    Inputs:  Json String with lastName,DateofBirth and postcode
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    02-11-2021   Sathvik Voola       Initial Draft
    ------------------------------------------------------------*/  
    public Static List<Account> getAccountRecords(Integer intRecordCount){
        List<Account> lstAccounts = new List<Account>();
        for(Integer i=0; i<intRecordCount;i++){
            Account objAccount= new Account(); 
            //objAccount.Name='Test Account '+i;
            objAccount.LastName='Test Account ';
            //objAccount.PersonBirthdate = Date.today();
            objAccount.BillingPostalCode = '111111' ;
            
            
            lstAccounts.add(objAccount);
        }
            return lstAccounts;
    }
    public static string createJSON() {
        string JsonStr = '{"lastName":"Test","dateOfBirth":"2021-12-10","postCode":"111111"}';
        return JsonStr;
    }
    

    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: to create residential loan application data
    Inputs:  Json String with Fnumber or application Number
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    02-11-2021   Sathvik Voola       Initial Draft
    ------------------------------------------------------------*/
    public Static List<ResidentialLoanApplication> getResidentialLoanApplications(Integer intRecordCount, String strAccountId){
        List<ResidentialLoanApplication> lstResidentialLoanApplication = new List<ResidentialLoanApplication>();
        for(Integer i=1; i<=intRecordCount;i++){	
            ResidentialLoanApplication objResidentialLoanApplication = new ResidentialLoanApplication();
            objResidentialLoanApplication.Name = 'ABC123466';
            objResidentialLoanApplication.accountId = strAccountId;
            lstResidentialLoanApplication.add(objResidentialLoanApplication);
        }
        return lstResidentialLoanApplication;

    }
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: To retrive all object api names from the org
    Inputs:  None
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    18-11-2021   Sathvik Voola       Initial Draft
    ------------------------------------------------------------*/
    public static List<String> getObjectAPINames(){
        List<String> lstAllObjectApiNames = new List<String>(); 
        for ( Schema.SObjectType objAllObjects : Schema.getGlobalDescribe().values() ){
            Schema.DescribeSObjectResult objDesObject = objAllObjects.getDescribe();
            lstAllObjectApiNames.add(String.valueOf(objDesObject.getName()));
        }
        return lstAllObjectApiNames;
    }
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: To retrive the page context
    Inputs:  None
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    18-11-2021   Sathvik Voola       Initial Draft
    ------------------------------------------------------------*/
    public static VisualEditor.DesignTimePageContext getVisualEditor(){
        VisualEditor.DesignTimePageContext objPageCOntext= new VisualEditor.DesignTimePageContext();
        objPageCOntext.entityName = 'Account';
        return objPageCOntext;
    }
        /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: to create questionnaire data
    Inputs:  Salespath name and Accordian section name
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    02-11-2021   Anuj Sahu            Initial Draft
    ------------------------------------------------------------*/
    public Static List<Questionnaire__c> getQuestionnaire(Integer noOfRecords){
        List<Questionnaire__c> lstQuestionnaire = new List<Questionnaire__c>();
        for(Integer i = 0; i<=noOfRecords; i++){
            Questionnaire__c objQuestionnaire = new Questionnaire__c();
            objQuestionnaire.Question__c = 'Question'+i;
            if(i == 0){
                objQuestionnaire.DataType__c = 'Boolean';
            }
            else if(i == 1){
                objQuestionnaire.DataType__c = 'Picklist';
            }
            else if(i == 2){
                objQuestionnaire.DataType__c = 'Text';
            }
            else if(i == 3){
                objQuestionnaire.DataType__c = 'TextArea';
            }
            else if(i == 4){
                objQuestionnaire.DataType__c = 'Select';
            }
            else if(i == 5){
                objQuestionnaire.DataType__c = 'Currency';
            }
            else if(i == 6){
                objQuestionnaire.DataType__c = 'Integer';
            }
            else if(i == 7){
                objQuestionnaire.DataType__c = 'Date';
            }
            else{
                objQuestionnaire.DataType__c = 'Boolean';
            }
            objQuestionnaire.Options__c = 'Yes;No';
            objQuestionnaire.SalesPath__c = 'Set-up';
            objQuestionnaire.SectionName__c = 'Regulation';
            objQuestionnaire.IsActive__c = true;
            objQuestionnaire.Index__c = 1;
            objQuestionnaire.IsDynamic__c = true;
            objQuestionnaire.ParentAnswer__c = 'Yes';
            objQuestionnaire.ParentQuestion__c = null;
            objQuestionnaire.HelpText__c = 'Help Text';
            objQuestionnaire.Type__c = 'Fixed';
            objQuestionnaire.IsOptionAvailable__c = true;
            objQuestionnaire.ErrorType__c = 'Hard Stop';
            objQuestionnaire.NegativeAnswer__c = 'Yes';
            objQuestionnaire.ErrorMessage__c = 'Erro Message';
            objQuestionnaire.IsDynamic__c =false;
            objQuestionnaire.FieldAPIName__c = 'Field_Name__c';
            lstQuestionnaire.add(objQuestionnaire);
        }
        return lstQuestionnaire;
    }
    
    
   
	/*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: Creating a List of records for Trigger_Framework_Setting__mdt
    Inputs:  list size
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    02-11-2021   Sathvik Voola            Initial Draft
    ------------------------------------------------------------*/
    public static List<Trigger_Framework_Setting__mdt> returnTriggerHandlerMetaSettings(Integer intSettingsSize){
        List<Trigger_Framework_Setting__mdt> lstTriggerSettings=new List<Trigger_Framework_Setting__mdt>();
        for(Integer i=0; i<intSettingsSize;i++){
            Trigger_Framework_Setting__mdt objTriggerSettings=new Trigger_Framework_Setting__mdt();
            objTriggerSettings.Active__c=true;
            objTriggerSettings.After_Delete__c=true;
            objTriggerSettings.After_Insert__c=true;
            objTriggerSettings.After_Undelete__c=true;
            objTriggerSettings.After_Update__c=true;
            objTriggerSettings.Before_Delete__c=true;
            objTriggerSettings.Before_Insert__c=true;
            objTriggerSettings.Before_Update__c=true;
            objTriggerSettings.Object__c='Account';
            objTriggerSettings.MaxTriggerCount__c =1;
            objTriggerSettings.TriggerHandlerName__c = 'AccountTriggerHandler';
            lstTriggerSettings.add(objTriggerSettings);
        }
        return lstTriggerSettings;
    }
    
    /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Description: Creating a List of records for ApplicationJourney__mdt
    Inputs:  list size
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    02-11-2021   Sathvik Voola            Initial Draft
    ------------------------------------------------------------*/
    public static List<ApplicationJourney__mdt> returnApplicationJourneyMetadata(Integer intSize){
        List<ApplicationJourney__mdt> lstApplicationJourney=new List<ApplicationJourney__mdt>();
        for(Integer i=0; i<intSize;i++){
            ApplicationJourney__mdt objApplicationJourneyMetadata=new ApplicationJourney__mdt();
            objApplicationJourneyMetadata.MasterLabel = 'Set-up';
            objApplicationJourneyMetadata.Label = 'Set-up';
            objApplicationJourneyMetadata.Sequence__c = 1;
            
            lstApplicationJourney.add(objApplicationJourneyMetadata);
        }
        return lstApplicationJourney;
    }
}
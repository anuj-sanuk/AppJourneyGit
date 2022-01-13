/*------------------------------------------------------------
    Author: Shirisha Naga
    Company: Coforge
    Description: to create setuppagesection metadata data
    Inputs:  Salespath name and Accordian section name
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    02-11-2021  shirisha naga          Initial Draft
    ------------------------------------------------------------*/
@isTest
public class TestDataFactorySetUpPageAccordian {
    public static  List<SetupPageSections__mdt> queryMetaDataRecord(String strSalesPath){
        
   return  [SELECT Id,MasterLabel,Is_Active__c from SetupPageSections__mdt WHERE Is_Active__c= TRUE AND  Sales_Path__c =:strSalesPath];
      // SetupPageSections__mdt setupPageSection= new SetupPageSections__mdt(); 
      // setupPageSection.Sales_Path__c='setup';
      // setupPageSection.Label='regulation';
      //return setupPageSectionsmdt;
    }
   
}
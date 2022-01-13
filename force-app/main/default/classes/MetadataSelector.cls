/*------------------------------------------------------------
Author: Shirisha Naga
Company: Coforge
Description: apex class to return custom meta data from query
Inputs: SetupPageSections__mdt from MasterLabel
Test Class: MetadataSelectorTest
History
<Date>      <Authors Name>       <Brief Description of Change>
16-11-2021   shirisha                 Initial Draft
24-11-2021  Yogesh Chand Sharma    Added trigger framework metadata method
------------------------------------------------------------*/
public with sharing class MetadataSelector {
    /*------------------------------------------------------------
    Author: shirisha  Naga
    Company: Coforge
    Description:A apex class to return custom meta data from query.
    Inputs: string strSalesPath
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    16-11-2021    shirisha        Initial Draft
    ------------------------------------------------------------*/
    public static  List<ApplicationJourney__mdt> getApplicationJourneyMetadata(String strSalesPath) {
        System.debug('Inside selector method');
        return [SELECT Id,
                        MasterLabel,
                        Is_Active__c,
                        Sequence__c
				   FROM ApplicationJourney__mdt
                   WHERE Is_Active__c= TRUE AND  Sales_Path__c =:strSalesPath order By Sequence__c Asc];
                    }

    /*------------------------------------------------------------
    Author: Yogesh Chand Sharma
    Company: Coforge
    Description: A apex method to return trigger framework metadata record.
    Inputs: string strObjectName
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    24-11-2021   Yogesh Chand Sharma      Initial Draft
    ------------------------------------------------------------*/
    public static  List<Trigger_Framework_Setting__mdt> getTriggerFrameworkRecords(String strObjectName) {         
        return [SELECT Id,
                       MasterLabel,
                       DeveloperName,
                       Active__c,
                       After_Delete__c,
                       After_Insert__c,
                       After_Undelete__c,
                       After_Update__c,
                       Before_Delete__c,
                       Before_Insert__c,
                       Before_Update__c,
                       Object__c,
                       MaxTriggerCount__c,
                       TriggerHandlerName__c
                  FROM Trigger_Framework_Setting__mdt 
                 WHERE Object__c =:strObjectName ];
        
    }

    /*------------------------------------------------------------
    Author: Yogesh Chand Sharma
    Company: Coforge
    Description: A apex method to return trigger framework bypass user metadata record.
    Inputs: string strTriggerFrameworkRecordID
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    01-12-2021   Yogesh Chand Sharma      Initial Draft
    ------------------------------------------------------------*/
    public static  List<TriggerFrameworkBypassUser__mdt> getTriggerFrameworkBypassUserRecords(String strTriggerFrameworkRecordID) {         
        return [SELECT Id,
                       MasterLabel,
                       DeveloperName,
                       IsActive__c,
                       Trigger_Framework_Setting__c
                  FROM TriggerFrameworkBypassUser__mdt
                 WHERE IsActive__c =: TRUE
                   AND Trigger_Framework_Setting__c =:strTriggerFrameworkRecordID 
                   AND MasterLabel =: Userinfo.getUserName()];
        
    }
}
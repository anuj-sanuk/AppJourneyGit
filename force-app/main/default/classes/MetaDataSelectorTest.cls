/*------------------------------------------------------------
Author: Shirisha Naga
Company: Coforge
Description: A test class for the class ' MetaDataSelector'
Inputs: setup
History
<Date>       <Authors Name>        <Brief Description of Change>
18/11/2021   Shirisha      Initial Draft
------------------------------------------------------------*/
@isTest
public class MetadataSelectorTest {
    /*------------------------------------------------------------
    Author: Shirisha Naga
    Company: Coforge
    Description: This is a test class for MetaDataSelector
    Inputs:  
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    18-11-2021  shirisha naga          Initial Draft
    ------------------------------------------------------------*/
    @isTest
    static void getSetUpPageSectionsMetadata(){
        List<ApplicationJourney__mdt> lstApplicationJourney =  TestDataFactory.returnApplicationJourneyMetadata(1);
        Test.startTest();
        MetadataSelector.getApplicationJourneyMetadata('Set-up');
        Test.stopTest();
       System.assertEquals(lstApplicationJourney.size(), 1);
   }
   
   /*------------------------------------------------------------
    Author: Yogesh Sharma
    Company: Coforge
    Description: This is a test class for MetaDataSelector
    Inputs:  
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    18-11-2021   Yogesh Sharma          Initial Draft
    ------------------------------------------------------------*/
   @isTest
   static void getTriggerFrameworkRecordsMethod(){
       	List<Trigger_Framework_Setting__mdt> lstTriggerFrameworkRecords = TestDataFactory.returnTriggerHandlerMetaSettings(1);
        List<TriggerFrameworkBypassUser__mdt> lstBypassTriggerFrameworkRecords = TestDataFactory.returnBypassTriggerMetaSettings(1,lstTriggerFrameworkRecords[0].Id);
        Test.startTest();
        MetadataSelector.getTriggerFrameworkRecords('Account');
        MetadataSelector.getTriggerFrameworkBypassUserRecords(lstTriggerFrameworkRecords[0].ID);
        Test.stopTest();
        System.assertEquals(lstTriggerFrameworkRecords.size(), 1);
   }

}
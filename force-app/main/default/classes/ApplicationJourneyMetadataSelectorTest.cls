/*------------------------------------------------------------
Author: Shirisha Naga
Company: Coforge
Description: A test class for the class ' ApplicationJourneyMetadataSelector'
Inputs: setup
History
<Date>       <Authors Name>        <Brief Description of Change>
18/11/2021   Shirisha      Initial Draft
------------------------------------------------------------*/
@isTest
public class ApplicationJourneyMetadataSelectorTest {
    /*------------------------------------------------------------
    Author: Shirisha Naga
    Company: Coforge
    Description: This is a test class for ApplicationJourneyMetadataSelector
    Inputs:  
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    18-11-2021  shirisha naga          Initial Draft
    ------------------------------------------------------------*/
@isTest
    static void getSetUpPageSectionsMetadata()
    {
        Test.startTest();
        List<ApplicationJourney__mdt> lstApplicationJourney =  MetadataSelector.getApplicationJourneyMetadata('Set-up');
        Test.stopTest();
        System.assertEquals(lstApplicationJourney.size(), 3);
   }

}
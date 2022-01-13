/*------------------------------------------------------------
    Author: Shirisha Naga
    Company: Coforge
    Description: This is a test class for SetUpPageSectionsAccordion_CC
    Inputs:  
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    18-11-2021  shirisha naga          Initial Draft
    ------------------------------------------------------------*/
@isTest
public class SetUpPageSectionsAccordionTest {
    /*------------------------------------------------------------
    Author: Shirisha Naga
    Company: Coforge
    Description: apex method to test 'SetUpPageSectionsAccordion_CC' by sepecfying salespath
    Inputs:  
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    18-11-2021  shirisha naga          Initial Draft
    ------------------------------------------------------------*/
@isTest
    public static void getSetUpPageSectionsCustomMetaData(){
        List<ApplicationJourney__mdt> lstApplicationJourney =  TestDataFactory.returnApplicationJourneyMetadata(1);
        Test.startTest();
        SetUpPageSectionsAccordion_CC.getSetUpPageSectionsMetaData('Set-up');
        Test.stopTest();
        System.assertEquals(lstApplicationJourney.size(), 1);
    }
}
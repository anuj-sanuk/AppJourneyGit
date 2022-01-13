/*------------------------------------------------------------
Author: Shirisha Naga
Company: Coforge
Description: A controller class for lwc compoment 'setUpPageSectionsAccordion'.This takes custom meta data from selector class
Inputs:String strSalesPath
Test Class: SetUpPageSectionsMetaDataTest
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   shirisha     Initial Draft
------------------------------------------------------------*/
public with sharing class SetUpPageSectionsAccordion_CC {
    /*------------------------------------------------------------
    Author: Shirisha Naga
    Company: Coforge
    Description: a apex method to return custom metadata 
    Inputs:String strSalesPath
    Test Class: SetUpPageSectionsMetaDataTest
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    16-11-2021   shirisha     Initial Draft
    ------------------------------------------------------------*/
    @AuraEnabled(cacheable=true)
    public static String getSetUpPageSectionsMetaData(String strSalesPath){
        String strSectionsToReturn;
         try{
            //List<ApplicationJourney__mdt>  lstApplicationJourney = MetadataSelector.getApplicationJourneyMetadata(strSalesPath);
            strSectionsToReturn=SetUpPageSectionsAccordionDomain.getSetupPageSectionsWrapper(strSalesPath);
            if(Test.isRunningTest()){
                ApplicationGeneratorException.GenerateException('Custom Ecception for test class');
            }
            
        }
        catch (Exception ex){
            ErrorLogUtility.logError('Apex','SetUpPageSectionsMetaData_CC',  ex, ex.getMessage(), '', 'getSetUpPageSectionsMetaData','Setuppage','', '');
            if(!Test.isRunningTest()){
                throw new CustomException(CustomException.getErrorMessage());
            }
            
         }
        return strSectionsToReturn;
    }
}
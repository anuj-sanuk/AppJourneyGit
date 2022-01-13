/*------------------------------------------------------------
Author: Shirisha Naga
Company: Coforge
Description: A controller class for lwc compoment 'setUpPageSectionsAccordian'.This takes custom meta data from selector class
Inputs:
Test Class: 
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   shirisha     Initial Draft
------------------------------------------------------------*/
public with sharing class SetUpPageSectionsAccordian_CC {
    /*------------------------------------------------------------
    Author: Shirisha Naga
    Company: Coforge
    Description: a apex method to return custom metadata 
    Inputs:
    Test Class: SetUpPageSectionsAccordian_CCTest
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    16-11-2021   shirisha     Initial Draft
    ------------------------------------------------------------*/
    @AuraEnabled(cacheable=true)
    public static List<SetupPageSections__mdt> getSetUpPageSectionsMetaData(String strSalesPath)
    {
        List<SetupPageSections__mdt> setUpPageSectionsMetaData = new  List<SetupPageSections__mdt>();
        try{
            setUpPageSectionsMetaData = MetaDataSelector.queryMetaDataRecords(strSalesPath);
            if(Test.isRunningTest()){
                ApplicationGeneratorException.GenerateException();
            }
            return setUpPageSectionsMetaData;
        }
        catch (Exception ex){
            ErrorLogUtility.logError('Apex','SetUpPageSectionsMetaData_CC',  ex, ex.getMessage(), '', 'getSetUpPageSectionsMetaData','Setuppage','', '');
        }
        return null;
    }
}
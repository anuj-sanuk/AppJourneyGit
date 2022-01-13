/*------------------------------------------------------------
Author: Shirisha Naga
Company: Coforge
Description: A controller class for lwc compoment 'setUpPageSectionsAccordian'.This takes custom meta data  from selector class
Inputs:
Test Class: 
History
<Date>      <Authors Name>  <Brief Description of Change>
18-11-2021   shirisha     Initial Draft
------------------------------------------------------------*/
public with sharing class SetUpPageSectionsMetaData_CC {
    /*------------------------------------------------------------
    Author: Shirisha Naga
    Company: Coforge
    Description: a apex method to return custom meta data 
    Inputs:
    Test Class: 
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    16-11-2021   shirisha     Initial Draft
    ------------------------------------------------------------*/
    @AuraEnabled(cacheable=true)
    public static List<SetupPageSections__mdt> getSetUpPageSectionsMetaData(String strSalesPath) {
        system.debug('-- str sales path --'+strSalesPath);
    List<SetupPageSections__mdt> setUpPageSectionsMetaData = new  List<SetupPageSections__mdt>();
        try{
            setUpPageSectionsMetaData = MetaDataSelector.queryMetaDataRecords(strSalesPath);
        }
        catch (Exception ex) {
          ErrorLogUtility.logError('Apex','SetUpPageSectionsMetaData_CC',  ex, ex.getMessage(), '', 'getSetUpPageSectionsMetaData','Setuppage','', '');
           
        }
        return setUpPageSectionsMetaData;
    }
}
@isTest
public class SetUpPageSectionsMetaData_CCTest {

  static testMethod void getSetUpPageSectionsCustomMetaData(){
    // List<SetupPageSections__mdt> SetupPageSectionsmetaData =  TestDataFactory.queryMetaDataRecord('Set-up');
         Test.startTest();
         SetUpPageSectionsMetaData_CC.getSetUpPageSectionsMetaData('Set-up');        
         Test.stopTest();
    }
    
}
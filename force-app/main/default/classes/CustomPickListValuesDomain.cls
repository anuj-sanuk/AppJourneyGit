/*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A domain class to that wraps the picklist values with configuration values
Inputs: Object API Name (String) ; Pick List Field API Name (String) 
Test Class: CustomPickListValuesDomainTest
History
<Date>      <Authors Name>  <Brief Description of Change>
08-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
public class CustomPickListValuesDomain {
    /*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A method to that wraps the picklist values with configuration values
Inputs: Object API Name (String) ; Pick List Field API Name (String) 
Test Class: 
History
<Date>      <Authors Name>  <Brief Description of Change>
08-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
    public static String getWrappedPickValues(String strObjectAPIName,String strFieldAPIName){
        List<String> lstPickListValues = CustomPickListValuesSelector.returnPickListValues(strObjectAPIName,strFieldAPIName);
        List<PickListValuesWrapper> lstPickListValuesWrapper =new List<PickListValuesWrapper>();
        for(String strPickVal : lstPickListValues){
            PickListValuesWrapper objPickListValuesWrapper = new PickListValuesWrapper();
            objPickListValuesWrapper.strPickValue=strPickVal;
            objPickListValuesWrapper.strActive='slds-is-incomplete';
            objPickListValuesWrapper.isCheck=false;
            lstPickListValuesWrapper.add(objPickListValuesWrapper);
        }
        return Json.serialize(lstPickListValuesWrapper);
    }
    public class PickListValuesWrapper{
        @AuraEnabled
        public String strPickValue;
        @AuraEnabled
        public String strActive;
        @AuraEnabled
        public Boolean isCheck;
        
    }
}
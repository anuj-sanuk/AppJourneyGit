/*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A selector class to return the values of picklist depending on the inputs provided
Inputs: Object API Name (String) ; Pick List Field API Name (String) 
Test Class: CustomPickListValuesSelectorTest
History
<Date>      <Authors Name>  <Brief Description of Change>
08-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
public class CustomPickListValuesSelector {
    /*------------------------------------------------------------
Author: V S Sathvik
Company: Coforge
Description: A method to return the values of picklist depending on the inputs provided
Inputs: Object API Name (String) ; Pick List Field API Name (String) 
Test Class: 
History
<Date>      <Authors Name>  <Brief Description of Change>
08-11-2021   V S Sathvik      Initial Draft
---------------------------------------------- */
    public static List<String> returnPickListValues(String strObjectAPIName,String strFieldAPIName){
        List<String> lstPickListValues = new List<String>();
        List<Schema.DescribeSobjectResult> lstSchemaSobjectResults = Schema.describeSObjects(new List<String>{strObjectAPIName});
        for(Schema.DescribeSobjectResult objSobjectResult : lstSchemaSobjectResults) {
            for (Schema.PicklistEntry objPicklist : objSobjectResult.fields.getMap().get(strFieldAPIName).getDescribe().getPicklistValues()) {
                if (objPicklist.isActive()) {
                    lstPickListValues.add(objPicklist.getLabel());
                }
            }
        }
		return lstPickListValues;
        
    }

}
/*------------------------------------------------------------
Author: Yogesh Chand Sharma
Company: Coforge
Description: Used to handle call to other classes
Inputs: NA
Test Class: TriggerFrameworkTest
History
<Date>       <Authors Name>        <Brief Description of Change>
22/11/2021   Yogesh Chand Sharma          Initial Draft
------------------------------------------------------------*/
public with sharing class TriggerFrameworkHandler {

/*------------------------------------------------------------
Author: Yogesh Chand Sharma
Company: Coforge
Description: Used to call from trigger
Inputs: NA
History
<Date>       <Authors Name>        <Brief Description of Change>
22/11/2021   Yogesh Chand Sharma          Initial Draft
------------------------------------------------------------*/
    public static void callHandler() {
     
      /* Description: get running object name from trigger context    */
      sObject objRecord;
      
      if(Trigger.New == NULL) {
         objRecord = Trigger.Old[0];
      } else {
         objRecord = Trigger.New[0];
      }
      
       string strObjectName = String.valueOf(objRecord.getSObjectType());
        
        /* Description: get trigger framework metadata record from selector class
           Input: string strObjectName    */

        List<Trigger_Framework_Setting__mdt> lstTriggerFrameworkSetting = MetaDataSelector.getTriggerFrameworkRecords(strObjectName);
		
        /* Description: validate trigger framework metadata record from selector class
           Input: List<Trigger_Framework_Setting__mdt> lstTriggerFrameworkSetting    */

        TriggerFrameworkHelper.validateMetadataSettings(lstTriggerFrameworkSetting);

        /* Description: get trigger framework bypass user metadata record from selector class
           Input: string lstTriggerFrameworkSetting[0].ID    */
        List<TriggerFrameworkBypassUser__mdt> lstTriggerFrameworkBypassUser = MetaDataSelector.getTriggerFrameworkBypassUserRecords(lstTriggerFrameworkSetting[0].ID);
        
        
        /* Description: execute handler logic
           Input: TriggerFrameworkInterface clsHandler, List<Trigger_Framework_Setting__mdt> lstTriggerFrameworkSetting    */

        TriggerFrameworkHelper.executeHandler(lstTriggerFrameworkSetting, lstTriggerFrameworkBypassUser);    
        
    }
}
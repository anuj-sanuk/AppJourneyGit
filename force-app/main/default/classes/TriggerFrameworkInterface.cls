/*------------------------------------------------------------
Author: Yogesh Chand Sharma
Company: Coforge
Description: Interface containing the methods to be used by the trigger handler
Inputs: Trigger events
History
<Date>       <Authors Name>        <Brief Description of Change>
18/11/2021   Yogesh Chand Sharma      Initial Draft
------------------------------------------------------------*/
public interface TriggerFrameworkInterface {

   /* Description : Called by the trigger framework before insert of the records
      Inputs : List<sObject> lstNewRecords     */
    void beforeInsert(List<sObject> lstNewRecords);
    
   /* Description : Called by the trigger framework after insert of the records
      Inputs : List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords     */
    
    void afterInsert(List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords);
    
    /* Description : Called by the trigger framework before update of the records
       Inputs : List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords
                List<sObject> lstOldRecords , Map<Id, sObject> mapOldRecords    */

    void beforeUpdate(Map<Id, sObject> mapNewRecords, Map<Id, sObject> mapOldRecords);
    
    /* Description : Called by the trigger framework after update of the records
       Inputs : List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords
                List<sObject> lstOldRecords , Map<Id, sObject> mapOldRecords    */

    void afterUpdate(Map<Id, sObject> mapNewRecords,  Map<Id, sObject> mapOldRecords);
    
    /* Description : Called by the trigger framework before delete of the records
       Inputs : List<sObject> lstOldRecords , Map<Id, sObject> mapOldRecords    */   

    void beforeDelete(List<sObject> lstOldRecords , Map<Id, sObject> mapOldRecords);
    
    /* Description : Called by the trigger framework after delete of the records
       Inputs : Map<Id, sObject> mapOldRecords    */
       
    void afterDelete(Map<Id, sObject> mapOldRecords);
    
    /* Description : Called by the trigger framework after undelete of the records
       Inputs : List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords    */

    void afterUnDelete(List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords);
    
}
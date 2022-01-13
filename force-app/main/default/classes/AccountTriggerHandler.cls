/*------------------------------------------------------------
Author: Yogesh Chand Sharma
Company: Coforge
Description: Handler class for Account trigger
Inputs: Added all posible trigger events and implements TriggerFrameworkInterface for all possible events
Test Class: AccountTriggerHandlerTest
History
<Date>          <Authors Name>              <Brief Description of Change>
02/12/2021    Yogesh Chand Sharma                Initial Draft
------------------------------------------------------------*/
public with sharing class AccountTriggerHandler implements TriggerFrameworkInterface{
       
   /* Description : Called by the trigger framework before insert of the records
      Inputs : List<sObject> lstNewRecords     */
      public void beforeInsert(List<sObject> lstNewRecords){
         // call to handler's helper class, put your business logic in helper class
      }
    
      /* Description : Called by the trigger framework after insert of the records
         Inputs : List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords     */
       
       public void afterInsert(List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords){
        // call to handler's helper class,  put your business logic in helper class
       }
       
       /* Description : Called by the trigger framework before update of the records
          Inputs : List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords
                   List<sObject> lstOldRecords , Map<Id, sObject> mapOldRecords    */
   
       public void beforeUpdate(Map<Id, sObject> mapNewRecords, Map<Id, sObject> mapOldRecords){
           // call to handler's helper class,  put your business logic in helper class
       }
       
       /* Description : Called by the trigger framework after update of the records
          Inputs : List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords
                   List<sObject> lstOldRecords , Map<Id, sObject> mapOldRecords    */
   
       public void afterUpdate(Map<Id, sObject> mapNewRecords,  Map<Id, sObject> mapOldRecords){
           // call to handler's helper class,  put your business logic in helper class
       }
       
       /* Description : Called by the trigger framework before delete of the records
          Inputs : List<sObject> lstOldRecords , Map<Id, sObject> mapOldRecords    */   
   
       public void beforeDelete(List<sObject> lstOldRecords , Map<Id, sObject> mapOldRecords){
           // call to handler's helper class,  put your business logic in helper class
       }
       
       /* Description : Called by the trigger framework after delete of the records
          Inputs : Map<Id, sObject> mapOldRecords    */
          
       public void afterDelete(Map<Id, sObject> mapOldRecords){
           // call to handler's helper class,  put your business logic in helper class
       }
       
       /* Description : Called by the trigger framework after undelete of the records
          Inputs : List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords    */
   
       public void afterUnDelete(List<sObject> lstNewRecords , Map<Id, sObject> mapNewRecords){
           // call to handler's helper class,  put your business logic in helper class
       }
}
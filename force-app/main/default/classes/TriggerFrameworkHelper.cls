/*------------------------------------------------------------
Author: Yogesh Chand Sharma
Company: Coforge
Description: Class contains trigger framework logic
Inputs: NA
Test Class: TriggerFrameworkTest
History
<Date>       <Authors Name>        <Brief Description of Change>
22/11/2021   Yogesh Chand Sharma      Initial Draft
------------------------------------------------------------*/
public with sharing class TriggerFrameworkHelper {
  
/* static variable to count trigger execution */
    public static Map<String, LoopCount> mapTriggerCount;

/*------------------------------------------------------------
Author: Yogesh Chand Sharma
Company: Coforge
Description: Used to validate metadata setting info
Inputs: Wrapper class attributes
History
<Date>       <Authors Name>        <Brief Description of Change>
22/11/2021   Yogesh Chand Sharma          Initial Draft
------------------------------------------------------------*/
    public static void validateMetadataSettings(List<Trigger_Framework_Setting__mdt> lstTriggerFrameworkSetting) {
       
            if(lstTriggerFrameworkSetting.isEmpty()) {
                ErrorLogUtility.logHandledError('TriggerFrameworkHelper', 'validateMetadataSettings', 'No Custom Setting Found', 'NULL', 'NULL', 'TriggerFramework', 'NUll', 'NULL');
                ApplicationGeneratorException.generateException('No Custom Setting Found');
                return;
            } else if(lstTriggerFrameworkSetting.size() > 1) {
                ErrorLogUtility.logHandledError('TriggerFrameworkHelper', 'validateMetadataSettings', 'Too Many Setting Found', 'NULL', 'NULL', 'TriggerFramework', 'NUll', 'NULL');
                ApplicationGeneratorException.generateException('Too Many Setting Found');
                return;
            }
      
    }

/*------------------------------------------------------------
Author: Yogesh Chand Sharma
Company: Coforge
Description: Used to instantiate trigger object handler
Inputs: Wrapper class attributes
History
<Date>       <Authors Name>        <Brief Description of Change>
22/11/2021   Yogesh Chand Sharma          Initial Draft
------------------------------------------------------------*/
    public static void executeHandler(List<Trigger_Framework_Setting__mdt> lstTriggerFrameworkSetting,
                                      List<TriggerFrameworkBypassUser__mdt> lstTriggerFrameworkBypassUser){

        mapTriggerCount = new Map<String, LoopCount>();
        /* If trigger is in-active then stop further execution */
            if(!lstTriggerFrameworkSetting[0].Active__c ) return ; 
       
        /* If trigger is bypass for running user */
        if(lstTriggerFrameworkBypassUser.size() == 1) return ;

        /* If trigger is executing more than trigger count stop further execution */
          String strHandlerName = lstTriggerFrameworkSetting[0].TriggerHandlerName__c;
          if(lstTriggerFrameworkSetting[0].MaxTriggerCount__c!=null)
            TriggerFrameworkHelper.mapTriggerCount.put(strHandlerName, new LoopCount(integer.valueof(lstTriggerFrameworkSetting[0].MaxTriggerCount__c))); 
          else
          TriggerFrameworkHelper.mapTriggerCount.put(strHandlerName, new LoopCount());

            if(TriggerFrameworkHelper.mapTriggerCount.containsKey(strHandlerName)) {
                Boolean exceeded  = TriggerFrameworkHelper.mapTriggerCount.get(strHandlerName).increment(); 
              if(exceeded) {
                ErrorLogUtility.logHandledError('TriggerFrameworkHelper', 'executeHandler', 'Too Many Loop Count Found', 'NULL', 'NULL', 'TriggerFramework', 'NUll', 'NULL');
                ApplicationGeneratorException.generateException('Too Many Loop Count Found');
                return;
              }
            }
        
        /* Create instance of handler name from metadata setting*/
        
        TriggerFrameworkInterface clsHandler = (TriggerFrameworkInterface)Type.forName(lstTriggerFrameworkSetting[0].TriggerHandlerName__c).newInstance();

        /* If trigger is executing in before context then route to the befor context methods */
       
        if(Trigger.isBefore){
            if(Trigger.isInsert && lstTriggerFrameworkSetting[0].Before_Insert__c){
                clsHandler.beforeInsert(Trigger.New);
            }
            if(Trigger.isUpdate && lstTriggerFrameworkSetting[0].Before_Update__c){
                clsHandler.beforeUpdate(Trigger.NewMap, Trigger.oldMap);
            }
            if(Trigger.isDelete && lstTriggerFrameworkSetting[0].Before_Delete__c){
                clsHandler.beforeDelete(Trigger.old, Trigger.oldMap);
            }
        }
        
       
       /* If trigger is executing in after context then route to the after context methods */
        
        If(Trigger.isAfter){
            if(Trigger.isInsert && lstTriggerFrameworkSetting[0].After_Insert__c){
                clsHandler.afterInsert(Trigger.new, Trigger.newMap);
            }
      
            If(Trigger.isUpdate && lstTriggerFrameworkSetting[0].After_Update__c){
                clsHandler.afterUpdate(Trigger.NewMap, Trigger.oldMap);
            }
            If(Trigger.isDelete && lstTriggerFrameworkSetting[0].After_Delete__c){
                clsHandler.afterDelete(Trigger.oldMap);
            }
            If(Trigger.isUndelete && lstTriggerFrameworkSetting[0].After_Undelete__c){
                clsHandler.afterUndelete(Trigger.new, Trigger.newMap);
            }
        }
    }
    
// inner class for managing the loop count per handler
public class LoopCount {
    private Integer max;
    private Integer count;

    public LoopCount() {
        this.max = 1;
        this.count = 0;
    }

    public LoopCount(Integer max) {
      this.max = max;
      this.count = 0;
    }

    public Boolean increment() {
      this.count++;
      return this.exceeded();
    }

    public Boolean exceeded() {
      return this.max >= 0 && this.count > this.max;
    }

  }
}
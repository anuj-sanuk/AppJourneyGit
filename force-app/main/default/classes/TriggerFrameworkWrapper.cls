/*------------------------------------------------------------
Author: Yogesh Chand Sharma
Company: Coforge
Description: Class contains data related to Trigger Framework Handler
Inputs: NA
History
<Date>       <Authors Name>        <Brief Description of Change>
18/11/2021   Yogesh Chand Sharma      Initial Draft
------------------------------------------------------------*/
public with sharing class TriggerFrameworkWrapper {
    /*------------------------------------------------------------
    Author: Yogesh Chand Sharma
    Company: Coforge
    Description: Class contains data related to Trigger Framework Handler
    Inputs: NA
    History
    <Date>       <Authors Name>        <Brief Description of Change>
    18/11/2021   Yogesh Chand Sharma      Initial Draft
    ------------------------------------------------------------*/
    public class triggerFrameworkData {
        public List<Trigger_Framework_Setting__mdt> lstTriggerFrameworkSetting { get;set; }
        public TriggerFrameworkInterface clasFrameworkInterface { get;set; }
        public String strRunningObject { get;set; }

        public triggerFrameworkData() {
            this.lstTriggerFrameworkSetting = new List<Trigger_Framework_Setting__mdt>();
        }
    }
}
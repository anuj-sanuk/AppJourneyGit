/*
Author: Sathvik Voola
Company: Coforge
Description:This Helper class handles the Events fired from the component and recieved from the helper class

History
Date            Authors Name        Brief Description of Change
18-11-2021      Sathvik Voola       Initial Draft
*/
({
    

    
    getSectionStateHelper : function(component, event, helper) {
        var isComplete=event.getParam('bolSectionsComplete');
        var index=component.get("v.numCurrentIndex");
        console.log('isComplete : '+isComplete);
        if(isComplete == true){
            console.log('Inside True');
            var lstPickValues=component.get("v.objWrappedPathValues");
            lstPickValues[index].strActive='Test';
            lstPickValues[index].isCheck=true;
            component.set("v.objWrappedPathValues",lstPickValues);
        }
        else if(isComplete == false){
            console.log('Inside false');
            var lstPickValues=component.get("v.objWrappedPathValues");
            lstPickValues[index].strActive='slds-is-current slds-is-active';
            lstPickValues[index].isCheck=false;
            component.set("v.objWrappedPathValues",lstPickValues);
        }
    },
    /*
Author: Alekya
Company: Coforge
Description:This getHardStopHelper Method shows lock  on DecisionPrinciple Tab when 
Hardstop message occurs and unlocks when it no hardStops.

History
Date            Authors Name        Brief Description of Change
18-11-2021      Sathvik Voola       Initial Draft
*/
    getHardStopHelper : function(component, event, helper) {
    var lstHard=[];
    var noHardStoplst=[];
    var hardStopList = [];
    var hardStop=event.getParam('lstHardStopMessage');
    if(hardStop){
        lstHard = JSON.parse(JSON.stringify(hardStop['hardStopList']));
        noHardStoplst =  JSON.parse(JSON.stringify(hardStop['noHardStopList']));
        hardStopList = component.get("v.hardStopList");
        noHardStoplst.forEach(function(element) {
            const index = hardStopList.indexOf(element);
            if(index > -1){
                hardStopList.splice(index, 1); 
            }
        })
        component.set("v.hardStopList", hardStopList);
        lstHard.forEach(function(element){
            if(hardStopList.length == 0 || !hardStopList.includes(element)){
                hardStopList.push(element)
            }
        })
        component.set("v.hardStopList", hardStopList);
        if(hardStopList.length > 0){
            var lstPickValues=component.get("v.objWrappedPathValues");
            for(var i=0; i<lstPickValues.length; i++){
                if(lstPickValues[i].strPickValue == 'Decision in Principle'){
                    lstPickValues[i].strActive='HardStop';
                    lstPickValues[i].isHardStop=true;
                    component.set("v.objWrappedPathValues",lstPickValues);
                } 
            }
        }else{
            var lstPickValues=component.get("v.objWrappedPathValues");
            for(var i=0; i<lstPickValues.length; i++){
                if(lstPickValues[i].strPickValue == 'Decision in Principle'){
                    lstPickValues[i].strActive=' HardStopAsh';
                    lstPickValues[i].isHardStop=false;
                    component.set("v.objWrappedPathValues",lstPickValues);
                }
            }
        }
    }

    
    },
    // arrayRemove: function(arr, value) {
    //     return arr.filter(function(ele){return ele != value;})
    // },
   
    doInitHelper : function(component, event, helper) {
        var strObjectName=component.get("v.sObjectName");
        var strFieldAPIName=component.get("v.strCurrentObjPickVal");
        var action = component.get("c.getPicklistValues");
        action.setParams({ strObjectAPIName :strObjectName, strFieldAPIName :  strFieldAPIName });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.objWrappedPathValues",JSON.parse(response.getReturnValue()));
                
            }
            else if (state === "INCOMPLETE") {
                //Adda toaster mesasge her
            }
                else if (state === "ERROR") {
                    //Add toster message here
                }
        });
        
        $A.enqueueAction(action);
    },
    handlePathClick: function(component, event, helper){
        console.log('Hello');
        var index =  event.target.dataset.index;
        console.log('Index outside : '+index);
        if(index !== undefined) {
            console.log('Index Inside : '+index);
            var strSelectedPickListValue = component.get("v.objWrappedPathValues")[index].strPickValue;
            component.set("v.numCurrentIndex",index);
            component.set("v.strSelectedPathVal",strSelectedPickListValue);
            var lstPickValues=component.get("v.objWrappedPathValues");
            for(var i=0; i<lstPickValues.length; i++){
                lstPickValues[i].strActive='slds-is-incomplete';
                if(lstPickValues[i].strPickValue == 'Decision in Principle'){
                    lstPickValues[i].isHardStop=false;
                } 
            }
            lstPickValues[index].strActive='slds-is-current slds-is-active';
            component.set("v.objWrappedPathValues",lstPickValues);
        }
    }
})
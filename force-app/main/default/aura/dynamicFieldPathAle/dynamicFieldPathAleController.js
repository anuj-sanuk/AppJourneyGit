/*
Author: Sathvik Voola
Company: Coforge
Description:This controller class handles the Events fired from the component and passes to the helper class

History
Date            Authors Name        Brief Description of Change
18-11-2021      Sathvik Voola       Initial Draft
07-12-2021		Sathvik Voola		Behaviour of lightning path
*/
({
    
    
    getSectionState : function(component, event, helper) {
        helper.getSectionStateHelper(component, event, helper);
    },
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
    },
    handlePathClick :function(component, event, helper) {
        helper.handlePathClick(component, event, helper);
    }, 
    getHardStop : function(component, event, helper) {
        helper.getHardStopHelper(component, event, helper);
    }, 
})
/*------------------------------------------------------------
Author: Shirisha Naga
Company: Coforge
History
Date            Authors Name        Brief Description of Change
02-11-2021      Shirisha Naga       Initial Draft
------------------------------------------------------------*/
import { LightningElement, track, wire,api } from 'lwc';
import getapplicationJourneyMetaData from '@salesforce/apex/SetUpPageSectionsAccordion_CC.getSetUpPageSectionsMetaData';
const COLUMNS = [
    { label: 'Label', fieldName: 'MasterLabel' },
    { label: 'ChekBox', fieldName: 'Is_Active__c' },
];
export default class SetUpPageAccordionCloneAle extends LightningElement {

    @track MasterLabelRecords;
    @track applicationJourneyRecords;
    @api strPathName;
    @track strSectionName;
    @track error;
    @track columns = COLUMNS;
    @track draftValues = [];
    @track activeSections = [''];
    @track activeSectionsMessage = '';
    @track testBol=false;
    @track questionnaireQueryJSON;
   

    /*------------------------------------------------------------
    Author: shirisha Naga
    Company: Coforge
    Description: This function will get sections through metadata

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     18-11-2021        shirisha naga       Initial Draft
    ------------------------------------------------------------*/
    
    @wire(getapplicationJourneyMetaData, { strSalesPath: '$strPathName' })
    applicationJourneyRecords({ data, error }) {
        if (data) {
            this.MasterLabelRecords = JSON.parse(data);
            console.log('Section records : ',this.MasterLabelRecords);
            this.error = undefined;
        }
    }
    
    getSelectedAccordion(event){
        this.strSectionName = event.target.label;
        this.questionnaireQueryJSON = JSON.stringify({ 'salesPath': this.strPathName,'sectionName':this.strSectionName });
    }

    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: This function will handle the event from child cmp. 
     Checkbox logic for section is handled in this function.

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     03-12-2021        Sathvik Voola       Initial Draft
    ------------------------------------------------------------*/
    handleUpdateSectionStatus(event){
        var strSectionName=event.detail.sectionName;
        var toRender=event.detail.render;
        for(var i =0; i<this.MasterLabelRecords.length; i++){
            if(this.MasterLabelRecords[i].strSection == strSectionName){
                this.MasterLabelRecords[i].isComplete=toRender;
            }
        }
        this.sectionCompleteValidator();
    }
    

    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: This function will validate if all the sections are completed and
    push an event to the parent Aura cmp.

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     06-12-2021        Sathvik Voola       Initial Draft
    ------------------------------------------------------------*/
    sectionCompleteValidator(){
        var bolSectionsComplete=false;
        var numSectionSize=this.MasterLabelRecords.length;
        var numInitialiser=0;
        for(var i =0; i<numSectionSize; i++){
            if(this.MasterLabelRecords[i].isComplete == true){
                numInitialiser=numInitialiser+1;
            } 
        }
        if(numSectionSize == numInitialiser){
            bolSectionsComplete=true;
        }
        
        const evtSectionValueChange = new CustomEvent("sectionvaluechange", {
            detail: { bolSectionsComplete }
          });
          this.dispatchEvent(evtSectionValueChange);

    }
}
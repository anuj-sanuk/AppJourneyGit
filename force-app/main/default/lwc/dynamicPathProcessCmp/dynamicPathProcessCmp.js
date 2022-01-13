/*------------------------------------------------------------
Author: Darshan S Almiya
Company: Coforge
Discripation : Convert the Aura to LWC
History
Date            Authors Name           Brief Description of Change
30-12-2021      Darshan S Almiya       Initial Draft
------------------------------------------------------------*/

import { LightningElement, track, wire, api } from 'lwc';
import salesPathData from '@salesforce/apex/CustomPickListValues_CC.getPicklistValues';

export default class DynamicPathProcessCmp extends LightningElement {
    @track objWrappedPathValues;
    numCurrentIndex;
    hardStopList = [];
    strSelectedPathVal;
    sldsPath = 'slds-path__item';
    @api objectApiName;
    @api strCurrentObjPickVal;


    getSectionState(event) {
        let isComplete = event.detail.bolSectionsComplete;
        if (isComplete) {
            this.objWrappedPathValues[this.numCurrentIndex].strActive = this.sldsPath + ' ' + 'Test';
            this.objWrappedPathValues[this.numCurrentIndex].isCheck = true;
        }
        else if (!isComplete) {
            this.objWrappedPathValues[this.numCurrentIndex].strActive = this.sldsPath + ' ' + 'slds-is-current slds-is-active';
            this.objWrappedPathValues[this.numCurrentIndex].isCheck = false;
        }

    }

    @wire(salesPathData, { strObjectAPIName: '$objectApiName', strFieldAPIName: '$strCurrentObjPickVal' })
    getPathData({ data, error }) {
        if (data) {
            this.objWrappedPathValues = JSON.parse(data);
            Object.keys(this.objWrappedPathValues).forEach(key => {
                this.objWrappedPathValues[key].strActive = this.sldsPath + ' ' + this.objWrappedPathValues[key].strActive;
            });
        }
        else {
            console.log('Error' + JSON.stringify(error));
        }
    }

    connectedCallback(event) {

    }

    handlePathClick(event) {
        var index = event.target.dataset.index;
        if (index) {
            this.strSelectedPathVal = this.objWrappedPathValues[index].strPickValue;
            this.numCurrentIndex = index;
            for (var i = 0; i < this.objWrappedPathValues.length; i++) {
                this.objWrappedPathValues[i].strActive = this.sldsPath + ' ' + 'slds-is-incomplete';
                this.objWrappedPathValues[i].isCheck = false;
                if (i == this.objWrappedPathValues.length - 1) {
                    this.objWrappedPathValues[i].isHardStop = false;
                }
            }
            this.objWrappedPathValues[index].strActive = this.sldsPath + ' ' + 'slds-is-current slds-is-active';
        }
    }


    getHardStop(event) {
        let lstHard = [];
        let noHardStoplst = [];
        let hardStopList = [];
        let hardStop = event.detail.lstHardStopMessage;
        if (hardStop) {
            lstHard = JSON.parse(JSON.stringify(hardStop['hardStopList']));
            noHardStoplst = JSON.parse(JSON.stringify(hardStop['noHardStopList']));
            hardStopList = this.hardStopList;
            if (hardStopList) {
                noHardStoplst.forEach(function (element) {
                    const index = hardStopList.indexOf(element);
                    if (index > -1) {
                        hardStopList.splice(index, 1);
                    }
                })

                this.hardStopList = hardStopList;
                lstHard.forEach(function (element) {
                    if (hardStopList.length == 0 || !hardStopList.includes(element)) {
                        hardStopList.push(element);
                    }
                })
            }
            this.hardStopList = hardStopList;

            // Lock and unlock the last path
            var lastIndexValues = this.objWrappedPathValues.length - 1;
            if (this.hardStopList.length > 0 && this.objWrappedPathValues[lastIndexValues].strPickValue != this.strSelectedPathVal) {
                this.objWrappedPathValues[lastIndexValues].strActive = this.sldsPath + ' ' + 'slds-is-lost';//'HardStop';
                this.objWrappedPathValues[lastIndexValues].isHardStop = true;
            }
            else{
                this.objWrappedPathValues[lastIndexValues].strActive = this.sldsPath + ' ' + 'slds-is-incomplete';
                this.objWrappedPathValues[lastIndexValues].isHardStop = false;
            }
        }
    }
}
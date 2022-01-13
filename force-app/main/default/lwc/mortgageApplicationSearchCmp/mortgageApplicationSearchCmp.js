/*------------------------------------------------------------
Author: Shirisha Naga
Company: Coforge
History
Date            Authors Name        Brief Description of Change
02-11-2021      Shirisha Naga       Initial Draft
------------------------------------------------------------*/

import { LightningElement, track } from 'lwc';
import getRecordIdForNavigation from '@salesforce/apex/MortgageApplicationSearch_CC.getRecordIdToNavigate';
import InValidApplicationNumber from '@salesforce/label/c.In_Valid_ApplicationNumber';
import { NavigationMixin } from 'lightning/navigation';
import InvalidFNumber from '@salesforce/label/c.InvalidFNumber';
import fNumberFormat from '@salesforce/label/c.FNumber_Format';
import fNumberMaxLength from '@salesforce/label/c.FNumber_MaxLength';
import mortgageApplicationNumberFormat from '@salesforce/label/c.Mortgage_Application_Number_Format';
import applicationNumLength from '@salesforce/label/c.ApplicationNumLength';
import fNumbervalidtyOne from '@salesforce/label/c.Fnumber_validity';
import applicationValidityOne from '@salesforce/label/c.Application_Number_Format';
import financialAccount from '@salesforce/label/c.Financial_Account';
import residentialLoanApp from '@salesforce/label/c.Residential_Loan_Application';
export default class MortgageApplicationSearchCmp extends NavigationMixin(LightningElement) {
    @track buttonDisabled = true;
    @track fNumber;
    @track applicationNumber;
    @track fNumberfieldDisabled = false;
    @track appNumberfieldDisabled = false;
    @track results;
    idResult;
    idError;
    maxLength;
    // Creating Object for Custom label
    label = {
        fNumberFormat,
        fNumberMaxLength,
        applicationNumLength,
        mortgageApplicationNumberFormat,
        InValidApplicationNumber,
        InvalidFNumber,
        fNumbervalidtyOne,
        applicationValidityOne,
        financialAccount,
        residentialLoanApp,
    };

    /*------------------------------------------------------------
    Author: Alekya Avadutha
    Company: Coforge
    Description: This function will disbale the Fnumber input field when entered mortgage application Number as input 

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     02-11-2021       Alekya Avadutha     Initial Draft
    ------------------------------------------------------------*/
    handleApplicationNumberDisabled(event) {
        this.applicationNumber = event.target.value;

        if (this.applicationNumber.length > 0) {
            this.fNumberfieldDisabled = true;
            this.buttonDisabled = false;
        }
        else {
            this.fNumberfieldDisabled = false;
            this.buttonDisabled = true;
        }
        var MortgageApplicationNumber = this.template.querySelector(".applicationNumber");
        MortgageApplicationNumber.setCustomValidity("");
        MortgageApplicationNumber.reportValidity();
    }

    /*------------------------------------------------------------
    Author: Alekya Avadutha
    Company: Coforge
    Description: this function will disbale the mortgage application number input field when entered  F number 

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     02-11-2021       Alekya Avadutha     Initial Draft
    ------------------------------------------------------------*/
    handleFNumberDisabled(event) {
        this.fNumber = event.target.value;

        if (this.fNumber.length > 0) {
            this.appNumberfieldDisabled = true;
            this.buttonDisabled = false;
        }
        else {
            this.appNumberfieldDisabled = false;
            this.buttonDisabled = true;
        }
        // To clear The error message 
        var fNumber = this.template.querySelector(".fNumber");
        fNumber.setCustomValidity("");
        fNumber.reportValidity();
    }

    /*------------------------------------------------------------
    Author: Alekya Avadutha
    Company: Coforge
    Description: when user clicks on clear button this method will called and will reset the values of input fields.

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     02-11-2021       Alekya Avadutha     Initial Draft
    ------------------------------------------------------------*/
    
    handleReset() {
        this.template.querySelector('form').reset();
        var inp = this.template.querySelectorAll("lightning-input");
        inp.forEach(function (element) {
            if (element.value !== '') {
                this.buttonDisabled = true;
                this.appNumberfieldDisabled = false;
                this.fNumberfieldDisabled = false;

                // To clear The error message when user clicks on the clear button
                var MortgageApplicationNumber = this.template.querySelector(".applicationNumber");
                MortgageApplicationNumber.setCustomValidity("");
                MortgageApplicationNumber.reportValidity();

                var fNumber = this.template.querySelector(".fNumber");
                fNumber.setCustomValidity("");
                fNumber.reportValidity();
            }
        }, this);
    }

    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: when user clicks on search button it will validate both fnumber and application number it will call controller

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     02-11-2021       Sathvik Voola     Initial Draft
    ------------------------------------------------------------*/

    handleSearch() {
        var objectApiToNavigate = '';
        var applicationError = false;
        var fNumberError = false;
        let searchString = '';
        //Get fNumber Input field
        var fNumber = this.template.querySelector(".fNumber");
        //Get fNumber value
        var fNumberValue = fNumber.value;
        //Get application number
        var applicationNumber = this.template.querySelector(".applicationNumber");
        //Get application Number value
        var applicationNumberValue = applicationNumber.value;
        var isValid = false;
        if (fNumberValue !== 'undefined' && fNumberValue !== null && fNumberValue !== '') {
            var regex = new RegExp(this.label.fNumbervalidtyOne);
            isValid = regex.test(fNumberValue);
            // Fnumber validation to check fnumber format 
            if (!isValid) {
                //to show the errror by Custom Label
                fNumber.setCustomValidity(this.label.fNumberFormat);
                fNumber.reportValidity();
            }
            //when the fnumber format is correct it goes to else part and it will check if fnumber found or not found in db
            else if (isValid) {
                searchString = { fNumber: fNumberValue };
            }
            fNumberError = true;
            applicationError = false;
            objectApiToNavigate = this.label.financialAccount;
        }

        if (applicationNumberValue !== 'undefined' && applicationNumberValue !== null && applicationNumberValue !== '') {
            var appRegex = new RegExp(this.label.applicationValidityOne);
            var appIsValid = appRegex.test(applicationNumberValue);
            if (!appIsValid) {
                //to show the errror by Custom Label 
                applicationNumber.setCustomValidity(this.label.mortgageApplicationNumberFormat);
                applicationNumber.reportValidity();
            }
            else if (appIsValid) {
                searchString = { applicationNumber: applicationNumberValue };
            }
            applicationError = true;
            fNumberError = false;
            objectApiToNavigate = this.label.residentialLoanApp;
        }

        var jsonSearchString = JSON.stringify(searchString);

        getRecordIdForNavigation({ strJsonFormat: jsonSearchString })
            .then((result) => {
                this.idResult = result;

                if (this.idResult == 'undefined' || this.idResult == null || this.idResult == '') {
                    if (applicationError) {
                        applicationNumber.setCustomValidity(this.label.InValidApplicationNumber);
                        applicationNumber.reportValidity();
                    }
                    if (fNumberError) {
                        fNumber.setCustomValidity(this.label.InvalidFNumber);
                        fNumber.reportValidity();
                    }
                }
                else {
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: this.idResult,
                            objectApiName: objectApiToNavigate,
                            actionName: 'view'
                        }
                    })
                }
            })
            .catch((error) => {
                this.idError = error;
                this.idResult = undefined;
            });

    }
}
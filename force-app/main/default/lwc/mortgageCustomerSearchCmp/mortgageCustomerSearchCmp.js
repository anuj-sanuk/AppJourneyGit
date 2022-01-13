/*------------------------------------------------------------
Author: Alekya Avadutha
Company: Coforge
History
Date            Authors Name        Brief Description of Change
30-11-2021     Alekya Avadutha        Initial Draft
------------------------------------------------------------*/
import { LightningElement,track } from 'lwc';
import pubsub from 'c/pubSubMessageChannel';
import birthDatePostCode from '@salesforce/label/c.Birthdate_Postcode_Validate';
import postCodeFormatRegex from '@salesforce/label/c.CustomerSearchPostCodeRegex';
import postCodeFormatMessage from '@salesforce/label/c.CustomerSearchPostCodeMessage';
import returnAccountRecords from '@salesforce/apex/MortgageCustomerSearch_CC.returnAccountRecords';


export default class MortgageCustomerSearch extends LightningElement{
    @track lastNameValue;
    @track lastNameLabel;
    @track postCodeValue;
    @track  dateOfBirth;
    buttonDisabled = true;
    @track results;
    @track error;

    // Creating Object for Custom label
    label = {   
        birthDatePostCode,
        postCodeFormatRegex,
        postCodeFormatMessage,
    }
    @track strPostCodeValue;
    @track strPostCodeLabel;
    @track strDOBValue;
    

/*------------------------------------------------------------
    Author: Alekya Avadutha
    Company: Coforge
    Description:  This is the event to record values of lastname

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     30-11-2021       Alekya Avadutha     Initial Draft
    ------------------------------------------------------------*/
    lastNameValue(event) {
        this.lastName = event.target.value;
        let lastNameField = this.template.querySelector(".lastName");
        lastNameField.setCustomValidity("");
        lastNameField.reportValidity();
        if (this.lastName!== null && this.lastName!=="") {
            this.buttonDisabled = false;
        }
        else {
            this.buttonDisabled = true;
        }
    }
    
    /*------------------------------------------------------------
    Author: Alekya Avadutha
    Company: Coforge
    Description:  This is the event to record values of dateofbirth and postcode

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     30-11-2021       Alekya Avadutha     Initial Draft
    ------------------------------------------------------------*/
    resetValidations() {
        this.dateOfBirth = this.template.querySelector('.dateOfBirth').value;
        this.postCode = this.template.querySelector('.postCode').value;
        let postCodeLabel = this.template.querySelector('.postCode');
        let dateOfBirthLabel = this.template.querySelector('.dateOfBirth');
        postCodeLabel.setCustomValidity("");
        postCodeLabel.reportValidity();
        dateOfBirthLabel.setCustomValidity("");
        dateOfBirthLabel.reportValidity();
    }

    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: This is the event to record values of postcode

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     02-12-2021        Anuj Sahu           Initial Draft
    ------------------------------------------------------------*/
    handlePostCodeChange(event){
        this.strPostCodeValue = event.target.value;
        this.resetValidations();
    }

    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: This is the event to record values of postcode

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     02-12-2021        Anuj Sahu           Initial Draft
    ------------------------------------------------------------*/
    handleDOBChange(event){
        this.strDOBValue = event.target.value;
        this.resetValidations();
    }


    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: This is the event to record values of lastname

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     02-12-2021        Anuj Sahu           Initial Draft
    ------------------------------------------------------------*/
    handleLastNameChange(event){
        this.lastNameValue = event.target.value;
        //this.lastNameLabel = event.target.value;
        let lastNameField = this.template.querySelector(".lastName");
        if (this.lastNameValue !== null && this.lastNameValue !== "") {
            this.buttonDisabled = false;
        }
        else {
            lastNameField.setCustomValidity("");
            lastNameField.reportValidity();
            this.buttonDisabled = true;
        }
    }

    /*------------------------------------------------------------
    Author: Alekya Avadutha
    Company: Coforge
    Description: when user clicks on clear button this method will called and will reset the values of input fields.

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     30-11-2021       Alekya Avadutha     Initial Draft
    ------------------------------------------------------------*/
    handleReset(){
        let lastNameLabel = this.template.querySelector(".lastName");
        let postCodeLabel = this.template.querySelector(".postCode");
        let dateOfBirthLabel = this.template.querySelector(".dateOfBirth");
        
        if (this.lastNameValue == ''){
            lastNameLabel.setCustomValidity("");
            lastNameLabel.reportValidity();
        }

        this.template.querySelectorAll('lightning-input').forEach(element=>{
            element.value=null;
            this.lastName='';
            this.postCode = '';
            this.dateOfBirth = '';
            this.buttonDisabled = true;
            postCodeLabel.setCustomValidity("");
            postCodeLabel.reportValidity();
            dateOfBirthLabel.setCustomValidity("");
            dateOfBirthLabel.reportValidity();
            pubsub.fire('evtReset',true);
        });
    }

    /*------------------------------------------------------------
    Author: Alekya Avadutha
    Company: Coforge
    Description: when user clicks on search button it will validate  lastName,dateOfBirth,postcode it will call controller

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     02-12-2021       Alekya Avadutha     Initial Draft
    ------------------------------------------------------------*/
   
    handleSearch(){
        let bolQueryRecords = false;
        var lastNameLabel = this.template.querySelector(".lastName");
        var postCodeLabel = this.template.querySelector(".postCode");
        var dateOfBirthLabel = this.template.querySelector(".dateOfBirth");
           
        if (this.lastNameValue == '' || this.lastNameValue == null  ||  this.lastNameValue =='undefined') {
            lastNameLabel.setCustomValidity("");
            lastNameLabel.reportValidity();
            return false;
        }
        else{
            if((this.strPostCodeValue == '' || this.strPostCodeValue == null || this.strPostCodeValue == 'undefined') && (this.strDOBValue =='' || this.strDOBValue == null || this.strDOBValue == 'undefined')){
                dateOfBirthLabel.setCustomValidity(this.label.birthDatePostCode);
                postCodeLabel.setCustomValidity(this.label.birthDatePostCode);
                dateOfBirthLabel.reportValidity();
                postCodeLabel.reportValidity();
                return false;
            }   
            else{
                if(this.strDOBValue){
                    bolQueryRecords = true;
                }

                if(this.strPostCodeValue){ 
                    bolQueryRecords = this.validatePostCodeFormat(this.strPostCodeValue,postCodeLabel)
                }
                
                if(bolQueryRecords){
                    this.generateJSONForRecords(this.lastNameValue,this.strPostCodeValue,this.strDOBValue);
                }
                else{
                    pubsub.fire('disableTable',true);
                }
                
            } 
        }
    }

    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: This is the event togenerate JSOn for records and query them

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     02-12-2021        Anuj Sahu           Initial Draft
    ------------------------------------------------------------*/
    generateJSONForRecords(strLastName,strPostCode,strDOB){

        let searchString;
        if ((strPostCode == '' || strPostCode == null) && (strDOB != '' || strDOB != null)) {
            searchString = { lastName: strLastName, dateOfBirth: strDOB };
        }
        else if ((strDOB == '' || strDOB == null) && (strPostCode != '' || strPostCode != null)) {
            searchString = { lastName: strLastName, postCode: strPostCode };
        } 
        else {
            searchString = { lastName: strLastName, dateOfBirth: strDOB, postCode: strPostCode };
        }

        var jsonSearchString = JSON.stringify(searchString);
        pubsub.fire('simplevt',jsonSearchString);
        returnAccountRecords({strJsonFormat: jsonSearchString})
        .then((result) => {
         this.results = result;
        })
        .catch(error => {
			this.error = error;
			this.data = undefined;	
		});
    }

    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: This is the event to validate the post code format

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     02-12-2021        Anuj Sahu           Initial Draft
    ------------------------------------------------------------*/
    validatePostCodeFormat(strPostCodeValue,postCodeLabel){
        let regex = new RegExp(this.label.postCodeFormatRegex);
        //let regex = new RegExp('((?:[G]|$)(?:[I]|$)(?:[R]|$) 0(?:[Aa]|$){2})|((((?:[A-Za-z]|$)[0-9]{1,2})|(((?:[A-Za-z]|$)(?:[A-Ha-hJ-Yj-y]|$)[0-9]{1,2})|(((?:[A-Za-z]|$)[0-9](?:[A-Za-z]|$))|((?:[A-Za-z]|$)(?:[A-Ha-hJ-Yj-y]|$)[0-9]?[A-Za-z])))) [0-9](?:[A-Za-z]|$){2})$');
        let isValid = false;
        isValid = regex.test(strPostCodeValue);
        if (!isValid) {
            postCodeLabel.setCustomValidity(this.label.postCodeFormatMessage);
            //postCodeLabel.innerText = postCodeLabel.innerText.replace(/\./g, "\n");
            postCodeLabel.reportValidity();
            
            return false;
        }else{
            return true;
        }
    }

}
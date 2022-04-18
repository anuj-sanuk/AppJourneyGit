/*------------------------------------------------------------
Author: Darshan S Almiya
Company: Coforge
History
Date            Authors Name           Brief Description of Change
16-11-2021      Darshan S Almiya       Initial Draft
------------------------------------------------------------*/
import { LightningElement, api, track, wire } from 'lwc';

//Importing dynamic function to get dynamic questions
import { getAdditionalQuestions, handleErrorMessage, handleErrorMessageDynamic } from 'c/genericUtilityComponent';

import getQuestionnaire from '@salesforce/apex/QnADisplay_CC.getQuestionJSON';
import { LABEL_QUESTION } from 'c/applicationJourneyUtility';
import OnlyIntegerRegexLabel from '@salesforce/label/c.OnlyInteger';


import { showToastError } from 'c/errorToastCmp';

// this navigationPath is used for navigation by taking the key for index
const navigationPath = { 
    mortgageDeal: 1,
   };
export default class QnADisplayCmp extends LightningElement {


    //Added for enhancment
    @api strSalesPath;
    @api strJournry;
    @api strSubJourney;
    @api strSectionName;
    @api strRecordId;

    @api isIncome;

    @track isIncomeSec = false;
    @api strApplicationName;
    @track arrDependentQuestions = [];
    @track lstquestionnaire = [];
    @track lstAddtionalQuestionnaire = [];
    @track intMonthlyAllowanceForRentalVoids;
    @track isCreditCheck = false;
    @track isModalOpen = false;
    @track validInvalidAnswersList = {};
    @track buttonEnabled = true;
    @track isShowPopover = false;
    @track lstIncomeQuestions = [];
    @track error;
    @track lstIncomeCount = [];
    @track questionMap = new Map();
    lstIdsToValidate = [];
    incomeCounter = 0;
    
    lstToHardStop = []; //using in enhancment
    setToHardStop = new Set();
    loanPartCount;
    @track noOfAgesCount;
    lstAddDyn = [];
    isJoint = true;
    isAdditionalCmpVisible = false;
    isGrossMothlyIn = false;
    incomeCheck = [];
    isChildHardStop = false;//842  

    @track isProduceESIS;
    @track showESISAdditionalComp;
    @track isProductValue = false;
    @track isOutPutfield = false;
    @track hyperLink = false;

    label ={
        OnlyIntegerRegexLabel
    };

    

    jsonButton = [
        { buttonName: 'No', buttonkey: 'No' },
        { buttonName: 'Yes', buttonkey: 'Yes' }

    ]

    handleButtonClick() {

        this.isModalOpen = true;
    }

     /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Description:This is a wire method which will get the question at the load or change the section
    input: strSalesPath(Selected or default from parent), strSectionName(Selected or default from parent), strRecordId(RLA record Id/or null), strJournry, strSubJourney

    History
    Date            Authors Name           Brief Description of Change
    16-11-2021      Darshan S Almiya       Initial Draft
    ------------------------------------------------------------*/
   @wire(getQuestionnaire, { strSalesPath: '$strSalesPath', strSectionName: '$strSectionName', strRecordId: '$strRecordId', strJournry: '$strJournry', strSubJourney : '$strSubJourney' }) 
   questionnaireData({ data, error }) {
        try {
            this.lstquestionnaire = [];
            if (data) {
                if (!data.isError) {
                    this.questionMap.clear();
                    this.lstIdsToValidate = [];
                    this.isIncome = false;
                    this.lstAddDyn = [];
                    this.lstIncomeQuestions = [];
                    this.lstquestionnaire = [];
                    this.lstAddtionalQuestionnaire = [];
                    this.lstquestionnaire = JSON.parse(data.strResponse);
                    this.lstToHardStop = []; //enhancment
                    
                    this.showESISAdditionalComp = false;
                    this.isChildHardStop = false; //842
                    for (var i = 0; i < this.lstquestionnaire.length; i++) {
                        this.questionMap.set(this.lstquestionnaire[i].strRecordId, this.lstquestionnaire[i]);
                        console.log('isDynamic : '+this.lstquestionnaire[i].isDynamic);
                        if (this.lstquestionnaire[i].isDynamic == false) {
                            this.lstIdsToValidate.push(this.lstquestionnaire[i].strRecordId);
                        }
                    }
                    
                }
                else {
                    this.lstquestionnaire = [];
                    this.error = data.strMessage;
                    showToastError(data.strMessage);
                }
            }
            else {
                this.lstquestionnaire = [];
            }
        }
        catch (e) {
        }

    }
    /*------------------------------------------------------------
    Author: Sathvik V
    Company: Coforge
    Description: This method validates the changes and updates the chckbox and fieldpath accordingly

    History
    Date            Authors Name           Brief Description of Change
    15-12-2021      Sathvik V              Initial Draft
    ------------------------------------------------------------*/
    validateChange(strKey, strAnswer, isResponseCheck) {
        var objCurRecord = this.questionMap.get(strKey);

        if (objCurRecord.isRadio || objCurRecord.isComboBox ) {
            var objCurRecord = this.questionMap.get(strKey);
            if (objCurRecord.isDynamic == false) {
                objCurRecord.isFlag = true;
            }
            else if (objCurRecord.isDynamic == true && objCurRecord.isFlag == false) {
                objCurRecord.isFlag = true;
            }
            this.questionMap.set(strKey, objCurRecord);
            this.dynamicFieldsValidator(strKey, strAnswer, isResponseCheck);
            this.checkboxValidator();
        }
        if (objCurRecord.isNumber || objCurRecord.isCurrency || objCurRecord.isText || objCurRecord.isTextArea || objCurRecord.isDate || objCurRecord.isCheckBox) {
            if (objCurRecord.isDynamic == false) {
                objCurRecord.isFlag = true;
                if (strAnswer.length == 0) {
                    objCurRecord.isFlag = false;
                }
            }
            else if (objCurRecord.isDynamic == true && objCurRecord.isFlag == false) {
                objCurRecord.isFlag = true;
                if (strAnswer.length == 0) {
                    objCurRecord.isFlag = false;
                }
            }
            else if (objCurRecord.isDynamic == true && objCurRecord.isFlag == true) {

                if (strAnswer.length == 0) {
                    objCurRecord.isFlag = false;
                }
            }
            this.questionMap.set(strKey, objCurRecord);
            this.dynamicFieldsValidator(strKey, strAnswer, isResponseCheck);
            this.checkboxValidator();
        }
    }

     /*------------------------------------------------------------
    Author: Sathvik V
    Company: Coforge
    Description: This method checks if there are any dynamic questions available

    History
    Date            Authors Name           Brief Description of Change
    03-12-2021      Voola Sathvik       Initial Draft
    ------------------------------------------------------------*/
    dynamicFieldsValidator(strRecordId, stringAnswer, isResponseCheck) {
        var defIds = []
        for (var i = 0; i < this.lstquestionnaire.length; i++) {
            if (this.lstquestionnaire[i].strParentQuestion == strRecordId && this.lstquestionnaire[i].strDefaultText != null) {
                defIds.push(this.lstquestionnaire[i].strRecordId);
            }
        }

        for (var i = 0; i < this.lstquestionnaire.length; i++) {
            if (this.lstquestionnaire[i].strParentQuestion == strRecordId) {
                //if (this.lstquestionnaire[i].strParentAnswer == stringAnswer) {
                if (this.lstquestionnaire[i].strParentAnswer && this.lstquestionnaire[i].strParentAnswer.includes(stringAnswer)) {
                    this.lstIdsToValidate.push(this.lstquestionnaire[i].strRecordId);
                    var objCurRecord = this.questionMap.get(this.lstquestionnaire[i].strRecordId);
                    if (objCurRecord.isFlag) {
                        objCurRecord.isFlag = false;
                    }
                    //Logic added for check box issues 
                    /*
                    if (objCurRecord.isFlag && !isResponseCheck) {
                        objCurRecord.isFlag = false;
                    }
                    else if (stringAnswer.length == 0 && isResponseCheck) {
                        objCurRecord.isFlag = true;
                        objCurRecord.responseValues = null;
                    }
                    else if (objCurRecord.isFlag && isResponseCheck && objCurRecord.responseValues != null) {//&& !this.lstquestionnaire[i].responseValues
                        objCurRecord.isFlag = true;
                    }
                    else if (objCurRecord.isFlag && isResponseCheck) {
                        objCurRecord.isFlag = false;
                        objCurRecord.responseValues = null;
                    }
                    */

                    this.questionMap.set(this.lstquestionnaire[i].strRecordId, objCurRecord);
                }
                else {
                    if (this.lstIdsToValidate.includes(this.lstquestionnaire[i].strRecordId)) {
                        this.lstIdsToValidate = this.removeArrayValue(this.lstIdsToValidate, this.lstquestionnaire[i].strRecordId);
                        var objCurRecord = this.questionMap.get(this.lstquestionnaire[i].strRecordId);
                        if (!objCurRecord.isFlag) {
                            objCurRecord.isFlag = true;
                        }
                        /*
                        //Logic added for check box issues 
                        if (!objCurRecord.isFlag && !isResponseCheck) {
                            objCurRecord.isFlag = true;
                        }
                        else if (!objCurRecord.isFlag && isResponseCheck) {
                            objCurRecord.isFlag = true;
                            objCurRecord.responseValues = null;
                        }
                        else if (isResponseCheck) {
                            objCurRecord.responseValues = null;
                        }
                        */

                        this.questionMap.set(this.lstquestionnaire[i].strRecordId, objCurRecord);
                    }
                }
            }
        }
        for (var j = 0; j < defIds.length; j++) {
            if (this.questionMap.get(defIds[j]).strParentAnswer.trim() == stringAnswer.trim()) {
                this.lstIdsToValidate.push(defIds[j]);
                var objCurRecord = this.questionMap.get(defIds[j]);
                objCurRecord.isFlag = true;
                this.questionMap.set(defIds[j], objCurRecord);
            }
            else {
                if (this.lstIdsToValidate.includes(defIds[j])) {
                    this.lstIdsToValidate = this.removeArrayValue(this.lstIdsToValidate, defIds[j]);
                    var objCurRecord = this.questionMap.get(defIds[j]);
                    objCurRecord.isFlag = false;
                    this.questionMap.set(defIds[j], objCurRecord);
                }
            }

        }
    }

    /*------------------------------------------------------------
    Author: Sathvik V
    Company: Coforge
    Description: Method handles the checkbox rendering validation

    History
    Date            Authors Name           Brief Description of Change
    04-12-2021      Sathvik V              Initial Draft
    ------------------------------------------------------------*/
    checkboxValidator() {
        var valueCheck = true;
        var addDynamic = false;
        var strSectionName;
        if (this.lstAddDyn.length > 0) {
            for (var i = 0; i < this.lstAddDyn.length; i++) {
                if (this.questionMap.has(this.lstAddDyn[i])) {
                    var objCurRecd = this.questionMap.get(this.lstAddDyn[i]);
                    if (objCurRecd.isAdditionalDynCmp == true) {
                        addDynamic = true;
                    }
                    else {
                        addDynamic = false;
                    }
                }
                else{
                    addDynamic = true;
                }
            }
        }
        
        for (var i = 0; i < this.lstIdsToValidate.length; i++) {
            var objCurRecd = this.questionMap.get(this.lstIdsToValidate[i]);
            strSectionName = objCurRecd.strSectionName;
            console.log('flag vals : '+objCurRecd.isFlag+' '+objCurRecd.strQuestionLabel);
            //console.log('Flag value in checkbox validator : '+objCurRecd.isFlag);
            if (!objCurRecd.isFlag) {
                valueCheck = false;
            }
        }
        console.log('strSectionName : '+strSectionName);
        console.log('addDynamic : '+addDynamic);
        console.log('value check : '+valueCheck);
        console.log('this.lstAddtionalQuestionnaire.length : '+this.lstAddtionalQuestionnaire.length);
        console.log('this.lstIncomeQuestions.length : '+this.lstIncomeQuestions.length );
        console.log('this.isIncome : '+this.isIncome);
        var strEventValue = '';
        if (this.lstAddtionalQuestionnaire.length > 0 || (this.lstIncomeQuestions.length >0 && this.isIncome == true)) {
            if(strSectionName == undefined ){
                strSectionName = this.strSectionName;
            }
            console.log('Onside one');
            if (addDynamic == true) {
                console.log('Onside two');
                if (valueCheck == true) {
                    strEventValue = { sectionName: strSectionName, render: true };
                }
                if (valueCheck == false) {
                    strEventValue = { sectionName: strSectionName, render: false };
                }
            }
            else {
                strEventValue = { sectionName: strSectionName, render: false };
            }

        }
        else {
            //console.log('section name local variable',strSectionName);
            console.log('isAddCmpFilled',this.isAddCmpFilled);
            if(strSectionName == '' ){
                strSectionName = this.strSectionName;
            }
            if (valueCheck == true && strSectionName != this.sectionNameFromAddtionalCmp) {
                console.log('if Section',this.sectionNameFromAddtionalCmp);
                strEventValue = { sectionName: strSectionName, render: true };
                //this.buttonEnabled = false;
            }else if(this.isAddCmpFilled == true && valueCheck == true && strSectionName == this.sectionNameFromAddtionalCmp){
                console.log('Else if Section',this.sectionNameFromAddtionalCmp);
                strEventValue = { sectionName: this.sectionNameFromAddtionalCmp, render: true };
            }else if(this.isAddCmpFilled == false && valueCheck == true && strSectionName == this.sectionNameFromAddtionalCmp){
                console.log('last Else if Section',this.sectionNameFromAddtionalCmp);
                strEventValue = { sectionName: strSectionName, render: false };
            }
            if (valueCheck == false) {
                strEventValue = { sectionName: strSectionName, render: false };
                //this.buttonEnabled = true;
            }
        }
        const updateSectionEvent = new CustomEvent("updatesectionstatus", {
            detail: strEventValue
        });
        this.dispatchEvent(updateSectionEvent);
    }

    // This method removes a value from an array
    removeArrayValue(arrayName, valToRemove) {
        return arrayName.filter(function (ele) {
            return ele != valToRemove;
        });

    }
    handleAddDynamicValidation(event){
        console.log('Inside additional dynamic validation handle');
    }
    /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Description: handle method to get selected answer for radio options questions

    History
    Date            Authors Name           Brief Description of Change
    16-11-2021      Darshan S Almiya       Initial Draft
    02-12-2021      Sathvik V               Filled Radio answers validation
    ------------------------------------------------------------*/
    handleRadioSelection(event) {
        try {
            let radioSelectedAnswer = event.detail.value;
            let radioSelectedQuestion = event.target.label;
            let index = event.target.dataset.index;
            
            this.handleErrorMessage(index, radioSelectedAnswer);
            //Changes Added By Ankur To Handle dynamic question
            let strRecordId = event.target.dataset.id;
             if (this.lstquestionnaire[index].lstReleatedRecordId.length > 0) {
                this.dynamicFieldShowHide(index, strRecordId, radioSelectedAnswer.trim());
            }
            this.validateChange(strRecordId, radioSelectedAnswer, false);
        }
        
        catch(e){
            console.log('Error on Radio----'+e);
        }

    }
    

    /*------------------------------------------------------------
   Author: Darshan S Almiya
   Company: Coforge
   Description: handle method combobox field

   History
   Date            Authors Name           Brief Description of Change
   16-11-2021      Darshan S Almiya       Initial Draft
   ------------------------------------------------------------*/

    handleComboBox(event) {
        try {
            let strSelectedPicklistValue = event.detail.value;
            let index = event.target.dataset.index;
            let strSelectedQuestion = event.target.label;
            let strRecordId = event.target.dataset.id;

            this.handleErrorMessage(index, strSelectedPicklistValue);
             if (this.lstquestionnaire[index].lstReleatedRecordId.length > 0) {
                this.dynamicFieldShowHide(index, strRecordId, strSelectedPicklistValue.trim());
            }

            // for loan part questions
            if(strSelectedQuestion =='Number of loan parts'){
                this.loanPartCount = strSelectedPicklistValue;
                this.lstquestionnaire[index].isDynamicFieldShow = true;

                // to get additonal dynamic question for selected question, if any
                this.getAdditionalQuestionnaire(strSelectedPicklistValue,index,strSelectedQuestion,strRecordId);
            }

            // for ages question
            if(strSelectedQuestion =='How many?'){
                this.noOfAgesCount = strSelectedPicklistValue;
                
                // to get additonal dynamic question for selected question, if any
                this.getAdditionalQuestionnaire(strSelectedPicklistValue,index,strSelectedQuestion,strRecordId);
            }
            this.validateChange(strRecordId, strSelectedPicklistValue, false);
        } 
        catch (error) {
            console.log('OUTPUT : Qna Error',error);
        }
    }


    modalCallBack(event) {
        let strButtonValue = event.detail;
        this.isModalOpen = false;
        if (strButtonValue == 'Yes') {
            this.handleYesButton();

        }
        if (strButtonValue == 'No') {
            this.handleNoButton();
        }
    }
   

    //handle Input    
    handleIntegerInput(event) {
        try{
            let index = event.target.dataset.index;
            let responseValue = event.detail.value;
            this.lstquestionnaire[index].responseValues = event.detail.value;
            this.handleErrorMessage(index, responseValue);
            let strRecordId = event.target.dataset.id;
            if (this.lstquestionnaire[index].lstReleatedRecordId.length > 0) {
                if (event.target.label == 'Outstanding balance ?') {
                    console.log('responseValue length',responseValue.length);
                    if(responseValue != null && responseValue.length > 0){
                        console.log('Called from Integer Input');
                        this.dynamicFieldShowHide(index, strRecordId,true);
                    }else{
                        this.dynamicFieldShowHide(index, strRecordId,false);
                    }
                    
                }
                //dynamic question for valuation fee question
                //Added by Abhijeet
                else if (event.target.label == LABEL_QUESTION.ValuationFee) {
                    if( responseValue !=0 && responseValue != null && responseValue > 0 && responseValue != undefined && !responseValue.includes('.') ){
                        this.dynamicFieldShowHide(index, strRecordId, true);   
                
                }else{
                    let setDynamicRecordId = this.dynamicFieldShowHide(index, strRecordId, false); 
                    this.handleErrorMessageHide(setDynamicRecordId);
    
                    }
                }
                else{
                    this.dynamicFieldShowHide(index, strRecordId, responseValue.trim());
                }
                
                //this.dynamicFieldShowHide(index, strRecordId, responseValue.trim());
            }
            this.validateChange(strRecordId, responseValue, false);
        }
        catch(e){
            console.log('Error--',e);

            
        }
    }

     /*------------------------------------------------------------
    Author: Abhijeet 
    Company: Coforge
    Description: Method handles hiding errors for dynamic questions

    History
    Date            Authors Name           Brief Description of Change
    13-04-2022      Abhijeet                  Initial Draft
    ------------------------------------------------------------*/
    handleErrorMessageHide(setDynamicRecordId){
        for(var i=0;i<this.lstquestionnaire.length;i++){
            if(setDynamicRecordId.has(this.lstquestionnaire[i].strRecordId)){
                this.lstquestionnaire[i].isError = false;
            }    

        }
    }

    

    /*------------------------------------------------------------
    Author: Sathvik V
    Company: Coforge
    Description: Method handles the text input

    History
    Date            Authors Name           Brief Description of Change
    04-12-2021      Sathvik V              Initial Draft
    ------------------------------------------------------------*/
    handleText(event) {
        try{
            var responseValue = event.detail.value;
            var index = event.target.dataset.index;
            let strRecordId = event.target.dataset.id;
            var strQuestionLabel = event.target.label;
            this.lstquestionnaire[index].responseValues = event.detail.value;

            this.handleErrorMessage(index, responseValue);
            if (this.lstquestionnaire[index].lstReleatedRecordId.length > 0) {
                this.dynamicFieldShowHide(index, strRecordId, responseValue.trim());
            }
        //Validating Payment reference number
        //Added by Abhijeet
        if(strQuestionLabel == LABEL_QUESTION.PaymentReference){
            var regex = new RegExp(this.label.OnlyIntegerRegexLabel);
            let isValid = regex.test(responseValue);
            if (!isValid) {      
                this.handleErrorMessageLogic(index, 'IsFirstError', true);
            }
            else {
                this.handleErrorMessageLogic(index, 'IsFirstError', false);
            }
            
        }
        this.validateChange(strRecordId, responseValue, false);
        }
        catch(e){
            console.log('Error--'+e);
        }
    }



    
    /*------------------------------------------------------------
    Author: Sathvik V
    Company: Coforge
    Description: Method handles the Date input

    History
    Date            Authors Name           Brief Description of Change
    04-12-2021      Sathvik V              Initial Draft
    ------------------------------------------------------------*/
    handleDate(event) {
        try{
            var stringAnswer = event.target.value;
            var strRecordId = event.currentTarget.dataset.id;
            let index = event.target.dataset.index;
            /*this.validateFutureDate(stringAnswer, index);
            if(stringAnswer == null){
                stringAnswer = '';

            }
            this.validateChange(strRecordId, stringAnswer, false);*/
            this.handleErrorMessage(index, stringAnswer);
            if (this.lstquestionnaire[index].lstReleatedRecordId.length > 0) {
                this.dynamicFieldShowHide(index, strRecordId, stringAnswer.trim());
            }
            this.validateChange(strRecordId, stringAnswer, false);
        }
        catch(e){
            console.log('Error---'+e);
        }

    }
    

    /*------------------------------------------------------------
    Author: Alekya
    Company: Coforge
    Description: Method handles the checkbox input

    History
    Date            Authors Name           Brief Description of Change
    04-12-2021      alekya              Initial Draft
    10-03-2022      Raghu                  Warning Message for directDebit (checkbox)
    ------------------------------------------------------------*/
    handleCheckBoxInput(event) {
        try{
            var checkedInput = event.target.value;
            let index = event.target.dataset.index;
            let strQuestionLabel = event.target.label;
            let strRecordId = event.target.dataset.id;
            this.lstquestionnaire[index].responseValues = event.detail.value; //added by DS storing response Values
            this.handleErrorMessage(index, checkedInput);
            if (this.lstquestionnaire[index].lstReleatedRecordId.length > 0) {
                this.dynamicFieldShowHide(index, strRecordId, checkedInput.trim());
            }
        }
        catch(e){
            console.log('Error--'+e);
        }
       
    }


    showPopover(event) {
        this.isShowPopover = true;

    }

    hidePopover(event) {
        this.isShowPopover = false;
    }

    /*------------------------------------------------------------
    Author: Naga Shirisha
    Company: Coforge
    Description: Method handles the validation

    History
    Date            Authors Name           Brief Description of Change
    10-03-2022      Naga shirisha             Initial Draft
    ------------------------------------------------------------*/
    handlecurrency(event) {
        try{
            let index = event.target.dataset.index;
            let responseValue = event.target.value;
            let formatter = event.target.formatter;
            let strRecordId = event.target.dataset.id;
            /*if (formatter === 'currency') {
                isCurrencyFormatValid = this.validateCurrencyFormat(responseValue, index);
            }*/
    
            this.handleErrorMessage(index, responseValue);
             if (this.lstquestionnaire[index].lstReleatedRecordId.length > 0) {
               //  this.dynamicFieldShowHide(index, strRecordId, responseValue.trim());
             }
             this.validateChange(strRecordId, responseValue, false);
        }
        catch(e){
            console.log('Error---'+e);
        }
    }
    
    
        
    /*------------------------------------------------------------
    Author: Nagashirisha
    Company: Coforge
    Description: method is used for navigation from section to path

    History
    Date            Authors Name           Brief Description of Change
    28-03-2022      Naga shirisha             Initial Draft
    ------------------------------------------------------------*/
    handleHyperLink(event){
        const navgationsection = new CustomEvent("navgationsectiontopath", {
        detail:  navigationPath.mortgageDeal, bubbles: true, composed: true

    });
        this.dispatchEvent(navgationsection);  
    }

    /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Description: To handle error messages
    input: index number of question, response value

    History
    Date            Authors Name           Brief Description of Change
    12-04-2022      Darshan S Almiya            Initial Draft
    ------------------------------------------------------------*/

    handleErrorMessage(index, responseValue){
        //method the handleErrorMessage to display the Error
        let errorObj = handleErrorMessage(this.lstquestionnaire[index], responseValue, this.setToHardStop);
        this.lstquestionnaire[index] = errorObj.lstquestionnaire;
        this.setToHardStop = errorObj.setToHardStop;
            
        this.validationIconLock(index);
       }

       handleErrorMessageLogic(index, responseValue, isErrorShow){
        //method the handleErrorMessage to display the Error
        let errorObj = handleErrorMessageDynamic(this.lstquestionnaire[index], responseValue, this.setToHardStop, isErrorShow);
        this.lstquestionnaire[index] = errorObj.lstquestionnaire;
        this.setToHardStop = errorObj.setToHardStop;
            
        this.validationIconLock(index);
       }

    /*------------------------------------------------------------
    Author: Sathvik
    Company: Coforge
    Description: This method handles the 'Error Sign' logic display
    at section level and the red background colour display on path whenever
    a hardstop is encountered

    History
    Date            Authors Name           Brief Description of Change
    11-01-2021      Sathvik                     Initial Draft
    11-03-2021      Darshan S Almiya        Added new variable 'isChildHardStop' in if condition
    12-04-2022      Darshan S Almiya        Removed dispatched event from this method and updated the if condition
    ------------------------------------------------------------*/

    validationIconLock(index) {

        var isHardStopIcon = false;
        var strSection = this.lstquestionnaire[index].strSectionName;
        if(this.setToHardStop.size > 0 || this.isChildHardStop){
            isHardStopIcon=true;
        }

        var detail = { theSection : strSection,
                        isStop : isHardStopIcon,
                        strId : this.lstquestionnaire[index].strRecordId,
                        };
        this.handleDisptachEvent('hardstopdisplay', detail);
    }

    /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Input: EventName, Detail
    Description: This method is use to dispatched the event to the parent component

    History
    Date            Authors Name           Brief Description of Change
    12-04-2022      Darshan S Almiya       Initial Draft
    ------------------------------------------------------------*/

    handleDisptachEvent(eventName, detail){
        const eventHandle = new CustomEvent(eventName, {
            detail
        });
        this.dispatchEvent(eventHandle);
    }

    /*------------------------------------------------------------
Author: Ankur Tripathi
Company: Coforge
Description: To display dynamic questions

History
Date            Authors Name           Brief Description of Change
09-04-2022      Ankur                  Initial Draft
------------------------------------------------------------*/

dynamicFieldShowHide(indexNumber, strRecordId, stringAnswer) {
    console.log('index',indexNumber);
    console.log('stringAnswer',stringAnswer);
    let pRecordId;
    let setDynamicRecordId = new Set();
    let recordsIds = [];
    let parentAnswers = [];
    let dynamicLogicInclude = false;
    Object.keys(this.lstquestionnaire).forEach(key => {
        //console.log('strParentQuestion',this.lstquestionnaire[key].strParentQuestion);
        //console.log('isDynamicFieldShow',this.lstquestionnaire[key].isDynamicFieldShow);
        if (this.lstquestionnaire[key].strParentQuestion) {
            if (this.lstquestionnaire[key].strParentQuestion == strRecordId) {
                pRecordId = this.lstquestionnaire[key].strRecordId;
                //Fetch dynamic Logic value
                let dynamicLogicValue = this.lstquestionnaire[key].strDynamicLogicValue;
                if (this.lstquestionnaire[key].strParentAnswer) {
                    if (this.lstquestionnaire[key].strParentAnswer.includes(';')) {
                        parentAnswers = this.lstquestionnaire[key].strParentAnswer.split(';');
                    } else {
                        parentAnswers = this.lstquestionnaire[key].strParentAnswer;
                    }
                }else if(dynamicLogicValue.includes('IsFirstDisplayQuestion')){
                       dynamicLogicInclude = true;
                }
                //console.log('parentAnswers',parentAnswers);
                if (!dynamicLogicInclude && parentAnswers != null && stringAnswer != null && parentAnswers.includes(stringAnswer)) {
                    if (!this.lstquestionnaire[key].isDynamicFieldShow) {
                        this.lstquestionnaire[key].isDynamicFieldShow = true;
                        this.arrDependentQuestions.push(this.lstquestionnaire[key]);
                    }
                    //console.log('this.arrDependentQuestions',this.arrDependentQuestions);
                }else if(dynamicLogicInclude && stringAnswer == true){
                   if (!this.lstquestionnaire[key].isDynamicFieldShow) {
                       this.lstquestionnaire[key].isDynamicFieldShow = true;
                       this.arrDependentQuestions.push(this.lstquestionnaire[key]);
                   }
                }
                else {
                    //console.log('In Else Block');
                    if (this.lstquestionnaire[key].isDynamicFieldShow) {
                        this.lstquestionnaire[key].isDynamicFieldShow = false;
                        setDynamicRecordId.add(this.lstquestionnaire[key].strRecordId);
                        Object.keys(this.arrDependentQuestions).forEach(arr => {
                            if (pRecordId == this.arrDependentQuestions[arr].strParentQuestion) {
                                recordsIds.push(this.arrDependentQuestions[arr].strRecordId);
                                pRecordId = this.arrDependentQuestions[arr].strRecordId;
                            }
                        });
                    }
                }
            }
        }
    });

    Object.keys(this.lstquestionnaire).forEach(key => {
        for (let i = 0; i <= recordsIds.length; i++) {
            if (this.lstquestionnaire[key].strRecordId == recordsIds[i]) {
                if (this.lstquestionnaire[key].isDynamicFieldShow) {
                    this.lstquestionnaire[key].isDynamicFieldShow = false;
                    setDynamicRecordId.add(this.lstquestionnaire[key].strRecordId);
                    break;
                }
            }
        }
    });
    return setDynamicRecordId;

}
    
    // to get additional dynamic questions
    getAdditionalQuestionnaire(strSelectedAnswer,index,strSelectedQuestion,strRecordId){

        let questionDetailsJSON = {
            'strSelectedAnswer':strSelectedAnswer,
            'index':index,
            'strSelectedQuestion':strSelectedQuestion,
            'strRecordId':strRecordId
        };

        // returns list of additonal dynamic question for selected question
        this.lstAddtionalQuestionnaire = getAdditionalQuestions(questionDetailsJSON, this.lstquestionnaire);
        console.log('OUTPUT : Add Question Length',this.lstAddtionalQuestionnaire.length);
    }
}
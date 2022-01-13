/*------------------------------------------------------------
Author: Darshan S Almiya
Company: Coforge
History
Date            Authors Name           Brief Description of Change
16-11-2021      Darshan S Almiya       Initial Draft
------------------------------------------------------------*/
import { LightningElement, api, track, wire } from 'lwc';
import getQuestionnaire from '@salesforce/apex/Questionnaire_CCCloneAnuj.getQuestionnaireJSON';
import MortgageAmountLabel from '@salesforce/label/c.MortgageAmount';
import EstimatedValuationLabel from '@salesforce/label/c.EstimatedValuation';
import LoanPartsLabel from '@salesforce/label/c.Loan_Parts';
import NoOfDependentsLabel from '@salesforce/label/c.No_Of_Depedents';
import MonthlyAllowanceForRentalVoidsLabel from '@salesforce/label/c.MonthlyAllowanceForRentalVoids';
import GrossMonthlyRentLabel from '@salesforce/label/c.GrossMonthlyRent';
import OtherMonthlyCostsLabel from '@salesforce/label/c.OtherMonthlyCosts';
import MonthlyPropertyMaintenanceCostsLabel from '@salesforce/label/c.MonthlyPropertyMaintenanceCosts';
import OtherMonthlyCommitmentsLabel from '@salesforce/label/c.OtherMonthlyCommitments';

export default class QuestionnaireCmpCloneAnuj extends LightningElement {
@api strApplicationJson;
@api strSectionName;
@api strSalesPath;
radioSelectedAnswer;
@track arrDependentQuestions = [];
@track lstquestionnaire= [];
@track lstDyanamicField;
@track lstAddtionalQuestionnaire = [];
@track intMonthlyAllowanceForRentalVoids;
@track intMonthlyGrossRent;
@track intOtherMonthlyCosts;
@track intMonthlyPropertyMaintenanceCosts;
@track intOtherMonthlyCommitments;
@track lstHardStopMessage =[];
@track lstNoHardStop=[];

    isHardStop;
    strHardStopMsg;
    isDate = false;
    mortgageAmount;
    estimatedValuation;
    loanToValue;
    loanPartCount;
    noOfAgesCount;
    isDynamicLogicCount = 0;
    lstAddDyn = [];
    @track questionMap = new Map();
    lstIdsToValidate = [];
    @track selectedLoanParts;

    label = {
        MortgageAmountLabel,
        EstimatedValuationLabel,
        LoanPartsLabel,
        NoOfDependentsLabel,
        MonthlyAllowanceForRentalVoidsLabel,
        GrossMonthlyRentLabel,
        OtherMonthlyCostsLabel,
        MonthlyPropertyMaintenanceCostsLabel,
        OtherMonthlyCommitmentsLabel,
    };

    
    /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Description: Wired method to get list of questions

    History
    Date            Authors Name           Brief Description of Change
    16-11-2021      Darshan S Almiya       Initial Draft
    01-12-2021      Sathvik V              Questionnaire returnde list coverted to Map format 
    ------------------------------------------------------------*/
    //@wire(getQuestionnaire, { strSalespathName: '$strSalesPath', strSectionName: '$strSectionName' })
    
    // connectedCallback(){
    //     this.strApplicationJson = JSON.stringify({ strSalespathName: '$strSalesPath', strSectionName: '$strSectionName' });
    // }

    

    @wire(getQuestionnaire, { strQuestionsQuery: '$strApplicationJson'})
    questionnaireData({ data, error }) {
        if (data){
            //this.lstquestionnaire = [] ;
            this.lstquestionnaire = JSON.parse(data);
            this.questionMap.clear();
            this.lstIdsToValidate = [];
            for (var i = 0; i < this.lstquestionnaire.length; i++) {
                if (this.lstquestionnaire[i].isAdditionalDynCmp == false) {
                    this.isDynamicLogicCount = this.isDynamicLogicCount + 1;
                    this.lstAddDyn.push(this.lstquestionnaire[i].strRecordId);
                }
                this.questionMap.set(this.lstquestionnaire[i].strRecordId, this.lstquestionnaire[i]);
                if (this.lstquestionnaire[i].isDynamic == false) {
                    this.lstIdsToValidate.push(this.lstquestionnaire[i].strRecordId);
                }
            }
        }
        else{
            this.lstquestionnaire = [] ;
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
    validateChange(strKey, strAnswer) {
        var objCurRecord = this.questionMap.get(strKey);
        if (objCurRecord.isRadio || objCurRecord.isComboBox || objCurRecord.isDate) {

            var objCurRecord = this.questionMap.get(strKey);
            if (objCurRecord.isDynamic == false) {
                objCurRecord.isFlag = true;
            }
            else if (objCurRecord.isDynamic == true && objCurRecord.isFlag == false) {
                objCurRecord.isFlag = true;
            }
            this.questionMap.set(strKey, objCurRecord);
            this.dynamicFieldsValidator(strKey, strAnswer);
            this.checkboxValidator();
        }
        if (objCurRecord.isNumber || objCurRecord.isCurrency || objCurRecord.isText || objCurRecord.isTextArea) {
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
            this.checkboxValidator();
        }
    }


    // this method call from child component for Ages

    handleAgeChange(event) {
        var isAgeCmp = event.detail;
        for (var i = 0; i < this.lstAddDyn.length; i++) {
            var objCurRecord = this.questionMap.get(this.lstAddDyn[i]);
            objCurRecord.isAdditionalDynCmp = isAgeCmp;
            this.questionMap.set(this.lstAddDyn[i], objCurRecord);
        }
        this.checkboxValidator();
    }

    // this method call from Loan Count component
    handleLoanChange(event) {
        var isLoanCmp = event.detail;
        for (var i = 0; i < this.lstAddDyn.length; i++) {
            var objCurRecord = this.questionMap.get(this.lstAddDyn[i]);
            objCurRecord.isAdditionalDynCmp = isLoanCmp;
            this.questionMap.set(this.lstAddDyn[i], objCurRecord);
        }
        this.checkboxValidator();
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
        let radioSelectedAnswer = event.detail.value;
        let radioSelectedQuestion = event.target.label;

        let stringAnswer = event.detail.value;

        let index = event.target.dataset.index;
        let strRecordId = event.target.dataset.id;

        if (this.lstquestionnaire[index].lstReleatedRecordId.length > 0) {
            this.dynamicFieldShowHide(index, strRecordId, stringAnswer); // calling theDyanmicFieldShowHide Method
            //this.toggleNextQuestion(index, strRecordId, stringAnswer);
        }
        
        this.getNegativeAnswer(radioSelectedQuestion, radioSelectedAnswer, index);
        this.validateChange(strRecordId, stringAnswer);
    }

    /*------------------------------------------------------------
    Author: Sathvik V
    Company: Coforge
    Description: This method checks if there are any dynamic questions available

    History
    Date            Authors Name           Brief Description of Change
    03-12-2021      Voola Sathvik       Initial Draft
    ------------------------------------------------------------*/
    dynamicFieldsValidator(strRecordId, stringAnswer) {
        for (var i = 0; i < this.lstquestionnaire.length; i++) {
            if (this.lstquestionnaire[i].strParentQuestion == strRecordId) {
                if (this.lstquestionnaire[i].strParentAnswer == stringAnswer) {
                    this.lstIdsToValidate.push(this.lstquestionnaire[i].strRecordId);
                    var objCurRecord = this.questionMap.get(this.lstquestionnaire[i].strRecordId);
                    if (objCurRecord.isFlag) {
                        objCurRecord.isFlag = false;
                    }
                    this.questionMap.set(this.lstquestionnaire[i].strRecordId, objCurRecord);
                }
                else {
                    if (this.lstIdsToValidate.includes(this.lstquestionnaire[i].strRecordId)) {
                        this.lstIdsToValidate = this.removeArrayValue(this.lstIdsToValidate, this.lstquestionnaire[i].strRecordId);
                        var objCurRecord = this.questionMap.get(this.lstquestionnaire[i].strRecordId);
                        if (!objCurRecord.isFlag) {
                            objCurRecord.isFlag = true;
                        }
                        this.questionMap.set(this.lstquestionnaire[i].strRecordId, objCurRecord);
                    }
                }
            }
        }
    }
    // This method removes a value from an array
    removeArrayValue(arrayName, valToRemove) {
        return arrayName.filter(function (ele) {
            return ele != valToRemove;
        });

    }

    /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Description: handle method to shoe and hide the Dynamic fields

    History
    Date            Authors Name           Brief Description of Change
    03-12-2021      Darshan S Almiya       Initial Draft
    ------------------------------------------------------------*/
    dynamicFieldShowHide(indexNumber, strRecordId, stringAnswer) {
        
        let pRecordId;
        let recordsIds = [];
        Object.keys(this.lstquestionnaire).forEach(key => {                                                                             
            if (this.lstquestionnaire[key].strParentQuestion) {
                if (this.lstquestionnaire[key].strParentQuestion == strRecordId) {
                    pRecordId = this.lstquestionnaire[key].strRecordId;
                    if (this.lstquestionnaire[key].strParentAnswer == stringAnswer) {
                        if (!this.lstquestionnaire[key].isDynamicFieldShow) {
                            this.lstquestionnaire[key].isDynamicFieldShow = true;
                            this.arrDependentQuestions.push(this.lstquestionnaire[key]);
                        }
                    }
                    else{
                        if (this.lstquestionnaire[key].isDynamicFieldShow) {
                            this.lstquestionnaire[key].isDynamicFieldShow = false;
                            Object.keys(this.arrDependentQuestions).forEach(arr =>{
                                if(pRecordId == this.arrDependentQuestions[arr].strParentQuestion){
                                    recordsIds.push(this.arrDependentQuestions[arr].strRecordId);
                                    pRecordId = this.arrDependentQuestions[arr].strRecordId;
                                }
                            });
                        }
                    }
                }  
            }
        });

        Object.keys(this.lstquestionnaire).forEach(key =>{
            for(let i=0 ; i<=recordsIds.length ; i++){
                if(this.lstquestionnaire[key].strRecordId == recordsIds[i]){
                    if(this.lstquestionnaire[key].isDynamicFieldShow){
                        this.lstquestionnaire[key].isDynamicFieldShow = false;
                        break;
                    }
                }
            }
        }); 
    }

    

    /*------------------------------------------------------------
   Author: Darshan S Almiya
   Company: Coforge
   Description: This method is use to open the Addtional

   History
   Date            Authors Name           Brief Description of Change
   22-12-2021      Darshan S Almiya       Initial Draft
   ------------------------------------------------------------*/

    addtionalComponentFieldShowHide(index, strRecordId) {
        if (this.lstquestionnaire[index].lstReleatedRecordId.length > 0) {
            this.lstquestionnaire[index].isDynamicLogicFieldShow = true;
            this.lstAddtionalQuestionnaire = []; 
            Object.keys(this.lstquestionnaire).forEach(key => {
                if (this.lstquestionnaire[key].strParentQuestion) {
                    if (this.lstquestionnaire[key].strParentQuestion == strRecordId)
                        this.lstAddtionalQuestionnaire.push(this.lstquestionnaire[key]);
                }
            });
        }
        else {
            this.lstquestionnaire[index].isDynamicLogicFieldShow = false;
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
        let responseValue = event.detail.value;
        let index = event.target.dataset.index;
        let strSelectedQuestion = event.target.label;
        let strRecordId = event.target.dataset.id;

        if (this.lstquestionnaire[index].lstReleatedRecordId.length > 0) {
            this.dynamicFieldShowHide(index, strRecordId, responseValue.trim());
        }

        //For Loan Additional Field
        if (strSelectedQuestion == this.label.LoanPartsLabel) {
            this.loanPartCount = event.target.value;
            this.addtionalComponentFieldShowHide(index, strRecordId);
        }

        //For Age Additional Field
        if (strSelectedQuestion == this.label.NoOfDependentsLabel) {
            this.noOfAgesCount = event.target.value;
            this.addtionalComponentFieldShowHide(index, strRecordId);
        }

        this.getNegativeAnswer(strSelectedQuestion, responseValue.trim(), index);
        this.validateChange(strRecordId, responseValue.trim());

    }

    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: handle method to get negative answer to show hard stop

    History
    Date            Authors Name           Brief Description of Change
    16-11-2021      Anuj Sahu               Initial Draft
    15-12-2021      Sathvik Voola           Made some changes to handle multiple negative answers
    ------------------------------------------------------------*/
    getNegativeAnswer(radioSelectedQuestion, radioSelectedAnswer, index) {

        for (var i = 0; i < this.lstquestionnaire[index].strNegativeAnswer.length; i++) {
            this.lstquestionnaire[index].strNegativeAnswer[i] = this.lstquestionnaire[index].strNegativeAnswer[i].trim()
        }
        if (this.lstquestionnaire[index].strNegativeAnswer.includes(radioSelectedAnswer)) {
            this.lstquestionnaire[index].isError = true;
            this.hardStop(index);
        }
        else {

            this.lstquestionnaire[index].isError = false;
            this.lstHardStopMessage = this.removeArrayValue(this.lstHardStopMessage, this.lstquestionnaire[index].strRecordId);
            this.lstNoHardStop.push(this.lstquestionnaire[index].strRecordId);
            var reqObj = {};
            reqObj['hardStopList'] = this.lstHardStopMessage;
            reqObj['noHardStopList'] = this.lstNoHardStop;
            var strEventValue={lstHardStopMessage:reqObj};
            const updatehardstopevent = new CustomEvent("hardstopeventvaluechanges", {
                detail:  strEventValue , bubbles: true, composed: true
            });
            this.dispatchEvent(updatehardstopevent);
            
        }
        
    }

    /*------------------------------------------------------------
    Author: Alekya
    Company: Coforge
    Description: handle method to get negative answer to show hard stop 
    and dispatching lstof HardStop messages and no hardstop messages 
    to parent component

    History
    Date            Authors Name           Brief Description of Change
    16-11-2021      Anuj Sahu       Initial Draft
    ------------------------------------------------------------*/
    hardStop(index){
        this.lstHardStopMessage.push(this.lstquestionnaire[index].strRecordId);
        this.lstNoHardStop = this.removeArrayValue(this.lstNoHardStop, this.lstquestionnaire[index].strRecordId);
        var reqObj = {};
        reqObj['hardStopList'] = this.lstHardStopMessage;
        reqObj['noHardStopList'] = this.lstNoHardStop;
        var strEventValue={lstHardStopMessage:reqObj};
         const updatehardstopevent = new CustomEvent("hardstopeventvaluechanges", {
             detail:  strEventValue , bubbles: true, composed: true
           });
        
         this.dispatchEvent(updatehardstopevent);
          
    }
    /*------------------------------------------------------------
    Author: Rishabh Tyagi
    Company: Coforge
    Description: handle method to get the answer for integer type of questions

    History
    Date            Authors Name           Brief Description of Change
    08-12-2021      Rishabh Tyagi            Initial Draft
    10-12-2021      Sathvik V               Section completion validation added
    ------------------------------------------------------------*/

    handleIntegerInput(event) {
        let index = event.target.dataset.index;
        let responseValue = event.detail.value;

        if (event.target.label == this.label.MortgageAmountLabel) {
            this.mortgageAmount = event.target.value;
            index = parseInt(index) + 1;
        }
        if (event.target.label == this.label.EstimatedValuationLabel) {
            this.estimatedValuation = event.target.value;
        }

        if(event.target.label==this.label.GrossMonthlyRentLabel){
            this.intMonthlyGrossRent=event.target.value;
            let intMonthlyRentIndex;
            Object.keys(this.lstquestionnaire).forEach(key => {
                if(this.lstquestionnaire[key].strQuestion == this.label.MonthlyAllowanceForRentalVoidsLabel){
                    intMonthlyRentIndex = this.lstquestionnaire[key].numIndex;
                }
            });

            index = intMonthlyRentIndex ;
        }

        if(event.target.label==this.label.MonthlyAllowanceForRentalVoidsLabel){
            this.intMonthlyAllowanceForRentalVoids=event.target.value; 
        }

        if(event.target.label==this.label.OtherMonthlyCommitmentsLabel){
            this.intOtherMonthlyCommitments=event.target.value;
            if(this.validateInteger(this.intOtherMonthlyCommitments)){
                this.getErrorForIntegers(event.target.label,this.intOtherMonthlyCommitments,index);
            }else {
                this.lstquestionnaire[index].isError = false;
            }
        }

        if(event.target.label==this.label.OtherMonthlyCostsLabel){
            this.intOtherMonthlyCosts=event.target.value;
            if(this.validateInteger(this.intOtherMonthlyCosts)){
                this.getErrorForIntegers(event.target.label,this.intOtherMonthlyCosts,index);
            }else {
                this.lstquestionnaire[index].isError = false;
            }
        }

        if(event.target.label==this.label.MonthlyPropertyMaintenanceCostsLabel){
            this.intMonthlyPropertyMaintenanceCosts=event.target.value;
            if(this.validateInteger(this.intMonthlyPropertyMaintenanceCosts)){
                this.getErrorForIntegers(event.target.label,this.intMonthlyPropertyMaintenanceCosts,index);
            }else {
                this.lstquestionnaire[index].isError = false;
            }
        }

        if((event.target.label==this.label.MonthlyAllowanceForRentalVoidsLabel || event.target.label== this.label.GrossMonthlyRentLabel)){
            if(this.validateInteger(this.intMonthlyAllowanceForRentalVoids) && this.validateInteger(this.intMonthlyGrossRent)){
                let monthlyRents = (this.intMonthlyGrossRent)/12;
                let bolShowError;
                if(this.intMonthlyAllowanceForRentalVoids < monthlyRents ){
                    bolShowError = true;
                }else{
                    bolShowError = false;
                }
                this.getErrorForIntegers(event.target.label,bolShowError,index);
            }else{
                this.lstquestionnaire[index].isError = false;
            } 
        }
        if((event.target.label ==this.label.MortgageAmountLabel ||
            event.target.label ==this.label.EstimatedValuationLabel) &&
            this.validateInteger(this.mortgageAmount) && this.validateInteger(this.estimatedValuation)){
                   this.loanToValue = (this.mortgageAmount/this.estimatedValuation)*100;
                   this.getErrorForIntegers(event.target.label,this.loanToValue,index);       
       }


        var strRecordId = event.currentTarget.dataset.id;
        this.validateChange(strRecordId, responseValue);
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
            if (!objCurRecd.isFlag) {
                valueCheck = false;
            }
        }
        var strEventValue = '';
        if (this.lstAddtionalQuestionnaire.length > 0) {
            if (addDynamic == true) {
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
            if (valueCheck == true) {
                strEventValue = { sectionName: strSectionName, render: true };
            }
            if (valueCheck == false) {
                strEventValue = { sectionName: strSectionName, render: false };
            }
        }
        const updateSectionEvent = new CustomEvent("updatesectionstatus", {
            detail: strEventValue
        });
        this.dispatchEvent(updateSectionEvent);
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
        var strTxtVal = event.detail.value;
        var strRecordId = event.currentTarget.dataset.id;
        this.validateChange(strRecordId, strTxtVal);
    }
    /*------------------------------------------------------------
    Author: Sathvik V
    Company: Coforge
    Description: Method handles the text input

    History
    Date            Authors Name           Brief Description of Change
    04-12-2021      Sathvik V              Initial Draft
    ------------------------------------------------------------*/
    handleDate(event) {
        var stringAnswer = event.target.value;
        var strRecordId = event.currentTarget.dataset.id;
        this.validateChange(strRecordId, stringAnswer);
    }
    /*------------------------------------------------------------
    Author: Rishabh Tyagi
    Company: Coforge
    Description: handle method to get negative answer to show/hide error for Integer fields

    History
    Date            Authors Name           Brief Description of Change
    08-12-2021      Rishabh Tyagi            Initial Draft
    ------------------------------------------------------------*/
    getErrorForIntegers(strSelectedQuestion,strSelectedAnswer,index){
        //For LTV
        if(strSelectedQuestion == this.label.MortgageAmountLabel || strSelectedQuestion == this.label.EstimatedValuationLabel){
            if(this.lstquestionnaire[index].strNegativeAnswer < strSelectedAnswer){
                this.lstquestionnaire[index].isError = true;
            }
            else{
                this.lstquestionnaire[index].isError = false;
            }
        }
        //For Monthly Rents & Expense
        else if(strSelectedQuestion == this.label.OtherMonthlyCostsLabel || strSelectedQuestion == this.label.MonthlyPropertyMaintenanceCostsLabel || strSelectedQuestion == this.label.OtherMonthlyCommitmentsLabel){
            if(this.lstquestionnaire[index].strNegativeAnswer.valueOf() == strSelectedAnswer.valueOf()){
                this.lstquestionnaire[index].isError = true;
            }
            else {
                this.lstquestionnaire[index].isError = false;
            }
        }
        //For gross rent
        else if(strSelectedQuestion == this.label.MonthlyAllowanceForRentalVoidsLabel || strSelectedQuestion == this.label.GrossMonthlyRentLabel){
            if(strSelectedAnswer == true){
                this.lstquestionnaire[index].isError = true;
            }
            else{
                this.lstquestionnaire[index].isError = false;
            }
        }
        else{
            this.lstquestionnaire[index].isError = false;
        }
    }

    /*------------------------------------------------------------
    Author: Rishabh Tyagi
    Company: Coforge
    Description: This method is used to validate integer value for undfined, null and empty

    History
    Date            Authors Name           Brief Description of Change
    08-12-2021      Rishabh Tyagi            Initial Draft
    ------------------------------------------------------------*/

    validateInteger(value) {
        if(typeof value === 'undefined' || value === null || value.length==0) {
            return false;
        }
        return true;
    }
}
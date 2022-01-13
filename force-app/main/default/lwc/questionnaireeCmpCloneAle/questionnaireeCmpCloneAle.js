/*------------------------------------------------------------
Author: Darshan S Almiya
Company: Coforge
History
Date            Authors Name           Brief Description of Change
16-11-2021      Darshan S Almiya       Initial Draft
------------------------------------------------------------*/
import { LightningElement,api,track, wire } from 'lwc';
import getQuestionnaire from '@salesforce/apex/Questionnaire_CC.getQuestionnaireJSON';
import MortgageAmountLabel from '@salesforce/label/c.MortgageAmount';
import EstimatedValuationLabel from '@salesforce/label/c.EstimatedValuation';
import LoanPartsLabel from '@salesforce/label/c.Loan_Parts';
import NoOfDependentsLabel from '@salesforce/label/c.No_Of_Depedents';
export default class QuestionnaireeCmpCloneAle extends LightningElement {
@api strSectionName;
@api strSalesPath;
radioSelectedAnswer;

@track lstquestionnaire;
@track lstDyanamicField;
@track lstAddtionalQuestionnaire;
@track isHardStop;
strHardStopMsg;

isDate = false;
loanPartItems;
mortgageAmount; 
estimatedValuation;
loanToValue; 
loanPartCount;
@track questionMap =new Map();
lstIdsToValidate=[];
lstHardStopMessage =[];
lstNoHardStop=[];
@track selectedLoanParts;
label = {
    MortgageAmountLabel,
    EstimatedValuationLabel,
    LoanPartsLabel,
    NoOfDependentsLabel,
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
    @wire(getQuestionnaire,{strSalespathName:'$strSalesPath', strSectionName: '$strSectionName'})
    questionnaireData({data,error}){
        if(data){
            this.lstquestionnaire = JSON.parse(data);
            for(var i=0; i<this.lstquestionnaire.length; i++){
                this.questionMap.set(this.lstquestionnaire[i].strRecordId,this.lstquestionnaire[i]);
                if(this.lstquestionnaire[i].isDynamic == false){
                    this.lstIdsToValidate.push(this.lstquestionnaire[i].strRecordId);
                }
            }
        }
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
    handleRadioSelection(event){
        let radioSelectedAnswer = event.detail.value;
        let radioSelectedQuestion = event.target.label;
        

        /**** Add New*** */
        let stringAnswer = event.detail.value;
        
        let index = event.target.dataset.index;
        let strRecordId = event.target.dataset.id;  

        if(this.lstquestionnaire[index].lstReleatedRecordId.length > 0){
            this.dynamicFieldShowHide(index, strRecordId, stringAnswer); // calling theDyanmicFieldShowHide Method
            if(this.lstquestionnaire[index].isDyanmicLogicNeeded){
                this.handleDynamicLogicField();
            }
        }
        else if(this.lstquestionnaire[index].isDyanmicLogicNeeded){
            this.handleDynamicLogicField();
        }

        this.getNegativeAnswer(radioSelectedQuestion,radioSelectedAnswer,index);
        var curKey=event.currentTarget.dataset.id;
        var objCurRecord=this.questionMap.get(curKey);
        if(objCurRecord.isDynamic == false){
            objCurRecord.isFlag=true;
        }
        this.questionMap.set(curKey,objCurRecord);
        this.dynamicFieldsValidator(curKey,stringAnswer);
        this.checkboxValidator();
    }
    /*------------------------------------------------------------
    Author: Sathvik V
    Company: Coforge
    Description: This method checks if there are any dynamic questions available

    History
    Date            Authors Name           Brief Description of Change
    03-12-2021      Voola Sathvik       Initial Draft
    ------------------------------------------------------------*/
    dynamicFieldsValidator(strRecordId, stringAnswer){
        for(var i=0; i< this.lstquestionnaire.length; i++){
            if(this.lstquestionnaire[i].strParentQuestion == strRecordId){
                if(this.lstquestionnaire[i].strParentAnswer == stringAnswer){
                    this.lstIdsToValidate.push(this.lstquestionnaire[i].strRecordId);
                    var objCurRecord=this.questionMap.get(this.lstquestionnaire[i].strRecordId);
                    if(objCurRecord.isFlag == true){
                        objCurRecord.isFlag = false;
                    }
                    this.questionMap.set(this.lstquestionnaire[i].strRecordId,objCurRecord);
                }
                else{
                    if(this.lstIdsToValidate.includes(this.lstquestionnaire[i].strRecordId)){
                        
                        this.lstIdsToValidate=this.removeArrayValue(this.lstIdsToValidate,this.lstquestionnaire[i].strRecordId);
                    
                    var objCurRecord=this.questionMap.get(this.lstquestionnaire[i].strRecordId);
                    
                    if(objCurRecord.isFlag == false){
                        
                        objCurRecord.isFlag = true;
                    }
                    this.questionMap.set(this.lstquestionnaire[i].strRecordId,objCurRecord);
                    
                    }
                }
            }
        }
    }
    // This method removes a value from an array
    removeArrayValue(arrayName,valToRemove){
        return arrayName.filter(function(ele){ 
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
    dynamicFieldShowHide(indexNumber, strRecordId, stringAnswer){
        
            Object.keys(this.lstquestionnaire).forEach(key => {
                if(this.lstquestionnaire[key].strParentQuestion){
                    if(this.lstquestionnaire[key].strParentQuestion == strRecordId){
                        console.log('record Id true : '+strRecordId);
                        console.log('Parent Answer from loop : '+this.lstquestionnaire[key].strParentAnswer);
                        console.log('Parent Answer from method : '+stringAnswer);
                        console.log('Length of answer from loop : '+this.lstquestionnaire[key].strParentAnswer.length);
                        console.log('Length of answer from method : '+stringAnswer.length);
                        if(this.lstquestionnaire[key].strParentAnswer == stringAnswer){
                            console.log('Parent Answer true : '+stringAnswer);
                            if(!this.lstquestionnaire[key].isDynamicFieldShow){
                                console.log('Is dynamic field show : '+stringAnswer);
                                this.lstquestionnaire[key].isDynamicFieldShow = true;
                            }
                        }
                        else{
                            if(this.lstquestionnaire[key].isDynamicFieldShow){
                                this.lstquestionnaire[key].isDynamicFieldShow = false;
                            }
                        }
                    }
                } 
              });
        
        
    }

     /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Description: handle method combobox field

    History
    Date            Authors Name           Brief Description of Change
    16-11-2021      Darshan S Almiya       Initial Draft
    ------------------------------------------------------------*/

    handleComboBox(event){
        let responseValue = event.detail.value;
        let index = event.target.dataset.index;
        let strSelectedQuestion = event.target.label;
        let strRecordId = event.target.dataset.id; 

        if(strSelectedQuestion == this.label.LoanPartsLabel){
            
            let loanParts = event.target.value;
            this.loanPartCount = event.target.value;
            let arrayValues = [];
            for (var i =1; i <= loanParts; i++) {
                arrayValues.push(i); 
            }
            this.loanPartItems = arrayValues;
            if(this.lstquestionnaire[index].lstReleatedRecordId.length > 0){
                this.lstAddtionalQuestionnaire = [];
                Object.keys(this.lstquestionnaire).forEach(key => {
                    if(this.lstquestionnaire[key].strParentQuestion){
                        if(this.lstquestionnaire[key].strParentQuestion == strRecordId && this.lstquestionnaire[key].isDyanmicLogicNeeded){
                            this.lstquestionnaire[key].isDynamicLogicFieldShow = true;
                            this.lstquestionnaire[index].isDynamicLogicFieldShow = true;
                            this.lstAddtionalQuestionnaire.push(this.lstquestionnaire[key]);
                        }else{
                            this.lstquestionnaire[index].isDynamicLogicFieldShow = false;
                        }
                    } 
                });
            }
            
        }
            
        //if(strSelectedQuestion == this.label.NoOfDependentsLabel){
           
                
                  //  this.dynamicFieldShowHide(index, strRecordId, stringAnswer); // calling theDyanmicFieldShowHide Method
                if(this.lstquestionnaire[index].lstReleatedRecordId.length > 0){  
                    console.log('Inside dynamic for combo : '+responseValue);  
                    this.dynamicFieldShowHide(index, strRecordId, responseValue.trim());
                    if(strSelectedQuestion == this.label.NoOfDependentsLabel){
                        this.handleDynamicLogicField(responseValue, index);
                    } 
                }
                else if(strSelectedQuestion == this.label.NoOfDependentsLabel){
                    this.handleDynamicLogicField(responseValue, index);
                } 
            
        
        var curKey=event.currentTarget.dataset.id;
        var objCurRecord=this.questionMap.get(curKey);
        if(objCurRecord.isDynamic == false){
            objCurRecord.isFlag=true;
        }
        if(objCurRecord.isDynamic == true){
            objCurRecord.isFlag=true;
        }
        this.questionMap.set(curKey,objCurRecord);
        this.checkboxValidator();
        
    }
    
    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: handle method to get negative answer to show hard stop
    and storing no hardStop records and dispatching it to parent component

    History
    Date            Authors Name           Brief Description of Change
    16-11-2021      Anuj Sahu              Initial Draft
    15-12-2021       Alekya                 Changes
    ------------------------------------------------------------*/
    getNegativeAnswer(radioSelectedQuestion,radioSelectedAnswer,index){
         if(this.lstquestionnaire[index].strNegativeAnswer == radioSelectedAnswer){
               this.lstquestionnaire[index].isError = true;
               this.hardStop(index);
              
           }
           else{
               this.lstquestionnaire[index].isError = false;
               this.lstHardStopMessage = this.arrayRemove(this.lstHardStopMessage, this.lstquestionnaire[index].strRecordId);
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
           arrayRemove(arr, value) {
            return arr.filter(function(ele){
                return ele != value;
            });
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
           this.lstNoHardStop = this.arrayRemove(this.lstNoHardStop, this.lstquestionnaire[index].strRecordId);
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
    Author: Darshan S Almiya
    Company: Coforge
    Description: handleDynamicLogicField method to show the one field multiple time as per response

    History
    Date            Authors Name           Brief Description of Change
    16-11-2021      Darshan S Almiya       Initial Draft
    ------------------------------------------------------------*/
    handleDynamicLogicField(responseValue, index){
        if(responseValue.valueOf() > 0){
            if(!this.lstquestionnaire[index].isAddtionalQuestionRequired){
                this.lstquestionnaire[index].isAddtionalQuestionRequired = true;
            }
            this.lstquestionnaire[index].strResponseValue = responseValue;
        }
        else{
            this.lstquestionnaire[index].isAddtionalQuestionRequired = false;
        }
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

    handleIntegerInput(event){
        let index = event.target.dataset.index;        
        let responseValue = event.detail.value;

        if(event.target.label ==this.label.MortgageAmountLabel) {
            this.mortgageAmount = event.target.value;
            index = parseInt(index)+1;
        }
        if(event.target.label ==this.label.EstimatedValuationLabel) {
            this.estimatedValuation = event.target.value;            
        }
        // logic to calculate LTV
        if((event.target.label ==this.label.MortgageAmountLabel || 
             event.target.label ==this.label.EstimatedValuationLabel) &&
             this.validateInteger(this.mortgageAmount) && this.validateInteger(this.estimatedValuation)){
                    this.loanToValue = (this.mortgageAmount/this.estimatedValuation)*100;
                    this.getErrorForIntegers(this.loanToValue,index);  // verifying LTV value        
        }

        var strNumVal=event.detail.value;
        var curKey=event.currentTarget.dataset.id;
        var objCurRecord=this.questionMap.get(curKey);
        if(objCurRecord.isDynamic == false){
            objCurRecord.isFlag=true;
            if(strNumVal.length == 0){
                objCurRecord.isFlag=false;
            }
        }
        this.questionMap.set(curKey,objCurRecord);
        this.checkboxValidator();
    }
    /*------------------------------------------------------------
    Author: Sathvik V
    Company: Coforge
    Description: Method handles the checkbox rendering validation

    History
    Date            Authors Name           Brief Description of Change
    04-12-2021      Sathvik V              Initial Draft
    ------------------------------------------------------------*/
    checkboxValidator()
    {
        var valueCheck = true;
        var strSectionName;
        
        for(var i=0; i<this.lstIdsToValidate.length;i++){
            var objCurRecd=this.questionMap.get(this.lstIdsToValidate[i]);
            strSectionName=objCurRecd.strSectionName;
            if(!objCurRecd.isFlag){
                valueCheck=false;
            }
        }

        var strEventValue=''
        if(valueCheck == true){
            strEventValue={sectionName:strSectionName, render:true};
        }
        if(valueCheck == false){
            strEventValue={sectionName:strSectionName, render:false};
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
    handleText(event){
        var strTxtVal=event.detail.value;
        var curKey=event.currentTarget.dataset.id;
        var objCurRecord=this.questionMap.get(curKey);
        
            objCurRecord.isFlag=true;
            if(strTxtVal.length == 0){
                objCurRecord.isFlag=false;
            }
        
        this.questionMap.set(curKey,objCurRecord);
        this.checkboxValidator();
    }
    /*------------------------------------------------------------
    Author: Sathvik V
    Company: Coforge
    Description: Method handles the text input

    History
    Date            Authors Name           Brief Description of Change
    04-12-2021      Sathvik V              Initial Draft
    ------------------------------------------------------------*/
    handleDate(event){
        var curKey=event.currentTarget.dataset.id;
        var objCurRecord=this.questionMap.get(curKey);
        
            objCurRecord.isFlag=true;
        
        this.questionMap.set(curKey,objCurRecord);
        this.checkboxValidator();
    }
    /*------------------------------------------------------------
    Author: Rishabh Tyagi
    Company: Coforge
    Description: handle method to get negative answer to show/hide error for Integer fields

    History
    Date            Authors Name           Brief Description of Change
    08-12-2021      Rishabh Tyagi            Initial Draft
    ------------------------------------------------------------*/
    getErrorForIntegers(strSelectedAnswer,index){
        if(this.lstquestionnaire[index].strNegativeAnswer < strSelectedAnswer){
            this.lstquestionnaire[index].isError = true;
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
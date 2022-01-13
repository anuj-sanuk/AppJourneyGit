/*------------------------------------------------------------
Author: Darshan S Almiya
Company: Coforge
History
Date            Authors Name           Brief Description of Change
01-12-2021      Darshan S Almiya       Initial Draft
------------------------------------------------------------*/
import { LightningElement,track, api } from 'lwc';
import captureAge from '@salesforce/label/c.CaptureAge';
import ContactMobile from '@salesforce/schema/Case.ContactMobile';

export default class QuestionnaireAdditionalQuestionCmp extends LightningElement {
    @api lstAddQuestions;
    @track setLoanCount;
    @track strAges;
    @track strAgesHelpText;
    lstLoanPartCount;
    lstAgesCount;
    lstUniqueIds=[];

    label = {
        captureAge,
    };

    //API get set method define

    @api get agesCount(){
        return this.agesCount;
    }

    set agesCount(value){
        this.setAttribute('agesCount', value);
        this.getAgesCount(value);
        this.hundleSetVariable(value);

    }
    @api get loanPartCount(){
        return this.loanPartCount;
    }

    set loanPartCount(value) {
        this.setAttribute('loanPartCount', value);
        this.getLoanCounts(value);
        this.hundleSetVariable(value);
    }

    // Create a method to make array for Loan Part
    getLoanCounts(loanPartCount){
        let arrayValues = [];
        for (var i =1; i <= loanPartCount; i++) {
            arrayValues.push(i); 
        }
        this.lstLoanPartCount = arrayValues;
    }

    // Create a method to make array for Ages
    getAgesCount(agesCount){

        let arrayValues = [];
        for (var i =1; i <= agesCount.valueOf(); i++) {
            arrayValues.push(i); 
        }
        this.lstAgesCount = arrayValues;
        try {
            if(this.lstAddQuestions){
                this.strAges = this.lstAddQuestions[0].strQuestion;
                this.strAgesHelpText = this.lstAddQuestions[0].strHelpText;
            }
        } catch (error) {
            console.log('OUTPUT : ',error);
        }
        
    }

    /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Description: handle method age field value to show the multiple field for Add age
    input: selectedValue Age

    History
    Date            Authors Name           Brief Description of Change
    01-12-2021      Darshan S Almiya       Initial Draft
    ------------------------------------------------------------*/

    hundleSetVariable(selectedValue){
            this.setLoanCount = new Set();
            for(let i=0; i<selectedValue; i++){
                for(let j=0; j<this.lstAddQuestions.length; j++){
                    this.setLoanCount.add(String(i)+String(j));
                }
            }

            if(this.lstUniqueIds){
                this.lstUniqueIds.forEach(element => {
                    if(!this.setLoanCount.has(element)){
                       this.lstUniqueIds  = this.removeArrayValue(this.lstUniqueIds, element);
                    }
                });
                if(this.lstLoanPartCount){
                    this.validateLoanComplete(this.lstLoanPartCount.length, 'Loan');
                }
                if(this.lstAgesCount){
                    this.validateLoanComplete(this.lstAgesCount.length, 'Age');
                }
                
            }
    }

    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: method that verifies if all Age fields are filled 

    History
    Date            Authors Name           Brief Description of Change
    014-12-2021      Sathvik Voola      Initial Draft
    22-12-2021      Darshan S Almiya    Remove all the code and make genric method for all
                                        Now we are paasing the event value to handleLoanIdsForAccordionCheckBox() method
                                        and length of Age count are and string to idinitify the method in validateLoanComplete()
    ------------------------------------------------------------*/
    handleAge(event){
        var isHandleIds = this.handleLoanIdsForAccordionCheckBox(event);
        if(isHandleIds){
            this.validateLoanComplete(this.lstAgesCount.length, 'Age');
        }
    }

    /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Description: method to remove array value

    History
    Date            Authors Name           Brief Description of Change
    22-12-2021      Darshan S Almiya        Initial Draft 
    ------------------------------------------------------------*/

    removeArrayValue(arrayName,valToRemove){
        return arrayName.filter(function(ele){ 
            return ele != valToRemove; 
        });

    }

    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description:Method that handle combo box field change 

    History
    Date            Authors Name           Brief Description of Change
    14-12-2021      Sathvik Voola      Initial Draft
    22-12-2021      Darshan S Almiya    Remove all the code and make genric method for all
                                      
    ------------------------------------------------------------*/
    handleCombobox(event){
        var isHandleIds = this.handleLoanIdsForAccordionCheckBox(event);
        if(isHandleIds){
            this.validateLoanComplete(this.lstLoanPartCount.length, 'Loan');
        }
        
    }
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description:Method that handle currency field change 

    History
    Date            Authors Name           Brief Description of Change
    14-12-2021      Sathvik Voola      Initial Draft
    22-12-2021      Darshan S Almiya    Remove all the code and make genric method for all
    ------------------------------------------------------------*/
    handleCurrency(event){
        var isHandleIds = this.handleLoanIdsForAccordionCheckBox(event);
        if(isHandleIds){
            this.validateLoanComplete(this.lstLoanPartCount.length, 'Loan');
        }
    }
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description:Method that handle number field change 

    History
    Date            Authors Name           Brief Description of Change
    14-12-2021      Sathvik Voola      Initial Draft
    22-12-2021      Darshan S Almiya    Remove all the code and make genric method for all
    ------------------------------------------------------------*/
    handleNumber(event){
        var isHandleIds = this.handleLoanIdsForAccordionCheckBox(event);
        if(isHandleIds){
            this.validateLoanComplete(this.lstLoanPartCount.length, 'Loan');
        }
    }

    /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Description: Genraic Method use to insert values on the lstUniqueIds which will call after onchange of fields

    History
    Date            Authors Name           Brief Description of Change
    22-12-2021      Darshan S Almiya       Initial Draft
    ------------------------------------------------------------*/

    handleLoanIdsForAccordionCheckBox(event){

        let strFieldId = event.target.dataset.id;
        let strIndex = event.target.dataset.index;

        let strUniqueId = String(strIndex)+String(strFieldId);
        var strValue=event.target.value;
        
        if(!this.lstUniqueIds.includes(strUniqueId)){
            this.lstUniqueIds.push(strUniqueId);
        }
        if(strValue.length == 0){
            this.lstUniqueIds=this.removeArrayValue(this.lstUniqueIds,strUniqueId);
        }
        return true;
        
    }


    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    input: arrayLength, strFieldName
    Description:Method validate loan parts completion

    History
    Date            Authors Name           Brief Description of Change
    14-12-2021      Sathvik Voola      Initial Draft
    22-12-2021      Darshan S Almiya   Update method pass to new input here
                                        Also remove the disptch event and create a new method and called from this method
    ------------------------------------------------------------*/
    validateLoanComplete(arrayLength, strFieldName){
        var numfieldsCount=this.lstAddQuestions.length;
        var numtovalidate = arrayLength * numfieldsCount;
        var isLoanCompleted=false;
        if(this.lstUniqueIds.length == numtovalidate){
            isLoanCompleted=true;
        }
        else{
            isLoanCompleted=false;
        }

        //Pass the value according the Addtional field and call teh dispatch method
        if(strFieldName == 'Loan'){
            this.hundleDisptchEvent('loanvaluechange', isLoanCompleted);
        }
        else if(strFieldName == 'Age'){
            this.hundleDisptchEvent('agevaluechange', isLoanCompleted);
        }
    }

    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    input: strEventName, IsValueChange(true and false)
    Description: Method is used to dispatch the value into the parent

    History
    Date            Authors Name           Brief Description of Change
    22-12-2021      Darshan S Almiya   Initial Draft
    ------------------------------------------------------------*/

    hundleDisptchEvent(strEventName, IsValueChange){
        const constEvent = new CustomEvent(strEventName, {
            detail: IsValueChange
          });
          this.dispatchEvent(constEvent);
    }
}
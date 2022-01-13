import { LightningElement,track } from 'lwc';
import birthDatePostCode from '@salesforce/label/c.Birthdate_Postcode_Validate';

export default class CloneCustomerSearch extends LightningElement {
    @track lastName;
    @track postCode;
    @track dateOfBirth;
    @track buttonDisabled = true;
   
    //@track lastNameField;
    
    // Creating Object for Custom label
    label = {
    birthDatePostCode,
}

/*------------------------------------------------------------
    Author: Alekya Avadutha
    Company: Coforge
    Description:  This is the event to record values of lastname,dateofbirth andpostcode

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     30-11-2021       Alekya Avadutha     Initial Draft
    ------------------------------------------------------------*/
    lastNameValue(event) {
        this.lastName = event.target.value;
        console.log('last', this.lastName);
        
        let inputField = this.template.querySelector(".lastName");
        inputField.setCustomValidity("");
        inputField.reportValidity();
        
        
        //console.log('lastName',this.lastName);
       
       if (this.lastName.value =="" || this.lastName.value == null || this.lastName.value =='undefined' ) {
        console.log('lasta', this.lastName);
        this.buttonDisabled = false;

        // let postCodeLabel = this.template.querySelector(".postCode");
        //     postCodeLabel.setCustomValidity("");
        //     postCodeLabel.reportValidity();
        //     let dateOfBirthLabel = this.template.querySelector(".dateOfBirth");
        //     dateOfBirthLabel.setCustomValidity("");
        //     dateOfBirthLabel.reportValidity();
       }else{
        this.buttonDisabled = true;

       }
           
       
    //    if (this.lastName.value !=="" ) {
    //     this.buttonDisabled = false;
    // }else{
    //         this.buttonDisabled = true;

    //     }
        
        
    }
    
        
    
    
    dateOfBirthValue(event) {
        this.dateOfBirth = event.target.value;
        //console.log('dob',this.dateOfBirth);
        let postCodeLabel = this.template.querySelector(".postCode");
        let dateOfBirthLabel = this.template.querySelector(".dateOfBirth");
        
         this.buttonDisabled = false;
         
             postCodeLabel.setCustomValidity("");
             postCodeLabel.reportValidity();
             
             dateOfBirthLabel.setCustomValidity("");
             dateOfBirthLabel.reportValidity();
        

    }
        
        
    postCodeValue(event) {
        this.postCode = event.target.value;
       
        let postCodeLabel = this.template.querySelector(".postCode");
        let dateOfBirthLabel = this.template.querySelector(".dateOfBirth");
        
         this.buttonDisabled = false;
         
             postCodeLabel.setCustomValidity("");
             postCodeLabel.reportValidity();
             
             dateOfBirthLabel.setCustomValidity("");
             dateOfBirthLabel.reportValidity();
        
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
        //this.template.reset();
        this.lastName ='';
        this.postCode ='';
        this.dateOfBirth ='';
        // var inp = this.template.querySelectorAll("lightning-input");
        
        // inp.forEach(function (element) {
        //     if (element.value !== '') {
        //         this.buttonDisabled = false;
		// 		this.lastName=='';
        //         let lastNameField = this.template.querySelector(".lastName");
        //         lastNameField.setCustomValidity("");
        //         lastNameField.reportValidity();
        //         this.lastName=='';
        //         this.postCode='';
        //         let postCodeLabel = this.template.querySelector(".postCode");
        //         postCodeLabel.setCustomValidity("");
        //         this.postCode='';
        //         postCodeLabel.reportValidity();
        //         let dateOfBirthLabel = this.template.querySelector(".dateOfBirth");
        //        this.dateOfBirth='';
        //         dateOfBirthLabel.setCustomValidity("");
        //         dateOfBirthLabel.reportValidity();
               
        //     } else{this.buttonDisabled = true;}

        // }, this);

      
        
    }







    
    /*------------------------------------------------------------
    Author: Alekya Avadutha
    Company: Coforge
    Description: validation for dateofbirth and postcode.

    History
    <Date>            <Authors Name>      <Brief Description of Change>
     02-11-2021       Alekya Avadutha     Initial Draft
    ------------------------------------------------------------*/
    handleSearch(){
        console.log("lastName" + this.lastName);
        var input= this.template.querySelector(".lastName");
        console.log("lth21" + this.dateOfBirth);
        if(this.lastName=="" || this.lastName== null || this.lastName=='undefined' ){
        if(input.required )
            { 

                if(input.value == '' )
                {
                    this.buttonDisabled = true;
                    input.reportValidity();
                   
                return false;
                    
                }
                
            }}
            
        
       
        

        console.log("lt2" + this.lastName);
        console.log("lth21" + this.dateOfBirth);
        console.log("ltg21" + this.postCode);
        
           if(this.lastName.value !==""  && ((this.dateOfBirth==null ||this.dateOfBirth =="" || this.dateOfBirth =='undefined' )&& (this.postCode==null ||this.postCode =="" || this.postCode =='undefined' ))){
            
            console.log("lt9" + this.dateOfBirth);
            
        
            let postCodeLabel = this.template.querySelector(".postCode");
            let dateOfBirthLabel = this.template.querySelector(".dateOfBirth");
            dateOfBirthLabel.setCustomValidity(this.label.birthDatePostCode);
                        dateOfBirthLabel.reportValidity();
                        postCodeLabel.setCustomValidity(this.label.birthDatePostCode);
                        postCodeLabel.reportValidity();
           }
         

    
        
              
                
                   
    
            
            
       
    
                    }    
 
                }
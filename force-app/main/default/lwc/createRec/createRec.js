import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
export default class CreateRec extends LightningElement {
    
        fields = [NAME_FIELD,REVENUE_FIELD, INDUSTRY_FIELD,PHONE_FIELD];
    
        handleSubmit = (event) =>
        {
            event.preventDefault();
            const fields = event.detail.fields;
            fields.Website = 'www.test.com';
            this.template.querySelector('lightning-record-form').submit(fields);
        }
    
        handleSuccess = (event) =>
        {
            console.log(JSON.stringify(event.detail));
            this.dispatchEvent(new ShowToastEvent({
                title: 'Record Created',
                message: `A new account with name ${ event.detail.fields.Name.value } has been created`,
                variant: 'success',
                mode: 'sticky'
            }));
        }
        /*handleError = () =>
        {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Record Created',
                message: `A new account with name ${ event.detail.fields.Name.value } has been created`,
                variant: 'success',
                mode: 'sticky'
            }));
        }*/
    }
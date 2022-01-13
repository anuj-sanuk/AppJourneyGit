import { LightningElement,api } from 'lwc';

export default class AccountPrinter extends LightningElement 

{
    @api accInfo;
    @api printId;
}
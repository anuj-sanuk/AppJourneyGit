import { LightningElement, track } from 'lwc';

export default class NewApplicationCmp extends LightningElement {

@track strApplicationJSON;
    
    connectedCallback(){
        this.strApplicationJSON = JSON.stringify({ 'applicationName': 'New Application' });
    }    
    
}
/*------------------------------------------------------------
Author: Shirisha Naga
Company: Coforge
History
Date            Authors Name        Brief Description of Change
30-11-2021      Shirisha Naga       Initial Draft
------------------------------------------------------------*/
import { LightningElement, wire, api ,track } from 'lwc';
import getAccountsRecords from '@salesforce/apex/MortgageCustomerSearch_CC.returnAccountRecords';
import maxRecords from '@salesforce/label/c.Max_Records_Too_Display';
import noCustomersFound from '@salesforce/label/c.NoCustomer_Found';
import pubsub from 'c/pubSubMessageChannel';
import { NavigationMixin } from 'lightning/navigation';

const columns = [
    {
        label: 'F-Number',
        fieldName: 'RecordPath',
        type: 'url',
        initialWidth: 100,
        typeAttributes: {
        label: {
            fieldName: 'F_Number__c'
        },
        target: '_self',
    },
      sortable: true,
      hideDefaultActions: true,
    },
    {
        label: 'Name',
        fieldName: 'Name',
        type:'text',
        sortable: true,
        hideDefaultActions: true,
},
{label: 'Date of Birth',

    fieldName: 'PersonBirthdate',
    initialWidth: 100,
    type: 'date',
    sortable: true,
    hideDefaultActions: true,
},
{
    label: 'Current Address',
    fieldName: 'BillingAddress',
    type: 'Address',
    sortable: true,
    hideDefaultActions: true,
},
{
    label: 'Preferred Number',
    fieldName: 'PersonHomePhone',
    type: 'phone',
    sortable: true,
    hideDefaultActions: true,
},
{
    label: 'Email',
    fieldName: 'PersonEmail',
    type: 'email',
    sortable: true,
    hideDefaultActions: true,
}
];
export default class MortgageCustomerSearchDataTableCmp extends NavigationMixin(LightningElement) {
    label = {
        maxRecords,
        noCustomersFound,
    };
    isErrorVisible = false;
    isPageVisible = false; 
    @track  underlineClassPrevious= 'whiteColor';
    @track  underlineClass = 'redcolor';
    @track showTable = false;
    @track error;
    @track conList;
    @track Heading;
    @track errorMessage;
    @track isDataAvailable=false;
    @track results=[];
    @track isSearchResult=true;
    @track value;
    @track error;
    //@track data;
    @track sortedBy;
    defaultSortDirection = 'asc';
    @track sortedDirection = 'asc';
    @api searchKey = '';
    result;
    @track page = 1;
    @track items = [];
    @track data = [];
    @track columns;
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track pageSize = 10;
    @track totalRecountCount = 0;
    @track totalPage = 0;
    @api jsonSearchString;
    
    connectedCallback() {
        
        this.evtRegister();
      
    }

    evtRegister(){
        pubsub.register('simplevt',this.handleEvent.bind(this));
        pubsub.register('evtReset',this.handleResetEvent.bind(this));
        pubsub.register('disableTable',this.handleTableDisplayForErrors.bind(this));
    }

    handleTableDisplayForErrors(messageFromEvt){
        if(messageFromEvt){
            this.showTable=false;
            this.isPageVisible = false;
            this.isDataAvailable = false;
        }
        
    }

    handleEvent(messageFromEvt){
        this.jsonSearchString = messageFromEvt;
    }

    handleResetEvent(messageFromEvt){
      if(messageFromEvt){
          this.data = '';
          this.isPageVisible = false;
          this.isDataAvailable = false;
          this.Heading='';
          this.showTable=false;
          this.startingRecord=1;
          this.endingRecord=0;
          this.totalRecountCount=0;
      }
    //   if(this.pageSize > this.totalRecountCount){
    //     this.endingRecord=this.totalRecountCount;
    // }
    }
    handleSearchEvent(messageFromEvt)
    {
        if(record.success == true){
            this.isSearchResult=true;
          
        }
      
    }
    /*------------------------------------------------------------
    Author: Shirisha naga
    Company: Coforge
    Description: This function will show list of data from jsonString 

    History
    <Date>            <Authors Name>      <Brief Description of Change>
    31-11-2021       shirisha naga     Initial Draft
    ------------------------------------------------------------*/
   
    @wire(getAccountsRecords,{strJsonFormat:'$jsonSearchString'})
    getListAccountRecords({ error, data }) {
    if (data) {

        this.items=[];
        let RecordPath;
        let BillingAddress;
        this.startingRecord=1;
            this.endingRecord=0;
            this.totalRecountCount=0;
        data.forEach(record => {
          //  record.reset();
            RecordPath = '/' + record.Id;
            if (record.BillingPostalCode != undefined) {
                BillingAddress =  ((record.BillingStreet != undefined) ? record.BillingStreet : ' ')+' '+((record.BillingCity != undefined) ? record.BillingCity : ' ')+' '+((record.BillingState != undefined) ? record.BillingState : '') +' '+((record.BillingPostalCode != undefined) ? record.BillingPostalCode : '') ;
            }
            else{
                BillingAddress='';
            }
            this.items.push({
                ...record, RecordPath, ...record, BillingAddress
             });
        })
        this.totalRecountCount = data.length;
       console.log(this.totalRecountCount);
        if(this.totalRecountCount <= 200 && this.totalRecountCount != 0){
            this.showTable = true;
            this.isPageVisible = true;
            this.Heading = this.totalRecountCount + ' Customers found';
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
            this.isDataAvailable=true;
            this.endingRecord = this.pageSize;
            if(this.pageSize > this.totalRecountCount){
                this.endingRecord=this.totalRecountCount;
            }
            // if(this.totalRecountCount > 0){
            //     this.showTable= true;  
    
            // }
            this.columns = columns;
            this.data = this.items.slice(0, this.pageSize);
            this.errorMessage ='';
            this.error = undefined;
            this.page=1;
            
        } 
        else if(this.totalRecountCount == 0){
        this.columns = columns;
        this.data = '';
        this.isErrorVisible= true;
        this.isPageVisible = false;
        this.isDataAvailable = false;
        this.Heading='';
        this.errorMessage =this.label.noCustomersFound;
        this.showTable = true;
       
    } else {
        this.isErrorVisible= true;
        this.isPageVisible = false;
        this.isDataAvailable = false;
        this.errorMessage=this.label.maxRecords;
        this.Heading='';
        this.showTable = true;
    } 
} else if (error) {
        this.error = error;
        this.data = undefined;
        this.isDataAvailable=false;
        this.showTable = false;
    }
}
renderedCallback() {
if (this.page == this.totalPage && this.totalPage != 1) {
    this.template.querySelectorAll('.disabled-lightning-nextbutton').forEach(a => { a.disabled = true; });
    this.template.querySelectorAll('.disabled-lightning-prevbutton').forEach(a => { a.disabled = false; });
    this.underlineClassPrevious = 'redColor';
    this.underlineClass = 'whiteColor';
} else if (this.page == 1 && this.totalRecountCount != 1 && this.pageSize <  this.totalRecountCount) {
    this.template.querySelectorAll('.disabled-lightning-prevbutton').forEach(a => { a.disabled = true; });
    this.template.querySelectorAll('.disabled-lightning-nextbutton').forEach(a => { a.disabled = false; });
    this.underlineClassPrevious = 'whiteColor';
    this.underlineClass = 'redColor';
} else if (this.page < this.totalPage) {
    this.template.querySelectorAll('.disabled-lightning-nextbutton').forEach(a => { a.disabled = false; });
    this.template.querySelectorAll('.disabled-lightning-prevbutton').forEach(a => { a.disabled = false; });
    this.underlineClassPrevious = 'redColor';
    this.underlineClass = 'redColor';
} else if(this.totalRecountCount == 1){
    this.template.querySelectorAll('.disabled-lightning-prevbutton').forEach(a => { a.disabled = true; });
    this.template.querySelectorAll('.disabled-lightning-nextbutton').forEach(a => { a.disabled = true; });
    this.underlineClassPrevious = 'whiteColor';
    this.underlineClass = 'whiteColor';
}
else if(this.totalRecountCount < this.pageSize) {
    this.template.querySelectorAll('.disabled-lightning-nextbutton').forEach(a => { a.disabled = true; });
   // this.template.querySelectorAll('.disabled-lightning-prevbutton').forEach(a => { a.disabled = true; });
   // this.underlineClassPrevious = 'whiteColor';
    this.underlineClass = 'whiteColor';
}
}

previousHandler() {
    if (this.page > 1) {
        this.page = this.page - 1; 
        this.displayRecordPerPage(this.page);
    }
}
nextHandler() {
    if ((this.page < this.totalPage) && this.page !== this.totalPage) {
        this.page = this.page + 1; 
        this.displayRecordPerPage(this.page);
    }
}
displayRecordPerPage(page) {
    this.startingRecord = ((page - 1) * this.pageSize);
    this.endingRecord = (this.pageSize * page);

    this.endingRecord = (this.endingRecord > this.totalRecountCount)
        ? this.totalRecountCount : this.endingRecord;
    this.data = this.items.slice(this.startingRecord, this.endingRecord);
    this.startingRecord = this.startingRecord + 1;
}
sortColumns(event) {
   this.sortedBy = event.detail.fieldName;
 
   this.sortedDirection = event.detail.sortDirection;
    if(this.sortedBy === "RecordPath"){
     
        this.sortAccountData("Name", event.detail.sortDirection);
    }
    else{
        this.sortAccountData(event.detail.fieldName, event.detail.sortDirection);
    }
  }
sortBy( field, reverse, primer ) {
const key = primer
        ? function( x ) {
              return primer(x[field]);
          }
        : function( x ) {
              return x[field];
          };

    return function( a, b ) {
        a = key(a);
        b = key(b);
        return reverse * ( ( a > b ) - ( b > a ) );
    };
}
sortAccountData(fieldname, direction) {
let parseData = JSON.parse(JSON.stringify(this.items));
let keyValue = (a) => {
        return a[fieldname];
    };
let isReverse = direction === 'asc' ? 1 : -1;
parseData.sort((x, y) => {
        x = keyValue(x) ? keyValue(x) : '';
        y = keyValue(y) ? keyValue(y) : '';
        return isReverse * ((x > y) - (y > x));
    });
    console.log(parseData);
    console.log(this.endingRecord);
    console.log(this.totalRecountCount);
   // parseData.slice(0, this.pageSize);
    this.items= parseData;
    this.displayRecordPerPage(this.page);


}
}
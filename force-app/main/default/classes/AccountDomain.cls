/*------------------------------------------------------------
Author: Ahshan Ali
Company: Coforge
Description: A utility class to return F Number to main handler after querying it from selector class.
Inputs: F Number (String)
Test Class: AccountDomainTest
History
<Date>      <Authors Name>  <Brief Description of Change>
02-11-2021   Ahshan Ali      Initial Draft
------------------------------------------------------------*/
public with sharing class AccountDomain {
    
    /*------------------------------------------------------------
    Author: Ahshan Ali
    Company: Coforge
    Description: A utility class to return F Number to main handler after querying it from selector class.
    Inputs: F Number (String)
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    02-11-2021   Ahshan Ali      Initial Draft
    ------------------------------------------------------------*/
    public static String getCustomerDetails(String fNumberToSearch){
        String strAccountId;
        Map<String,String> mapFnumbers=new Map<String,String>();
        mapFnumbers.put('F-000000001','ABCD0001');
        mapFnumbers.put('F-000000002','ABCD0002');
        mapFnumbers.put('F-000000003','ABCD0003');
        mapFnumbers.put('F-000000004','ABCD0004');
        mapFnumbers.put('F-000000005','ABCD0005');
        String strSearchResult;
        String strSearchVal;
        strSearchResult = returnFNumber(fNumberToSearch);
        for(String setValue : mapFnumbers.keySet()){
            if(setValue.contains(strSearchResult)){
                strSearchVal=mapFnumbers.get(setValue);
                break;
            }
        }
        List<Account> listAccountDetails = AccountSelector.getAccountDetails(strSearchVal);
        if(!listAccountDetails.isEmpty()){
            strAccountId = String.valueOf(listAccountDetails[0].Id);
        }
        return strAccountId;
    }
    
    /*------------------------------------------------------------
    Author: Anuj Sahu
    Company: Coforge
    Description: Apex method to handle multiple F Number when user input it.
    ex :F number without '-' i.e. 'F123456789' 
        F number with space i.e. 'F 123456789'
        F number with '-' i.e. 'F-123456789' 
        F number without F i.e. '123456789'
    Inputs: F Number (String)
    Output: F Number, without alphabet and special character (String)
    History
    <Date>          <Authors Name>      <Brief Description of Change>
    09-11-2021       Anuj Sahu           Initial Draft
    ------------------------------------------------------------*/
    public static String returnFNumber(String strSearchValue){
        String strSearchResult;
        
        if(!String.isBlank(strSearchValue)){
            if(strSearchValue.contains(' ')){
                strSearchResult = strSearchValue.subStringAfter(' ');
            }
            else if(strSearchValue.isAlphaNumeric() && strSearchValue.length()==10){
                strSearchResult = strSearchValue.Substring(1);
            }
            else if(strSearchValue.contains('-')){
                strSearchResult = strSearchValue.subStringAfter('-');
            }
            else{
                strSearchResult = strSearchValue;
            }
        }
        return strSearchResult;
    }
    /*------------------------------------------------------------
    Author: Alekya Avadutha 
    Company: Coforge
    Description: A utility class to return List of Accounts  to main handler.
    ex :
    Inputs: lastName,dateOfBirth,postCode
    Output: Records with lastName and dateOfBirth, and with lastName and postCode
    History
    <Date>          <Authors Name>      <Brief Description of Change>
    30-11-2021       Alekya Avadutha           Initial Draft
    ------------------------------------------------------------*/
    public static List<Account> getAccountDetails(String strJsonFormat) {
        String strQuery  ='Select id,Name,FirstName,LastName,F_Number__c,BillingAddress,PersonHomePhone,PersonEmail,PersonBirthdate,BillingPostalCode,BillingCity,BillingState,BillingStreet from Account where isPersonAccount= true ';
        Map<String,object> mapJsonInput =(Map<String, object>)JSON.deserializeUntyped(strJsonFormat);
        string dateOfBirthValue = mapJsonInput.containsKey('dateOfBirth')!=null ? String.valueOf(mapJsonInput.get('dateOfBirth')):'';
        string postCodeValue =mapJsonInput.containsKey('postCode')!=null ? String.valueOf(mapJsonInput.get('postCode')):'';
        strQuery = strQuery + 'AND LastName=\'' + String.valueOf(mapJsonInput.get('lastName')) + '\'';
        if(mapJsonInput.containsKey('dateOfBirth')){
                strQuery = strQuery + ' AND PersonBirthdate =' + dateOfBirthValue ;
        }
        if(mapJsonInput.containsKey('postCode')){
                strQuery = strQuery + ' AND BillingPostalCode=\'' + postCodeValue + '\'' ;
        }
        List<Account> lstAccountRecords = AccountSelector.getAccountRecords(strQuery);
        return lstAccountRecords;
    }

}
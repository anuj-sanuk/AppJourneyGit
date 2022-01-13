/*------------------------------------------------------------
Author: Darshan Singh
Company: Coforge
Description: A class for the class 'Exception Handling'
Inputs: None
History
<Date>       <Authors Name>     <Brief Description of Change>
10/11/2021   Darshan Singh      Initial Draft
------------------------------------------------------------*/
public without sharing class CustomException extends Exception{
    
    /*------------------------------------------------------------
    Author: Darshan Singh
    Company: Coforge
    Description: A apex method to return error message.
    History
    <Date>       <Authors Name>      <Brief Description of Change>
    10-11-2021   Darshan Singh       Initial Draft
    ------------------------------------------------------------*/
    public static string getErrorMessage(){
        return label.ErrorMessage;
        }
}
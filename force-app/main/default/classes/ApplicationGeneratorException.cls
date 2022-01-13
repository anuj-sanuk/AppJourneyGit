/*------------------------------------------------------------
Author: Darshan S Almiya
Company: Coforge
Description: Custom exception generation class.
Inputs: <to be added> 
Test Class: ApplicationGeneratorExceptionTest
History
<Date>      <Authors Name>       <Brief Description of Change>
16-11-2021   Darshan Almiya       Initial Draft
------------------------------------------------------------*/
public with sharing class ApplicationGeneratorException extends Exception {
    
    /*------------------------------------------------------------
    Author: Darshan S Almiya
    Company: Coforge
    Description: A apex method return custom exception.
    Inputs: Inputs: Salespath Name (String) ; Section Name (String)
    History
    <Date>      <Authors Name>         <Brief Description of Change>
    16-11-2021   Darshan S Almiya       Initial Draft
    ------------------------------------------------------------*/
    public static void generateException(string strCustomException) {
        throw new ApplicationGeneratorException(strCustomException);
    }
}
/* Author: Sathvik Voola
Company: Coforge
Description: A class for the class 'Error Log Utility'
Inputs: None
History
<Date>       <Authors Name>     <Brief Description of Change>
10/11/2021   Sathvik Voola      Initial Draft
------------------------------------------------------------*/
@isTest
public class ErrorLogUtility_Test
{
    public Static Exception exc;
    public Static List<Account> lstAccount;
    
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: Apex method to make of list of accounts
    Inputs: 
	History
    <Date>      <Authors Name>       <Brief Description of Change>
    02-11-2021   Sathvik Voola      Initial Draft
    ------------------------------------------------------------*/
    public static void getAccounts(){
        lstAccount = new List<Account>();
        for(Integer i = 0; i<10; i++){
            Account a =new Account();
            lstAccount.add(a);
        }
    }
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: Apex method to call the logError Method
    Inputs: 
	History
    <Date>      <Authors Name>       <Brief Description of Change>
    02-11-2021   Sathvik Voola      Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void logErrorTest()
    {
        getAccounts();      
        Test.startTest();
        try
        {
            insert lstAccount;
        }
        catch(Exception e)
        {
            exc=e;
            ErrorLogUtility.logError('Account','Test Method',e,e.getMessage(),'test ref ID','test ref info','Test App',e.getMessage(),e.getTypeName());
        }
        Test.stopTest();
        
        System.assert(exc.getMessage().length() > 0);
        
    }
    
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: Apex method to call the logHandleError Method
    Inputs: 
	History
    <Date>      <Authors Name>       <Brief Description of Change>
    02-11-2021   Sathvik Voola      Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public static void logHandledErrorTest()
    {
        getAccounts(); 
        Test.startTest();
        try
        {
            insert lstAccount;
        }
        catch(Exception e)
        {
            exc=e;
            ErrorLogUtility.logHandledError('Account','Test Method',e.getMessage(),'test ref ID','test ref info','Test App',e.getMessage(),String.valueOf(e.getLineNumber()));
        }
        Test.stopTest();
        
        System.assert(exc.getMessage().length() > 0);
    }
    
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: Apex method to call the logDebugTest Method
    Inputs: 
	History
    <Date>      <Authors Name>      <Brief Description of Change>
    02-11-2021   Sathvik Voola      Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public Static void logDebugTest()
    {
        getAccounts(); 
        Test.startTest();
        try
        {
            insert lstAccount;
        }
        catch(Exception e)
        {
            exc=e;
            ErrorLogUtility.logDebug('Account','Test Method',e.getMessage(),'test ref ID','test ref info','Test App',e.getMessage(),String.valueOf(e.getLineNumber()));
        }
        Test.stopTest();
        
        System.assert(exc.getMessage().length() > 0);
    }
    
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: Apex method to call the logInfoTest Method
    Inputs: 
	History
    <Date>      <Authors Name>      <Brief Description of Change>
    02-11-2021   Sathvik Voola      Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public Static Void logInfoTest()
    {
        getAccounts(); 
        Test.startTest();
        try
        {
            insert lstAccount;
        }
        catch(Exception e)
        {
            exc=e;
            ErrorLogUtility.logInfo('Account','Test Method',e.getMessage(),'test ref ID','test ref info','Test App',e.getMessage(),String.valueOf(e.getLineNumber()));
        }
        Test.stopTest();
        
        System.assert(exc.getMessage().length() > 0);
    }
    
    /*------------------------------------------------------------
    Author: Sathvik Voola
    Company: Coforge
    Description: Apex method to call the logWarnTest Method
    Inputs: 
	History
    <Date>      <Authors Name>      <Brief Description of Change>
    02-11-2021   Sathvik Voola      Initial Draft
    ------------------------------------------------------------*/
    @isTest
    public Static void logWarnTest()
    {
       getAccounts(); 
        Test.startTest();
        try
        {
            insert lstAccount;
        }
        catch(Exception e)
        {
            exc=e;
            ErrorLogUtility.logWarn('Account','Test Method',e.getMessage(),'test ref ID','test ref info','Test App',e.getMessage(),String.valueOf(e.getLineNumber()));
        }
        Test.stopTest();
        
        System.assert(exc.getMessage().length() > 0);
    }

}
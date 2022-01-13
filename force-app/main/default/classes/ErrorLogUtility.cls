/**
@author:            Rishabh Tyagi
@description:       Utility class to help log consistent messages into the Error_Log__c object
@inputs:            logLevel         - Debug, Error, Info, Warning
                    source           - Contains the name of Originating component or apex class
                    sourceFunction   - Method in class above that initiated the log
                    ex               - The standard exception object for errors
                    message          - The user friendly message associated with the log record
                    referenceId      - The salesforce record or job ID related to the log
                    referenceInfo    - Additional context about the reference ID (e.g. Apex Class, Apex Batch, Web Callout, Flow etc,,,)
                    payLoad          - Optional payload. E.g. could be used to log the Request and Response of a web callout
                    logCode          - Optional logCode. Used for reporting purposes
      
*/

public without sharing class ErrorLogUtility {
 
    public static final String LOGLEVEL_ERROR = 'Error';
    public static final String LOGLEVEL_DEBUG = 'Debug';
    public static final String LOGLEVEL_INFO  = 'Info';
    public static final String LOGLEVEL_WARN  = 'Warning';
 
    //TODO: alter the below to instead use a custom metadata type
    public static Boolean errorLoggingIsEnabled = true;
    public static Boolean debugLoggingIsEnabled = true;
    public static Boolean infoLoggingIsEnabled = true;
    public static Boolean warnLoggingIsEnabled = true;
 
    public static List<ErrorLogWrapper> errorLogContainer = new List<ErrorLogWrapper>();

    /**
     * /**
   @description: Method to get custom data, from where we activate and deactivate the log.
    */
    public static void getCustomMetaData(){
        Map<String, CM_ErrorLog__mdt> map_ErrorLog = CM_ErrorLog__mdt.getAll();
        System.debug('calling...');
        if(!map_ErrorLog.isEmpty()){
            for(String errorLogName : map_ErrorLog.keySet()){
                errorLoggingIsEnabled = map_ErrorLog.get(errorLogName).ErrorLog__c;
                debugLoggingIsEnabled = map_ErrorLog.get(errorLogName).DebugLog__c;
                infoLoggingIsEnabled = map_ErrorLog.get(errorLogName).InfoLog__c;
                warnLoggingIsEnabled = map_ErrorLog.get(errorLogName).WarnLog__c;
            }  
        }
    }
 
   /**
   @description: Method to log a single ERROR record.
                   Used to log exceptions that need support team visibility (e.g. a controller class failed to update a record)
   @inputs:          See class "Inputs" above
   */
    public static void logError(
            String source, 
            String sourceFunction,
            Exception ex,
            String message,
            String referenceID,
            String referenceInfo,
            String applicationType,
            String payLoad,
            String logCode) {
                
                getCustomMetaData(); //get custom meta data values
        if(errorLoggingIsEnabled) {
            insertLog(LOGLEVEL_ERROR, source, sourceFunction, ex, message, referenceID, referenceInfo, applicationType, payLoad, logCode);
        }
    }
    /**
   @description:      Method to log a handled single ERROR record.
                      Used to log  handled error that need support team visibility (e.g. any record error / 
                      master configuration missing / partial record update error)
   @inputs:           See class "Inputs" above
   */
    public static void logHandledError(
            String source,
            String sourceFunction,
            String message,
            String referenceID,
            String referenceInfo,
            String applicationType,
            String payLoad,
            String logCode) {

                getCustomMetaData(); //get custom meta data values 
        if(errorLoggingIsEnabled) {
            insertLog(LOGLEVEL_ERROR, 
                      source, 
                      sourceFunction, 
                      null, 
                      message, 
                      referenceID, 
                      referenceInfo, 
                      applicationType,
                      payLoad, 
                      logCode);
        }
    }
 
   /**
   @description:     Method to log a single DEBUG record.
                     Used to log a statement that will assist with issue resolution (e.g. log the request and response from a web service callout)
   @inputs:          See class "Inputs" above
   */
    public static void logDebug(
            String source,
            String sourceFunction,
            String message,
            String referenceID,
            String referenceInfo,
            String applicationType,
            String payLoad,
            String logCode) {

        getCustomMetaData(); //get custom meta data values
 
        if(debugLoggingIsEnabled) {
            insertLog(LOGLEVEL_DEBUG, 
                      source, 
                      sourceFunction, 
                      null, 
                      message, 
                      referenceID, 
                      referenceInfo, 
                      applicationType,
                      payLoad, 
                      logCode);
        }
    }
 
 
 
   /**
   @description:     Method to log a single INFO record.
                     Used to log information about a process (e.g. when a batch job finished, how many records were processed, how many batches were used, what time did the job start and finish)
   @inputs:          See class "Inputs" above
   */
    public static void logInfo(    
            String source,
            String sourceFunction,
            String message,
            String referenceID,
            String referenceInfo,
            String applicationType,
            String payLoad,
            String logCode) {
        
            getCustomMetaData(); //get custom meta data values
 
        if(infoLoggingIsEnabled) {
            insertLog(LOGLEVEL_INFO, source, sourceFunction, null, message, referenceID, referenceInfo, applicationType, payLoad, logCode);
        }
    }
 
   /**
   @description:     Method to log a single WARNING record.
                     Used to notify the support team that one or more application limits are in danger of being reached (e.g. an Account trigger results in 80 SOQL queries)
   @inputs:          See class "Inputs" above
   */
    public static void logWarn(    
            String source,
            String sourceFunction,
            String message,
            String referenceID,
            String referenceInfo,
            String applicationType,
            String payLoad,
            String logCode) {

            getCustomMetaData(); //get custom meta data values
 
        if(warnLoggingIsEnabled) {
            insertLog(LOGLEVEL_WARN, source, sourceFunction, null, message, referenceID, referenceInfo, applicationType, payLoad, logCode);
        }
    }
 
   /**
   @description:     Method to add a single record to the errorLogContainer. Must call commitLog() to commit all contents
   @inputs:          See class "Inputs" above
   */
    public static void insertLog( 
            String logLevel,
            String source,
            String sourceFunction,
            Exception ex,
            String message,
            String referenceId,
            String referenceInfo,
            String applicationType,
            String payLoad,
            String logCode) {
 
 
        try {
            ErrorLogWrapper errorLog = new ErrorLogWrapper();
 
            if(logLevel!=null){ errorLog.logLevel = logLevel;}
            if(source!=null){ errorLog.source = source;}
            if(sourceFunction!=null){ errorLog.sourceFunction = sourceFunction;}
            if(message!=null){errorLog.message = message; }
            if(referenceId!=null){ errorLog.referenceId = referenceID;}
            if(referenceInfo!=null){ errorLog.referenceInfo = referenceInfo;}
            if(applicationType!=null){errorLog.applicationType = applicationType;}
            if(payLoad!=null){ errorLog.payLoad = payLoad;}
            if(logCode!=null){ errorLog.logCode = logCode;}
            if(ex!=null){ errorLog.stackTrace = ex.getStackTraceString();
                          errorLog.message = ex.getMessage();}
 
            errorLogContainer.add(errorLog);
            
            commitLog();
        }
        catch(Exception e) {
            System.debug('Failed to add errorLog to errorLogContainer'
                    + ' Error = ' + e.getMessage()
                    + ' logLevel='+logLevel
                    + ' source='+source
                    + ' sourceFunction='+sourceFunction
                    + ' ex='+ex
                    + ' message='+message
                    + ' referenceID='+referenceID
                    + ' referenceInfo='+referenceInfo
                    + ' applicationType='+applicationType
                    + ' payLoad='+payLoad
                    + ' logCode='+logCode);
        }
    }
 
   /**
   @description:     Method will attempt to insert errorLogContainer into the Error_Log__c sObject
   @inputs:          See class "Inputs" above
   */
    public static void commitLog() {
        if (!errorLogContainer.isEmpty()) {
            List<ErrorLog__c> errorLogsForInsert = new List<ErrorLog__c>();
            for (ErrorLogWrapper log : errorLogContainer) {
                ErrorLog__c errorLog = new ErrorLog__c();
                errorLog.LogLevel__c = log.logLevel;
                errorLog.Source__c = log.source;
                errorLog.SourceFunction__c = log.sourceFunction;
                errorLog.Message__c = log.message;
                errorLog.ReferenceID__c = log.referenceId;
                errorLog.ReferenceInfo__c = log.referenceInfo;
                errorLog.ApplicationType__c = log.applicationType;
                errorLog.PayLoad__c = log.payLoad;
                errorLog.LogCode__c = log.logCode;
                //errorLog.Stack_Trace__c = log.stackTrace;
                errorLogsForInsert.add(errorLog);
            }
            try{
                insert errorLogsForInsert;
            }
            catch(Exception e){
                System.debug('Failed to insert contents of errorLogContainer to Error_Log__c'
                + ' Error Message = ' + e.getMessage()
                + ' Error Stack Trace = ' + e.getStackTraceString());
            }
        }
    }
 
    /**
    @description:     Method will attempt to insert errorLogContainer into the Error_Log__c sObject
    @inputs:          See class "Inputs" above
    */
    public class ErrorLogWrapper {
        public String logLevel;
        public String source;
        public String sourceFunction;
        public String message;
        public String referenceId;
        public String referenceInfo;
        public String applicationType;
        public String payLoad;
        public String logCode;
        public String stackTrace;
    }
 
}
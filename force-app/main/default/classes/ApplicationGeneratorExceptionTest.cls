@isTest
public with sharing class ApplicationGeneratorExceptionTest {
    @isTest
    private static void throwExceptionMethod() {
        try{
            Test.startTest();
                ApplicationGeneratorException.generateException('Custom Exception Thrown');
            Test.stopTest();
        }
        catch(exception ex){
            system.debug(ex.getMessage());
            System.assert(ex.getMessage().contains('Exception'),'Custom Exception Thrown');
        }
    }
}
/*------------------------------------------------------------
Author: Yogesh Chand Sharma
Company: Coforge
Description: Test Class of trigger framework
Inputs: NA
History
<Date>       <Authors Name>        <Brief Description of Change>
22/11/2021   Yogesh Chand Sharma      Initial Draft
------------------------------------------------------------*/
@isTest
public with sharing class TriggerFrameworkTest {
   @isTest
   public static void checkInsertEventTest(){
       List<Account> lstAccount = TestDataFactory.getAccounts(1);          
       Test.startTest();
         insert lstAccount;
        Test.stopTest();    
   }

  @isTest
   public static void checkUpdateEventTest(){  
        List<Account> lstAccount = TestDataFactory.getAccounts(1);
        insert lstAccount;
        lstAccount[0].Type = 'Unknown';
       
       Test.startTest();
         update lstAccount;
        Test.stopTest();
   }
    
   @isTest
   public static void checkDeleteEventTest(){
        
        List<Account> lstAccount = TestDataFactory.getAccounts(1);
        insert lstAccount;
       
       Test.startTest();
         delete lstAccount[0];
        Test.stopTest();
   }
    
    @isTest
   public static void checkUndeleteEventTest(){
       
        List<Account> lstAccount = TestDataFactory.getAccounts(1);
        lstAccount[0].Type = 'Unknown';
        insert lstAccount;
        delete lstAccount[0];
        Account[] savedAccts = [SELECT Id, Name FROM Account WHERE Type = 'Unknown' ALL ROWS]; 

       Test.startTest();
         undelete savedAccts;
        Test.stopTest();
   }
   
}
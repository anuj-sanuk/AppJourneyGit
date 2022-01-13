@isTest
public class TestDataFactoryMortgageApplication {
public  List<Account> getAccounts(Integer noOfRecords)
{
    List<Account> allAccounts = new List<Account>();
    for(Integer i=1; i<=noOfRecords;i++)
    {
		Account acc= new Account(); 
        acc.Name='Test Account '+i;
        acc.FinServ__SourceSystemId__c='ABCD000'+i;
        allAccounts.add(acc);
    }
    	insert allAccounts;
    	return allAccounts;
        
        
       
}
    public Static List<ResidentialLoanApplication> returnResidentialLoanApplicationName(Integer noOfRecords){
      List<ResidentialLoanApplication> resApplicationList = new List<ResidentialLoanApplication>();
        TestDataFactoryMortgageApplication tdfma=new TestDataFactoryMortgageApplication();
        List<Account> allAccounts= tdfma.getAccounts(1);
        for(Integer i=1; i<=noOfRecords;i++)
    	{	
        ResidentialLoanApplication res = new ResidentialLoanApplication();
       
        res.Name = 'ABC123466';
        
        res.accountId =allAccounts[0].Id;
        resApplicationList.add(res);
    	}
        insert resApplicationList;
        return resApplicationList;

    }
    
    
}
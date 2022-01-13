@isTest
public class TestDataFactory1 {

public  String returnAccountId(){
    Account acc= new Account();
        acc.Name='Test';
        insert acc;
        return string.valueOf(acc.id);
}
    public  String returnResidentialLoanApplicationName(){
      
        ResidentialLoanApplication res = new ResidentialLoanApplication();
       res.Name = 'ABC123466';
        TestDataFactory1 data= new TestDataFactory1();
        res.accountId = data.returnAccountId();
        insert res;
        return res.Name;

    }
    public Static String generateQuery( String accountName)
 	{
        String queryString= 'Select Id ,Name from ResidentialLoanApplication where Name=:'+accountName;
        return queryString;
	}
    
    
}
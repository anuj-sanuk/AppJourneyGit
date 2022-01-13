public class TestDatafactoryOfFNumber {

    
    public  String returnAccountId(){
    Account acc= new Account();
        acc.Name='Test';
        insert acc;
        return string.valueOf(acc.id);
}
    public  String returnResidentialLoanApplicationId(){
      
        ResidentialLoanApplication res = new ResidentialLoanApplication();
       res.Name = 'ABC123466';
        insert res;
        return res.id;

    }
    public  String generateQuery( String accountName)
 	{
        String queryString= 'Select Id ,Name from ResidentialLoanApplication where Name=:'+accountName;
        return queryString;
	}
}
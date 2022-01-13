@isTest
public class ResedentialLoanTest {
    
    static testMethod void getMortgageApplications(){
        TestDataFactoryMortgageApplication dataFactory = new TestDataFactoryMortgageApplication();
        String applicationName = dataFactory.returnResidentialLoanApplicationName();
        // String accountName = dataFactory.returnAccountId();
        String jsonString = '{"Name":"'+applicationName+'"}';
        //ResidentialLoanApplication residentialLoanApplication= ResidentialLoanApplicationSelector.getResidentialLoanApplications(TestDataFactory1.generateQuery());
        //MortgageApplicationSearch_CC.getMortgageApplications(obj);
    String strJson=  MortgageApplicationSearch_CC.getMortgageApplications(jsonString);
        
    }
    
    static testMethod void getMortgageException(){
    String jsonString = '';
    MortgageApplicationSearch_CC.getMortgageApplications(jsonString);
    
    }
    
    
}
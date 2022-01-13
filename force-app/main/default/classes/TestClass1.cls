@isTest
public class TestClass1 {
static testMethod void testingDynamicQuery(){
        TestDataFactory1 dataFactory = new TestDataFactory1();
        String recordId = dataFactory.returnContactId();
         //String obj = '{"Name":"ABC123456"}';
    //String str = ResidentialLoanApplicationSelector.getResidentialLoanApplications(obj);
    ResidentialLoanApplication residentialLoanApplication= ResidentialLoanApplicationSelector.getResidentialLoanApplications(TestDataFactory1.generateQuery());
}
}
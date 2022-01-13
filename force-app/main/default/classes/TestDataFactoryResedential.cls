public class TestDataFactoryResedential {
public static ResidentialLoanApplication CreateTestMethod(String strApplicationNumber){
      
        //List<ResidentialLoanApplication> res = new List<ResidentialLoanApplication>();
        
            ResidentialLoanApplication residentialLoanApplication =new ResidentialLoanApplication();
            residentialLoanApplication.Name='ABC098765';
            
            
        
    
      insert residentialLoanApplication;
      return residentialLoanApplication;
        }



        public static String testWithResidentialLoanApplicationSelectorQuery()
        {
     return  'Select ID, Name From Contact Where Name=:ABC098765';
       }

}
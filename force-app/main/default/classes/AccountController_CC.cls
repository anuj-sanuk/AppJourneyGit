/**************************************************************************
* Date          Author        Version     Description
* ************************************************************************
* 08/11/2021   Ahshan Ali                  Calling Domain class method
**************************************************************************/
public with sharing class AccountController_CC {
	@AuraEnabled(Cacheable=true)
    public static String getAccountController(String fNumberjson){
		try{
		System.debug('fNumberjson is:'+fNumberjson);
		}
		catch(Exception ex){
			System.debug(ex.getMessage());
		}
		// use the result in js file to iterate/display records.
		return AccountDomain.getAccountDomain(fNumberjson);
	}
}
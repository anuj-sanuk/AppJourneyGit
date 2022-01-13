/*------------------------------------------------------------
Author: Ahshan Ali
Company: Coforge
Description: A utility class to return one Contact record after querying it from Contact Object.
Inputs: (String)
Test Class: ContactSelectorTest
History
<Date>      <Authors Name>  <Brief Description of Change>
00-12-2021   Ahshan Ali      Initial Draft
------------------------------------------------------------*/
public with sharing class ContactSelector {

    /*------------------------------------------------------------
    Author: Ahshan Ali
    Company: Coforge
    Description: A apex method to return Contact record.
    Inputs:  (String)
    History
    <Date>      <Authors Name>  <Brief Description of Change>
    00-12-2021   Ahshan Ali      Initial Draft
    ------------------------------------------------------------*/
    public static List<Contact> getContactDetails(String strDynamicQuery) {
        system.debug('json queryselc' + strDynamicQuery);
        List<Contact> records = Database.query(strDynamicQuery);
        system.debug('json selectorrec' + records);
        return Security.stripInaccessible(AccessType.READABLE,records).getRecords();
    }

}
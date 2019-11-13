@isTest
public class CustomProductInfo_AuraControllerTest {
    /* Name: TestSetup
     * Description: Method to set up test data
    */
	@TestSetup
    static void TestSetup(){
    	Contact cont = new Contact();
        cont.FirstName = 'Test';
        cont.LastName = 'User';
        cont.Home_Country__c = 'DE';
        cont.Product__c = 'Standard';
        insert cont;
        Case c = new Case();
        c.ContactId = cont.Id;
        insert c;
        Product_Cost__c pc = new Product_Cost__c();
        pc.Cost_Currency__c = 500;
        pc.Cost_Type__c = 'Cost Per Calendar Month';
        pc.Country_Code__c = 'DE';
        pc.Product__c = 'Standard';
        insert pc;
    }
    /* Name: testfetchProductCostInfo
     * Description: Method to test fetchProductCostInfo method from CustomProductInfo_AuraController class
    */
    @IsTest
    static void testfetchProductCostInfo() {
        Case c = [SELECT Id FROM Case LIMIT 1];
    	List<Product_Cost__c> pcList = CustomProductInfo_AuraController.fetchProductCostInfo(c.Id);
        system.assertEquals(1,pcList.size());
    }
}
@isTest
public class ProductInfoAPITest {
	/* Name: TestSetup
     * Description: Method to set up test data
    */
	@TestSetup
    static void TestSetup(){
        List<Contact> contacts = new List<Contact>();
    	Contact cont1 = new Contact();
        cont1.FirstName = 'Test';
        cont1.LastName = 'User';
        cont1.Home_Country__c = 'DE';
        cont1.Product__c = 'Standard';
        cont1.UUID__c = 'test123';
        contacts.add(cont1);
        Contact cont2 = new Contact();
        cont2.FirstName = 'Test';
        cont2.LastName = 'User';
        cont2.Home_Country__c = 'DE';
        cont2.Product__c = 'Black';
        cont2.UUID__c = 'test1234';
        contacts.add(cont2);
        insert contacts;
        Product_Cost__c pc = new Product_Cost__c();
        pc.Cost_Currency__c = 500;
        pc.Cost_Type__c = 'Cost Per Calendar Month';
        pc.Country_Code__c = 'DE';
        pc.Product__c = 'Standard';
        insert pc;
    }
    /* Name: testGet
     * Description: Method to test testGet method from ProductInfoAPI class when product is present
    */
    @IsTest
	static void testGet(){
		RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/Contact/test123';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = res;
		ProductInfoAPI.doGet();
	}
    
    /* Name: testGet
     * Description: Method to test testGet method from ProductInfoAPI class when no product is present
    */
    @IsTest
	static void testGetNoProduct(){
		RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/Contact/test1234';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = res;
		ProductInfoAPI.doGet();
	}
    
    /* Name: testGet
     * Description: Method to test testGet method from ProductInfoAPI class when no contact is present
    */
    @IsTest
	static void testGetNoContact(){
		RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/Contact/test12345';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = res;
		ProductInfoAPI.doGet();
	}
}
@RestResource(urlMapping='/Contact/*')
global with sharing class ProductInfoAPI {
    /* Name: doGet
     * Description: Method to fetch the product costs based on the home country and product of the contact with UUID present in the REST Request
     * Parameters: 
     * Return Type: void
    */
    @HttpGet
    global static void doGet() {
        String result = '';
        RestRequest request = RestContext.request;
        //Fetch UUID from request
        String contactId = request.requestURI.substringAfter( '/Contact/' );
        List<Contact> contactList = new List<Contact>();
        //Get Contact Home Country & Product
        contactList=[SELECT Id,Product__c,Home_Country__c FROM Contact WHERE UUID__c = :contactId];
        RestContext.response.addHeader('Content-Type','application/json');
        //If contact not present, display message
        if(contactList.size()==0){
            result = 'No contact found with UUID ' + contactId;
	        RestContext.response.responseBody = Blob.valueOf(result);
            return;
        }
        Contact c = contactList[0];
        //Get fields of Product Cost based on field set QueryFields to have flexibility.
        List<Schema.FieldSetMember> prodCostFieldSetMembers = SObjectType.Product_Cost__c.FieldSets.QueryFields.getFields();
        String fields='';
        for(Schema.FieldSetMember field:prodCostFieldSetMembers){
            fields = fields + ' ' + field.getFieldPath() + ',';
        }
        String query='SELECT '+fields.substring(0, fields.length() - 1)+' FROM Product_Cost__c WHERE Country_Code__c = \''+c.Home_Country__c+'\' AND Product__c = \''+c.Product__c+'\'';
        List<Product_Cost__c> prodCosts = database.query(query);
        //If no product costs present, display message
        if(prodCosts.size() == 0) {
        	result = 'No products found for contact with UUID ' + contactId;
	        RestContext.response.responseBody = Blob.valueOf(result);
            return;
        }
        //Result Map to show the required information from the Product Costs object.
        Map<String,Map<String,String>> resultMap = new Map<String,Map<String,String>>();
        for(Product_Cost__c pc:prodCosts){
            Map<String,String> pcFieldMap = new Map<String,String>();
            for(Schema.FieldSetMember field:prodCostFieldSetMembers){
                pcFieldMap.put(field.getLabel(),string.valueOf(pc.get(field.getFieldPath())));
            }
            resultMap.put(pc.Cost_Type__c,pcFieldMap);
        }
        result = JSON.serialize(resultMap);
        RestContext.response.responseBody = Blob.valueOf(result);
    }   
}
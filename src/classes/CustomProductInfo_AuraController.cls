public class CustomProductInfo_AuraController {
    /* Name: fetchProductCostInfo
     * Description: Method to fetch the product costs based on the home country and product of the contact associated with the case
     * Parameters: CaseId
     * Return Type: List<Product_Cost__c>
    */
	@AuraEnabled
    public static List<Product_Cost__c> fetchProductCostInfo(String caseId){
        try {
            Case c = [SELECT Id,ContactId,Contact.Home_Country__c,Contact.Product__c FROM Case WHERE Id = :caseId];
            //Get fields of Product Cost based on field set QueryFields to have flexibility.
            List<Schema.FieldSetMember> prodCostFieldSetMembers = SObjectType.Product_Cost__c.FieldSets.QueryFields.getFields();
            String fields = '';
            for (Schema.FieldSetMember field : prodCostFieldSetMembers) {
                fields = fields + ' ' + field.getFieldPath() + ',';
            }
            String query = 'SELECT Id,' + fields.substring(0, fields.length() - 1) + ' FROM Product_Cost__c WHERE Country_Code__c = \'' + c.Contact.Home_Country__c + '\' AND Product__c = \'' + c.Contact.Product__c + '\'';
            List<Product_Cost__c> prodCosts = database.query(query);
            return prodCosts;
        }catch (Exception e){
            system.debug('Exception Occurred: '+e.getMessage()+' :::: on line: '+e.getStackTraceString());
            return new List<Product_Cost__c>();
        }
    }
}
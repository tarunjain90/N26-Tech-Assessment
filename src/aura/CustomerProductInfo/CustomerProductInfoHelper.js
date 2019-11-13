({
	getCosts : function(component, event, helper) {
		var action = component.get("c.fetchProductCostInfo");
        action.setParams({ caseId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                //Setting columns for lightning:datatable
				component.set("v.columns", [
                    {label: "Cost Type", fieldName: "link", type: "url", typeAttributes: {label: { fieldName: 'Cost_Type__c' }, target: '_self'}},
                    {label: "Country Code", fieldName: "Country_Code__c", type: "text"},
                    {label: "Product", fieldName: "Product__c", type: "text"},
                    {label: "Cost", fieldName: "Cost__c", type: "text"}
                ]);
                var results=response.getReturnValue();
                if(results.length>0){
                    component.set("v.isDataPresent",true);
                    //Setting the link for the first column to navigate to the Product Cost Record.
                    for(var i=0;i<results.length;i++){
                        results[i].link='/'+results[i].Id;
                    }
                }
                else{
                    component.set("v.isDataPresent",false);
                }
                component.set("v.data",results);
            }
        });
        $A.enqueueAction(action);
	}
})
package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.Customer
import org.xtext.example.mydsl.bookingDSL.Entity
import org.xtext.example.mydsl.bookingDSL.Declaration

class ManagementPagesGenerator {
	
	private IFileSystemAccess2 fsa;
	private Resource resource;
	private String managementPagesRoot;
	
	new(IFileSystemAccess2 fsa, Resource resource, String pagesRoot) {
		this.fsa = fsa;
		this.resource = resource;
		this.managementPagesRoot = pagesRoot + "/management";
	}
	
	def generate() {
		
		this.generateManagementOverview()
		var definedCustomerTypes = resource.allContents.toList.filter(Customer);
		var definedResourceTypes = resource.allContents.toList.filter(org.xtext.example.mydsl.bookingDSL.Resource);
		var definedEntityTypes = resource.allContents.toList.filter(Entity);
		
		for (Customer c : definedCustomerTypes){
			generateResourceManagementPages(c);
		}
		
		for (org.xtext.example.mydsl.bookingDSL.Resource c : definedResourceTypes){
			generateResourceManagementPages(c);
		}
		
		for (Entity c : definedEntityTypes){
			generateResourceManagementPages(c);
		}
	}
	
	private def generateManagementOverview() {
		
		// Find all customer types, 
		var definedCustomerTypes = resource.allContents.toList.filter(Customer);
		var definedResourceTypes = resource.allContents.toList.filter(org.xtext.example.mydsl.bookingDSL.Resource);
		var definedEntityTypes = resource.allContents.toList.filter(Entity);
		
		this.fsa.generateFile(this.managementPagesRoot + "/ResourceOverviewPage.tsx", '''
		import { Accordion, AccordionDetails, AccordionSummary, Button, Typography } from "@material-ui/core";
		import { ExpandMore } from "@material-ui/icons";
		import React from "react";
		import { useHistory } from "react-router";
		
		const ResourceOverviewPage = () => {
		
		    const history = useHistory();
		
		    const render = () => {
		
		        return <div style={{display: "flex", width: "100%", justifyContent: "center", flexDirection: "column", padding: "20px"}}>
		            <Typography style={{textAlign: "center", width: "100%"}} variant="h2">System Resources</Typography>
		            «FOR entity : definedEntityTypes»
    		    		<Accordion>
    		                <AccordionSummary
    		                expandIcon={<ExpandMore/>}
    		                >
    		                    <Typography>«entity.name»s</Typography>
    		                </AccordionSummary>
    		                <AccordionDetails>
    		                    <div style={{display: "flex", flexDirection: "column"}}>
    		                        <Typography>
    		                            Resource description goes here, manage «entity.name»s below:
    		                        </Typography>
    		                        <div style={{paddingTop: "20px", display: "flex"}}>
    		                            <Button onClick={() => history.push("/management/«entity.name»_create")} variant="outlined" color="primary">Create «entity.name»</Button>
                                        <div style={{paddingRight: "10px"}}></div>
                                        <Button onClick={() => history.push("/management/«entity.name»s_overview")} variant="outlined" color="primary">«entity.name»s Overview</Button>
    		                        </div>
    		                    </div>
    		                </AccordionDetails>
    		            </Accordion>
    		    	«ENDFOR»
    		    	«FOR resource : definedResourceTypes»
    		    	 	<Accordion>
    		                <AccordionSummary
    		                expandIcon={<ExpandMore/>}
    		                >
    		                    <Typography>«resource.name»s</Typography>
    		                </AccordionSummary>
    		                <AccordionDetails>
    		                    <div style={{display: "flex", flexDirection: "column"}}>
    		                        <Typography>
    		                            Resource description goes here, manage «resource.name»s below:
    		                        </Typography>
    		                        <div style={{paddingTop: "20px", display: "flex"}}>
    		                            <Button onClick={() => history.push("/management/«resource.name»_create")} variant="outlined" color="primary">Create «resource.name»</Button>
                                        <div style={{paddingRight: "10px"}}></div>
                                        <Button onClick={() => history.push("/management/«resource.name»s_overview")} variant="outlined" color="primary">«resource.name»s Overview</Button>
    		                        </div>
    		                    </div>
    		                </AccordionDetails>
    		            </Accordion>	    		
    		    	«ENDFOR»
		    		«FOR customer : definedCustomerTypes»
	    		    	<Accordion>
			                <AccordionSummary
			                expandIcon={<ExpandMore/>}
			                >
			                    <Typography>«customer.name»s</Typography>
			                </AccordionSummary>
			                <AccordionDetails>
			                    <div style={{display: "flex", flexDirection: "column"}}>
			                        <Typography>
			                            Resource description goes here, manage «customer.name»s below:
			                        </Typography>
			                        <div style={{paddingTop: "20px", display: "flex"}}>
			                            <Button onClick={() => history.push("/management/«customer.name»_create")} variant="outlined" color="primary">Create «customer.name»</Button>
                                        <div style={{paddingRight: "10px"}}></div>
                                        <Button onClick={() => history.push("/management/«customer.name»s_overview")} variant="outlined" color="primary">«customer.name»s Overview</Button>
			                        </div>
			                    </div>
			                </AccordionDetails>
			            </Accordion>	
    		    	«ENDFOR»
		        </div>
		    }
		
		    return render();
		}
		
		export default ResourceOverviewPage;
		''')
	}
	
	private def generateResourceManagementPages(Declaration declaration) {
		
		var root = this.managementPagesRoot + "/" + declaration.name
		
		this.generateOverviewPage(root, declaration);
		this.generateCreatePage(root, declaration);
		this.generateUpdatePage(root, declaration);
	}
	
	private def generateOverviewPage(String root, Declaration declaration) {
		this.fsa.generateFile('''«root»/«declaration.name»sOverviewPage.tsx''', '''
		import React from "react";«»
		
		const «declaration.name»sOverviewPage = () => {
		
		    const render = () => {
		        return <div>«declaration.name»sOverviewPage</div>
		    }
		
		    return render();
		}
		
		export default «declaration.name»sOverviewPage;
		''')
	}
	
	private def generateCreatePage(String root, Declaration declaration) {
		this.fsa.generateFile('''«root»/Create«declaration.name»Page.tsx''', '''
		import React from "react";
		
		const Create«declaration.name»Page = () => {
		
		    const render = () => {
		        return <div>Create«declaration.name»</div>
		    }
		
		    return render();
		}
		
		export default Create«declaration.name»Page;
		''')
	}
	
	private def generateUpdatePage(String root, Declaration declaration) {
		this.fsa.generateFile('''«root»/Update«declaration.name»Page.tsx''', '''
		import React from "react";
		
		const Update«declaration.name»Page = () => {
		
		    const render = () => {
		        return <div>Update«declaration.name»</div>
		    }
		
		    return render();
		}
		
		export default Update«declaration.name»Page;
		''')
	}
	
	
	
	
}
package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.Customer
import java.util.List
import java.util.ArrayList

class PagesGenerator {
	
	private IFileSystemAccess2 fsa;
	private Resource resource;
	private String pagesRoot;
	private ManagementPagesGenerator managementPagesGenerator;
	
	
	new(IFileSystemAccess2 fsa, Resource resource, String srcRoot) {
		this.fsa = fsa;
		this.resource = resource;
		this.pagesRoot = srcRoot + "/pages";
		this.managementPagesGenerator = new ManagementPagesGenerator(fsa, resource, this.pagesRoot);
}
	
	def generate() {
		
		this.managementPagesGenerator.generate()
		this.generateBookingPage();
		
		var customers = this.resource.allContents.filter(Customer).toList;
		
		this.fsa.generateFile(this.pagesRoot + "/LoginPage.tsx", '''
		import { Button, Card, CircularProgress, FormControl, Grid, InputLabel, MenuItem, Select, Typography } from "@material-ui/core";
		import { Alert, AlertTitle } from "@material-ui/lab";
		import React, { useState } from "react";
		import { useHistory } from "react-router";
		import { httpGet } from "../api/httpClient";
		«FOR cus: customers»
		import { «cus.name» } from "../api/models/customers/«cus.name»";
		«ENDFOR»
		import { useMount } from "../lifeCycleExtensions";
		
		const LoginPage = () => {
		
		    const history = useHistory();
		    
	        const [loading, setLoading] = useState(false);
	        const [error, setError] = useState<string>();
	        const [selectedId, setSelectedId] = useState<string>('');
	    
	        const [ids, setIds] = useState<string[]>([])
		
		    useMount(() => {
	            fetchCustomers();
	        })
	    
	        const fetchCustomers = async () => {
	    
	            setLoading(true)
	    		
	    		«FOR cus: customers»
	    		const «cus.name»Result = await httpGet<«cus.name»[]>("/«cus.name»")
	    		«ENDFOR»
	    
	            if(«joinCustomers(customers)») {
	    
	                const ids: string[] = []
	    			«FOR cus: customers»
	    			«cus.name»Result.data.forEach(e => {
	                    if(!ids.includes(e.id)) {
	                        ids.push(e.id)
	                    }
	                })
	    			«ENDFOR»
	                
	                setIds(ids);
	            } else {
	                setError("Fetching customers failed");
	            }
	    
	            setLoading(false)        
	        }
		
		    const renderBody = () => {
	            if(loading) {
	                return (
	                    <div style={{display: "flex", width: "100%"}}>
	                        <CircularProgress/>
	                    </div>
	                )
	            }
	    
	            return (
	                <div style={{width: "100%", display: "flex", flexDirection: "column"}}>
	                    <FormControl variant="outlined">
	                    <InputLabel id="demo-simple-select-outlined-label">Customer</InputLabel>
	                        <Select variant="outlined" label={"Customer"} value={selectedId} onChange={e => setSelectedId(e.target.value as string)}>
	                        {ids.map((ele, key) => {
	                            return <MenuItem key={key} value={ele}>{ele}</MenuItem>
	                        })}
	                    </Select>
	                    </FormControl>
	                    <div style={{padding: "20px 0", width: "100%"}}>    
	                        <Button style={{width: "100%"}} variant="outlined" color="primary" onClick={() => {
	                            if(selectedId) {
	                                history.push(`/booking/${selectedId}`)
	                            }
	                        }}>Login</Button>
	                    </div>
	                </div>
	            )
	        }
	    
	        const render = () => {
	            return <div>
	                <Grid container style={{width: "100%", minHeight: "100vh"}} justify="center" alignItems="center">
	                    <Grid item xs={10} sm={8} md={6} lg={4} xl={4}>
	                        <Card style={{width: "100%", padding: "20px", display: "flex", justifyContent: "center", flexDirection: "column", textAlign: "center"}}> 
	                            <Typography style={{paddingBottom: "10px"}} variant="h5">Login</Typography>
	                            {error
	                            ? <Alert style={{margin: "10px 0"}} severity="error">
	                                <AlertTitle>Error</AlertTitle>
	                                {error}
	                            </Alert>
	                            : renderBody()}
	                        </Card>
	                    </Grid>
	                </Grid>
	            </div>
	        }
	    
	        return render();
		}
		
		export default LoginPage;
		''')
	}
	
	def joinCustomers(List<Customer> customers) {
		var customersString = new ArrayList<String>();
		
		for(cus : customers) {
			customersString.add(cus.name + "Result.isSuccess")
		}
		
		return customersString.join(" && ")
	}
	
	def generateBookingPage() {
		this.fsa.generateFile(this.pagesRoot + "/BookingPage.tsx", '''
		import React from "react";
		import { useParams } from "react-router";
		
		const BookingPage = () => {
		
		    const params = useParams() as { id: string };
		
		    const render = () => {
		        return <div>Booking as user: {params.id}</div>
		    }
		
		    return render();
		}
		
		export default BookingPage;
		''')
	}
}
package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.Customer
import java.util.List
import java.util.ArrayList
import org.xtext.example.mydsl.bookingDSL.Booking
import org.xtext.example.mydsl.bookingDSL.Schedule
import org.xtext.example.mydsl.bookingDSL.Relation
import org.xtext.example.mydsl.bookingDSL.Attribute

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
		this.generateBookingOverpage();
		this.generateUserPage();
		
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
	        const [selectedType, setSelectedType] = useState<string>("");
	    
	        «FOR cus: customers»
    		const [«cus.name»Result, set«cus.name»Result] = useState<«cus.name»[]>([]);
    		«ENDFOR»
		
		    useMount(() => {
	            fetchCustomers();
	        })
	    
	        const fetchCustomers = async () => {
	    
	            setLoading(true)
	    		
	    		«FOR cus: customers»
	    		const «cus.name»Result = await httpGet<«cus.name»[]>("/«cus.name»")
	    		«ENDFOR»
	    
	            if(«joinCustomers(customers)») {
	    			«FOR cus: customers»
	    			set«cus.name»Result(«cus.name»Result.data);
		    		«ENDFOR»
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
		                «FOR cus: customers»
		    			<FormControl variant="outlined">
	                    	<InputLabel id="demo-simple-select-outlined-label">«cus.name»</InputLabel>
	                        <Select variant="outlined" label={"«cus.name»"} value={selectedId} onChange={e => {
								setSelectedId(e.target.value as string)
								setSelectedType("«cus.name»")
							}}>
							{«cus.name»Result.map((ele, key) => {
								return <MenuItem key={key} value={ele.id}>{ele.«getDisplayAttribute(cus)»}</MenuItem>
							})}
	                    	</Select>
	                    </FormControl>
	                    <div style={{paddingBottom: "20px", width: "100%"}}/> 
			    		«ENDFOR»
	                    <div style={{paddingBottom: "20px", width: "100%"}}>    
	                        <Button style={{width: "100%"}} variant="outlined" color="primary" onClick={() => {
	                            if(selectedId) {
	                                history.push(`/booking/${selectedId}/${selectedType}`)
	                            }
	                        }}>Login</Button>
	                    </div>
	                    <div style={{cursor: "pointer"}} onClick={() => history.push(`/management/overview`)}>Management Overview</div>
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
	
	private def getDisplayAttribute(Customer customer) {
		
		var customerMembers = customer.members
		
		for(mem : customerMembers) {
			if(mem instanceof Attribute) {
				if(mem.name == "name") {
					return "name";
				}
			}	
		}
		return "id";
	}	
	
	def joinCustomers(List<Customer> customers) {
		var customersString = new ArrayList<String>();
		
		for(cus : customers) {
			customersString.add(cus.name + "Result.isSuccess")
		}
		
		return customersString.join(" && ")
	}
	
	private def getBookingResourceDeclaration(Booking booking) {
		for(member: booking.members) {
			if(member instanceof Relation) {
				if(member.relationType instanceof org.xtext.example.mydsl.bookingDSL.Resource) {
					return member.relationType;
				}
			}
		}
	}
	
	private def getBookingScheduleDeclaration(Booking booking) {
		for(member: booking.members){
			if(member instanceof Relation) {
				if(member.relationType instanceof Schedule) {
					return member.relationType;
				}
			}
		}
	}
	
	private def getBookingCustomerType(Booking booking) {
		for(member : booking.members) {
			if(member instanceof Relation) {
				if(member.relationType instanceof Customer) {
					return member.relationType;
				}
			}
		}
	}
	
	private def getBookingCustomerName(Booking booking) {
		for(member : booking.members) {
			if(member instanceof Relation) {
				if(member.relationType instanceof Customer) {
					return member.name;
				}
			}
		}
	}
	
	private def getBookingResourceName(Booking booking) {
		for(member : booking.members) {
			if(member instanceof Relation) {
				if(member.relationType instanceof org.xtext.example.mydsl.bookingDSL.Resource) {
					println(member.name)
					return member.name;
				}
			}
		}
	}
	
	private def getBookingResourceType(Booking booking) {
		for(member : booking.members) {
			if(member instanceof Relation) {
				if(member.relationType instanceof org.xtext.example.mydsl.bookingDSL.Resource) {
					return member.relationType;
				}
			}
		}
	}
	
	private def getBookingScheduleName(Booking booking) {
		for(member : booking.members) {
			if(member instanceof Relation) {
				if(member.relationType instanceof Schedule) {
					return member.name;
				}
			}
		}
	}
	
	private def getUniqueResourceImport(List<Booking> bookings) {
		var list = new ArrayList<String>();
		for(booking: bookings) {
			if(!list.contains(getBookingResourceDeclaration(booking).name)) {
				list.add(getBookingResourceDeclaration(booking).name)
			}
		}
		
		return list;
	}
	
	private def getUniqueScheduleImport(List<Booking> bookings) {
		var list = new ArrayList<String>();
		for(booking: bookings) {
			if(!list.contains(getBookingScheduleDeclaration(booking).name)) {
				list.add(getBookingScheduleDeclaration(booking).name)
			}
		}
		
		return list;
	}
	
	def generateBookingPage() {
		
		var bookings = this.resource.allContents.filter(Booking).toList;
		var customers = this.resource.allContents.filter(Customer).toList;
		
		var uniqueResourceImport = getUniqueResourceImport(bookings);
		var uniqueScheduleImport = getUniqueScheduleImport(bookings);
		
		this.fsa.generateFile(this.pagesRoot + "/BookingPage.tsx", '''
		import { Accordion, AccordionDetails, AccordionSummary, Button, CircularProgress, Collapse, FormControl, InputLabel, MenuItem, Select, Typography } from "@material-ui/core";
		import { ExpandMore } from "@material-ui/icons";
		import { Alert, AlertTitle } from "@material-ui/lab";
		import React, { useEffect, useState } from "react";
		import { useParams } from "react-router";
		import { httpGet, httpPost } from "../api/httpClient";
		import { useMount } from "../lifeCycleExtensions";
		«FOR booking: bookings»
		import { Create«booking.name»RequestModel } from "../api/requestModels/Create«booking.name»RequestModel";
		«ENDFOR»
		«FOR resourceImport: uniqueResourceImport»
		import { «resourceImport» } from "../api/models/resources/«resourceImport»";
		«ENDFOR»
		«FOR resourceSchedule: uniqueScheduleImport»
		import { «resourceSchedule» } from "../api/models/schedules/«resourceSchedule»";
		«ENDFOR»
		«FOR cust : customers»
		import { «cust.name» } from "../api/models/customers/«cust.name»";
		«ENDFOR»
		
		const BookingPage = () => {
			
			const params = useParams() as { id: string, type: string };
			
			const [loadUser, setLoadUser] = useState(false);
		    const [loadUserError, setLoadUserError] = useState<string>()
			«FOR cust : customers»
			const [user«cust.name», setUser«cust.name»] = useState<«cust.name»>();
			«ENDFOR»
			
			«FOR booking: bookings»
			const [load«booking.name»Resources, setLoad«booking.name»Resources] = useState(false);
		    const [loadError«booking.name»Resources, setLoadError«booking.name»Resources] = useState<string>();
		    const [open«booking.name»Resource, setOpen«booking.name»Resource] = useState(false);
		    const [«booking.name»Resource, set«booking.name»Resource] = useState<«getBookingResourceDeclaration(booking).name»[]>([]);
		    const [selected«booking.name»Resource, setSelected«booking.name»Resource] = useState<string>('');
		    const [load«booking.name»ResourceSchedules, setLoad«booking.name»ResourceSchedules] = useState(false);
		    const [loadError«booking.name»ResourceSchedules, setLoadError«booking.name»ResourceSchedules] = useState<string>()
		    const [«booking.name»ResourceSchedules, set«booking.name»ResourceSchedules] = useState<«getBookingScheduleDeclaration(booking).name»[]>([]);
		    const [selected«booking.name»ResourceSchedule, setSelected«booking.name»ResourceSchedule] = useState<string>('');
		    const [submitting«booking.name», setSubmitting«booking.name»] = useState(false);
		    const [submitting«booking.name»Error, setSubmitting«booking.name»Error] = useState<string>();
			«ENDFOR»
			
			useMount(() => {
				«FOR cust: customers»
				if(params.type === "«cust.name»") {
		            fetch«cust.name»();
		        }
				«ENDFOR»
		    })
		    
		    «FOR cust: customers»
		    const fetch«cust.name» = async () => {
	            setLoadUser(true);
	    
	            var result = await httpGet<«cust.name»>(`/«cust.name»/${params.id}`)
	            console.log(result)
	            if(result.isSuccess) {
	                setUser«cust.name»(result.data);
	            } else {
	                setLoadUserError(result.message);
	            }
	            setLoadUser(false);
	        }
	        
		    «ENDFOR»
		    
		    «FOR booking: bookings»
		    const fetch«booking.name»Resource = async () => {
	            setLoad«booking.name»Resources(true);
	            setLoadError«booking.name»Resources(undefined);
	    
	            var result = await httpGet<«getBookingResourceDeclaration(booking).name»[]>("/«getBookingResourceDeclaration(booking).name»");
	    
	            if(result.isSuccess) {
	                set«booking.name»Resource(result.data)
	            } else {
	                setLoadError«booking.name»Resources(result.message);
	            }
	    
	            setLoad«booking.name»Resources(false);
	        }
	    
	        useEffect(() => {
	            fetch«booking.name»ResourceSchedules();
	        }, [selected«booking.name»ResourceSchedule])
	    
	        const fetch«booking.name»ResourceSchedules = async () => {
	            setLoad«booking.name»ResourceSchedules(true)
	            setLoadError«booking.name»ResourceSchedules(undefined);
	    
	            var result = await httpGet<«getBookingScheduleDeclaration(booking).name»[]>("/«getBookingScheduleDeclaration(booking).name»");
	            if(result.isSuccess) {
	                set«booking.name»ResourceSchedules(result.data);
	            } else {
	                setLoadError«booking.name»ResourceSchedules(result.message);
	            }
	    
	            setLoad«booking.name»ResourceSchedules(false);
	        }
	        
	        const create«booking.name»Booking = async () => {
	            setSubmitting«booking.name»(true);
	            setSubmitting«booking.name»Error(undefined)
	    
	            var result = await httpPost<Create«booking.name»RequestModel>("/«booking.name»", {
	            	«getBookingResourceName(booking)»: «booking.name»Resource.filter(e => e.id === selected«booking.name»Resource)[0],
	            	«getBookingScheduleName(booking)»: «booking.name»ResourceSchedules.filter(e => e.id === selected«booking.name»ResourceSchedule)[0],
	                «getBookingCustomerName(booking)»: user«getBookingCustomerType(booking).name»
	          
	              
	            } as Create«booking.name»RequestModel)
	    
	            if(result.isSuccess) {
	                setSelected«booking.name»Resource('');
	                setSelected«booking.name»ResourceSchedule('')
	            } else {
	                setSubmitting«booking.name»Error(result.message)
	            }
	    
	            setSubmitting«booking.name»(false)
	        }
		    «ENDFOR»
		
		    const render = () => {
	            return <div style={{display: "flex", width: "100%", justifyContent: "center", flexDirection: "column", padding: "20px"}}>
                    <Typography style={{textAlign: "center", width: "100%"}} variant="h2">Book resources</Typography>
                    <Typography style={{textAlign: "center", width: "100%"}} variant="h4">User: {params.id}, type: {params.type}</Typography>
                    {loadUser
                    ? <div style={{display: "flex", width: "100%", justifyContent: "center"}}><CircularProgress/></div>
                    : loadUserError
                    ? <Alert style={{margin: "10px 0"}} severity="error">
                        <AlertTitle>User load Error:</AlertTitle>
                        {loadUserError}
                    </Alert> 
                    : <div>
                    	«FOR booking : bookings»
                    	<Accordion disabled={"«getBookingCustomerType(booking).name»" !== params.type} style={{width: "100%"}}>
		                    <AccordionSummary
		                    onClick={() => {
		                        if(!open«booking.name»Resource)fetch«booking.name»Resource();
		                        setOpen«booking.name»Resource(!open«booking.name»Resource);
		                    }}
		                    expandIcon={<ExpandMore/>}
		                    >
		                        <Typography>«booking.name»</Typography>
		                    </AccordionSummary>
		                    <AccordionDetails style={{width: "100%"}}>
		                        <div style={{display: "flex", flexDirection: "column", width: "100%"}}>
		                            {load«booking.name»Resources
		                            ? <div style={{display: "flex", width: "100%", justifyContent: "center"}}><CircularProgress/></div>
		                            : loadError«booking.name»Resources 
		                            ? <Alert style={{margin: "10px 0"}} severity="error">
		                                <AlertTitle>Error</AlertTitle>
		                                {loadError«booking.name»Resources}
		                            </Alert> 
		                            : <div style={{width: "100%"}}>
		                                {submitting«booking.name»Error 
		                                ?<Alert style={{margin: "10px 0"}} severity="error">
		                                    <AlertTitle>Error</AlertTitle>
		                                    {submitting«booking.name»Error}
		                                </Alert> : null}
		                                <FormControl style={{width: "100%"}} variant="outlined">
		                                    <InputLabel id="demo-simple-select-outlined-label">«getBookingResourceDeclaration(booking).name»</InputLabel>
		                                    <Select variant="outlined" value={selected«booking.name»Resource} label={"«getBookingResourceDeclaration(booking).name»"} onChange={change => setSelected«booking.name»Resource(change.target.value as string)}>
		                                    {«booking.name»Resource.map((ele, key) => {
		                                        return <MenuItem key={key} value={ele.id}>{ele.«getDisplayAttribute(getBookingResourceDeclaration(booking) as org.xtext.example.mydsl.bookingDSL.Resource)»}</MenuItem>
		                                    })}
		                                    </Select>
		                                </FormControl>
		                                <Collapse in={selected«booking.name»Resource ? true : false}>
		                                    <div style={{padding: "20px 0"}}>
		                                        {load«booking.name»ResourceSchedules
		                                        ? <div style={{display: "flex", width: "100%", justifyContent: "center"}}><CircularProgress/></div>
		                                        : <FormControl style={{width: "100%"}} variant="outlined">
		                                            <InputLabel id="demo-simple-select-outlined-label">«getBookingScheduleDeclaration(booking).name»</InputLabel>
		                                            <Select variant="outlined" value={selected«booking.name»ResourceSchedule} label={"«getBookingScheduleDeclaration(booking).name»"} onChange={change => setSelected«booking.name»ResourceSchedule(change.target.value as string)}>
		                                            {«booking.name»Resource.filter(e => e.id === selected«booking.name»Resource)[0]?.«getBookingResourceType(booking).members.filter(Relation).get(0).name»?.map((ele, key) => {
														return <MenuItem key={key} value={ele.id}>{ele.«getDisplayAttribute(getBookingScheduleDeclaration(booking) as Schedule)»}</MenuItem>
													})}
		                                            </Select>
		                                        </FormControl>
		                                        }
		                                        <Collapse in={selected«booking.name»ResourceSchedule ? true : false}>
		                                            <div style={{paddingTop: "20px", width: "100%"}}>
		                                                {submitting«booking.name»
		                                                ? <div style={{display: "flex", width: "100%", justifyContent: "center"}}><CircularProgress/></div>
		                                                : <Button style={{width: "100%"}} color="primary" variant="outlined" onClick={create«booking.name»Booking}>Book «booking.name»t</Button>}
		                                            </div>
		                                        </Collapse>
		                                    </div>
		                                </Collapse>
		                            <div style={{padding:"10px"}}/>
		                            </div>}
		                        </div>
		                    </AccordionDetails>
		                </Accordion>
                    	«ENDFOR»
                    </div>}
                </div>
	        }
		
		    return render();
		}
		
		export default BookingPage;
		''')
	}
	
	private def getDisplayAttribute(Schedule schedule) {
		
		var relationTypeMembers =schedule.members
		
		for(mem : relationTypeMembers) {
			if(mem instanceof Attribute) {
				if(mem.name == "name" && mem.type.literal == "string") {
					return "name";
				}
			}	
		}
		return "id";
	}
	
	private def getDisplayAttribute(org.xtext.example.mydsl.bookingDSL.Resource resource) {
		
		var relationTypeMembers = resource.members
		
		for(mem : relationTypeMembers) {
			if(mem instanceof Attribute) {
				if(mem.name == "name" && mem.type.literal == "string") {
					return "name";
				}
			}	
		}
		return "id";
	}	
	
	def generateUserPage() {
		this.fsa.generateFile(this.pagesRoot + "/UserPage.tsx", '''
		import { Button, Card, Divider, Grid, Typography } from "@material-ui/core";
		import React from "react";
		import { useHistory, useParams } from "react-router";
		
		const UserPage = () => {
		
		    const params = useParams() as {id: string, type: string}
		    const history = useHistory();
		
		    const render = () => {
		        return (
		            <div>
		                <Grid container style={{width: "100%", minHeight: "100vh"}} justify="center" alignItems="center">
		                    <Grid item xs={10} sm={8} md={6} lg={4} xl={4}>
		                        <Card style={{width: "100%", padding: "20px", display: "flex", justifyContent: "center", flexDirection: "column", textAlign: "center"}}> 
		                            <Typography style={{paddingBottom: "10px"}} variant="h5">User: {params.id}</Typography>
		                            <Typography style={{paddingBottom: "10px"}} variant="h5">Type: {params.type}</Typography>
		
		                            <Divider style={{margin: "20px 0"}}></Divider>
		                            
		                            <div style={{padding: "20px 0", width: "100%"}}>
		                                <Button style={{width: "100%"}} variant="outlined" color="primary" onClick={() => history.push(`/bookingoverview/${params.id}/${params.type}`)}>My bookings</Button>
		                            </div>
		                            <div style={{paddingBottom: "20px", width: "100%"}}>
		                                <Button style={{width: "100%"}} variant="outlined" color="primary" onClick={() => history.push(`/booking/${params.id}/${params.type}`)}>Create Booking</Button>
		                            </div>
		                        </Card>
		                    </Grid>
		                </Grid>
		            </div>
		        )
		    }
		
		    return render();
		}
		
		export default UserPage;
		''')
	}
	
	
	def generateBookingOverpage()
 	{
 		this.fsa.generateFile(this.pagesRoot + "/BookingOverviewPage.tsx", '''
 		import React from "react";
 		
 		const BookingOverviewPage = () => {
 		
 		    const render = () => {
 		        return <div>Booking overview</div>
 		    }
 		
 		    return render();
 		}
 		
 		export default BookingOverviewPage;
 		''')
 	}
}
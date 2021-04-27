package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.Customer
import org.xtext.example.mydsl.bookingDSL.Entity
import org.xtext.example.mydsl.bookingDSL.Declaration
import org.xtext.example.mydsl.bookingDSL.Attribute
import org.xtext.example.mydsl.bookingDSL.Relation
import org.xtext.example.mydsl.bookingDSL.Schedule
import org.xtext.example.mydsl.bookingDSL.Booking
import java.util.List
import java.util.ArrayList

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
		var definedScheduleTypes = resource.allContents.toList.filter(Schedule);
		
		for (Customer c : definedCustomerTypes){
			generateResourceManagementPages(c);
		}
		
		for (org.xtext.example.mydsl.bookingDSL.Resource c : definedResourceTypes){
			generateResourceManagementPages(c);
		}
		
		for (Entity c : definedEntityTypes){
			generateResourceManagementPages(c);
		}
		
		for (Schedule s : definedScheduleTypes) {
			generateResourceManagementPages(s);
		}
	}
	
	private def generateManagementOverview() {
		
		// Find all customer types, 
		var definedCustomerTypes = resource.allContents.toList.filter(Customer);
		var definedResourceTypes = resource.allContents.toList.filter(org.xtext.example.mydsl.bookingDSL.Resource);
		var definedEntityTypes = resource.allContents.toList.filter(Entity);
		var definedScheduleTypes = resource.allContents.toList.filter(Schedule);
		
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
    		    	«FOR schedule : definedScheduleTypes»
	    		    	<Accordion>
			                <AccordionSummary
			                expandIcon={<ExpandMore/>}
			                >
			                    <Typography>«schedule.name»s</Typography>
			                </AccordionSummary>
			                <AccordionDetails>
			                    <div style={{display: "flex", flexDirection: "column"}}>
			                        <Typography>
			                            Resource description goes here, manage «schedule.name»s below:
			                        </Typography>
			                        <div style={{paddingTop: "20px", display: "flex"}}>
			                            <Button onClick={() => history.push("/management/«schedule.name»_create")} variant="outlined" color="primary">Create «schedule.name»</Button>
                                        <div style={{paddingRight: "10px"}}></div>
                                        <Button onClick={() => history.push("/management/«schedule.name»s_overview")} variant="outlined" color="primary">«schedule.name»s Overview</Button>
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
		import { Button, Card, CircularProgress, Grid, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Typography } from "@material-ui/core";
		import React, { useState } from "react";
		import { httpGet, httpDelete } from "../../../api/httpClient";
		import { useHistory } from "react-router";
		import { useMount } from "../../../lifeCycleExtensions";
		import { «declaration.name» } from "../../../api/models/«this.declarationType(declaration)»/«declaration.name»";
		import { Alert, AlertTitle } from "@material-ui/lab";
		
		const «declaration.name»sOverviewPage = () => {
		
				const history = useHistory()
		
		    	const [loading, setLoading] = useState(false);
		        const [error, setError] = useState<String>();
		        const [«declaration.name»Result, set«declaration.name»Result] = useState<«declaration.name»[]>([])
		    	const [deleting, setDeleting] = useState<String[]>([])
		    
		        useMount(() => {
		            fetchData();
		        })
		    
		        const fetchData = async () => {
		    
		            setLoading(true);
		            var result = await httpGet<«declaration.name»[]>("/«declaration.name»")
		    
		            if(result.isSuccess) {
		                set«declaration.name»Result(result.data);
		            } else {
		                setError(result.message)
		            }
		    
		            setLoading(false);
		        }
		        
		        const deleteEntity = async (id: String) => {
		                
	                if(!deleting.includes(id)) {
	                    setDeleting([...deleting, id]);
	                }
	        
	                var result = await httpDelete<boolean>(`/«declaration.name»?id=${id}`)
	                
	                if(result.isSuccess) {
                    	«declaration.name»Result.splice(«declaration.name»Result.indexOf(«declaration.name»Result.filter(e => e.id === id)[0]),1)
                    	set«declaration.name»Result([...«declaration.name»Result]);
	                } 
	                
	                if(!deleting.includes(id)) {
	                    deleting.splice(deleting.indexOf(id), 1)
	                    setDeleting([...deleting])
	                }
	            }
		    
		        const renderBody = () => {
		            return (
		                <div style={{width: "100%", paddingTop: "20px"}}>
		                    <Grid container justify="center">
		                        <Grid item xs={12} sm={12} md={12} lg={12} xl={12} style={{padding: "20px"}}>
		                            <div style={{width: "100%", display: "flex", justifyContent: "center", flexDirection: "column"}}>
		                                <Typography variant="h4">«declaration.name» overview</Typography>
		                                <Card>
		                                    <TableContainer style={{margin: "20px 0", padding: "20px", overflow: "true"}}>
		                                        <Table aria-label="simple table">
		                                            <TableHead>
		                                            <TableRow>
		                                            	«FOR mem: declaration.members»
		                                            		«IF (mem instanceof Attribute)»
			                                            		«IF (mem.type.value == 0 || mem.type.value == 3)»
			                                            		<TableCell align="right">«mem.name»</TableCell>
			                                            		«ELSE»
			                                            		<TableCell>«mem.name»</TableCell>
			                                            		«ENDIF»
		                                            		«ENDIF»
		                                            		«IF (mem instanceof Relation)»
		                                            		<TableCell>«mem.name»</TableCell>
		                                            		«ENDIF»
		                                            	«ENDFOR»
		                                            	<TableCell></TableCell>
		                                            	<TableCell></TableCell>
		                                            </TableRow>
		                                            </TableHead>
		                                            <TableBody>
		                                            {«declaration.name»Result.map((row) => (
		                                                <TableRow key={row.id}>
		                                                	«FOR mem: declaration.members»
		                                                		«IF (mem instanceof Attribute)»
		                                                			«IF (mem.type.value == 0 || mem.type.value == 3)»
				                                            		<TableCell align="right">{row.«mem.name»«determineJoin(mem)»}</TableCell>
				                                            		«ELSEIF (mem.type.value == 2)»
				                                            		<TableCell>{row.«mem.name» ? row.«mem.name».toString() : "null"}</TableCell>
				                                            		«ELSE»
				                                            		<TableCell>{row.«mem.name»«determineJoin(mem)»}</TableCell>
				                                            		«ENDIF»
		                                                		«ENDIF»
		                                                		«IF (mem instanceof Relation)»
	                                                			<TableCell>{row.«mem.name».toString()}</TableCell>
		                                                		«ENDIF»
		                                                	«ENDFOR»
		                                                    <TableCell>
		                                                    	<Button color="primary" variant="outlined" onClick={() => history.push(`/management/«declaration.name»_update/${row.id}`)}>Edit</Button>
		                                                    </TableCell>
		                                            		<TableCell>
		                                            			{deleting.includes(row.id)
		                                            			? <div style={{display: "flex", width: "100%"}}>
			                                                        <CircularProgress/>
			                                                    </div>
		                                            			: <Button color="primary" variant="outlined" onClick={() => deleteEntity(row.id)}>Delete</Button>
		                                            			}
		                                            		</TableCell>
		                                                </TableRow>
		                                            ))}
		                                            </TableBody>
		                                        </Table>
		                                    </TableContainer>
		                                </Card>
		                            </div>
		                        </Grid>
		                    </Grid>
		                </div>
		            )
		        }
		    
		        const render = () => {
		            return <div style={{display: "flex", width: "100%"}}>
		                {loading
		                ? <div><CircularProgress/></div>
		                : renderBody()}
		            </div>
		        }
		    
		        return render();
		}
		
		export default «declaration.name»sOverviewPage;
		''')
	}
	
	private def determineJoin(Attribute attribute) {
		return attribute.array ? ".join(\", \")" : ""
	}
	
	private def declarationType(Declaration declaration) {
		switch declaration {
			Customer: "customers"
			org.xtext.example.mydsl.bookingDSL.Resource: "resources"
			Entity: "entities"
			Schedule: "schedules"
			Booking: "bookings"
		}
	}
	
	private def generateUpdatePage(String root, Declaration declaration) {
		this.fsa.generateFile('''«root»/Update«declaration.name»Page.tsx''', '''
		import React, { useState } from "react";
		import { Button, Card, Checkbox, CircularProgress, Grid, TextField, MenuItem, Select, Typography, FormControl, InputLabel } from "@material-ui/core";
		import { Alert, AlertTitle } from "@material-ui/lab";
		import { httpGet, httpPost, httpPut } from "../../../api/httpClient";
		import ChipInput from 'material-ui-chip-input'
		import { useMount } from "../../../lifeCycleExtensions";
		import ChipList from "../../../components/Chiplist";
		import { useParams } from "react-router";
		import { Update«declaration.name»RequestModel } from "../../../api/requestModels/Update«declaration.name»RequestModel"
		import { «declaration.name» } from "../../../api/models/«this.declarationType(declaration)»/«declaration.name»";
		«FOR mem: declaration.members»
			«IF (mem instanceof Relation)»
			import {«mem.relationType.name»} from "../../../api/models/«mem.relationType.declarationType»/«mem.relationType.name»"
			«ENDIF»
		«ENDFOR»
		
		const Update«declaration.name»Page = () => {
		
		const params = useParams() as { id: string }
		
			const [submitting, setSubmitting] = useState(false);
			const [loading, setLoading] = useState(false);
			const [loadError, setLoadError] = useState<string>();
			const [error, setError] = useState<string>();
			const [success, setSuccess] = useState(false)
		
			«FOR mem : declaration.members»
				«IF (mem instanceof Attribute)»
					«IF mem.isArray»
						«IF mem.type.value == 0 || mem.type.value == 3»
						const [«mem.name», set«mem.name»] = useState<number[]>([]);
						«ELSEIF mem.type.value == 2»
						const [«mem.name», set«mem.name»] = useState<boolean[]>([])
						«ELSE»
						const [«mem.name», set«mem.name»] = useState<string[]>([])
						«ENDIF»
					«ELSE»
						«IF mem.type.value == 0 || mem.type.value == 3»
						const [«mem.name», set«mem.name»] = useState<number>();
						«ELSEIF mem.type.value == 2»
						const [«mem.name», set«mem.name»] = useState<boolean>(false)
						«ELSE»
						const [«mem.name», set«mem.name»] = useState<string>("")
						«ENDIF»
					«ENDIF»
				«ENDIF»
				«IF (mem instanceof Relation)»
					«IF (mem.plurality == "many")»
						const [«mem.name», set«mem.name»] = useState<«mem.relationType.name»[]>([])
					«ELSE»
						const [«mem.name», set«mem.name»] = useState<«mem.relationType.name»>()
					«ENDIF»
				«ENDIF»
			«ENDFOR»
			«FOR mem : declaration.members»
			«IF (mem instanceof Relation)»
				const [«mem.name»Result, set«mem.name»Result] = useState<«mem.relationType.name»[]>([])
			«ENDIF»
			«ENDFOR»
			const [loadResult, setLoadResult] = useState<«declaration.name»>();
			
			useMount(() => {
		        load();
		    })
		    
		    const load = async () => {
	            setLoading(true);
	    
	            const result = await httpGet<«declaration.name»>(`/«declaration.name»/${params.id}`)
	            if(result.isSuccess) {
	                setLoadResult(result.data)
	                «FOR mem : declaration.members»
		                «IF (mem instanceof Attribute)»
		                set«mem.name»(result.data.«mem.name»)
		                «ENDIF»
		                «IF (mem instanceof Relation)»
		                set«mem.name»(result.data.«mem.name»)
		                «ENDIF»
	                «ENDFOR»
	                «IF (declaration.hasRelation)»
	                downloadRelationData()
	                «ENDIF»
	            } else {
	                setLoadError(result.message)
	            }
	    
	            setLoading(false);
	        }
	        
	        «this.generateDownloadRelationDataCode(declaration, false)»
			
			const submit = async () => {
		        setSubmitting(true);
		        setError(undefined);
		        setSuccess(false);
		
		        const result = await httpPut<Update«declaration.name»RequestModel>("/«declaration.name»", {
		        	id: params.id,
		            «this.generateRequestMapping(declaration)»
		        } as Update«declaration.name»RequestModel);
		
		        if(result.isSuccess) {
		        	setSuccess(true);
		        } else {
					setError(result.statusCode +": "+ result.message);
		        }
		
		        setSubmitting(false);
		    }
		    
		    const isNumber = (n: string | number): boolean => 
	            !isNaN(parseFloat(String(n))) && isFinite(Number(n));
			
			«this.generateRelationStateUpdateCode(declaration)»
		
		    const renderBody = () => {
		        if(loading) {
		            return <div style={{width: "100%"}}><CircularProgress/></div>
		        }
			
		        return (
		            <>
		                «FOR mem : declaration.members»
	        				«IF (mem instanceof Attribute)»
	        					«IF mem.isArray»
	        						«IF mem.type.value == 0 || mem.type.value == 3»
	        						<ChipInput label={"«mem.name»"} variant="outlined" value={«mem.name»} onAdd={(chip) => {
			                            if(isNumber(chip)) {
			                                set«mem.name»([...«mem.name», parseInt(chip)])
			                            }
			                        }}
			                        onDelete={(chip, index) => {
			                            «mem.name».splice(index, 1)
			                            set«mem.name»([...«mem.name»]);
			                        }}
			                        />
			                        <div style={{padding:"10px"}}/>
	        						«ELSEIF mem.type.value == 1»
	        						<ChipInput label={"«mem.name»"} variant="outlined" onChange={(chips) => set«mem.name»(chips)}/>
	        						<div style={{padding:"10px"}}/>
	        						«ENDIF»
	        					«ELSE»
	        						«IF mem.type.value == 0 || mem.type.value == 3»
	            					<TextField onChange={(e) => set«mem.name»(parseInt(e.target.value))} value={«mem.name»} type="number" label="«mem.name»" size="small" variant="outlined"></TextField>
	            					<div style={{padding:"10px"}}/>
	            					«ELSEIF mem.type.value == 2»
	            					<div style={{display: "flex", alignItems: "center"}}>
			                            <Checkbox onChange={e => set«mem.name»(e.target.checked)} value={«mem.name»}/> «mem.name»
			                        </div>
			                        <div style={{padding:"10px"}}/>
	            					«ELSE»
	            					<TextField onChange={(e) => set«mem.name»(e.target.value)} value={«mem.name»} type="text" label="«mem.name»" size="small" variant="outlined"></TextField>                 					
	            					<div style={{padding:"10px"}}/>
	            					«ENDIF»
	        					«ENDIF»
	        				«ENDIF»
	        				«IF (mem instanceof Relation)»
	        					«IF (mem.plurality == "many")»
	        					<ChipList selectedItems={«mem.name».map(e => e.id)} onRemoveItem={(item) => update«mem.name»(«mem.name».filter(e => e.id === item)[0], false)}></ChipList>
	        					<FormControl variant="outlined">
	        					<InputLabel id="demo-simple-select-outlined-label">«mem.name»</InputLabel>
	        					<Select variant="outlined" value={''} label={"«mem.name»"} onChange={(value) => update«mem.name»(«mem.name»Result.filter(e => e.id === value.target.value as string)[0], true)}>
									{«mem.name»Result.filter(f => !«mem.name».map(e => e.id).includes(f.id)).map((ele, key) => {
										return <MenuItem key={key} value={ele.id}>{ele.«getDisplayAttribute(mem)»}</MenuItem>
									})}
								</Select>
								</FormControl>
								<div style={{padding:"10px"}}/>
	        					«ELSE»
	        					<FormControl variant="outlined">
	        					<InputLabel id="demo-simple-select-outlined-label">«mem.name»</InputLabel>
	        					<Select variant="outlined" label={"«mem.name»"} value={«mem.name» ? «mem.name».id : undefined} onChange={(event) => set«mem.name»(«mem.name»Result.filter(e => e.id === event.target.value as string)[0])}>
									{«mem.name»Result.map((ele, key) => {
										return <MenuItem key={key} value={ele.id}>{ele.«getDisplayAttribute(mem)»}</MenuItem>
									})}
								</Select>
								</FormControl>
								<div style={{padding:"10px"}}/>
	        					«ENDIF»
	        				«ENDIF»
	        			«ENDFOR»
	                    <div style={{padding:"10px"}}/>
	                    {submitting
	                    ? <div style={{width: "100%"}}><CircularProgress/></div>
	                    : <Button onClick={submit} variant="outlined" color="primary">Update</Button>}
		            </>       
		        )
		    }
		    
		    const render = () => {
		        return <div>
                    <Grid container style={{width: "100%", minHeight: "100vh"}} justify="center" alignItems="center">
                        <Grid item xs={10} sm={8} md={6} lg={4} xl={4}>
                            <Card style={{width: "100%", padding: "20px", display: "flex", justifyContent: "center", flexDirection: "column", textAlign: "center"}}> 
                                <Typography style={{paddingBottom: "10px"}} variant="h5">Update «declaration.name»</Typography>
                                {success
	                            ? <Alert style={{margin: "10px 0"}} severity="success">
	                                <AlertTitle>Success</AlertTitle>
	                                «declaration.name» was updated successfully
	                            </Alert>
	                            : null}
	                            {error || loadError
                                ? <Alert style={{margin: "10px 0"}} severity="error">
                                    <AlertTitle>Error</AlertTitle>
                                    {error ? error : loadError}
                                </Alert>
	                            : null}
	                            {loadError 
                                ? null
                                : renderBody()}
                            </Card>
                        </Grid>
                    </Grid>
                </div>
		    }
		
		    return render();
		}
		
		export default Update«declaration.name»Page;
		''')
	}
	
	private def generateCreatePage(String root, Declaration declaration) {
		this.fsa.generateFile('''«root»/Create«declaration.name»Page.tsx''', '''
		import React, { useState } from "react";
		import { Button, Card, Checkbox, CircularProgress, Grid, TextField, MenuItem, Select, Typography, FormControl, InputLabel } from "@material-ui/core";
		import { Alert, AlertTitle } from "@material-ui/lab";
		import { httpGet, httpPost } from "../../../api/httpClient";
		import ChipInput from 'material-ui-chip-input'
		import { useMount } from "../../../lifeCycleExtensions";
		import ChipList from "../../../components/Chiplist";
		import { Create«declaration.name»RequestModel } from "../../../api/requestModels/Create«declaration.name»RequestModel";
		
		«FOR mem: declaration.members»
			«IF (mem instanceof Relation)»
			import {«mem.relationType.name»} from "../../../api/models/«mem.relationType.declarationType»/«mem.relationType.name»"
			«ENDIF»
		«ENDFOR»
		
		const Create«declaration.name»Page = () => {
			
			const [submitting, setSubmitting] = useState(false);
			const [loading, setLoading] = useState(false);
			const [loadError, setLoadError] = useState<string>();
			const [error, setError] = useState<string>();
			const [success, setSuccess] = useState(false)
			
			«FOR mem : declaration.members»
				«IF (mem instanceof Attribute)»
					«IF mem.isArray»
						«IF mem.type.value == 0 || mem.type.value == 3»
						const [«mem.name», set«mem.name»] = useState<number[]>([]);
						«ELSEIF mem.type.value == 2»
						const [«mem.name», set«mem.name»] = useState<boolean[]>([])
						«ELSE»
						const [«mem.name», set«mem.name»] = useState<string[]>([])
						«ENDIF»
					«ELSE»
						«IF mem.type.value == 0 || mem.type.value == 3»
						const [«mem.name», set«mem.name»] = useState<number>();
						«ELSEIF mem.type.value == 2»
						const [«mem.name», set«mem.name»] = useState<boolean>(false)
						«ELSE»
						const [«mem.name», set«mem.name»] = useState<string>("")
						«ENDIF»
					«ENDIF»
				«ENDIF»
				«IF (mem instanceof Relation)»
					«IF (mem.plurality == "many")»
						const [«mem.name», set«mem.name»] = useState<«mem.relationType.name»[]>([])
					«ELSE»
						const [«mem.name», set«mem.name»] = useState<«mem.relationType.name»>()
					«ENDIF»
				«ENDIF»
			«ENDFOR»
			«FOR mem : declaration.members»
			«IF (mem instanceof Relation)»
				const [«mem.name»Result, set«mem.name»Result] = useState<«mem.relationType.name»[]>([])
			«ENDIF»
			«ENDFOR»
			
			«this.generateDownloadRelationDataCode(declaration, true)»
		
			const submit = async () => {
		        setSubmitting(true);
		        setError(undefined);
		        setSuccess(false);
		
		        const result = await httpPost<Create«declaration.name»RequestModel>("/«declaration.name»", {
		            «this.generateRequestMapping(declaration)»
		        } as Create«declaration.name»RequestModel);
		
		        if(result.isSuccess) {
		        	«FOR mem : declaration.members»
    					«IF (mem instanceof Attribute)»
    						«IF mem.isArray»
    							set«mem.name»([])
    						«ELSE»
    							«IF mem.type.value == 0 || mem.type.value == 3»
    							set«mem.name»(undefined)
    							«ELSEIF mem.type.value == 2»
    							set«mem.name»(false)
    							«ELSE»
    							set«mem.name»("")
    							«ENDIF»
    						«ENDIF»
    					«ENDIF»
    					«IF (mem instanceof Relation)»
    						«IF (mem.plurality == "many")»
    							set«mem.name»([])
    						«ELSE»
    							set«mem.name»(undefined)
    						«ENDIF»
    					«ENDIF»
    				«ENDFOR»
		        	
					setSuccess(true);
		        } else {
					setError(result.statusCode +": "+ result.message);
		        }
		
		        setSubmitting(false);
		    }
		    
		    const isNumber = (n: string | number): boolean => 
	            !isNaN(parseFloat(String(n))) && isFinite(Number(n));
			
			«this.generateRelationStateUpdateCode(declaration)»
			
			const renderBody = () => {
		        if(loading) {
		            return <div style={{width: "100%"}}><CircularProgress/></div>
		        }
			
		        return (
		            <>
		                «FOR mem : declaration.members»
	        				«IF (mem instanceof Attribute)»
	        					«IF mem.isArray»
	        						«IF mem.type.value == 0 || mem.type.value == 3»
	        						<ChipInput label={"«mem.name»"} variant="outlined" value={«mem.name»} onAdd={(chip) => {
			                            if(isNumber(chip)) {
			                                set«mem.name»([...«mem.name», parseInt(chip)])
			                            }
			                        }}
			                        onDelete={(chip, index) => {
			                            «mem.name».splice(index, 1)
			                            set«mem.name»([...«mem.name»]);
			                        }}
			                        />
			                        <div style={{padding:"10px"}}/>
	        						«ELSEIF mem.type.value == 1»
	        						<ChipInput label={"«mem.name»"} variant="outlined" onChange={(chips) => set«mem.name»(chips)}/>
	        						<div style={{padding:"10px"}}/>
	        						«ENDIF»
	        					«ELSE»
	        						«IF mem.type.value == 0 || mem.type.value == 3»
	            					<TextField onChange={(e) => set«mem.name»(parseInt(e.target.value))} value={«mem.name»} type="number" label="«mem.name»" size="small" variant="outlined"></TextField>
	            					<div style={{padding:"10px"}}/>
	            					«ELSEIF mem.type.value == 2»
	            					<div style={{display: "flex", alignItems: "center"}}>
			                            <Checkbox onChange={e => set«mem.name»(e.target.checked)} value={«mem.name»}/> «mem.name»
			                        </div>
			                        <div style={{padding:"10px"}}/>
	            					«ELSE»
	            					<TextField onChange={(e) => set«mem.name»(e.target.value)} value={«mem.name»} type="text" label="«mem.name»" size="small" variant="outlined"></TextField>                 					
	            					<div style={{padding:"10px"}}/>
	            					«ENDIF»
	        					«ENDIF»
	        				«ENDIF»
	        				«IF (mem instanceof Relation)»
	        					«IF (mem.plurality == "many")»
	        					<ChipList selectedItems={«mem.name».map(e => e.id)} onRemoveItem={(item) => update«mem.name»(«mem.name».filter(e => e.id === item)[0], false)}></ChipList>
	        					<FormControl variant="outlined">
	        					<InputLabel id="demo-simple-select-outlined-label">«mem.name»</InputLabel>
	        					<Select variant="outlined" value={''} label={"«mem.name»"} onChange={(value) => update«mem.name»(«mem.name»Result.filter(e => e.id === value.target.value as string)[0], true)}>
									{«mem.name»Result.filter(f => !«mem.name».map(e => e.id).includes(f.id)).map((ele, key) => {
										return <MenuItem key={key} value={ele.id}>{ele.«getDisplayAttribute(mem)»}</MenuItem>
									})}
								</Select>
								</FormControl>
								<div style={{padding:"10px"}}/>
	        					«ELSE»
	        					<FormControl variant="outlined">
	        					<InputLabel id="demo-simple-select-outlined-label">«mem.name»</InputLabel>
	        					<Select variant="outlined" label={"«mem.name»"} value={«mem.name» ? «mem.name».id : undefined} onChange={(event) => set«mem.name»(«mem.name»Result.filter(e => e.id === event.target.value as string)[0])}>
									{«mem.name»Result.map((ele, key) => {
										return <MenuItem key={key} value={ele.id}>{ele.«getDisplayAttribute(mem)»}</MenuItem>
									})}
								</Select>
								</FormControl>
								<div style={{padding:"10px"}}/>
	        					«ENDIF»
	        				«ENDIF»
	        			«ENDFOR»
	                    <div style={{padding:"10px"}}/>
	                    {submitting
	                    ? <div style={{width: "100%"}}><CircularProgress/></div>
	                    : <Button onClick={submit} variant="outlined" color="primary">Create</Button>}
		            </>       
		        )
		    }
		    
		    const render = () => {
		        return <div>
                    <Grid container style={{width: "100%", minHeight: "100vh"}} justify="center" alignItems="center">
                        <Grid item xs={10} sm={8} md={6} lg={4} xl={4}>
                            <Card style={{width: "100%", padding: "20px", display: "flex", justifyContent: "center", flexDirection: "column", textAlign: "center"}}> 
                                <Typography style={{paddingBottom: "10px"}} variant="h5">Create «declaration.name»</Typography>
                                {success
	                            ? <Alert style={{margin: "10px 0"}} severity="success">
	                                <AlertTitle>Success</AlertTitle>
	                                «declaration.name» was created successfully
	                            </Alert>
	                            : null}
	                            {error || loadError
                                ? <Alert style={{margin: "10px 0"}} severity="error">
                                    <AlertTitle>Error</AlertTitle>
                                    {error ? error : loadError}
                                </Alert>
	                            : null}
	                            {loadError 
                                ? null
                                : renderBody()}
                            </Card>
                        </Grid>
                    </Grid>
                </div>
		    }
		
		    return render();
		}
		
		export default Create«declaration.name»Page;
		''')
	}
	
	private def generateRequestMapping(Declaration declaration) {
		
		var members = declaration.members;
		var mappingList = new ArrayList<String>();
		for(mem: members) {
			if(mem instanceof Attribute) {
				mappingList.add(mem.name + ": " + mem.name)	
			}
			if(mem instanceof Relation) {
				mappingList.add(mem.name + ": " + mem.name)
			}
		}
		return mappingList.join(", ");
	}
	
	private def generateRelationStateUpdateCode(Declaration declaration) {
		var relationMembers = declaration.members.filter(Relation);
		
		'''
		«FOR mem : relationMembers»
			«IF mem.plurality == "many"»
			const update«mem.name» = (item: «mem.relationType.name», add: boolean) => {
				if(add) {
					«mem.name».push(item);
				} else {
					«mem.name».splice(«mem.name».indexOf(item), 1)
				} 
				set«mem.name»([...«mem.name»]);
			}
			«ENDIF»
		«ENDFOR»
		
		'''
	}
	
	private def generateDownloadRelationDataCode(Declaration declaration, boolean withMount) {
		
		var relationMembers = declaration.members.filter(Relation);
		var successCheckList = new ArrayList<String>();
		for(mem : relationMembers) {
			successCheckList.add(mem.name + "Response.isSuccess")
		}
		
		
		if(declaration.hasRelation) {
			return '''
			«IF withMount»
			useMount(() => {
		        downloadRelationData();
		    })
	    	«ENDIF»
	
	    const downloadRelationData = async () => {
	    	setLoading(true);
			«FOR mem: relationMembers»
				const «mem.name»Response = await httpGet<«mem.relationType.name»[]>("/«mem.relationType.name»")
			«ENDFOR»
			if(«successCheckList.join(" && ")») {
				«FOR mem: relationMembers»
					set«mem.name»Result(«mem.name»Response.data)
				«ENDFOR»
			} else {
				setLoadError("Loading failed!")
			}
			
			setLoading(false);
	    }
		'''
		}
		
		return "";
	}
	
	private def hasRelation(Declaration declaration) {
		for(member: declaration.members) {
			if(member instanceof Relation) {
				return true;
			}
		}
		return false;
	}
	
	private def getDisplayAttribute(Relation relation) {
		
		var relationTypeMembers = relation.relationType.members
		
		for(mem : relationTypeMembers) {
			if(mem instanceof Attribute) {
				if(mem.name == "name" && mem.type.literal == "string") {
					return "name";
				}
			}	
		}
		return "id";
	}	
}
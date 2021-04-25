package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.Customer
import org.xtext.example.mydsl.bookingDSL.Entity
import org.xtext.example.mydsl.bookingDSL.Schedule

class ComponentsGenerator {
	
	private IFileSystemAccess2 fsa;
	private Resource resource;
	private String componentsRoot;
	
	new(IFileSystemAccess2 fsa, Resource resource, String srcRoot) {
		this.fsa = fsa;
		this.resource = resource;
		this.componentsRoot = srcRoot + "/components";
	}
	
	def generate() {
		
		var definedCustomerTypes = resource.allContents.toList.filter(Customer);
		var definedResourceTypes = resource.allContents.toList.filter(org.xtext.example.mydsl.bookingDSL.Resource);
		var definedEntityTypes = resource.allContents.toList.filter(Entity);
		var definedScheduleTypes = resource.allContents.toList.filter(Schedule);
		
		this.fsa.generateFile(this.componentsRoot + "/App.tsx", '''
		import React, { Component } from 'react';
		import { Redirect, Route, Switch } from 'react-router';
		import { BrowserRouter as Router} from 'react-router-dom';
		import LoginPage from '../pages/LoginPage';
		import BookingPage from '../pages/BookingPage';
		import ResourceOverviewPage from '../pages/management/ResourceOverviewPage';
		import UserPage from '../pages/UserPage';
		import BookingOverviewPage from '../pages/BookingOverviewPage';
		«FOR entity : definedEntityTypes»
		import «entity.name»sOverviewPage from '../pages/management/«entity.name»/«entity.name»sOverviewPage';
		import Update«entity.name»Page from '../pages/management/«entity.name»/Update«entity.name»Page';
		import Create«entity.name»Page from '../pages/management/«entity.name»/Create«entity.name»Page';
		«ENDFOR»
		«FOR resource : definedResourceTypes»
		import «resource.name»sOverviewPage from '../pages/management/«resource.name»/«resource.name»sOverviewPage';
		import Update«resource.name»Page from '../pages/management/«resource.name»/Update«resource.name»Page';
		import Create«resource.name»Page from '../pages/management/«resource.name»/Create«resource.name»Page';
		«ENDFOR»
		«FOR customer : definedCustomerTypes»
		import «customer.name»sOverviewPage from '../pages/management/«customer.name»/«customer.name»sOverviewPage';
		import Update«customer.name»Page from '../pages/management/«customer.name»/Update«customer.name»Page';
		import Create«customer.name»Page from '../pages/management/«customer.name»/Create«customer.name»Page';
		«ENDFOR»
		«FOR schedule : definedScheduleTypes»
		import «schedule.name»sOverviewPage from '../pages/management/«schedule.name»/«schedule.name»sOverviewPage';
		import Update«schedule.name»Page from '../pages/management/«schedule.name»/Update«schedule.name»Page';
		import Create«schedule.name»Page from '../pages/management/«schedule.name»/Create«schedule.name»Page';
		«ENDFOR»
		
		const App = () => {
		
		  const render = () => {
		    return <Router>
		      <Switch>
		      	«FOR entity : definedEntityTypes»
		      	<Route exact path="/management/«entity.name»s_overview" component={«entity.name»sOverviewPage}/>
		      	<Route exact path="/management/«entity.name»_update/:id" component={Update«entity.name»Page}/>
		      	<Route exact path="/management/«entity.name»_create" component={Create«entity.name»Page}/>
		      	«ENDFOR»
		      	«FOR resource : definedResourceTypes»
		      	<Route exact path="/management/«resource.name»s_overview" component={«resource.name»sOverviewPage}/>
		      	<Route exact path="/management/«resource.name»_update/:id" component={Update«resource.name»Page}/>
		      	<Route exact path="/management/«resource.name»_create" component={Create«resource.name»Page}/>
		      	«ENDFOR»
		      	«FOR customer : definedCustomerTypes»
		      	<Route exact path="/management/«customer.name»s_overview" component={«customer.name»sOverviewPage}/>
		      	<Route exact path="/management/«customer.name»_update/:id" component={Update«customer.name»Page}/>
		      	<Route exact path="/management/«customer.name»_create" component={Create«customer.name»Page}/>
		      	«ENDFOR»
		      	«FOR schedule : definedScheduleTypes»
		      	<Route exact path="/management/«schedule.name»s_overview" component={«schedule.name»sOverviewPage}/>
		      	<Route exact path="/management/«schedule.name»_update/:id" component={Update«schedule.name»Page}/>
		      	<Route exact path="/management/«schedule.name»_create" component={Create«schedule.name»Page}/>
		      	«ENDFOR»
		      	<Route exact path="/management/overview" component={ResourceOverviewPage}/>
		        <Route exact path="/booking/:id/:type" component={BookingPage}/>
		        <Route exact path="/userpage/:id/:type" component={UserPage}/>
        		<Route exact path="/bookingoverview/:id/:type" component={BookingOverviewPage}/>
        		<Route exact path="/login" component={LoginPage}/>
        		<Redirect to="/login"/>
		      </Switch>
		    </Router>
		  }
		
		  return render();
		
		}
		
		export default App;
		''')
		
		this.fsa.generateFile(this.componentsRoot + "/Chiplist.tsx", '''
		import { Chip, makeStyles, Theme, Typography } from "@material-ui/core";
		import { Cancel } from "@material-ui/icons";
		import React from "react";
		
		const useStyles = makeStyles((theme: Theme) => ({
		    chipContainer: {
		        "backgroundColor": "transparent",
		        "display": "inline-block",
		        "marginBottom": "20px"
		    },
		    chip: {
		        "marginTop": "10px",
		        "marginRight": "5px"
		    }
		}))
		
		interface ChipListProps {
		    selectedItems: string[]
		    onRemoveItem: (item: string) => void;
		    title?: string
		}
		
		const ChipList = (props: ChipListProps) => {
		
		    const classes = useStyles();
		
		    const {selectedItems, onRemoveItem, title} = props;
		
		    const render = () => {
		        return (
		            <div className={classes.chipContainer}>
		                {selectedItems.length > 0 ?
		                    <div>
		                        <Typography>{title}:</Typography>
		                        {selectedItems.map((item, key) => {
		                            return <Chip
		                                key={key}
		                                className={classes.chip}
		                                label={item}
		                                deleteIcon={<Cancel/>}
		                                onDelete={() => onRemoveItem(item)}
		                                onClick={() => onRemoveItem(item)}
		                            />
		                        })}
		                    </div> : null
		                }
		            </div>
		        )
		    }
		
		    return render();
		}
		
		export default ChipList;
		
		''')
	}
}
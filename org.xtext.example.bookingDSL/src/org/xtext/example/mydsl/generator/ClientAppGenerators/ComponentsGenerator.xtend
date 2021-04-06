package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource

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
		this.fsa.generateFile(this.componentsRoot + "/App.tsx", '''
		import React, { Component } from 'react';
		import { Redirect, Route, Switch } from 'react-router';
		import { BrowserRouter as Router} from 'react-router-dom';
		import HomePage from '../pages/HomePage';
		
		const App = () => {
		
		  const render = () => {
		    return <Router>
		      <Switch>
		        <Route exact path="/home" component={HomePage}/>
		        <Redirect to="/home"/>
		      </Switch>
		    </Router>
		  }
		
		  return render();
		
		}
		
		export default App;
		''')
	}
}
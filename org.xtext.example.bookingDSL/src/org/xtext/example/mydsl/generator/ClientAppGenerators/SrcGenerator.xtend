package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource

class SrcGenerator {
	
	private IFileSystemAccess2 fsa;
	private Resource resource;
	private String srcRoot;
	
	private APIGenerator apiGenerator;
	private ComponentsGenerator componentsGenerator;
	private PagesGenerator pagesGenerator;
	private ModelGenerator modelGenerator;
	
	new(IFileSystemAccess2 fsa, Resource resource, String clientRoot) {
		this.fsa = fsa;
		this.resource = resource;
		this.srcRoot = clientRoot + "/src";
		
		this.apiGenerator = new APIGenerator(fsa, resource, this.srcRoot);
		this.componentsGenerator = new ComponentsGenerator(fsa, resource, this.srcRoot);
		this.pagesGenerator = new PagesGenerator(fsa, resource, this.srcRoot);
		this.modelGenerator = new ModelGenerator(fsa, resource , this.srcRoot);
	}
	
	def generate() {
		this.generateLifeCycleExtensions();
		this.generateIndexTsx();
		
		this.apiGenerator.generate();
		this.componentsGenerator.generate();
		this.pagesGenerator.generate();
		
		// Added models
		this.modelGenerator.generate();
	}
	
	
	private def generateLifeCycleExtensions() {
		this.fsa.generateFile(this.srcRoot + "/lifeCycleExtensions.tsx", '''
		import { useEffect, useState } from "react";
		
		/* eslint-disable no-alert, no-console */
		
		// Will run after first initialize...
		export const useMount = 
		    (func: (() => void) | (() => () => void)) => useEffect(func, []);
		
		/* eslint-enable no-alert */
		
		/* eslint-disable no-alert, no-console */
		
		// This will run before rendering but can't access anything outside the method as those are not initialize for func methods
		export const useConstructor = 
		    (constructorFunction: () => void) => useState(() => constructorFunction());
		
		/* eslint-enable no-alert */
		''')
	}
	
	private def generateIndexTsx() {
		this.fsa.generateFile(this.srcRoot + "/index.tsx", '''
		import 'bootstrap/dist/css/bootstrap.css';
		import React from 'react';
		import ReactDOM from 'react-dom';
		import App from './components/App';
		
		ReactDOM.render(
		  <App />,
		  document.getElementById('root')
		);
		''')
	}
	
	
}
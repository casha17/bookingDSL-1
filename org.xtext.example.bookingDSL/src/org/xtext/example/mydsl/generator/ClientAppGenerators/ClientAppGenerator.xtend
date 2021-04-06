package org.xtext.example.mydsl.generator.ClientAppGenerators

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource

class ClientAppGenerator {

	private IFileSystemAccess2 fsa;
	private Resource resource;

	new (IFileSystemAccess2 fsa, Resource resource) {
		this.fsa = fsa;
		this.resource = resource;
	}
	
	def generate() {
		
	}
}
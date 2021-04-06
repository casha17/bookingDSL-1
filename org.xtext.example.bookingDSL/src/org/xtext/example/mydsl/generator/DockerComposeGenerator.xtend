package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class DockerComposeGenerator{
	
	static def void generateComposeFile(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		
		fsa.generateFile('''«systemName»/«systemName»/Startup.cs''', 
			'''
			version: '3.7'
			services:
			  mongodb_container:
			    image: mongo:latest
			    environment:
			      - MONGO_INITDB_DATABASE=«systemName»DB
			      - MONGO_INITDB_ROOT_USERNAME=root
			      - MONGO_INITDB_ROOT_PASSWORD=rootpassword
			    ports:
			      - 27017:32768
			''')
	}
}
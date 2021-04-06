package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.xtext.example.mydsl.generator.ClientAppGenerators.ClientAppGenerator
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class ProjectGenerator {
	
	private IFileSystemAccess2 fsa;
	private Resource resource;
	private String systemName;
	private String slnRoot;
	private String projRoot;
	private ClientAppGenerator clientAppGenerator;
	
	new (IFileSystemAccess2 fsa, Resource resource) {
		this.fsa = fsa;
		this.resource = resource;
		
		var system = resource.allContents.toList.filter(System).get(0);
		
		this.systemName = system.getName();
		this.slnRoot = '''«systemName»/'''
		this.projRoot = '''«this.slnRoot»/«systemName»'''
	}
	
	
	 	
	def void generateProject() {
		
		this.fsa.generateFile('''«this.slnRoot»/«this.systemName».sln''', '')
		this.fsa.generateFile('''«this.projRoot»/«this.systemName».csproj''', '')
		
		
		//this.clientAppGenerator.generate();
		DockerComposeGenerator.generateComposeFile(this.fsa, this.resource)
		AppSettingsGenerator.generateAppSettings(this.fsa, this.resource)
	}
	
	 	
	 	
	/*def void generateStartup() {
		this.fsa.generateFile('src/Startup.cs', '''
		using System;
		class Startup {
			static public void Main(string[] args)  {
				Console.Writeline("Hi from xtext");		
				}
		}
		
		''')
	 	
	}
	
	def void generateProgram() {
		this.fsa.generateFile('Program.cs', 'People to greet: ')
	} */
	
}
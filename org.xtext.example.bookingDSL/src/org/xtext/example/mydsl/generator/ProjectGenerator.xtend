package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2

class ProjectGenerator {
	
	private IFileSystemAccess2 fsa;
	def void startGeneration(IFileSystemAccess2 fsa) {		
		this.fsa = fsa;
	 	this.generateStartup
	 	}
	 	
	 	
	def void generateStartup() {
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
	} 
	
}
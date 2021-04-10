package org.xtext.example.mydsl.generator.persistence

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class ModelsGenerator {
	static def void generateModels(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		var declarations = resource.allContents.toList.filter(Declaration);
		for(dec : declarations){
			genFile(fsa, dec, systemName, dec.name)
		}
		
		fsa.generateFile('''«systemName»/«systemName»/Persistence/Models/IEntity.cs''', 
			'''
			using System;
			
			namespace «systemName».Persistence.Models
			{
			    public interface IEntity
			    {
			        Guid Id { get; }
			    }
			}
			''')
	}
	
	static def void genFile(IFileSystemAccess2 fsa, Declaration dec, String systemName, String name){
		fsa.generateFile('''«systemName»/«systemName»/Persistence/Models/«name».cs''', 
			'''
			using System;
			
			namespace «systemName».Persistence.Models
			{
			    public class «name» : IEntity
			    {
			        public Guid Id { get; set; }
			        «FOR mem : dec.members»
			        «IF (mem instanceof Attribute)»
			        public «mem.type» «mem.name» {get; set;}
			        «ENDIF»
			        «ENDFOR»
			    }
			}
			''')
	}
	
	static def void test(Declaration dec){
		for (mem : dec.members){
			if(mem instanceof Attribute){
				println("Type: " + mem.type);
				println("Array: " + mem.array)
				println("Class: " + mem.class)
				println("EContents: " + mem.eContents)
				println("Name" + mem.name)
				println("Length: " + mem.length)
				println("ToString: " + mem.toString)
			}
		}
	}
}